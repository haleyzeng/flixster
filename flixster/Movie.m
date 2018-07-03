//
//  Movie.m
//  flixster
//
//  Created by Haley Zeng on 7/2/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.title = dictionary[@"title"];
    self.releaseDate = dictionary[@"release_date"];
    self.synopsis = dictionary[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    
    NSString *posterURLString = dictionary[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    self.posterURL = [NSURL URLWithString:fullPosterURLString];
    
    NSString *backdropURLString = dictionary[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    
    self.backdropURL = [NSURL URLWithString:fullBackdropURLString];
    
    self.movieID = dictionary[@"id"];
    
    return self;
}

+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in dictionaries) {
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
        
        [movies addObject:movie];
    }
    return movies;
}

@end
