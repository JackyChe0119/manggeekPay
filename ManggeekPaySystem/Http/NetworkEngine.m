//
//  NetworkEngine.m
//  KongGeekSample
//
//  Created by Robin on 16/7/5.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import "NetworkEngine.h"
#import "InterfaceMacro.h"
#import <AFHTTPSessionManager.h>
#import "CommonToastHUD.h"
#define TIME_OUT 5 //请求超时时间

@implementation NetworkEngine

+(void)sendRequestMessage:(RequestMessage *)message delegate:(id)delegate callbackSelector:(SEL)callbackSelector{
    [self doRequest:message delegate:delegate callbackSelector:callbackSelector callbackBlock:nil];
}

+(void)sendRequestMessage:(RequestMessage *)message callbackBlock:(NetworkResponseCallback)callback{
    [self doRequest:message delegate:nil callbackSelector:nil callbackBlock:callback];
}

+(void)doRequest:(RequestMessage *)message delegate:(id)delegate callbackSelector:(SEL)callbackSelector callbackBlock:(NetworkResponseCallback)callbackBlock {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (message.args) {
        [params setValuesForKeysWithDictionary:message.args];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = TIME_OUT;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFSecurityPolicy *security = [AFSecurityPolicy defaultPolicy];
    security.allowInvalidCertificates = YES;
    security.validatesDomainName = NO;
    manager.securityPolicy = security;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    NSLog(@"%@", [NSString stringWithFormat:@"请求地址%@",message.url]);
    NSLog(@"请求参数===========%@",message.args);
    if (message.method==GET) {
        [manager GET:message.url parameters:message.args progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"请求成功！responseObject : %@",responseObject);
            [self proccessResponse:message operation:responseObject responseObject:responseObject error:nil delegate:delegate callbackSelector:callbackSelector callbackBlock:callbackBlock];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求出错:%@ + responseString : %@",error.userInfo,task);
            [self proccessResponse:message operation:error.userInfo responseObject:nil error:error delegate:delegate callbackSelector:callbackSelector callbackBlock:callbackBlock];
        }];
    }
//    NSString *jsonStr = [self toJSONString:message.args];
    if (message.method==POST) {
        [manager POST:message.url parameters:message.args progress:^(NSProgress * _Nonnull uploadProgress) {
                // 这里可以获取到目前的数据请求的进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"请求成功！responseObject : %@",responseObject);
                [self proccessResponse:message operation:responseObject responseObject:responseObject error:nil delegate:delegate callbackSelector:callbackSelector callbackBlock:callbackBlock];
               NSHTTPURLResponse *resonse = (NSHTTPURLResponse *)task.response;
            NSLog(@"请求的头部信息为:========>>>%@",resonse.allHeaderFields);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"请求出错:%@ + responseString : %@",error.userInfo,task.response);
                [self proccessResponse:message operation:error.userInfo responseObject:nil error:error delegate:delegate callbackSelector:callbackSelector callbackBlock:callbackBlock];
        }];
        message.url = [message.url stringByAppendingString:@"?"];
        [[params allKeys] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            message.url = [message.url stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",obj,[params objectForKey:obj]]];
        }];
        NSLog(@"============>>>>%@<<<<===========",message.url);
    }
}

+(void)proccessResponse:(RequestMessage *)message operation:(NSDictionary *)operation responseObject:(id)responseObject error:(NSError *)error delegate:(id)delegate callbackSelector:(SEL)callbackSelector callbackBlock:(NetworkResponseCallback)callbackBlock {
    ResponseMessage *responseMessage =[[ResponseMessage alloc] initWithRequestUrl:message.url requestArgs:message.args];
    if (responseObject && [responseObject isKindOfClass:NSDictionary.class]) {
        responseMessage.responseObject=responseObject;
        responseMessage.success=responseObject[@"success"];
        responseMessage.bussinessData=responseObject[@"result"];
        responseMessage.bussinessInfo = responseMessage.bussinessData[@"info"];
        responseMessage.list = responseMessage.bussinessData[@"list"];;
        responseMessage.errorMessage= responseObject[@"result"][@"desc"];
        responseMessage.totalPage = [responseObject[@"totalPage"] integerValue];
        if ([responseObject[@"result"][@"errorCode"] integerValue]==10013) {
            NSHTTPCookieStorage *manager = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSArray *cookieStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
            for (NSHTTPCookie *cookie in cookieStorage) {
                [manager deleteCookie:cookie];
            }
            [CommonToastHUD showTips:responseMessage.errorMessage];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Cookie"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCESS_TOKEN];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Cookielogout" object:nil];
        }
        NSLog(@"=====%@======",responseMessage.bussinessData);
    }

    if (error) {
        responseMessage.responseState=ResponseFailureFinished;
        responseMessage.success = @"500";//服务器异常
        if (error.code==-1009) {
            responseMessage.errorMessage = @"网络异常，请检查网络连接";
        }else if (error.code == -1001) {
            responseMessage.errorMessage = @"网络请求超时，请稍后重新尝试";
        }else {
            responseMessage.errorMessage = @"系统处理异常，请稍后重新尝试";
        }
    }else{
        responseMessage.responseState=ResponseSuccessFinished;
    }
    if (delegate && [delegate respondsToSelector:callbackSelector]) {
        IMP imp = [delegate methodForSelector:callbackSelector];
        void (*func)(id, SEL,ResponseMessage *) = (void *)imp;
        func(delegate, callbackSelector,responseMessage);
    }
    if (callbackBlock) {
        callbackBlock(responseMessage);
    }
}
+(NSString *)toJSONString:(id)dataObject {
    if (!dataObject) {
        return nil;
    }
    if ([NSJSONSerialization isValidJSONObject:dataObject])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataObject options:NSJSONWritingPrettyPrinted error:&error];
        if(error) {
            return nil;
        }
        NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}
+(void)addAdditionalParams:(NSMutableDictionary *)params{
    NSString *accessToken =[[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN];
    if (accessToken) {
        [params setObject:accessToken forKey:ACCESS_TOKEN];
    }
    [params setObject:@"iOS" forKey:REQUEST_SOURCE];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [params setObject:version forKey:REQUEST_VERSION];
}

@end

