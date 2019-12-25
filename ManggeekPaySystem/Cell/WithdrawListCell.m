//
//  WithdrawListCell.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "WithdrawListCell.h"

@implementation WithdrawListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.statusLabel.textColor = ColorYellow;
    self.priceLabel.textColor = ColorWith3;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.timelAabel.textColor = colorWithHexString(@"#a8a8a8");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
