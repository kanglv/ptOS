//
//  CareManViewController.h
//  ptOS
//
//  Created by 胡礼节 on 2017/3/15.
//  Copyright © 2017年 zhourui. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContactCell.h"




@interface CareManViewController :  UIViewController<ContactCellDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    
    NSMutableArray *searchResults;
    UISearchBar *contactsSearchBar;
    UISearchDisplayController *searchDisplayController;
    
}


@end
