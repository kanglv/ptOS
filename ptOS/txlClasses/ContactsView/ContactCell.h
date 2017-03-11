//
//  ContactCell.h
//  Contacts
//
//  Created by emma on 15/6/18.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactCellDelegate <NSObject>


@end


@interface ContactCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;


@property (assign, nonatomic) id<ContactCellDelegate> delegate;

@end
