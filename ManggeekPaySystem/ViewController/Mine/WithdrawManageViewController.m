//
//  WithdrawManageViewController.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "WithdrawManageViewController.h"

@interface WithdrawManageViewController ()<UITextViewDelegate>
@property (nonatomic,strong)UIScrollView *baseScrollView;
@property (nonatomic,strong)UITextView *editTextView;
@end

@implementation WithdrawManageViewController

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
    
    UIButton *sureButton = [UIButton createTextButtonWithFrame:RECT(30, ScreenHeight-NAVIGATION_BAR_HEIGHT, (ScreenWidth-120)/2.0, 44) bgColor:ColorYellow textColor:ColorWhite font:15 bold:YES title:@"同意"];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    sureButton.layer.cornerRadius = 3;
    sureButton.layer.masksToBounds = YES;
    [self.view addSubview:sureButton];
    
    UIButton *refuseButton = [UIButton createTextButtonWithFrame:RECT(30+ScreenWidth/2.0, ScreenHeight-NAVIGATION_BAR_HEIGHT, (ScreenWidth-120)/2.0, 44) bgColor:ColorYellow textColor:ColorWhite font:15 bold:YES title:@"拒绝"];
    [refuseButton addTarget:self action:@selector(refuseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    refuseButton.layer.cornerRadius = 3;
    refuseButton.layer.masksToBounds = YES;
    [self.view addSubview:refuseButton];
    
}
- (void)layoutData {
    UIView *topView  = [UIView createViewWithFrame:RECT(15, NAVIGATION_BAR_HEIGHT+25, ScreenWidth-30, 55) color:ColorWhite alpha:1];
    topView.backgroundColor = [ColorWhite colorWithAlphaComponent:.9];
    [self.view addSubview:topView];
    
    UILabel *order = [UILabel createLabelWith:RECT(15, 10, 60, 35) alignment:Left font:14 textColor:ColorWith3 bold:NO text:@"门店"];
    [topView addSubview:order];
    
    UILabel *orderNumber= [UILabel createLabelWith:RECT(GETX(order.frame), 10, WIDTH(topView)-GETX(order.frame)-10, 35) alignment:Right font:16 textColor:ColorWith3 bold:NO text:self.resultDic[@"storeName"]];
    [topView addSubview:orderNumber];
    
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
    NSArray *array = @[@"账号",@"渠道",@"金额",@"时间",@"备注"];
    NSArray *array2 = @[self.resultDic[@"account"],payType,[NSString stringWithFormat:@"%.2f",[self.resultDic[@"amount"] doubleValue]],self.resultDic[@"createTime"],remarks];
    
    for (int i = 0; i<array.count; i++) {
        UILabel *label = [UILabel createLabelWith:RECT(15,5+45*i, 70, 45) alignment:Left font:15 textColor:ColorWith3 bold:NO text:array[i]];
        [_baseScrollView addSubview:label];
        
        UILabel *infoLabel = [UILabel createLabelWith:RECT(85, 5+45*i, WIDTH(_baseScrollView)-100, 45) alignment:Right font:15 textColor:Color_666666 bold:NO text:array2[i]];
        [_baseScrollView addSubview:infoLabel];
        if (i==2) {
            infoLabel.font = [UIFont fontWithName:CUSTOM_FONT size:18];
            infoLabel.frame = RECT(85, 8+45*i,WIDTH(_baseScrollView)-100,42);
        }
    }
    
    UIView *inputTextView = [UIView createViewWithFrame:RECT(15, 45*array.count+5, ScreenWidth-60, 80) color:[UIColor whiteColor] alpha:1];
    inputTextView.layer.cornerRadius = 3;
    inputTextView.layer.borderWidth = .5;
    inputTextView.layer.borderColor = ColorYellow.CGColor;
    [_baseScrollView addSubview:inputTextView];
    
    _editTextView = [[UITextView alloc]initWithFrame:RECT(5, 5,WIDTH(inputTextView)-10 , HEIGHT(inputTextView)-10)];
    _editTextView.delegate = self;
    _editTextView.text = @"请输入备注";
    _editTextView.font = FONT(14);
    _editTextView.textColor = Color_666666;
    [inputTextView addSubview:_editTextView];
    
    
    [_baseScrollView setContentSize:CGSizeMake(WIDTH(_baseScrollView), GETY(inputTextView.frame)+10)];

}
- (void)sureButtonClick {
    [AlertViewUtil showSelectAlertViewWithVC:self Title:@"同意该提现申请?" Message:@"" LeftTitle:@"取消" RightTitle:@"确认" callBack:^(NSInteger type) {
        if (type==1) {
        }else {
            [self dorequest:1];//执行退款操作
        }
    }];
}
- (void)refuseButtonClick {
    [AlertViewUtil showSelectAlertViewWithVC:self Title:@"拒绝该提现申请?" Message:@"" LeftTitle:@"取消" RightTitle:@"确认" callBack:^(NSInteger type) {
        if (type==1) {
        }else {
            [self dorequest:2];//执行退款操作
        }
    }];
}
- (void)dorequest:(NSInteger)type {
    [self showProgressHud];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    [params setValue:[NSNumber numberWithInteger:[self.resultDic[@"id"] integerValue] ] forKey:@"id"];
    NSString *merchantId =  [[NSUserDefaults standardUserDefaults] objectForKey:@"merchantId"];
    [params setValue:[NSNumber numberWithInteger:[merchantId integerValue] ]  forKey:@"merchantId"];
    if (type==1) {
        [params setObject:@"fish" forKey:@"withdrawState"];
    }else {
        [params setObject:@"err" forKey:@"withdrawState"];
    }
    if (![_editTextView.text isEqualToString:@"请输入备注"]) {
        [params setValue:_editTextView.text forKey:@"refusal"];
    }
    [RequestEngine doRqquestWithMessage:@"withdraw_audit/audit.do" params:params callbackBlock:^(ResponseMessage *result) {
        [self hiddenProgressHud];
        if ([result isSuccessful]) {
            [self showToastHUD:@"操作成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self showToastHUD:result.errorMessage];
        }
    }];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([_editTextView.text isEqualToString:@"请输入备注"]) {
        _editTextView.text = @"";
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (_editTextView.text.length==0) {
        _editTextView.text = @"请输入备注";
    }
}
@end
