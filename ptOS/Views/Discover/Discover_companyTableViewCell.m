//
//  Discover_companyTableViewCell.m
//  ptOS
//
//  Created by 周瑞 on 16/9/12.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "Discover_companyTableViewCell.h"

#import "DisplayCollectionViewCell.h"

@implementation Discover_companyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ZRViewRadius(self.m_ImageView, 30);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(80, 60);
    layout.minimumLineSpacing = 10;
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.itemArray = [NSArray arrayWithObjects:@"新闻资讯",@"薪资政策",@"通知公告",@"工资查询",@"工友集",@"意见征集",nil];
    self.imageArray = [NSArray arrayWithObjects:@"icon_xinwenzixun",@"icon_xinzi",@"icon_tongzhigonggao",@"icon_gongzichaxun",@"icon_gongyouji",@"icon_yijianzhengji", nil];
    
    
    [self.disPlayCollectionView setCollectionViewLayout:layout];
    self.disPlayCollectionView.dataSource =  self;
    self.disPlayCollectionView.delegate = self;
    self.disPlayCollectionView.showsHorizontalScrollIndicator = NO;
    self.disPlayCollectionView.pagingEnabled = YES;
    [self.disPlayCollectionView registerClass:[DisplayCollectionViewCell class] forCellWithReuseIdentifier:@"DisplayCollectionViewCell"];
    [self.disPlayCollectionView registerNib:[UINib nibWithNibName:@"DisplayCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DisplayCollectionViewCell"];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}
//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str  = @"DisplayCollectionViewCell";
    DisplayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:str forIndexPath:indexPath ];
    if(indexPath.row<6){
        
        cell.itemLabel.text = [self.itemArray objectAtIndex:indexPath.row];
        NSString *imageName = [self.imageArray objectAtIndex:indexPath.row];
        cell.headerImage.image = [UIImage imageNamed:imageName];
    } else{
        cell.backgroundColor = WhiteColor;
        cell.itemLabel.text = @"";
        cell.headerImage.image = nil;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",indexPath.row);
    NSString *str = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    NSMutableDictionary *indexDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:str,@"0", nil];
    //发一个通知，传递当前被点击的cell
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"indexItem" object:self userInfo:indexDic];

    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"结束滑动");
    if(self.disPlayCollectionView.contentOffset.x > self.frame.size.width/2) {
        self.rightLabel.backgroundColor = MainColor;
        self.leftLabel.backgroundColor = BackgroundColor;
    } else {
        self.rightLabel.backgroundColor = BackgroundColor;
        self.leftLabel.backgroundColor = MainColor;
        
    }
    
    
}

@end
