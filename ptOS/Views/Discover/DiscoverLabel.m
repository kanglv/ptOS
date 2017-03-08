//
//  DiscoverLabel.m
//  ptOS
//
//  Created by 周瑞 on 16/9/27.
//  Copyright © 2016年 zhourui. All rights reserved.
//

#import "DiscoverLabel.h"
#import "ControlUtil.h"
#import "FX_TZDetailModel.h"
@implementation DiscoverLabel
{
    NSArray *_array;
    CGFloat height;
    CGFloat h;
}
- (id)initWithArray:(NSArray *)array {
    if (self == [super init]) {
        self.backgroundColor = RGB(242, 242, 242);
        ZRViewRadius(self, 10);
        _array = array;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    h = 0;
    for (NSDictionary *replyDict in _array) {
        
        NSString *replyId = replyDict[@"replyId"];
        NSString *replyName = replyDict[@"replyName"];
        NSString *repliedName = replyDict[@"repliedName"];
        NSString *replyContent = replyDict[@"replyContent"];
        NSString *time = replyDict[@"time"];
        
//        CGFloat replyWidth = [ControlUtil widthWithContent:replyName withFont:[UIFont systemFontOfSize:14] withHeight:14];
//        CGFloat repliedWidth = [ControlUtil widthWithContent:repliedName withFont:[UIFont systemFontOfSize:14] withHeight:14];
//        CGFloat huifuWidth = [ControlUtil widthWithContent:@"回复" withFont:[UIFont systemFontOfSize:14] withHeight:14];
        CGFloat contentHeight;
        NSString *text;
        if (![repliedName isKindOfClass:[NSNull class]] && ![repliedName isEqualToString:@""] && repliedName != nil) {
            //有回复人
            contentHeight = [ControlUtil heightWithContent:[NSString stringWithFormat:@"%@%@%@：%@",replyName,@"回复",repliedName,replyContent] withFont:[UIFont systemFontOfSize:14] withWidth:FITWIDTH(258)];
            text = [NSString stringWithFormat:@"%@回复%@：%@",replyName,repliedName,replyContent];
            
        }else {
            //没有回复人
            contentHeight = [ControlUtil heightWithContent:[NSString stringWithFormat:@"%@%@%@：%@",replyName,@"",repliedName,replyContent] withFont:[UIFont systemFontOfSize:14] withWidth:FITWIDTH(258)];
            text = [NSString stringWithFormat:@"%@%@：%@",replyName,repliedName,replyContent];
        }
        

        UILabel *label = [[UILabel alloc]init];
        label.textColor = RGB(40, 40, 40);
        label.numberOfLines = 0;
        label.text = text;
        label.font = [UIFont systemFontOfSize:14];
        if (![repliedName isKindOfClass:[NSNull class]] && ![repliedName isEqualToString:@""] && repliedName != nil) {
            //有回复人
            NSRange range1 = [text rangeOfString:@"回复"];
            NSRange range2 = [text rangeOfString:@"："];
            NSMutableAttributedString *att1 = [[NSMutableAttributedString alloc] initWithString:text];
            [att1 addAttributes:@{NSForegroundColorAttributeName:MainColor}  range:NSMakeRange(0, range1.location)];
            [att1 addAttributes:@{NSForegroundColorAttributeName:MainColor} range:NSMakeRange(range1.location+2, range2.location-range1.location-1)];
            label.attributedText = att1;

        }else {
            //没有回复人
            NSRange range = [text rangeOfString:@"："];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
            [att addAttributes:@{NSForegroundColorAttributeName:MainColor}  range:NSMakeRange(0, range.location+1)];
            label.attributedText = att;
        }
        label.frame = CGRectMake(12, h + 5 , FITWIDTH(258), contentHeight + 10);
        [self addSubview:label];
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(FITWIDTH(258 + 10), label.y + 8, 55, 12)];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.text = time;
        timeLabel.textColor = RGB(153, 153, 153);
        timeLabel.textAlignment = NSTextAlignmentRight;
        label.tag = 10000 + replyId.integerValue;
        [self addSubview:timeLabel];
        
        UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reply:)];
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:g];
        h = h + label.height;
    }
    NSString *str = [NSString stringWithFormat:@"%f",h];
    [UserDefault setValue:str forKey:@"height"];
}

- (CGFloat)getHeightWithArray:(NSArray *)array {
    CGFloat he = 5;
    for (NSDictionary *replyDict in array) {
        NSString *replyId = replyDict[@"replyId"];
        NSString *replyName = replyDict[@"replyName"];
        NSString *repliedName = replyDict[@"repliedName"];
        NSString *replyContent = replyDict[@"replyContent"];
        NSString *time = replyDict[@"time"];
        
        CGFloat contentHeight = 0;
        NSString *text;
        if (![repliedName isKindOfClass:[NSNull class]] && ![repliedName isEqualToString:@""] && repliedName != nil) {
            //有回复人
            contentHeight = [ControlUtil heightWithContent:[NSString stringWithFormat:@"%@%@%@：%@",replyName,@"回复",repliedName,replyContent] withFont:[UIFont systemFontOfSize:14] withWidth:FITWIDTH(258)];
            text = [NSString stringWithFormat:@"%@回复%@：%@",replyName,repliedName,replyContent];
            
        }else {
            //没有回复人
            contentHeight = [ControlUtil heightWithContent:[NSString stringWithFormat:@"%@%@%@：%@",replyName,@"",repliedName,replyContent] withFont:[UIFont systemFontOfSize:14] withWidth:FITWIDTH(258)];
            text = [NSString stringWithFormat:@"%@%@：%@",replyName,repliedName,replyContent];
        }
        he = he + contentHeight + 10;
    }
    return he;
}

- (void)reply:(UITapGestureRecognizer *)g {
    NSInteger replyId = g.view.tag - 10000;
    NSString *name;
    for (NSDictionary *replyDict in _array) {
        if ([replyDict[@"replyId"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)replyId]] ) {
            name = replyDict[@"replyName"];
        }
    }
    [self.delegate replyWithId:[NSString stringWithFormat:@"%ld",(long)replyId] withRepliedName:name];
}



@end
