//
//  UIImageView+Create.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/23.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "UIImageView+Create.h"

@implementation UIImageView (Create)

+ (UIImageView *)createImageViewWithFrame:(CGRect)rect imageName:(NSString *)imageName {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}

@end
