//
//  UIButton+Create.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/23.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "UIButton+Create.h"

@implementation UIButton (Create)
+ (UIButton *)createimageButtonWithFrame:(CGRect)rect imageName:(NSString *)imageName{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame  = rect;
    
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
    return button;
}

+ (UIButton *)createTextButtonWithFrame:(CGRect)rect bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor font:(CGFloat)font bold:(BOOL)bold title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = rect;
    
    [button setBackgroundColor:bgColor];
    
    [button setTitleColor:textColor forState:UIControlStateNormal];
    
    if (bold) {
        button.titleLabel.font = [UIFont boldSystemFontOfSize:font];
    }else {
        button.titleLabel.font = FONT(font);
    }
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

@end
