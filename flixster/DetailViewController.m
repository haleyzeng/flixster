//
//  DetailViewController.m
//  flixster
//
//  Created by Haley Zeng on 6/27/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "WebViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *detailBackdropImageView;
@property (weak, nonatomic) IBOutlet UIImageView *detailPosterImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullUBackdropRLString = [baseURLString stringByAppendingString:backdropURLString];
    NSURL *backdropURL = [NSURL URLWithString:fullUBackdropRLString];
    [self.detailBackdropImageView setImageWithURL:backdropURL];
    
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullUPosterRLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullUPosterRLString];
    [self.detailPosterImageView setImageWithURL:posterURL];
    
    // Create a white border with defined width
    self.detailPosterImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.detailPosterImageView.layer.borderWidth = 1;
    // Set image corner radius
  //  self.detailPosterImageView.layer.cornerRadius = 5.0;
    
    self.detailTitleLabel.text = self.movie[@"title"];
    self.detailDateLabel.text = self.movie[@"release_date"];
    self.detailDescriptionLabel.text = self.movie[@"overview"];
    
    [self.detailTitleLabel sizeToFit];
    [self.detailDescriptionLabel sizeToFit];
    
 //   double maxHeight = self.detailDescriptionLabel.frame.origin.y + self.detailDescriptionLabel.frame.size.height;
    
  //  self.scrollView.frame.size = CGSizeMake(self.scrollView.frame.size.width, maxHeight);
    
    NSLog(@"%@", self.movie[@"id"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onTap:(id)sender {
    NSLog(@"Tapping");
    [self performSegueWithIdentifier:@"trailerSegue" sender:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    WebViewController *webViewController = [segue destinationViewController];
    webViewController.movie = self.movie;
}


@end
