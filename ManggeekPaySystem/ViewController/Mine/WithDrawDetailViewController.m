//
//  WithDrawDetailViewController.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "WithDrawDetailViewController.h"

@interface WithDrawDetailViewController ()
@property (nonatomic,strong)UIScrollView *baseScrollView;
@end

@implementation WithDrawDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
    
    [self layoutData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)layoutUI {
    UIImageView *BGimageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, ScreenHeight) imageName:@"icon_loginbg"];
    [self.view addSubview:BGimageView];
    
    [self navgationLeftButtonImage:@"icon_backup"];
    [self NavigationItemTitle:@"订单详情" Color:ColorWhite];
    
    UIView *baseView = [UIView createViewWithFrame:RECT(0, NAVIGATION_BAR_HEIGHT+80, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-80) color:ColorWhite alpha:1];
    [self.view addSubview:baseView];
    
    UIView *bottomView = [UIView createViewWithFrame:RECT(15, 0, ScreenWidth-30, ScreenHeight-NAVIGATION_BAR_HEIGHT-80-115) color:ColorWhite alpha:1];
    bottomView.layer.shadowColor = ColorBlack.CGColor;
    bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    bottomView.layer.shadowOpacity = .3;
    [baseView addSubview:bottomView];
    
    _baseScrollView = [[UIScrollView alloc]initWithFrame:RECT(15, 0, ScreenWidth-30, ScreenHeight-NAVIGATION_BAR_HEIGHT-80-115)];
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    _baseScrollView.bounces = NO;
    _baseScrollView.backgroundColor = ColorWhite;
    [baseView addSubview:_baseScrollView];
    
}
- (void)layoutData {
    UIView *topView  = [UIView createViewWithFrame:RECT(15, NAVIGATION_BAR_HEIGHT+25, ScreenWidth-30, 55) color:ColorWhite alpha:1];
    topView.backgroundColor = [ColorWhite colorWithAlphaComponent:.9];
    [self.view addSubview:topView];
    
    UILabel *order = [UILabel createLabelWith:RECT(15, 10, 60, 35) alignment:Left font:14 textColor:ColorWith3 bold:NO text:@"姓名"];
    [topView addSubview:order];
    
    UILabel *orderNumber= [UILabel createLabelWith:RECT(GETX(order.frame), 10, WIDTH(topView)-GETX(order.frame)-10, 35) alignment:Right font:16 textColor:ColorWith3 bold:NO text:self.resultDic[@"nickName"]];
    [topView addSubview:orderNumber];
    
    NSString *payStatus;
    if ([self.resultDic[@"withdrawState"] isEqualToString:@"wait"]) {
        payStatus = @"审核中";
    }else if ([self.resultDic[@"withdrawState"] isEqualToString:@"fish"]) {
        payStatus = @"已到账";
    }else {
        payStatus = @"未通过";
    }
    NSString *payType;
    if ([self.resultDic[@"payType"] isEqualToString:@"alipay"]) {
        payType = @"支付宝";
    }else {
        payType = @"银行卡";
    }
    NSString *remarks ;
    if (self.resultDic[@"remarks"]!=nil||![self.resultDic[@"remarks"] isEqualToString:@""] ) {
        remarks = self.resultDic[@"remarks"];
    }else {
        remarks = @"无备注";
    }
    NSArray *array = @[@"账号",@"渠道",@"金额",@"备注",@"状态",@"时间"];
    NSArray *array2 = @[self.resultDic[@"account"],payType,[NSString stringWithFormat:@"%.2f",[self.resultDic[@"amount"] doubleValue]],remarks,payStatus,self.resultDic[@"createTime"]];
    
    for (int i = 0; i<array.count; i++) {
        UILabel *label = [UILabel createLabelWith:RECT(15,5+45*i, 70, 45) alignment:Left font:15 textColor:ColorWith3 bold:NO text:array[i]];
        [_baseScrollView addSubview:label];
        
        UILabel *infoLabel = [UILabel createLabelWith:RECT(85, 5+45*i, WIDTH(_baseScrollView)-100, 45) alignment:Right font:15 textColor:Color_666666 bold:NO text:array2[i]];
        [_baseScrollView addSubview:infoLabel];
        if (i==2) {
            infoLabel.font = [UIFont fontWithName:CUSTOM_FONT size:18];
            infoLabel.frame = RECT(85, 8+45*i,WIDTH(_baseScrollView)-100,42);
        }else if (i==4) {
            infoLabel.textColor = ColorYellow;
        }
    }
    [_baseScrollView setContentSize:CGSizeMake(WIDTH(_baseScrollView), 45*array.count+5)];
    
}


@end
