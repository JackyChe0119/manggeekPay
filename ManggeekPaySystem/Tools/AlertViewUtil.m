//
//  AlertViewUtil.m
//  ManggeekBaseProject
//
//  Created by 车杰 on 2017/8/10.
//  Copyright © 2017年 Jacky. All rights reserved.
//

#import "AlertViewUtil.h"
@implementation AlertViewUtil

+ (void)showCancelAlertViewWithVC:(UIViewController *)ViewController Title:(NSString *)title Message:(NSString *)message LeftTitle:(NSString *)LeftTitle  callbackBlock:(MJVoidCallbackBlock)callbackBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:LeftTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        callbackBlock();
    }];
    [alertController addAction:rightAction];
    [ViewController presentViewController:alertController animated:YES completion:nil];
}
+ (void)showSelectAlertViewWithVC:(UIViewController *)ViewController Title:(NSString *)title Message:(NSString *)message LeftTitle:(NSString *)LeftTitle RightTitle:(NSString *)rightTitle  callBack:(MJTypeCallbackBlock)callBackBlock  {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:LeftTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        callBackBlock(1);
    }];
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        callBackBlock(2);
    }];
    [alertController addAction:otherAction];
    [alertController addAction:rightAction];
    [ViewController presentViewController:alertController animated:YES completion:nil];
}
@end
