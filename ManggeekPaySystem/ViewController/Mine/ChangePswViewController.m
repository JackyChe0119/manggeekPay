//
//  ChangePswViewController.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "ChangePswViewController.h"

@interface ChangePswViewController ()

@end

@implementation ChangePswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *BGimageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, ScreenHeight) imageName:@"icon_loginbg"];
    [self.view addSubview:BGimageView];
    
    [self navgationLeftButtonImage:@"icon_backup"];
    [self NavigationItemTitle:@"修改密码" Color:ColorWhite];
    
    UIView *baseView = [UIView createViewWithFrame:RECT(0, NAVIGATION_BAR_HEIGHT, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT) color:ColorWhite alpha:1];
    baseView.tag = 50;
    [self.view addSubview:baseView];
    NSArray *array = @[@"原密码",@"新密码",@"确认"];
    NSArray *array2 = @[@"请输入原密码",@"请输入新密码",@"确认新密码"];
    for (int i = 0; i<3; i++) {
        UILabel *tipLabel = [UILabel createLabelWith:RECT(12, 1+56*i, 100, 55) alignment:Left font:14 textColor:ColorWith3 bold:NO text:array[i]];
        [baseView addSubview:tipLabel];
        
        UITextField *textField = [[UITextField alloc]initWithFrame:RECT(112, 13+56*i, ScreenWidth-124, 30)];
        textField.borderStyle = 0;
        textField.font = FONT(14);
        textField.textColor = ColorWith3;
        textField.secureTextEntry = YES;
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.placeholder = array2[i];
        textField.tag = 100+i;
        textField.textAlignment = NSTextAlignmentRight;
        [baseView addSubview:textField];
        
        UIView *lineView = [UIView createViewWithFrame:RECT(12, 56*(i+1), ScreenWidth-12, .5) color:ColorLine alpha:1];
        [baseView addSubview:lineView];
    }
    
    UIButton *sureButton = [UIButton createTextButtonWithFrame:RECT(12, 56*3+40, ScreenWidth-24, 44) bgColor:ColorYellow textColor:ColorWhite font:15 bold:YES title:@"保存"];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    sureButton.layer.cornerRadius = 3;
    sureButton.layer.masksToBounds = YES;
    [baseView addSubview:sureButton];

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
#pragma mark method
- (void)sureButtonClick {
    UIView *baseView = [self.view viewWithTag:50];
    UITextField *old = (UITextField *)[baseView viewWithTag:100];
    UITextField *New = (UITextField *)[baseView viewWithTag:101];
    UITextField *SureNew = (UITextField *)[baseView viewWithTag:102];
    if (old.text.length==0) {
        [self showToastHUD:@"请先输入原密码"];
        return;
    }
    if (New.text.length==0) {
        [self showToastHUD:@"请输入新密码"];
        return;
    }
    if (SureNew.text.length==0) {
        [self showToastHUD:@"请输入确认密码"];
        return;
    }
    if (![New.text isEqualToString:SureNew.text]) {
        [self showToastHUD:@"新密码和确认密码不一致"];
        return;
    }
    [self showProgressHud];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    [params setValue:[CommonUtil md5:old.text] forKey:@"oldPwd"];
    [params setValue:[CommonUtil md5:New.text] forKey:@"newPwd"];
    [params setValue:[CommonUtil md5:SureNew.text] forKey:@"confirmPwd"];
    [RequestEngine doRqquestWithMessage:@"user/modifyPwd.do" params:params callbackBlock:^(ResponseMessage *result) {
        [self hiddenProgressHud];
        if ([result isSuccessful]) {
            [CommonToastHUD showTips:@"修改成功"];
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
