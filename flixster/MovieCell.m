//
//  MovieCell.m
//  flixster
//
//  Created by Haley Zeng on 6/27/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMovie:(Movie *)movie {
    _movie = movie;
    
    self.titleLabel.text = self.movie.title;
    self.descriptionLabel.text = self.movie.synopsis;
    self.posterImageView.image = nil;
    if (self.movie.posterURL != nil) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.movie.posterURL];
        __weak MovieCell *weakSelf = self;
        [self.posterImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
            // imageResponse will be nil if the image is cached
            if (imageResponse) {
                NSLog(@"Poster Image was NOT cached, fade in image");
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
}

@end
