//
//  LoginViewController.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "LoginViewController.h"
#import "AgreementViewController.h"
#import "MainViewController.h"
@interface LoginViewController ()
@property (nonatomic,strong)UITextField *nameTextField;//用户名输入框
@property (nonatomic,strong)UITextField *passwordTextField;//密码输入框
@property (nonatomic,strong)UITextField *codeTextField;//验证码输入框
@property (nonatomic,strong)UIButton *codeButton;//验证码按钮
@property (nonatomic,copy) NSString *currentCode;//当前正确的验证码
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)layoutUI {
    UIImageView *bgimageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, ScreenHeight) imageName:@"icon_loginbg"];
    [self.view addSubview:bgimageView];
    
    CGFloat top = 0;//您好视图居上间距
    if (IPHONE5) {
        top = 40;
    }else {
        top = 30+NAVIGATION_BAR_HEIGHT;
    }
    
    CGFloat top2 = 0; //用户名输入框 居上间距
    CGFloat bottom = 70; //登录视图居下 布局间距
    if (IPAD) {
        top = 20;
        top2 = 20;
        bottom = 20;
    }else {
        top2 = 50;
    }
    
    UILabel *tipLabel1 = [UILabel createLabelWith:RECT(25,top, ScreenWidth-40, 40) alignment:Left font:35 textColor:ColorWhite bold:YES text:@"您好，"];
    [self.view addSubview:tipLabel1];
    
    UILabel *tipLabel2 = [UILabel createLabelWith:RECT(25, GETY(tipLabel1.frame)+5, ScreenWidth-40, 40) alignment:Left font:16 textColor:ColorWhite bold:YES text:@"欢迎来到芒极支付，登录使用"];
    [self.view addSubview:tipLabel2];
    
    UIView *loginView = [UIView createViewWithFrame:RECT(25, GETY(tipLabel2.frame)+10, ScreenWidth-50, ScreenHeight-GETY(tipLabel2.frame)-10-bottom) color:ColorWhite alpha:.95];
    loginView.layer.shadowColor = Color_shadow.CGColor;
    loginView.layer.shadowOpacity = 0.12f;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(-10, -3)];
    //添加直线
    [path addLineToPoint:CGPointMake(loginView.frame.size.width+7, -3)];
    [path addLineToPoint:CGPointMake(loginView.frame.size.width +7, loginView.frame.size.height+12)];
    [path addLineToPoint:CGPointMake(-10, loginView.frame.size.height+12)];
    [path addLineToPoint:CGPointMake(-10, -3)];
    //        设置阴影路径
    loginView.layer.shadowPath = path.CGPath;
    [self.view addSubview:loginView];
    
    _nameTextField = [[UITextField alloc]initWithFrame:RECT(15, top2, WIDTH(loginView)-30, 30)];
    _nameTextField.placeholder = @"请输入登录账号";
    _nameTextField.borderStyle = UITextBorderStyleNone;
    _nameTextField.font = FONT(16);
    [loginView addSubview:_nameTextField];
    
    UIView *lineview1 = [UIView createViewWithFrame:RECT(15, GETY(_nameTextField.frame)+14, WIDTH(loginView)-30, .5) color:ColorLine alpha:1];
    [loginView addSubview:lineview1];
    
    _passwordTextField = [[UITextField alloc]initWithFrame:RECT(15, GETY(_nameTextField.frame)+28, WIDTH(loginView)-30, 30)];
    _passwordTextField.placeholder = @"请输入账号密码";
    _passwordTextField.borderStyle = UITextBorderStyleNone;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.keyboardType =  UIKeyboardTypeASCIICapable;
    _passwordTextField.font = FONT(16);
    [loginView addSubview:_passwordTextField];
    
    UIView *lineview2 = [UIView createViewWithFrame:RECT(15, GETY(_passwordTextField.frame)+14, WIDTH(loginView)-30, .5) color:ColorLine alpha:1];
    [loginView addSubview:lineview2];

    _codeTextField = [[UITextField alloc]initWithFrame:RECT(15, GETY(_passwordTextField.frame)+28, WIDTH(loginView)-30-120, 30)];
    _codeTextField.placeholder = @"请输入验证码";
    _codeTextField.borderStyle = UITextBorderStyleNone;
    _codeTextField.keyboardType =  UIKeyboardTypeASCIICapable;
    _codeTextField.font = FONT(16);
    [loginView addSubview:_codeTextField];
    
    UIView *lineview3 = [UIView createViewWithFrame:RECT(15, GETY(_codeTextField.frame)+14, WIDTH(_codeTextField), .5) color:ColorLine alpha:1];
    [loginView addSubview:lineview3];
    
    _codeButton = [UIButton createTextButtonWithFrame:RECT(GETX(_codeTextField.frame)+10, GETY(lineview2.frame)+18, 110, 40) bgColor:Color_999999 textColor:ColorWhite font:13 bold:NO title:@"获取验证码"];
    [_codeButton addTarget:self action:@selector(getCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:_codeButton];
    
    UIButton *loginButton = [UIButton createTextButtonWithFrame:RECT(15, HEIGHT(loginView)-125, 140, 45) bgColor:ColorYellow textColor:ColorWhite font:15 bold:YES title:@"登录"];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.shadowColor = ColorYellow.CGColor;
    loginButton.layer.shadowOpacity = .25;
    loginButton.layer.shadowOffset = CGSizeMake(0, 0);
    
    [loginView addSubview:loginButton];

}

