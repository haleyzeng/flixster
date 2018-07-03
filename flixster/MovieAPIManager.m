//
//  MovieAPIManager.m
//  flixster
//
//  Created by Haley Zeng on 7/2/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "MovieAPIManager.h"
#import "Movie.h"

@implementation MovieAPIManager

// constructor
- (id)init {
    self = [super init];
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    return self;
}

- (void)fetchNowPlaying:(void(^)(NSArray *movies, NSError *error))completion {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            // The network request has completed, but failed.
            // Invoke the completion block with an error.
            // Think of invoking a block like calling a function with parameters
            completion(nil, error);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *dictionaries = dataDictionary[@"results"];
            NSArray *movies = [Movie moviesWithDictionaries:dictionaries];
            
            // The network request has completed, and succeeded.
            // Invoke the completion block with the movies array.
            // Think of invoking a block like calling a function with parameters
            completion(movies, nil);
        }
    }];
    [task resume];
}

- (void)fetchTrailerOf:(id)movieID withBlock:(void(^)(NSURL *trailerURL, NSError *error))completion {
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed", movieID];
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }
        else {
            // convert json data to dictionary obj
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *videos = dataDictionary[@"results"];
            
            NSURL *trailerURL;
            // if there are videos
            if (videos.count == 0)
                trailerURL = nil;
            
            else {
                // build url string
                NSString *basetrailerURLString = @"https://www.youtube.com/embed/";
                
                NSString *fullTrailerURLString = [basetrailerURLString stringByAppendingString:videos[0][@"key"]];
                
                // Convert the url String to a NSURL object.
                trailerURL = [NSURL URLWithString:fullTrailerURLString];
            }
            completion(trailerURL, nil);
        }
        
    }];
    
    [task resume];
    
}
@end
