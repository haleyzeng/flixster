//
//  MoviesGridViewController.m
//  flixster
//
//  Created by Haley Zeng on 6/28/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieGridCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"

@interface MoviesGridViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *fetchingActivityIndicator;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSArray *filteredMovies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.searchBar.delegate = self;
    
    // mid-screen loading wheel
    [self.fetchingActivityIndicator startAnimating];
    
    // get movie data to fill collection view
    [self fetchMovies];
    
    // create pull-to-refresh wheel
    self.refreshControl = [[UIRefreshControl alloc] init];
    // add refresh functionality to pull action
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    // place wheel in view
    [self.collectionView insertSubview:self.refreshControl atIndex:0];
    
    // ========= adjust poster size to fill view evenly ============
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    CGFloat postersPerRow = 2;
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat itemWidth = (width - (layout.minimumInteritemSpacing * (postersPerRow - 1))) / postersPerRow;

    CGFloat itemHeight = itemWidth * 1.5;
    
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    // =============================================================
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchMovies {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            
            // ====== create error for failing to load data =============
            
            // create alert element
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Error"
                                        message:[error localizedDescription]
                                        preferredStyle:(UIAlertControllerStyleAlert)];
            // create OK action action
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"Try Again"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * _Nonnull action) {
                                           [self fetchMovies];
                                       }];
            
            // add the OK action to the alert controller
            [alert addAction:okAction];
            
            // show alert
            [self presentViewController:alert animated:YES completion:^{
            }];
            // ======================================================
        }
        else {
            
            // convert json to dict
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            self.movies = dataDictionary[@"results"];
            self.filteredMovies = self.movies;
            
            // after getting data reload collection view to update it
            [self.collectionView reloadData];
            
            // stop loading wheel
            [self.fetchingActivityIndicator stopAnimating];
        }
        
        // stop pull-to-refresh wheel
        [self.refreshControl endRefreshing];
    }];
    [task resume];
    
}

// specify how many cells in collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}

// specify what goes inside each cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MovieGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieGridCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.filteredMovies[indexPath.item];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *url = [NSURL URLWithString:fullURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // load poster image with fade-in if is being downloaded
    __weak MovieGridCell *weakSelf = cell;
    [cell.posterImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        // imageResponse will be nil if the image is cached
        if (imageResponse) {
            NSLog(@"Grid Poster Image was NOT cached, fade in image");
            weakSelf.posterImageView.alpha = 0.0;
            weakSelf.posterImageView.image = image;
            
            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.posterImageView.alpha = 1.0;
            }];
        }
        else {
            NSLog(@"Grid Poster Image was cached so just update the image");
            weakSelf.posterImageView.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
    }];
    
    return cell;
}

// searching: filtering results based on what's typed
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [[evaluatedObject[@"title"] lowercaseString] containsString:[searchText lowercaseString]];
        }];
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredMovies = self.movies;
    }
    
    [self.collectionView reloadData];
}



- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO; // hide cancel button
    self.searchBar.text = @"";  // clear search text
    [self.searchBar resignFirstResponder]; // hide keyboard
    
    // return view to all movies
    self.filteredMovies = self.movies;
    [self.collectionView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.item];
    
    DetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.movie = movie;
}

@end
