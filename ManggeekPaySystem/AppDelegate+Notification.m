//
//  AppDelegate+Notification.m
//  KongGeekSample
//
//  Created by Robin on 16/7/2.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import "AppDelegate+Notification.h"
#import <objc/runtime.h>
//利用静态变量地址唯一不变的特性
static void *strKey = &strKey;

@implementation AppDelegate (Notification)
-(void) registerNotification:(UIApplication *)application {
  if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]){//IOS8以上
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:notiSettings];
    } else{ // ios7
        //        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    }
}
- (void)setInfoDic:(NSDictionary *)infoDic {
    objc_setAssociatedObject(self, &strKey, infoDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}
- (NSDictionary *)infoDic {
    return objc_getAssociatedObject(self,&strKey);
}
-(void) refreshDeviceToken:(NSData *)deviceToken {
    NSString *currentToken = [[[[deviceToken description]
                                stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""]  stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Receive DeviceToken: %@", currentToken);
    [[NSUserDefaults standardUserDefaults] setObject:currentToken forKey:DEVICE_TOKEN];
}
//启动时接收到消息的后续处理
-(void)handleReceiveNotificationByLaunching:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions{
    application.applicationIconBadgeNumber = 0;
    if (launchOptions) {
        NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [self forwarToPage:message];
    }
}
//接收到消息的后续处理
-(void)handleReceiveNotification:(UIApplication *)application UserInfo:(NSDictionary *)userInfo{
    application.applicationIconBadgeNumber = 0;
    if (application.applicationState == UIApplicationStateActive) {
        [self showMessageAlert:userInfo];
    }else{
        [self forwarToPage:userInfo];
    }
}
//app正在使用的时候收到了通知处理
- (void)showMessageAlert:(NSDictionary *)userInfo {
    [CommonUtil playSound:userInfo[@"aps"][@"alert"]];
    self.infoDic = userInfo;
}

//app退到后台的情况,根据参数不同，跳转到不同的页面
- (void)forwarToPage:(NSDictionary *)userInfo {
   
}
//app在前台的时候收到消息推送的处理（iOS 10）
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary *userInfo = notification.request.content.userInfo;
    [self showMessageAlert:userInfo];
}
//app在后台的时候收到消息推送的处理（iOS 10）
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    [self forwarToPage:userInfo];
}
@end
