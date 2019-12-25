//
//  InterfaceMarco.h
//  KongGeekSample
//
//  Created by Robin on 16/7/2.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#ifndef InterfaceMarco_h
#define InterfaceMarco_h

#define URLAppendAPIServer(path) [NSString stringWithFormat:@"%@%@",URL_RootAPIServer,path]
#define ACCESS_TOKEN @"accessToken"
#define REQUEST_VERSION  @"version"
#define REQUEST_SOURCE @"source"

//测试环境
#define URL_RootAPIServer @"http://service.pay.manggeek.com/"
//#define URL_RootAPIServer @"http://192.168.0.147:8088/"


//正式环境
//#define URL_RootAPIServer @"http://121.42.196.103:8080/mj-server"

#define ALIYUN_OSS_BUCKET_NAME @"diaoyuoss"
#define ALIYUN_OSS_IMAGE_DOMAIN @"http://diaoyuoss.oss-cn-hangzhou.aliyuncs.com"

#define ALIYUN_OSS_SERVER @"http://oss-cn-hangzhou.aliyuncs.com"
#define ALIYUN_OSS_GET_ACCESS_TOKEN @"/common/alioss/distribute_token.htm"


#endif /* InterfaceMarco_h */

