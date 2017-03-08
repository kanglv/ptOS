//
//  Discover_companyTableViewCell.h
//  ptOS
//
//  Created by 周瑞 on 16/9/12.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Discover_companyTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *m_ImageView;

@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (strong, nonatomic) IBOutlet UICollectionView *disPlayCollectionView;
@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;

@property (strong, nonatomic)NSArray *itemArray;
@property (strong, nonatomic)NSArray *imageArray;

@end
