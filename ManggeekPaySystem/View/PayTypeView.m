//
//  PayTypeView.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "PayTypeView.h"

@implementation PayTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = Color_shadow.CGColor;
        self.layer.shadowOpacity = .12;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(-10, -3)];
        //添加直线
        [path addLineToPoint:CGPointMake(frame.size.width+7, -3)];
        [path addLineToPoint:CGPointMake(frame.size.width +7, frame.size.height+12)];
        [path addLineToPoint:CGPointMake(-10, frame.size.height+12)];
        [path addLineToPoint:CGPointMake(-10, -3)];
        //        设置阴影路径
        self.layer.shadowPath = path.CGPath;
        
        UIView *topView = [UIView createViewWithFrame:RECT(0, 0, WIDTH(self), 40) color:colorWithHexString(@"#eeeeee") alpha:1];
        [self addSubview:topView];
        
        UILabel *tipLabel = [UILabel createLabelWith:RECT(12, 5, 100, 30) alignment:Left font:14 textColor:colorWithHexString(@"#555555") bold:NO text:@"支付方式统计"];
        [self addSubview:tipLabel];
        
        UIButton *alipayButton = [UIButton createimageButtonWithFrame:RECT(0,50, 100, 43) imageName:@"icon_zhidubao"];
        [alipayButton setTitle:@" 支付宝" forState:UIControlStateNormal];
        alipayButton.userInteractionEnabled = NO;
        [alipayButton setTitleColor:ColorWith3 forState:UIControlStateNormal];
        alipayButton.titleLabel.font = FONT(14);
        [self addSubview:alipayButton];
        
        UIButton *weChatButton = [UIButton createimageButtonWithFrame:RECT(0,50+63, 100, 43) imageName:@"icon_weixin"];
        [weChatButton setTitle:@" 微    信" forState:UIControlStateNormal];
        weChatButton.userInteractionEnabled = NO;
        [weChatButton setTitleColor:ColorWith3 forState:UIControlStateNormal];
        weChatButton.titleLabel.font = FONT(14);
        [self addSubview:weChatButton];
        
        _aliPayOrderNumberLabel = [UILabel createLabelWith:RECT(100, 50,WIDTH(self)-200, 43) alignment:Center font:14 textColor:Color_666666 bold:NO text:@"0笔"];
        [self addSubview:_aliPayOrderNumberLabel];
        
        _weCahtOrderNumberLabel = [UILabel createLabelWith:RECT(100, 50+63,WIDTH(self)-200, 43) alignment:Center font:14 textColor:Color_666666 bold:NO text:@"0笔"];
        [self addSubview:_weCahtOrderNumberLabel];
        
        _alipayOrderMoneryLabel = [UILabel createLabelWith:RECT(WIDTH(self)-100, 50,100, 43) alignment:Center font:14 textColor:Color_666666 bold:NO text:@"0.00元"];
        [self addSubview:_alipayOrderMoneryLabel];
        
        _weChatOrderMoneryLabel = [UILabel createLabelWith:RECT(WIDTH(self)-100, 50+63,100, 43) alignment:Center font:14 textColor:Color_666666 bold:NO text:@"0.00元"];
        [self addSubview:_weChatOrderMoneryLabel];
        
    }
    return self;
}
- (void)setAlipayOrderNumber:(NSString *)alipayOrderNumber {
    _alipayOrderNumber = alipayOrderNumber;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:alipayOrderNumber];
    //更改字体
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:CUSTOM_FONT size:18] range:NSMakeRange(0, alipayOrderNumber.length-2)];
    //修改颜色
    [string addAttribute:NSForegroundColorAttributeName value:ColorWith3 range:NSMakeRange(0, alipayOrderNumber.length-2)];
    
    self.aliPayOrderNumberLabel.attributedText = string;
}
- (void)setAlipayOrderMonery:(NSString *)alipayOrderMonery {
    _alipayOrderMonery = alipayOrderMonery;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:alipayOrderMonery];
    //更改字体
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:CUSTOM_FONT size:18] range:NSMakeRange(0, alipayOrderMonery.length-2)];
    //修改颜色
    [string addAttribute:NSForegroundColorAttributeName value:ColorWith3 range:NSMakeRange(0, alipayOrderMonery.length-2)];
    self.alipayOrderMoneryLabel.attributedText  = string;
}
- (void)setWeChatOrderNumber:(NSString *)weChatOrderNumber {
    _weChatOrderNumber = weChatOrderNumber;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:weChatOrderNumber];
    //更改字体
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:CUSTOM_FONT size:18] range:NSMakeRange(0, weChatOrderNumber.length-2)];
    //修改颜色
    [string addAttribute:NSForegroundColorAttributeName value:ColorWith3 range:NSMakeRange(0, weChatOrderNumber.length-2)];
    self.weCahtOrderNumberLabel.attributedText = string;
}
- (void)setWeChatOrderMonery:(NSString *)weChatOrderMonery {
    _weChatOrderMonery = weChatOrderMonery;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:weChatOrderMonery];
    //更改字体
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:CUSTOM_FONT size:18] range:NSMakeRange(0, weChatOrderMonery.length-2)];
    //修改颜色
    [string addAttribute:NSForegroundColorAttributeName value:ColorWith3 range:NSMakeRange(0, weChatOrderMonery.length-2)];
    self.weChatOrderMoneryLabel.attributedText = string;
}
@end
