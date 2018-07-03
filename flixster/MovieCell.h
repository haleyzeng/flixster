//
//  MovieCell.h
//  flixster
//
//  Created by Haley Zeng on 6/27/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) Movie *movie;

@end
