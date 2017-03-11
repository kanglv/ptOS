//
//  NTESContactViewController.h
//  NIMDemo
//
//  Created by chris on 15/2/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactCell.h"
@interface NTESContactViewController : UIViewController<ContactCellDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    
    NSMutableArray *searchResults;
    UISearchBar *contactsSearchBar;
    UISearchDisplayController *searchDisplayController;
    
}


@property(nonatomic,strong) IBOutlet UITableView *tableView;

@end
