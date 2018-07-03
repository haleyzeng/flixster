//
//  MoviesViewController.m
//  flixster
//
//  Created by Haley Zeng on 6/27/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"
#import "Movie.h"
#import "MovieAPIManager.h"


@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *fetchingActivityIndicator;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSArray *filteredMovies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    // animate mid-screen loading wheel
    [self.fetchingActivityIndicator startAnimating];
    
    // pull movies from database into tableview
    [self fetchMovies];
    
    // create pull-to-refresh loading wheel
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    // when pull-to-refresh wheel activated, fetch movies
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    
    // add refresh wheel to view
    [self.tableView insertSubview:self.refreshControl atIndex:0];
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
            [self.tableView reloadData];
            [self.fetchingActivityIndicator stopAnimating];
            [self.refreshControl endRefreshing];
        }
    }];
}

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
    
    [self.tableView reloadData];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
      self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.filteredMovies = self.movies;
    [self.tableView reloadData];
}

// tells tableview how many rows are in the table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}

// tells tableview what goes inside each cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    cell.movie = self.filteredMovies[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    Movie *movie = self.filteredMovies[indexPath.row];
    
    DetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.movie = movie;
}


@end
