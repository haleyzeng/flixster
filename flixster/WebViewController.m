//
//  WebViewController.m
//  flixster
//
//  Created by Haley Zeng on 6/28/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "WebViewController.h"
#import "MovieAPIManager.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // animate mid-screen loading wheel
    [self.loadingActivityIndicator startAnimating];
    
    // get trailer
    [self fetchTrailer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// linked to X button
// when tapped, close moda, view
- (IBAction)onTap:(id)sender {
    [self close];
}

// close modal view
- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// get trailer from YouTube
- (void)fetchTrailer {
    MovieAPIManager *manager = [MovieAPIManager new];
    [manager fetchTrailerOf:(id)self.movie.movieID withBlock:^(NSURL *trailerURL, NSError *error) {
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
                                                 [self fetchTrailer];
                                             }];
            
            // create Go Back action button
            UIAlertAction *goBackAlert = [UIAlertAction
                                          actionWithTitle:@"Go Back"
                                          style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction * _Nonnull action) {
                                              [self close];
                                          }];
            
            // add the Try Again action to the alert controller
            [alert addAction:tryAgainAction];
            
            // add the Go Back action to the alert controller
            [alert addAction:goBackAlert];
            
            // show alert
            [self presentViewController:alert animated:YES completion:^{}];
        }
        else { // no error
            if (trailerURL != nil) {
                // Place the URL in a URL Request.
                NSURLRequest *request = [NSURLRequest requestWithURL:trailerURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
            
                // Load Request into WebView.
                [self.webView loadRequest:request];
            }
            else { // if no videos exist
                // create alert element
                UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Not Available"
                                        message:@"No Trailer Available"
                                        preferredStyle:(UIAlertControllerStyleAlert)];
           
                // create Go Back action button
                UIAlertAction *goBackAlert = [UIAlertAction
                                          actionWithTitle:@"Go Back"
                                          style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction * _Nonnull action) {
                                              [self close];
                                          }];
           
                // add the Go Back action to the alert controller
                [alert addAction:goBackAlert];
            
                // show alert
                [self presentViewController:alert animated:YES completion:^{}];
            }
        }
        
        // stop mid-screen loading view
        [self.loadingActivityIndicator stopAnimating];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
