//
//  orderCell.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "orderCell.h"

@implementation orderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.timeLabel.textColor = colorWithHexString(@"#555555");
    self.orderNumberLabel.textColor = colorWithHexString(@"#a8a8a8");
    self.payPriceLabel.textColor = ColorWith3;
    self.psyTypeLabel.textColor = ColorYellow;
}
- (void)showCellWithDic:(NSDictionary *)result {
    if ([result[@"payChannel"] integerValue]==1) {
        self.typeimageView.image = IMAGE(@"icon_zhifubao_big");
    }else {
        self.typeimageView.image = IMAGE(@"icon_weixin_big");
    }
    self.timeLabel.text = result[@"createTime"];
    self.orderNumberLabel.text = result[@"orderNo"];
    if ([result[@"status"] integerValue]==1) {
        self.psyTypeLabel.textColor = ColorYellow;
        self.psyTypeLabel.text = @"支付成功";
    }else if([result[@"status"] integerValue]==2) {
        self.psyTypeLabel.textColor = colorWithHexString(@"fe6631");
        self.psyTypeLabel.text = @"支付失败";
    }else if([result[@"status"] integerValue]==4){
        self.psyTypeLabel.textColor = colorWithHexString(@"fe6631");
        self.psyTypeLabel.text = @"退款成功";
        self.psyTypeLabel.textColor = colorWithHexString(@"fe6631");
    }else if([result[@"status"] integerValue]==0){
        self.psyTypeLabel.textColor = colorWithHexString(@"fe6631");
        self.psyTypeLabel.text = @"开始支付";
        self.psyTypeLabel.textColor = colorWithHexString(@"fe6631");
    }else {
        self.psyTypeLabel.textColor = colorWithHexString(@"fe6631");
        self.psyTypeLabel.text = @"未支付";
        self.psyTypeLabel.textColor = colorWithHexString(@"fe6631");
    }
    self.payPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[result[@"amount"] doubleValue]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
