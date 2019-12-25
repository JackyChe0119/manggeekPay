//
//  UILabel+Create.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/23.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "UILabel+Create.h"

@implementation UILabel (Create)

+ (UILabel *)createLabelWith:(CGRect)rect alignment:(textAlignmngt)alignment font:(CGFloat)font textColor:(UIColor *)color bold:(BOOL)bold text:(NSString *)text {
    UILabel *label = [UILabel new];
    label.frame = rect;
    if (alignment==Left) {
        label.textAlignment = NSTextAlignmentLeft;
    }else if (alignment==Center) {
        label.textAlignment = NSTextAlignmentCenter;
    }else {
        label.textAlignment = NSTextAlignmentRight;
    }
    if (bold) {
        label.font = [UIFont boldSystemFontOfSize:font];
    }else {
        label.font = [UIFont systemFontOfSize:font];
    }
    label.textColor = color;
    label.text = text;
    return label;
}

@end

