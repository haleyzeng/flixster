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
 
    // base for poster and backdrop photos
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    
    // =============== add backdrop photo =====================
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullUBackdropRLString = [baseURLString stringByAppendingString:backdropURLString];
    NSURL *backdropURL = [NSURL URLWithString:fullUBackdropRLString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:backdropURL];
    
    __weak DetailViewController *weakSelf = self;
    [self.detailBackdropImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        // imageResponse will be nil if the image is cached
        if (imageResponse) {
            NSLog(@"Backdrop Image was NOT cached, fade in image");
            weakSelf.detailBackdropImageView.alpha = 0.0;
            weakSelf.detailBackdropImageView.image = image;
            
            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.detailBackdropImageView.alpha = 1.0;
            }];
        }
        else {
            NSLog(@"Backdrop Image was cached so just update the image");
            weakSelf.detailBackdropImageView.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
        // do something for the failure condition
    }];
    // ==========================================================
    
    // ================ add poster photo ========================
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullUPosterRLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullUPosterRLString];
    
    request = [NSURLRequest requestWithURL:posterURL];
    
    [self.detailPosterImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        // imageResponse will be nil if the image is cached
        if (imageResponse) {
            NSLog(@"Detail Poster Image was NOT cached, fade in image");
            weakSelf.detailPosterImageView.alpha = 0.0;
            weakSelf.detailPosterImageView.image = image;
            
            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.detailPosterImageView.alpha = 1.0;
            }];
        }
        else {
            NSLog(@"Detail Poster Image was cached so just update the image");
            weakSelf.detailPosterImageView.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
        // do something for the failure condition
    }];
    // =======================================================
    
    // Create a white border around movie poster
    self.detailPosterImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.detailPosterImageView.layer.borderWidth = 1.5;

    // add title, release date, and synopsis
    self.detailTitleLabel.text = self.movie[@"title"];
    self.detailDateLabel.text = self.movie[@"release_date"];
    self.detailDescriptionLabel.text = self.movie[@"overview"];
    
    // label box will resize based on length of description
    [self.detailDescriptionLabel sizeToFit];
    
    // adjust scrollview size according to size needs of description
    double maxHeight = self.detailDescriptionLabel.frame.origin.y + self.detailDescriptionLabel.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, maxHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WebViewController *webViewController = [segue destinationViewController];
    webViewController.movie = self.movie;
}

@end
