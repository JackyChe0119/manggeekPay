//
//  UIImageView+Create.h
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/23.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Create)
/*
 * 参数：不切圆角的图片
 */
+ (UIImageView *)createImageViewWithFrame:(CGRect)rect imageName:(NSString *)imageName;

@end
