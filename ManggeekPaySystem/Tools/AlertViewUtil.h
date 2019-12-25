//
//  AlertViewUtil.h
//  ManggeekBaseProject
//
//  Created by 车杰 on 2017/8/10.
//  Copyright © 2017年 Jacky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJCallBackBlock.h"

@interface AlertViewUtil : NSObject
/*
 * 参数：取消提示框 只有提示效果  不做任何处理
 */
+ (void)showCancelAlertViewWithVC:(UIViewController *)ViewController Title:(NSString *)title Message:(NSString *)message LeftTitle:(NSString *)LeftTitle  callbackBlock:(MJVoidCallbackBlock)callbackBlock;
/*
 * 参数：选择提示框 callbackBlock 执行右边action  callbackBlock2执行左边action
 */
+ (void)showSelectAlertViewWithVC:(UIViewController *)ViewController Title:(NSString *)title Message:(NSString *)message LeftTitle:(NSString *)LeftTitle RightTitle:(NSString *)rightTitle  callBack:(MJTypeCallbackBlock)callBackBlock;
@end
