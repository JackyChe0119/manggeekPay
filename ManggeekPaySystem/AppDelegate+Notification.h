//
//  AppDelegate+Notification.h
//  KongGeekSample
//
//  Created by Robin on 16/7/2.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate (Notification)<UIAlertViewDelegate,UNUserNotificationCenterDelegate>

@property (nonatomic,strong) NSDictionary *infoDic;
-(void) registerNotification:(UIApplication *)application;

-(void) refreshDeviceToken:(NSData *)deviceToken;

-(void)handleReceiveNotificationByLaunching:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions;

-(void)handleReceiveNotification:(UIApplication *)application UserInfo:(NSDictionary *)userInfo;
@end
