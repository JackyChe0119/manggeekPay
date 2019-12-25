//
//  CustomAlertView.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor =ColorWhite;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        
        UIButton *closeButton = [UIButton createimageButtonWithFrame:RECT(WIDTH(self)-30, 0, 30, 30) imageName:@"iocn_close"];
        [closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:RECT(WIDTH(self)/2.0-40, 20, 80, 80)];
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        
        if (type==1) {
            imageView.image = IMAGE(@"iocn_exit");
            UILabel *tipLabel = [UILabel createLabelWith:RECT(10, GETY(imageView.frame)+5, WIDTH(self)-20, 30) alignment:Center font:19 textColor:Color_666666 bold:YES text:@"确认退出?"];
            [self addSubview:tipLabel];
            
            UIButton *sureButton = [UIButton createTextButtonWithFrame:RECT(WIDTH(self)/2.0-55, HEIGHT(self)-55, 110, 32) bgColor:ColorYellow textColor:ColorWhite font:15 bold:YES title:@"确定"];
            [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:sureButton];

        }else if (type==2) {
            imageView.image = IMAGE(@"icon_contactView");
            UILabel *tipLabel = [UILabel createLabelWith:RECT(10, GETY(imageView.frame)+10, WIDTH(self)-20, 30) alignment:Center font:19 textColor:ColorWith3 bold:YES text:@"400-670-1855"];
            tipLabel.font = [UIFont fontWithName:CUSTOM_FONT size:25];
            [self addSubview:tipLabel];
            
            UILabel *companyLabel = [UILabel createLabelWith:RECT(10, GETY(tipLabel.frame)+5, WIDTH(self)-20, 20) alignment:Center font:15 textColor:Color_777777 bold:YES text:@"杭州芒极科技有限公司"];
            [self addSubview:companyLabel];
            
            UIButton *sureButton = [UIButton createTextButtonWithFrame:RECT(WIDTH(self)/2.0-55, HEIGHT(self)-55, 110, 32) bgColor:ColorYellow textColor:ColorWhite font:15 bold:YES title:@"拨打"];
            [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:sureButton];
            
        }else if (type==3) {
            imageView.image = IMAGE(@"icon_order_info");
            UILabel *tipLabel = [UILabel createLabelWith:RECT(10, GETY(imageView.frame)+5, WIDTH(self)-20, 30) alignment:Center font:19 textColor:Color_666666 bold:YES text:@"请输入订单号"];
            [self addSubview:tipLabel];
            
            UIView *inputBaseview = [UIView createViewWithFrame:RECT(15, HEIGHT(self)-120, WIDTH(self)-30, 40) color:colorWithHexString(@"#eeeeee") alpha:1];
            [self addSubview:inputBaseview];
            
            _inputView = [[UITextField alloc]initWithFrame:RECT(0, 5, WIDTH(inputBaseview), 30)];
            _inputView.textColor = ColorYellow;
            _inputView.font = [UIFont boldSystemFontOfSize:17];
            _inputView.keyboardType = UIKeyboardTypeASCIICapable;
            _inputView.textAlignment = NSTextAlignmentCenter;
            _inputView.adjustsFontSizeToFitWidth = YES;
            [_inputView setValue:ColorYellow forKeyPath:@"_placeholderLabel.textColor"];
            [inputBaseview addSubview:_inputView];

            UIButton *sureButton = [UIButton createTextButtonWithFrame:RECT(WIDTH(self)/2.0-55, HEIGHT(self)-55, 110, 32) bgColor:ColorYellow textColor:ColorWhite font:15 bold:YES title:@"确定"];
            [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:sureButton];
        }
    }
    return self;
}
- (void)sureButtonClick {
    if (_alertblock) {
        _alertblock (1);
    }
}
- (void)closeButtonClick {
    if (_alertblock) {
        _alertblock (0);
    }
}
@end
