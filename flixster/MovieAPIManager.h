//
//  MovieAPIManager.h
//  flixster
//
//  Created by Haley Zeng on 7/2/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieAPIManager : NSObject

@property (nonatomic, strong) NSURLSession *session;

- (void)fetchNowPlaying:(void(^)(NSArray *movies, NSError *error))completion;

- (void)fetchTrailerOf:(id)movieID withBlock:(void(^)(NSURL *trailerURL, NSError *error))completion;

@end
