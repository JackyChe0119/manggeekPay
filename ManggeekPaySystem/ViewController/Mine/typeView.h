//
//  typeView.h
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface typeView : UIView
@property (nonatomic,strong)UILabel *item1,*item2;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,assign)BOOL isSelect;
@property (nonatomic,assign)NSInteger type;//1 支付宝 2 银行卡
@property (nonatomic,strong) void (^tapBlock)(NSString *text);
@end
