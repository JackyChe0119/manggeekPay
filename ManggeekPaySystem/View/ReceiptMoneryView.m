//
//  ReceiptMoneryView.m
//  ManggeekPaySystem 实收金额视图
//
//  Created by 车杰 on 2018/4/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "ReceiptMoneryView.h"

@implementation ReceiptMoneryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = Color_shadow.CGColor;
        self.layer.shadowOpacity = .14;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(-10, -3)];
        //添加直线
        [path addLineToPoint:CGPointMake(frame.size.width+7, -3)];
        [path addLineToPoint:CGPointMake(frame.size.width +7, frame.size.height+12)];
        [path addLineToPoint:CGPointMake(-10, frame.size.height+12)];
        [path addLineToPoint:CGPointMake(-10, -3)];
//        设置阴影路径
        self.layer.shadowPath = path.CGPath;



        UILabel *tipLabel = [UILabel createLabelWith:RECT(12, 5, 100, 30) alignment:Left font:14 textColor:colorWithHexString(@"#111111") bold:NO text:@"实收金额(元)"];
        [self addSubview:tipLabel];
        
        _moneryLabel = [UILabel createLabelWith:RECT(5, 40, WIDTH(self)-10, 100) alignment:Center font:14 textColor:ColorYellow bold:NO text:@"0.00"];
        _moneryLabel.font = [UIFont fontWithName:CUSTOM_FONT size:45];
        [self addSubview:_moneryLabel];
        
        _orderNumberLabel = [UILabel createLabelWith:RECT(5, HEIGHT(self)-65, WIDTH(self)/2.0-10, 30) alignment:Center font:14 textColor:ColorWith3 bold:NO text:@"0"];
        _orderNumberLabel.font = [UIFont fontWithName:CUSTOM_FONT size:25];
        [self addSubview:_orderNumberLabel];
        
        _returnMoneryLabel = [UILabel createLabelWith:RECT(WIDTH(self)/2.0+5, HEIGHT(self)-65, WIDTH(self)/2.0-10, 30) alignment:Center font:14 textColor:ColorWith3 bold:NO text:@"0.00"];
        _returnMoneryLabel.font = [UIFont fontWithName:CUSTOM_FONT size:25];
        [self addSubview:_returnMoneryLabel];
        
        UILabel *tipLabel2 = [UILabel createLabelWith:RECT(5, HEIGHT(self)-40,WIDTH(self)/2.0-10, 30) alignment:Center font:14 textColor:Color_666666 bold:NO text:@"订单笔数(笔)"];
        [self addSubview:tipLabel2];
        
        UILabel *tipLabel3 = [UILabel createLabelWith:RECT(5+WIDTH(self)/2.0, HEIGHT(self)-40, WIDTH(self)/2.0-10, 30) alignment:Center font:14 textColor:Color_666666 bold:NO text:@"退款金额(元)"];
        [self addSubview:tipLabel3];
        
        UIView *lineview = [UIView createViewWithFrame:RECT(WIDTH(self)/2.0, HEIGHT(self)-50, .5, 15) color:ColorLine alpha:1];
        [self addSubview:lineview];
    }
    return self;
}
- (void)setAllMoery:(NSString *)allMoery {
    _allMoery = allMoery;
    self.moneryLabel.text = allMoery;
}
- (void)setOrderNumber:(NSString *)orderNumber {
    _orderNumber = orderNumber;
    _orderNumberLabel.text = orderNumber;
}
- (void)setReturnMoery:(NSString *)returnMoery {
    _returnMoery = returnMoery;
    _returnMoneryLabel.text = returnMoery;
}
@end
