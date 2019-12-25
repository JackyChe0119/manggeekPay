//
//  CustomKeyBoard.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "CustomKeyBoard.h"
@implementation CustomKeyBoard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"00",@"0",@"." ];
        for (int i = 0; i<4; i++) {
            for (int j = 0; j<3; j++) {
                UIButton *numberButton = [UIButton createTextButtonWithFrame:RECT(j*WIDTH(self)/4.0, i*HEIGHT(self)/4.0, WIDTH(self)/4.0, HEIGHT(self)/4.0) bgColor:colorWithHexString(@"#f9f9f9") textColor:colorWithHexString(@"#777777") font:30 bold:YES title:array[i*3+j]];
                numberButton.titleLabel.font = [UIFont fontWithName:CUSTOM_FONT size:40];
                [numberButton addTarget:self action:@selector(buttonCkick:) forControlEvents:UIControlEventTouchUpInside];
                numberButton.tag = i*3+j+1000;
                [numberButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
                [numberButton addTarget:self action:@selector(touchCancel:) forControlEvents:UIControlEventTouchDragOutside];
                numberButton.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
                numberButton.layer.borderColor = Color_LineE9.CGColor;
                numberButton.layer.borderWidth = .5;
                [self addSubview:numberButton];
            }
        }
        UIButton *delButton = [UIButton createTextButtonWithFrame:RECT(WIDTH(self)/4.0*3, 0, WIDTH(self)/4.0, HEIGHT(self)/4.0) bgColor:colorWithHexString(@"#fffbeb") textColor:colorWithHexString(@"#777777") font:30 bold:YES title:@""];
        [delButton setImage:IMAGE(@"icon_del") forState:UIControlStateNormal];
        [delButton setImage:IMAGE(@"icon_del") forState:UIControlStateHighlighted];
        [delButton addTarget:self action:@selector(buttonCkick:) forControlEvents:UIControlEventTouchUpInside];
        delButton.tag = 1100;
        [self addSubview:delButton];
        
        UIButton *clearButton = [UIButton createTextButtonWithFrame:RECT(WIDTH(self)/4.0*3, HEIGHT(self)/4.0, WIDTH(self)/4.0, HEIGHT(self)/4.0) bgColor:colorWithHexString(@"#fff7d9") textColor:colorWithHexString(@"#fff7d9") font:30 bold:YES title:@""];
        [clearButton setImage:IMAGE(@"icon_clear") forState:UIControlStateNormal];
        [clearButton setImage:IMAGE(@"icon_clear") forState:UIControlStateHighlighted];
        [clearButton addTarget:self action:@selector(buttonCkick:) forControlEvents:UIControlEventTouchUpInside];
        clearButton.tag = 1200;
        [self addSubview:clearButton];
        
        UIButton *scanButton = [UIButton createTextButtonWithFrame:RECT(WIDTH(self)/4.0*3, HEIGHT(self)/4.0*2, WIDTH(self)/4.0, HEIGHT(self)/4.0*2) bgColor:colorWithHexString(@"#ffeeac") textColor:colorWithHexString(@"#ffeeac") font:30 bold:YES title:@""];
        [scanButton setImage:IMAGE(@"icon_scan_pay") forState:UIControlStateNormal];
        [scanButton setImage:IMAGE(@"icon_scan_pay") forState:UIControlStateHighlighted];
        [scanButton addTarget:self action:@selector(buttonCkick:) forControlEvents:UIControlEventTouchUpInside];
        scanButton.tag = 1300;
        [self addSubview:scanButton];
    }
    return self;
}
- (void)touchDown:(UIButton *)sender {
    [sender setBackgroundColor:ColorYellow];
}
- (void)touchCancel:(UIButton *)sender {
    [sender setBackgroundColor:colorWithHexString(@"#f9f9f9")];
}
- (void)buttonCkick:(UIButton *)sender {
    if (sender.tag<1100) {
        [sender setBackgroundColor:colorWithHexString(@"#f9f9f9")];
    }
    switch (sender.tag) {
        case 1000:
            _returnBlock(@"1",sender.tag);
            break;
        case 1001:
            _returnBlock(@"2",sender.tag);
            break;
        case 1002:
            _returnBlock(@"3",sender.tag);
            break;
        case 1003:
            _returnBlock(@"4",sender.tag);
            break;
        case 1004:
            _returnBlock(@"5",sender.tag);
            break;
        case 1005:
            _returnBlock(@"6",sender.tag);
            break;
        case 1006:
            _returnBlock(@"7",sender.tag);
            break;
        case 1007:
            _returnBlock(@"8",sender.tag);
            break;
        case 1008:
            _returnBlock(@"9",sender.tag);
            break;
        case 1009:
            _returnBlock(@"00",sender.tag);
            break;
        case 1010:
            _returnBlock(@"0",sender.tag);
            break;
        case 1011:
            _returnBlock(@".",sender.tag);
            break;
        case 1100:
            _returnBlock(@"del",sender.tag);
            break;
        case 1200:
            _returnBlock(@"clear",sender.tag);
            break;
        case 1300:
            _returnBlock(@"scan",sender.tag);
            break;
        default:
            break;
    }
}
@end
