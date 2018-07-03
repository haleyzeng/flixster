//
//  MovieGridCell.m
//  flixster
//
//  Created by Haley Zeng on 6/28/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "MovieGridCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MovieGridCell

- (void)setMovie:(Movie *)movie {
    _movie = movie;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.movie.posterURL];
    
    // load poster image with fade-in if is being downloaded
    __weak MovieGridCell *weakSelf = self;
    [self.posterImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        // imageResponse will be nil if the image is cached
        if (imageResponse) {
            NSLog(@"Grid Poster Image was NOT cached, fade in image");
            weakSelf.posterImageView.alpha = 0.0;
            weakSelf.posterImageView.image = image;
            
            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.posterImageView.alpha = 1.0;
            }];
        }
        else {
            NSLog(@"Grid Poster Image was cached so just update the image");
            weakSelf.posterImageView.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
    }];
    

}


@end
