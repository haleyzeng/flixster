//
//  WebViewController.m
//  flixster
//
//  Created by Haley Zeng on 6/28/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.loadingActivityIndicator startAnimating];
    [self fetchTrailer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
    [self close];
}


- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)fetchTrailer {
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed", self.movie[@"id"]];
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            
            // create alert element
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Error"
                                        message:[error localizedDescription]
                                        preferredStyle:(UIAlertControllerStyleAlert)];

            // create try again action button
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
            [self presentViewController:alert animated:YES completion:^{
            }];
            
        }
        else {
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *videos = dataDictionary[@"results"];
            
            NSString *basetrailerURLString = @"https://www.youtube.com/embed/";
            NSString *fullTrailerURLString = [basetrailerURLString stringByAppendingString:videos[0][@"key"]];
            
            NSLog(@"%@", fullTrailerURLString);
            
            // Convert the url String to a NSURL object.
            NSURL *trailerURL = [NSURL URLWithString:fullTrailerURLString];

            // Place the URL in a URL Request.
            NSURLRequest *request = [NSURLRequest requestWithURL:trailerURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];

            // Load Request into WebView.
            [self.webView loadRequest:request];
            [self.loadingActivityIndicator stopAnimating];
           NSLog(@"loaded");
        }
    }];
    
    [task resume];
    
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
