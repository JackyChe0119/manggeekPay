//
//  WithdrawViewController.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "WithdrawViewController.h"
#import "inputView.h"
#import "WithdrawListViewController.h"
#import "typeView.h"
@interface WithdrawViewController ()
@property (nonatomic,strong)UIScrollView *baseScrollView;
@property (nonatomic,strong)inputView *nameView,*cardView,*typeView,*priceView,*remarkView;
@property (nonatomic,strong)UIButton *typeButton;
@property (nonatomic,assign)NSInteger time;
@property (nonatomic,strong)typeView *typeChooseView;
@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
    [self requestLastWithdraw];
    [self requestTotalYuE];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)layoutUI {
    UIImageView *BGimageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, ScreenHeight) imageName:@"icon_loginbg"];
    [self.view addSubview:BGimageView];
    
    [self navgationLeftButtonImage:@"icon_backup"];
    [self NavigationItemTitle:@"提现支付宝" Color:ColorWhite];
    
    UIButton *RightButton = [UIButton createimageButtonWithFrame:RECT(ScreenWidth-45, STATUS_BAR_HEIGHT+7, 30, 30) imageName:@"icon_withdrawlist"];
    [RightButton addTarget:self action:@selector(navgationRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    RightButton.layer.cornerRadius = 15;
    [RightButton setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:RightButton];
    
    _baseScrollView = [[UIScrollView alloc]initWithFrame:RECT(0, NAVIGATION_BAR_HEIGHT, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT)];
    _baseScrollView.backgroundColor = [UIColor whiteColor];
    _baseScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_baseScrollView];
    
//    _nameView = [[inputView alloc]initWithFrame:RECT(0, 10, ScreenWidth, 55)];
//    _nameView.titLe = @"姓名";
//    _nameView.placeHold = @"请填写姓名";
//    [_baseScrollView addSubview:_nameView];
//
//    _cardView = [[inputView alloc]initWithFrame:RECT(0, GETY(_nameView.frame), ScreenWidth, 55)];
//    _cardView.titLe = @"账号";
//    _cardView.placeHold = @"请填写支付宝账号";
//    _cardView.inputTextfield.keyboardType = UIKeyboardTypeASCIICapable;
//    [_baseScrollView addSubview:_cardView];
//
//    _typeView = [[inputView alloc]initWithFrame:RECT(0, GETY(_cardView.frame), ScreenWidth, 55)];
//    _typeView.titLe = @"渠道";
//    _typeView.placeHold = @"";
//    _typeView.inputTextfield.hidden = YES;
//    [_baseScrollView addSubview:_typeView];
    
    _priceView = [[inputView alloc]initWithFrame:RECT(0, 10, ScreenWidth, 55)];
    _priceView.titLe = @"金额";
    _priceView.placeHold = @"请填写提现金额";
    _priceView.inputTextfield.keyboardType = UIKeyboardTypeDecimalPad;
    [_baseScrollView addSubview:_priceView];
    
    _remarkView = [[inputView alloc]initWithFrame:RECT(0, GETY(_priceView.frame), ScreenWidth, 55)];
    _remarkView.titLe = @"备注";
    _remarkView.placeHold = @"请填写提现备注";
    [_baseScrollView addSubview:_remarkView];
    
    UIButton *sureButton = [UIButton createTextButtonWithFrame:RECT(12, GETY(_remarkView.frame)+30, ScreenWidth-24, 44) bgColor:ColorYellow textColor:ColorWhite font:15 bold:YES title:@"确认提现"];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    sureButton.layer.cornerRadius = 3;
    sureButton.layer.masksToBounds = YES;
    [_baseScrollView addSubview:sureButton];
    
//    UIImageView *imageView = [UIImageView createImageViewWithFrame:RECT(12, GETY(sureButton.frame)+30, ScreenWidth-24, 100) imageName:@"icon_tip"];
//    imageView.contentMode = UIViewContentModeLeft;
//    [_baseScrollView addSubview:imageView];

//    _typeChooseView = [[typeView alloc]initWithFrame:RECT(ScreenWidth-96, GETY(_cardView.frame)+12, 80, 30)];
//    _typeChooseView.type = 1;
//    [_baseScrollView addSubview:_typeChooseView];
    
    _baseScrollView.alwaysBounceVertical = YES;
    [_baseScrollView setContentSize:CGSizeMake(ScreenWidth, GETY(sureButton.frame)+20)];
    
}
- (void)requestLastWithdraw {
    NSString *storeid =  [[NSUserDefaults standardUserDefaults] objectForKey:@"storeId"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    [params setValue:[NSNumber numberWithInteger:[storeid integerValue] ]  forKey:@"storeId"];
    [RequestEngine doRqquestWithMessage:@"withdraw_apply/last_apply.do" params:params callbackBlock:^(ResponseMessage *result) {
        if ([result isSuccessful]) {
//            _nameView.inputTextfield.text = result.bussinessInfo[@"nickName"];
//            _cardView.inputTextfield.text = result.bussinessInfo[@"account"];
            _remarkView.inputTextfield.text = result.bussinessInfo[@"remarks"];
            if ([result.bussinessInfo[@"payType"] isEqualToString:@"alipay"]) {
                _typeChooseView.type = 1;
            }else {
                _typeChooseView.type = 2;
            }
        }else {
            [self showToastHUD:@"获取提现信息失败"];
        }
    }];
}
- (void)requestTotalYuE {
    [self showProgressHud];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    NSString *storeid =  [[NSUserDefaults standardUserDefaults] objectForKey:@"storeId"];
    [params setValue:[NSNumber numberWithInteger:[storeid integerValue] ]  forKey:@"storeId"];
    [RequestEngine doRqquestWithMessage:@"withdraw_apply/info.do" params:params callbackBlock:^(ResponseMessage *result) {
        [self hiddenProgressHud];
        if ([result isSuccessful]) {
            _priceView.inputTextfield.placeholder = [NSString stringWithFormat:@"可提现金额%.2f",[result.bussinessInfo[@"capital"] doubleValue]];
        }else {
            [self showToastHUD:@"余额获取失败"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (void)navgationRightButtonClick{
    WithdrawListViewController *vc = [[WithdrawListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)sureButtonClick {
//    if (_nameView.inputTextfield.text.length==0) {
//        [self showToastHUD:@"请填写姓名"];
//        return;
//    }
//    if (_cardView.inputTextfield.text.length==0) {
//        [self showToastHUD:@"请填写账号"];
//        return;
//    }
    if (_priceView.inputTextfield.text.length==0) {
        [self showToastHUD:@"请填写提现金额"];
        return;
    }
    [self showProgressHud];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    NSString *storeid =  [[NSUserDefaults standardUserDefaults] objectForKey:@"storeId"];
    [params setValue:[NSNumber numberWithInteger:[storeid integerValue] ]  forKey:@"storeId"];
//    [params setValue:_nameView.inputTextfield.text forKey:@"nickName"];
//    [params setValue:_cardView.inputTextfield.text forKey:@"account"];
    [params setValue:[NSNumber numberWithDouble:[_priceView.inputTextfield.text doubleValue]] forKey:@"amount"];
    if (_remarkView.inputTextfield.text.length!=0) {
        [params setValue:_remarkView.inputTextfield.text forKey:@"remarks"];
    }
//    if (_typeChooseView.type==1) {
    [params setValue:@"alipay" forKey:@"payType"];
//    }else {
//        [params setValue:@"blank" forKey:@"payType"];
//    }
    [RequestEngine doRqquestWithMessage:@"withdraw_apply/save.do" params:params callbackBlock:^(ResponseMessage *result) {
        [self hiddenProgressHud];
        if ([result isSuccessful]) {
            [self showToastHUD:@"提现已申请"];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self showToastHUD:result.errorMessage];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
