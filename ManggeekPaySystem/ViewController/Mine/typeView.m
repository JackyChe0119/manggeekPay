//
//  typeView.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "typeView.h"

@implementation typeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.item1];
        [self addSubview:self.item2];
        [self addSubview:self.imageView];
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = .5;
        self.layer.borderColor = ColorYellow.CGColor;
    }
    return self;
}
- (UILabel *)item1 {
    if (!_item1) {
        _item1 = [UILabel createLabelWith:RECT(0, 0, WIDTH(self)-5,30) alignment:Center font:13 textColor:ColorYellow bold:NO text:@"支付宝"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapInItem1)];
        _item1.userInteractionEnabled = YES;
        [_item1 addGestureRecognizer:tap];
        
    }
    return _item1;
}
- (void)setType:(NSInteger)type {
    _type = type;
    if (_type==1) {
        self.item1.text = @"支付宝";
        self.item2.text = @"银行卡";
    }else {
        self.item1.text = @"银行卡";
        self.item2.text = @"支付宝";
    }
}
- (UILabel *)item2 {
    if (!_item2) {
        _item2 = [UILabel createLabelWith:RECT(0, 30, WIDTH(self)-5,30) alignment:Center font:13 textColor:ColorYellow bold:NO text:@"银行卡"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapInItem2)];
        _item2.userInteractionEnabled = YES;
        [_item2 addGestureRecognizer:tap];
        
    }
    return _item2;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView createImageViewWithFrame:RECT(WIDTH(self)-22, 5, 20, 20) imageName:@"icon_xialalist"];
        _imageView.contentMode = UIViewContentModeCenter;
    }
    return _imageView;
}
- (void)tapInItem1 {
    if (self.isSelect) {
        CGRect rect = self.frame;
        rect.size.height = 30;
        [UIView animateWithDuration:.3 animations:^{
            self.frame = rect;
        }];
        self.isSelect = NO;
        self.imageView.image = IMAGE(@"icon_xialalist");
    }else {
        CGRect rect = self.frame;
        rect.size.height = 60;
        [UIView animateWithDuration:.3 animations:^{
            self.frame = rect;
        }];
        self.imageView.image = IMAGE(@"icon_shanglalist");
        self.isSelect = YES;
    }
}
- (void)tapInItem2 {
    if (self.type==2) {
        self.item1.text = @"支付宝";
        self.item2.text = @"银行卡";
        if (_tapBlock) {
            _tapBlock(@"alipay");
        }
        self.type = 1;
    }else {
        self.item1.text = @"银行卡";
        self.item2.text = @"支付宝";
        if (_tapBlock) {
            _tapBlock(@"blank");
        }
        self.type = 2;
    }
    CGRect rect = self.frame;
    rect.size.height = 30;
    [UIView animateWithDuration:.3 animations:^{
        self.frame = rect;
    }];
    self.isSelect = NO;
    self.imageView.image = IMAGE(@"icon_xialalist");
}
@end
