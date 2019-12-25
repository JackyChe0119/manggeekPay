//
//  AppDelegate.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/23.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "IQKeyboardManager.h"
#import "AppDelegate+Notification.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window =  [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    [self registerNotification:application];
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    [self registerIQKboardManager];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN]!=nil) {
        MainViewController *MainVc = [[MainViewController alloc]init];
        self.window.rootViewController = MainVc;
    }else {
        LoginViewController *LoginVc = [[LoginViewController alloc]init];
        self.window.rootViewController = LoginVc;
    }
    
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"Cookie"]];
    NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie * cookie in cookies){
        [cookieStorage setCookie: cookie];
        NSLog(@"cookies--->>>%@",cookies);
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Cookielogout) name:@"Cookielogout" object:nil];
    
    [application setApplicationIconBadgeNumber:0];
    
    return YES;
}
- (void)Cookielogout {
    LoginViewController *LoginVc = [[LoginViewController alloc]init];
    self.window.rootViewController = LoginVc;
}
/**
 *   键盘第三方 
 **/
- (void)registerIQKboardManager {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES; // 控制整个功能是否启用。
    manager.shouldResignOnTouchOutside =YES; // 控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor =YES; // 控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar =YES; // 控制是否显示键盘上的工具条
}
- (void)applicationWillResignActive:(UIApplication *)application {
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
}
- (void)applicationWillTerminate:(UIApplication *)application {
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken{
    [self refreshDeviceToken:pToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [self handleReceiveNotification:application UserInfo:userInfo];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"DeviceToken获取失败:%@",error.description);
}
@end
