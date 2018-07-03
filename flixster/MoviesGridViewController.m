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
#import "Movie.h"
#import "MovieAPIManager.h"

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
    MovieAPIManager *manager = [MovieAPIManager new];
    [manager fetchNowPlaying:^(NSArray *movies, NSError *error) {
        if (error != nil) {
            // create alert element
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Error"
                                        message:[error localizedDescription]
                                        preferredStyle:(UIAlertControllerStyleAlert)];
            
            // create Try Again action button
            UIAlertAction *tryAgainAction = [UIAlertAction
                                             actionWithTitle:@"Try Again"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action) {
                                                 [self fetchMovies];
                                             }];
            
            // add the Try Again action to the alert controller
            [alert addAction:tryAgainAction];
            
            // show alert
            [self presentViewController:alert animated:YES completion:^{
            }];
        }
        else {
            self.movies = movies;
            self.filteredMovies = self.movies;
            [self.collectionView reloadData];
            [self.fetchingActivityIndicator stopAnimating];
            [self.refreshControl endRefreshing];
        }
    }];
}

// specify how many cells in collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}

// specify what goes inside each cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MovieGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieGridCell" forIndexPath:indexPath];
    cell.movie = self.filteredMovies[indexPath.item];
    return cell;
}

// searching: filtering results based on what's typed
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Movie *evaluatedObject, NSDictionary *bindings) {
            return [[evaluatedObject.title lowercaseString] containsString:[searchText lowercaseString]];
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
    Movie *movie = self.filteredMovies[indexPath.item];
    
    DetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.movie = movie;
}

@end
