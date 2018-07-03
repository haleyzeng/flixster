//
//  Movie.h
//  flixster
//
//  Created by Haley Zeng on 7/2/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *releaseDate;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSURL *posterURL;
@property (nonatomic, strong) NSURL *backdropURL;
@property (nonatomic) id movieID;

// constructor
- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries;

@end
