//
//  CustomAlertView.h
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^alertBlock)(NSInteger type);
@interface CustomAlertView : UIView

@property (nonatomic,strong)alertBlock alertblock;
@property (nonatomic,strong)UITextField *inputView;
- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;

@end