#pragma mark method 事件处理相关
/**
 *   用户协议点击事件
 **/
- (void)tapInAgreemengtLabel {
    AgreementViewController *vc = [[AgreementViewController alloc]init];
    [self presentViewController:vc animated:YES completion:^{
    }];
}
/**
 *   登录按钮点击
 **/
- (void)loginButtonClick {
    if (_nameTextField.text.length==0) {
        [self showToastHUD:@"请先输入登录账号"];
        return;
    }
    if (_passwordTextField.text.length==0) {
        [self showToastHUD:@"请先输入账号密码"];
        return;
    }
    if (_passwordTextField.text.length<6) {
        [self showToastHUD:@"账号密码不得少于6位，请检查是否正确"];
        return;
    }
    if (self.codeTextField.text.length==0) {
        [self showToastHUD:@"请先输入验证码"];
        return;
    }
    if (self.codeTextField.text.length!=5) {
        [self showToastHUD:@"请检查验证码位数是否正确"];
        return;
    }
    if (![self.codeTextField.text isEqualToString:_currentCode]) {
        [self showToastHUD:@"验证码不正确，请区分大小写"];
        return;
    }
 
    [self showProgressHud];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    [params setValue:self.nameTextField.text forKey:@"phone"];
    [params setValue:[CommonUtil  md5:_passwordTextField.text] forKey:@"pwd"];
    [params setValue:@"ios" forKey:@"deviceType"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_TOKEN];
    if (token) {
        [params setValue:token forKey:@"deviceId"];
    }
    [RequestEngine doRqquestWithMessage:@"user/login.do" params:params callbackBlock:^(ResponseMessage *result) {
        [self hiddenProgressHud];
        if ([result isSuccessful]) {
            [self showToastHUD:@"登录成功"];
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:ACCESS_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:result.bussinessInfo[@"merchantId"] forKey:@"merchantId"];
                  [[NSUserDefaults standardUserDefaults] setObject:result.bussinessInfo[@"storeId"] forKey:@"storeId"];
            [[NSUserDefaults standardUserDefaults] setObject:result.bussinessInfo[@"userName"] forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] setObject:result.bussinessInfo[@"storeName"] forKey:@"storeName"];
            [[NSUserDefaults standardUserDefaults] setObject:result.bussinessInfo[@"role"] forKey:@"role"];
            MainViewController *vc = [[MainViewController alloc]init];
            
            [UIApplication sharedApplication].delegate.window.rootViewController = vc;
            NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject: cookiesData forKey:@"Cookie"];
            [defaults synchronize];
            
        }else {
            [self showToastHUD:result.errorMessage];
        }
    }];
}
/**
 *   获取验证码
 **/
- (void)getCodeButtonClick {
    [_codeButton setTitle:@"" forState:UIControlStateNormal];
    [_codeButton setImage:[self createShareImage:@"yanzhengma" Context:[self randomStringWithLength:5]] forState:UIControlStateNormal];
}
/**
 *   在图片上绘制文本
 **/
- (UIImage *)createShareImage:(NSString *)imageName Context:(NSString *)text {
    UIImage *sourceImage = [UIImage imageNamed:imageName];
    CGSize imageSize; //画的背景 大小
    imageSize = [sourceImage size];
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [sourceImage drawAtPoint:CGPointMake(0, 0)];
    //获得 图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathStroke);
    CGFloat nameFont = 20.f;
    //画 自己想要画的内容
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:nameFont]};
    CGRect sizeToFit = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, nameFont) options:NSStringDrawingUsesDeviceMetrics attributes:attributes context:nil];
    NSLog(@"图片: %f %f",imageSize.width,imageSize.height);
    NSLog(@"sizeToFit: %f %f",sizeToFit.size.width,sizeToFit.size.height);
    CGContextSetFillColorWithColor(context, Color_666666.CGColor);
    [text drawAtPoint:CGPointMake((imageSize.width-sizeToFit.size.width)/2,8) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:nameFont]}];
    //返回绘制的新图形
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/**
 *   随机生成字符串
 **/
- (NSString *)randomStringWithLength:(NSInteger)len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    _currentCode = randomString;
    return randomString;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
