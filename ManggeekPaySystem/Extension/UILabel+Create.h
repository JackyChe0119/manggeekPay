//
//  UILabel+Create.h
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/23.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,textAlignmngt)  {
    Left = 0,
    Center,
    Right,
};
@interface UILabel (Create)
+ (UILabel *)createLabelWith:(CGRect)rect alignment:(textAlignmngt)alignment font:(CGFloat)font textColor:(UIColor *)color bold:(BOOL)bold text:(NSString *)text;
@end
