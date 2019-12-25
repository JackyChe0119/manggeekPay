//
//  CustomTimeSelectView.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "CustomTimeSelectView.h"

@implementation CustomTimeSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ColorWhite;
        
        UILabel *shi = [UILabel createLabelWith:RECT(10, 10, 20, 20) alignment:Center font:14 textColor:colorWithHexString(@"#555555") bold:NO text:@"始"];
        [self addSubview:shi];
        
        UIButton *shiButton = [UIButton createimageButtonWithFrame:RECT(WIDTH(self)/2.0-30, 10, 20, 20) imageName:@"icon_selectItem"];
        [shiButton addTarget:self action:@selector(shiButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shiButton];
        
        UILabel *zhong = [UILabel createLabelWith:RECT(WIDTH(self)/2.0+10, 10, 20, 20) alignment:Center font:14 textColor:colorWithHexString(@"#555555") bold:NO text:@"终"];
        [self addSubview:zhong];
        
        UIButton *zhongButton = [UIButton createimageButtonWithFrame:RECT(WIDTH(self)-30, 10, 20, 20) imageName:@"icon_selectItem"];
          [zhongButton addTarget:self action:@selector(zhongButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:zhongButton];
        
        UIView *lineView = [UIView createViewWithFrame:RECT(WIDTH(self)/2.0, 13, .5, 14) color:ColorLine alpha:1];
        [self addSubview:lineView];
        
        _beginTimeLabel = [UILabel createLabelWith:RECT(30, 5, WIDTH(self)/2.0-60, 35) alignment:Center font:14 textColor:colorWithHexString(@"#555555") bold:NO text:@"2018-01-01"];
        _beginTimeLabel.font = [UIFont fontWithName:CUSTOM_FONT size:20];
        _beginTimeLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(beginTimeLabelTap)];
        [_beginTimeLabel addGestureRecognizer:tap];
        _beginTimeLabel.tag = 100;
        _beginTime = @"2018-01-01";
        [self addSubview:_beginTimeLabel];
        
        NSDate *currentDate = [NSDate date];
        NSString *dateStr = [CommonUtil getStringForDate:currentDate format:@"yyyy-MM-dd"];
        _endTime = dateStr;
        
        _endTimeLabel = [UILabel createLabelWith:RECT(WIDTH(self)/2.0+30, 5, WIDTH(self)/2.0-60, 35) alignment:Center font:14 textColor:colorWithHexString(@"#555555") bold:NO text:dateStr];
        _endTimeLabel.tag = 200;
        _endTimeLabel.font = [UIFont fontWithName:CUSTOM_FONT size:20];
        _endTimeLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endTimeLabelTap)];
        [_endTimeLabel addGestureRecognizer:tap2];
        [self addSubview:_endTimeLabel];
        
    }
    return self;
}
- (void)setBeginTime:(NSString *)beginTime {
    _beginTime = beginTime;
    self.beginTimeLabel.text = beginTime;
}
- (void)setEndTime:(NSString *)endTime {
    _endTime = endTime;
    self.endTimeLabel.text = endTime;
}
/**
 *   起始时间点击了
 **/
- (void)shiButtonClick {
    if (_delegate&&[_delegate respondsToSelector:@selector(customeTimeSelectViewClickView:viewTag:)]) {
        [_delegate customeTimeSelectViewClickView:self viewTag:100];
    }
}
- (void)beginTimeLabelTap {
    if (_delegate&&[_delegate respondsToSelector:@selector(customeTimeSelectViewClickView:viewTag:)]) {
        [_delegate customeTimeSelectViewClickView:self viewTag:100];
    }
}
/**
 *   结束时间点击了
 **/
- (void)zhongButtonClick {
    if (_delegate&&[_delegate respondsToSelector:@selector(customeTimeSelectViewClickView:viewTag:)]) {
        [_delegate customeTimeSelectViewClickView:self viewTag:200];
    }
}
- (void)endTimeLabelTap {
    if (_delegate&&[_delegate respondsToSelector:@selector(customeTimeSelectViewClickView:viewTag:)]) {
        [_delegate customeTimeSelectViewClickView:self viewTag:200];
    }
}
@end
