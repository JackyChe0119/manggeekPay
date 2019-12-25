//
//  UIView+Create.h
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/23.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Create)
/*
 * 参数：无切圆角的视图创建
 */
+ (UIView *)createViewWithFrame:(CGRect)rect color:(UIColor *)color alpha:(CGFloat)alpha;
/*
 * 参数：给View切割圆角
 */
- (void)setCornerDious:(CGFloat)cornerDious;
/*
 * 参数：设置边框颜色和宽度
 */
- (void)setBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end
