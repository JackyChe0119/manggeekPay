//
//  UIView+Create.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/23.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "UIView+Create.h"

@implementation UIView (Create)

+ (UIView *)createViewWithFrame:(CGRect)rect color:(UIColor *)color alpha:(CGFloat)alpha{
    UIView *view = [[UIView alloc]initWithFrame:rect];
    view.backgroundColor = [color colorWithAlphaComponent:alpha];
    return view;
}

- (void)setCornerDious:(CGFloat)cornerDious {
    self.layer.cornerRadius = cornerDious;
    self.layer.masksToBounds = YES;
}
- (void)setBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor  {
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
}
@end
