//
//  RequestEngine.h
//  CCube
//
//  Created by Robin on 16/8/20.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkEngine.h"
#define RSA_PRIVATE @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAM9IlyAYjxzD5CwXC6APW5Gr0vSKVkE8jQqPee1TSI1iQc0QhfAqrZpod1k7lFgqNfgwo42rRcjbB4LjVbukeYsp0Wqb4cb5tXzJoBrKhg9H6GmdpoEMQ5un0nm8aL8Xb1UJwdjuOjhk1q836G/xSfBbr94C5ENrqa/kdpeqvrxbAgMBAAECgYEAhxqtRgI75WfY5NPwg9b+vCfeS/2O0t6An418zy8lbuHIOby3UB7BII9Omx62RfDdVHN/ZutnhM8eSjWav78oaFt4ec6VLHONxBFedyCv8rJIRwJDdxXAx6JisB+Pf0NxaaLHcYY7S3ZBvyuL3A9H1aFsM9+VAQ81J7i6o1GXkiECQQD0mCqYrONYndhKuOq2hjd2d2Tglf61UXq2/+8loyY9kQxyam8iopeOxcP9SMoePHrujrn++twlZPX88gU7fvF/AkEA2PMHD13dFJn7bKUeAhLbVCT+omR52JzZ2AuOb10b49APwHKMTioWuPr/6Mm+1SmrKiPRXDJGeqiZ49wkeOqrJQJBANS4xksUCYFXffW2jwMBBZl1Svl72hKNc2FWgwFDvA1NafrUECWaLJ9R5hsRRB850FxLKv3T5MRs4vcC8YQF6jcCQFm+Pn9mzptFDzJkI0OsVTo7i3HVqmmmiJ7MOQFsPKtCWCG9wLhcxMWEXvQG8H/xGrL12hcPXQREVlRhrlyuhlkCQDUApVsbaOBkCLay8xWVBozLrlttAsgoi0UlOZ3nN5WJydhNY+kMhOs0O4zoZopbmCcKinleO7pjqFgOlsqTXlU="

typedef void (^RequestResultBlock)(ResponseMessage *responseMessage);

@interface RequestEngine : NSObject

+ (void)doRqquestWithMessage:(RequestMessage *)message callbackBlock:(NetworkResponseCallback)callbackBlock;
+ (void)doRqquestWithMessage:(NSString *)url params:(NSMutableDictionary *)params callbackBlock:(NetworkResponseCallback)callbackBlock;

+ (void)doRqquestForWeather:(NSString *)url params:(NSMutableDictionary *)params methodL:(NSString *)method callbackBlock:(NetworkResponseCallback)callbackBlock;
@end

