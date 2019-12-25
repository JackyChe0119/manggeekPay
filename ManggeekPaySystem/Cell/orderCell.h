//
//  orderCell.h
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *psyTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeimageView;
@property (weak, nonatomic) IBOutlet UILabel *payPriceLabel;
- (void)showCellWithDic:(NSDictionary *)result;
@end
