//
//  CutsomActionsheet.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "CutsomActionsheet.h"

@implementation CutsomActionsheet

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title listArray:(NSArray *)array{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ColorWhite;
        
        _itemArray = array;
        
        UIView *topView = [UIView createViewWithFrame:RECT(0, 0, WIDTH(self), 50) color:colorWithHexString(@"#eeeeee") alpha:1];
        [self addSubview:topView];
        
        UILabel *titleLabel = [UILabel createLabelWith:RECT(15, 10, 100, 30) alignment:Left font:16 textColor:colorWithHexString(@"#555555") bold:YES text:title    ];
        [self addSubview:titleLabel];
        
        UIButton *cancelButton = [UIButton createimageButtonWithFrame:CGRectMake(WIDTH(self)-45, 5, 30, 40) imageName:@"icon_xxxxx"];
        [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        for (int i = 0; i<array.count; i++) {
            UIView *listView = [UIView createViewWithFrame:RECT(0, 60*i+50, ScreenWidth, 60) color:ColorWhite alpha:1];
            listView.tag = 1000+i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapItem:)];
            listView.userInteractionEnabled = YES;
            [listView addGestureRecognizer:tap];
            
            UILabel *label = [UILabel createLabelWith:RECT(15, 10, ScreenWidth-30, 40) alignment:Left font:15 textColor:ColorWith3 bold:NO text:array[i]];
            [listView addSubview:label];
            
            UIView *lineView = [UIView createViewWithFrame:RECT(15, 59.5, ScreenWidth-15, .5) color:ColorLine alpha:1];
            [listView addSubview:lineView];
            
            [self addSubview:listView];
        }

    }
    return self;
}
- (void)cancel {
    if (_delegate&&[_delegate respondsToSelector:@selector(customActionSheetClickCancelInView:)]) {
        [_delegate customActionSheetClickCancelInView:self];
    }
}
- (void)tapItem:(UITapGestureRecognizer *)tap {
    if (_delegate&&[_delegate respondsToSelector:@selector(customActionSheetClickInView:index:)]) {
        [_delegate customActionSheetClickInView:self index:tap.view.tag-1000];
    }
}
@end
