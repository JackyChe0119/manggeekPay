//
//  ReceiptMoneryView.h
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptMoneryView : UIView
@property (nonatomic,strong)UILabel *moneryLabel;
@property (nonatomic,strong)UILabel *orderNumberLabel;
@property (nonatomic,strong)UILabel *returnMoneryLabel;
@property (nonatomic,copy)NSString *allMoery,*orderNumber,*returnMoery;
@end
