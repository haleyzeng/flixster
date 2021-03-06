//
//  MovieGridCell.h
//  flixster
//
//  Created by Haley Zeng on 6/28/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieGridCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (strong, nonatomic) Movie *movie;
@end
