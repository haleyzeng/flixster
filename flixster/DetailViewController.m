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
 
    self.detailBackdropImageView.image = nil;
    [self loadBackdropImage];
    
    self.detailPosterImageView.image = nil;
    [self loadPosterImage];
    
    // Create a white border around movie poster
    self.detailPosterImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.detailPosterImageView.layer.borderWidth = 1.5;

    // add title, release date, and synopsis
    self.detailTitleLabel.text = self.movie.title;
    self.detailDateLabel.text = self.movie.releaseDate;
    self.detailDescriptionLabel.text = self.movie.synopsis;
    
    // label box will resize based on length of description
    [self.detailDescriptionLabel sizeToFit];
    
    // adjust scrollview size according to size needs of description
    double maxHeight = self.detailDescriptionLabel.frame.origin.y + self.detailDescriptionLabel.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, maxHeight);
}

- (void)loadBackdropImage {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.movie.backdropURL];
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
    }];
}

- (void)loadPosterImage {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.movie.posterURL];
    __weak DetailViewController *weakSelf = self;
    // will fade in if being downloaded
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
    }];
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
