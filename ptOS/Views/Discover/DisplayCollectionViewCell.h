//
//  DisplayCollectionViewCell.h
//  ptOS
//
//  Created by 吕康 on 17/3/5.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;
@property (strong, nonatomic) IBOutlet UILabel *itemLabel;

@end
