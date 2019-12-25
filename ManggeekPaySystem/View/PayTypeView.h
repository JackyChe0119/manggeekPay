//
//  PayTypeView.h
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTypeView : UIView
@property (nonatomic,strong)UILabel *aliPayOrderNumberLabel,*alipayOrderMoneryLabel;
@property (nonatomic,strong)UILabel *weCahtOrderNumberLabel,*weChatOrderMoneryLabel;
@property (nonatomic,copy) NSString *alipayOrderNumber,*alipayOrderMonery;
@property (nonatomic,copy) NSString *weChatOrderNumber,*weChatOrderMonery;
@end
