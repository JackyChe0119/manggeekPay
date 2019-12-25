//
//  RequestEngine.m
//  CCube
//
//  Created by Robin on 16/8/20.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import "RequestEngine.h"
@class RequestMessage;
@implementation RequestEngine
//注册
/*
 ***  数据请求类 ****
 */
+ (void)doRqquestWithMessage:(NSString *)url params:(NSMutableDictionary *)params callbackBlock:(NetworkResponseCallback)callbackBlock {
    RequestMessage *requestMessage = [[RequestMessage alloc]initWithUrl:URLAppendAPIServer(url) args:params];
    [NetworkEngine sendRequestMessage:requestMessage callbackBlock:^(ResponseMessage *responseMessage) {
        callbackBlock(responseMessage);
    }];
}

@end

