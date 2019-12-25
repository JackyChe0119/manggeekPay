//
//  inputView.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "inputView.h"

@implementation inputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.inputTextfield];
        [self addSubview:self.lineView];
    }
    return self;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelWith:RECT(12, 1, 100, HEIGHT(self)-2) alignment:Left font:14 textColor:ColorWith3 bold:NO text:@""];
    }
    return _titleLabel;
}
- (void)setTitLe:(NSString *)titLe {
    _titLe = titLe;
    self.titleLabel.text = titLe;
}
- (UITextField *)inputTextfield {
    if (!_inputTextfield) {
       _inputTextfield = [[UITextField alloc]initWithFrame:RECT(112, HEIGHT(self)/2.0-15, ScreenWidth-124, 30)];
        _inputTextfield.borderStyle = 0;
        _inputTextfield.font = FONT(14);
        _inputTextfield.textColor = ColorWith3;
        _inputTextfield.textAlignment = NSTextAlignmentRight;
    }
    return _inputTextfield;
}
- (void)setPlaceHold:(NSString *)placeHold {
    _placeHold = placeHold;
    self.inputTextfield.placeholder = placeHold;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView createViewWithFrame:RECT(12, HEIGHT(self)-0.5, ScreenWidth-12, .5) color:ColorLine alpha:1];
    }
    return _lineView;
}
@end




