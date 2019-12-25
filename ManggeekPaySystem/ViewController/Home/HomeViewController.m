//
//  HomeViewController.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "HomeViewController.h"
#import "CustomKeyBoard.h"
#import "ZRQRCodeController.h"
#import "CutsomActionsheet.h"
#import "CustomAlertView.h"
#import "OrderDetailViewController.h"
#import <UIImageView+AFNetworking.h>
@interface HomeViewController ()<CustomActionSheetDelegate,ShadowViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong)UILabel *companyNameLabel;//公司名称
@property (nonatomic,strong)UIImageView *itemBgView;
@property (nonatomic,strong)UIButton *commonReceiptButton;//普通收款码
@property (nonatomic,strong)UIButton *ReceiptCodeButton;//收款码
@property (nonatomic,strong)UIScrollView *baseScrollview;//
@property (nonatomic,strong)UILabel *moneryLabel;//收钱金额
@property (nonatomic,assign)BOOL isOrigal;//是否是初始化状态
@property (nonatomic,strong)CustomAlertView *inputView;//手动输入订单号
@property (nonatomic,assign)BOOL shouldPresentPhotoLibrary;//跳转到手机相册
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,copy)NSString *orderNo;//正在支付的订单号码
@property (nonatomic,assign) BOOL isLoadCode;//是否请求过二维码
@property (nonatomic,strong)UIImageView *codeIamgeView;//收款二维码
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    //识别相册二维码 通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recognitionPhotoLibraryButtonClick) name:@"recognitionPhotoLibraryButtonClick" object:nil];
    self.isOrigal = YES;
    [self layoutUI];
    
}
- (void)KeyboardWillShowNotification:(NSNotification *)notify {
    NSDictionary *userInfo = [notify userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardHeight = keyboardRect.size.height;
    if (135+keyboardHeight>ScreenHeight/2.0) {
        if (_inputView) {
            [UIView animateWithDuration:.3 animations:^{
                _inputView.frame = RECT(ScreenWidth/2.0-150, ScreenHeight-270-keyboardHeight, 300, 270);
            }];
        }
    }
}
- (void)KeyboardWillHideNotification:(NSNotification *)notify {
    [UIView animateWithDuration:.3 animations:^{
        _inputView.frame = RECT(ScreenWidth/2.0-150, ScreenHeight/2.0-135, 300, 270);
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.shouldPresentPhotoLibrary) {
        self.shouldPresentPhotoLibrary = NO;
        UIImagePickerController *vc = [[UIImagePickerController alloc]init];
        vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:^{
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }];
    }
}
- (void)layoutUI {
    UIImageView *BGimageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, ScreenHeight) imageName:@"icon_loginbg"];
    [self.view addSubview:BGimageView];
    
    _companyNameLabel = [UILabel createLabelWith:RECT(15, STATUS_BAR_HEIGHT+15, ScreenWidth-80, 30) alignment:Left font:20 textColor:ColorWhite bold:YES text:@"芒极科技有限公司"];
    _companyNameLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_companyNameLabel];
    
    UIButton *searchButton = [UIButton createimageButtonWithFrame:RECT(ScreenWidth-54, STATUS_BAR_HEIGHT+12, 44, 44) imageName:@"icon_search"];
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
    
    _itemBgView = [UIImageView createImageViewWithFrame:RECT(0, STATUS_BAR_HEIGHT+68, 198, 44) imageName:@"icon_homeItem"];
    [self.view addSubview:_itemBgView];
    
    _commonReceiptButton = [UIButton createTextButtonWithFrame:RECT(0, STATUS_BAR_HEIGHT+68, 99, 44) bgColor:[UIColor clearColor] textColor:colorWithHexString(@"#111111") font:14 bold:YES title:@"普通收款"];
    _commonReceiptButton.tag = 100;
    [_commonReceiptButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commonReceiptButton];

    _ReceiptCodeButton = [UIButton createTextButtonWithFrame:RECT(99, STATUS_BAR_HEIGHT+68, 99, 44) bgColor:[UIColor clearColor] textColor:colorWithHexString(@"#777777") font:14 bold:YES title:@"收款码"];
    _ReceiptCodeButton.tag = 200;
    [_ReceiptCodeButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ReceiptCodeButton];
    
    _baseScrollview = [[UIScrollView alloc]initWithFrame:RECT(0,GETY(_itemBgView.frame), ScreenWidth,  ScreenHeight-GETY(_itemBgView.frame)-TAB_BAR_HEIGHT)];
    _baseScrollview.backgroundColor = [UIColor whiteColor];
    _baseScrollview.showsVerticalScrollIndicator = NO;
    _baseScrollview.showsHorizontalScrollIndicator = NO;
    _baseScrollview.scrollEnabled  = NO;
    [_baseScrollview setContentSize:CGSizeMake(ScreenWidth*2.0, HEIGHT(_baseScrollview))];
    [self.view addSubview:_baseScrollview];

    CGFloat keboardHeight = 0;
    
    if (IPAD) {
        keboardHeight = ScreenWidth *0.75;
    }else {
        keboardHeight = ScreenWidth;
    }
    
    _moneryLabel = [UILabel createLabelWith:RECT(10, HEIGHT(_baseScrollview)-keboardHeight-60, ScreenWidth-20, 60) alignment:Right font:50 textColor:colorWithHexString(@"#111111") bold:YES text:@"0"];
    _moneryLabel.font = [UIFont fontWithName:CUSTOM_FONT size:50];
    _moneryLabel.adjustsFontSizeToFitWidth = YES;
    [_baseScrollview addSubview:_moneryLabel];
    
    CustomKeyBoard *keyBoard = [[CustomKeyBoard alloc]initWithFrame:RECT(0, HEIGHT(_baseScrollview)-keboardHeight, ScreenWidth, keboardHeight)];
    keyBoard.returnBlock = ^(NSString *text,NSInteger tag) {
        [self doChange:text tag:tag];
    };
    [_baseScrollview addSubview:keyBoard];
    __weak typeof(self)weakSelf = self;
    _codeIamgeView = [[UIImageView alloc]initWithFrame:RECT(50+ScreenWidth,(HEIGHT(_baseScrollview)-60)/2.0-(ScreenWidth-100)/2.0 , ScreenWidth-100, ScreenWidth-100)];
    [_codeIamgeView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://service.pay.manggeek.com/pay/getPayImg.do"]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        weakSelf.codeIamgeView.image = image;
        weakSelf.isLoadCode = YES;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        [weakSelf showToastHUD:@"二维码加载失败"];
    }];
    [_baseScrollview addSubview:_codeIamgeView];
    
    UIButton *tipButton = [UIButton createimageButtonWithFrame:RECT(ScreenWidth, HEIGHT(_baseScrollview)-60, ScreenWidth, 60) imageName:@"icon_tip1"];
    [tipButton setTitle:@" 请使用支付宝 / 微信扫描支付" forState:UIControlStateNormal];
    [tipButton setTitleColor:colorWithHexString(@"#777777") forState:UIControlStateNormal];
    tipButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    tipButton.userInteractionEnabled = NO;
    [tipButton setBackgroundColor:colorWithHexString(@"#eeeeee")];
    [_baseScrollview addSubview:tipButton];
}
#pragma mark method
- (void)itemButtonClick:(UIButton *)sender {
    if (sender.tag==100) {
        [_ReceiptCodeButton setTitleColor:colorWithHexString(@"#777777") forState:UIControlStateNormal];
        [_commonReceiptButton setTitleColor:colorWithHexString(@"#111111") forState:UIControlStateNormal];
        [_baseScrollview setContentOffset:CGPointMake(0, 0) animated:YES];
        [_itemBgView setImage:IMAGE(@"icon_homeItem")];
    }else {
        [_commonReceiptButton setTitleColor:colorWithHexString(@"#777777") forState:UIControlStateNormal];
        [_ReceiptCodeButton setTitleColor:colorWithHexString(@"#111111") forState:UIControlStateNormal];
        [_baseScrollview setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
        [_itemBgView setImage:IMAGE(@"icon_homeItem2")];
        if (!self.isLoadCode) {
            __weak typeof(self)weakSelf = self;
            [_codeIamgeView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://service.pay.manggeek.com/pay/getPayImg.do"]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                weakSelf.codeIamgeView.image = image;
                weakSelf.isLoadCode = YES;
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                [weakSelf showToastHUD:@"二维码加载失败"];
            }];
        }
    }
}
/**
 *   搜索按钮点击
 **/
- (void)searchButtonClick {
    [self showShadowViewWithColor:YES];
    self.shadowViewDelegate = self;
    NSArray *array = @[@"扫描条形码 / 二维码",@"手动输入订单号"];
    CutsomActionsheet *sheet = [[CutsomActionsheet alloc]initWithFrame:RECT(0, ScreenHeight, ScreenWidth, 50+60*array.count) title:@"选择查单方式" listArray:array];
    sheet.delegate = self;
    [UIView animateWithDuration:.3 animations:^{
        sheet.frame = RECT(0, ScreenHeight-50-array.count*60, ScreenWidth, 50+array.count*60);
    }];
    sheet.tag = 500;
    [self.shadowView addSubview:sheet];
}
#pragma mark uiimageviewpickviewdelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if ([[CommonUtil hasQZCodeimage:image] isEqualToString:@"无内容"]) {
         [CommonToastHUD showTips:@"未检测到二维码,请重新选择"];
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [picker dismissViewControllerAnimated:YES completion:^{
            [self doRequest:[CommonUtil hasQZCodeimage:image]];
        }];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark delegate
- (void)customActionSheetClickInView:(CutsomActionsheet *)sheet index:(NSInteger)index {
    switch (index) {
        case 0:
            [self jumpToScanVcIsPayCode:NO];
            [self hiddenView:sheet hidden:YES];
            break;
        case 1:
            [self hiddenView:sheet hidden:NO];
            [self showInPutView];
            break;
        default:
            break;
    }
}
- (void)customActionSheetClickCancelInView:(CutsomActionsheet *)sheet {
    [self hiddenView:sheet hidden:YES];
}
- (void)hiddenView:(CutsomActionsheet *)sheet hidden:(BOOL)hidden{
    CGRect rect = sheet.frame;
    rect.origin.y = ScreenHeight;
    [UIView animateWithDuration:.3 animations:^{
        sheet.frame = rect;
    } completion:^(BOOL finished) {
        [sheet removeFromSuperview];
        if (hidden) {
            [self hiddenShadowView];
        }
    }];
}
- (void)recognitionPhotoLibraryButtonClick {
    self.shouldPresentPhotoLibrary = YES;
}
- (void)doChange:(NSString *)type tag:(NSInteger)tag{
    if (self.isOrigal) {
        if (tag==1100) {
            //删除上一位 不作处理
        }else if (tag==1200) {
            //清空数据源 不作处理
        }else if (tag==1300) {
            //执行扫描操作
            [self checkoutPriceLabel];//校验金额是否正确
        }else {
            if (tag==1009||tag==1010||tag==1011) {
                _moneryLabel.text = @"0.";
            }else {
                //初始化状态可以不进行校验
                [self doValueChange:type];
            }
            self.isOrigal = NO;
        }
    }else {
        if (tag<1009) {
            [self doValueChange:type];
        }else if (tag==1009) {
            if ([_moneryLabel.text containsString:@"."]) {
                NSArray *array = [_moneryLabel.text componentsSeparatedByString:@"."];
                _moneryLabel.text = [NSString stringWithFormat:@"%@.00",[array firstObject]];
            }else {
                [self doValueChange:type];
            }
        }else if(tag==1010){
            [self doValueChange:type];
        }else if (tag==1011) {
            if ([_moneryLabel.text containsString:@"."]) {
                return;
            }else {
                [self doValueChange:type];
            }
        }else if (tag==1100) {
            if (_moneryLabel.text.length<2) {
                _moneryLabel.text = @"0";
                self.isOrigal = YES;
            }else {
                _moneryLabel.text = [_moneryLabel.text substringToIndex:_moneryLabel.text.length-1];
                if ([_moneryLabel.text isEqualToString:@"0"]) {
                    self.isOrigal = YES;
                }
            }
        }else if (tag==1200) {
            _moneryLabel.text = @"0";
            self.isOrigal = YES;
        }else if (tag==1300) {
            //执行扫码操作
            [self checkoutPriceLabel];//校验金额是否正确
        }
    }
}
- (void)doValueChange:(NSString *)type {
    if ([CommonUtil checkCanInput:_moneryLabel.text]) {
        if (self.isOrigal) {
            _moneryLabel.text = type;
        }else {
            _moneryLabel.text = [_moneryLabel.text stringByAppendingFormat:@"%@",type];
        }
    }
}
- (void)checkoutPriceLabel {
    if (![CommonUtil checkPrice:_moneryLabel.text]) {
        [self showToastHUD:@"输入金额格式不正确，请重新输入"];
        return;
    }
    if ([_moneryLabel.text isEqualToString:@"0"]||[_moneryLabel.text isEqualToString:@"0.0"]||[_moneryLabel.text isEqualToString:@"0.00"]) {
        [self showToastHUD:@"收款金额不能为零"];
        return;
    }
    [self jumpToScanVcIsPayCode:YES];
}
- (void)jumpToScanVcIsPayCode:(BOOL)isPay {
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [AlertViewUtil showSelectAlertViewWithVC:self Title:@"您已关闭相机权限" Message:@"如需使用请在设置中打开" LeftTitle:@"取消" RightTitle:@"确定" callBack:^(NSInteger type) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        return;
    }
    ZRQRCodeViewController *qrCode = [[ZRQRCodeViewController alloc] initWithScanType:ZRQRCodeScanTypeReturn];
    [qrCode QRCodeScanningWithViewController:self completion:^(NSString *strValue) {
        NSLog(@"二维码扫描结果%@",strValue);
        if (isPay) {
            [self doRequest:strValue];
        }else {
            OrderDetailViewController *vc = [[OrderDetailViewController alloc]init];
            vc.orderNo = strValue;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSString *message) {
        [self showToastHUD:message];
    }];
}
- (void)doRequest:(NSString *)strValue {
    if ([strValue hasPrefix:@"10"]||[strValue hasPrefix:@"11"]||[strValue hasPrefix:@"12"]||[strValue hasPrefix:@"13"]||[strValue hasPrefix:@"14"]||[strValue hasPrefix:@"15"]) {
        //微信二维码
        if (strValue.length!=18) {
            [self showToastHUD:@"无效的微信二维码"];
            return;
        }
    }else if ([strValue hasPrefix:@"25"]||[strValue hasPrefix:@"26"]||[strValue hasPrefix:@"27"]||[strValue hasPrefix:@"28"]||[strValue hasPrefix:@"29"]||[strValue hasPrefix:@"30"]) {
        //支付宝
        if (strValue.length<16&&strValue.length>24) {
            [self showToastHUD:@"无效的支付宝二维码"];
            return;
        }
    }else {
        [self showToastHUD:@"无效的二维码,请扫描微信或支付宝付款吗"];
        return;
    }
    [self showProgressHud];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    [params setValue:_moneryLabel.text forKey:@"total_fee"];
    [params setValue:strValue forKey:@"auth_code"];
    [RequestEngine doRqquestWithMessage:@"pay/tradePay.do" params:params callbackBlock:^(ResponseMessage *result) {
        [self hiddenProgressHud];
        if ([result isSuccessful]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [CommonUtil playSound:[NSString stringWithFormat:@"收款成功%@元",_moneryLabel.text]];
                [self showToastHUD:@"收款成功"];
                _moneryLabel.text = @"0";
            });
        }else {
            if ([result.bussinessInfo[@"payStatus"] isEqualToString:@"USERPAYING"]) {
                //开启定时器 查询订单状态
                self.orderNo = result.bussinessInfo[@"orderNo"];
                NSTimer  *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkPayState:) userInfo:nil repeats:NO];
                [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            }else {
                [CommonUtil playSound:result.errorMessage];
                [self showToastHUD:result.errorMessage];
            }
        }
    }];
}
- (void)checkPayState:(NSTimer *)timer {
    [timer invalidate];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    [params setValue:self.orderNo forKey:@"orderNo"];
    [RequestEngine doRqquestWithMessage:@"pay/queryOrderPayResult.do" params:params callbackBlock:^(ResponseMessage *result) {
        if ([result isSuccessful]) {
            if ([result.bussinessInfo[@"tradeStatus"] isEqualToString:@"USERPAYING"]) {
                NSTimer  *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkPayState:) userInfo:nil repeats:NO];
                [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            }else if ([result.bussinessInfo[@"tradeStatus"] isEqualToString:@"SUCCESS"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CommonUtil playSound:[NSString stringWithFormat:@"收款成功%@元",result.bussinessInfo[@"buyerPayAmount"]]];
                    [self showToastHUD:@"收款成功"];
                    _moneryLabel.text = @"0";
                });
            }else if([result.bussinessInfo[@"tradeStatus"] isEqualToString:@"NOTPAY"]){
                [CommonUtil playSound:@"收款失败"];
            }else if ([result.bussinessInfo[@"tradeStatus"] isEqualToString:@"PAYERROR"]) {
                [CommonUtil playSound:@"收款失败"];
                [self showToastHUD:result.errorMessage];
            }
        }else {
            [self showToastHUD:result.errorMessage];
            [CommonUtil playSound:result.errorMessage];
        }
    }];
}
- (void)showInPutView {
    __weak typeof(self)weakSelf = self;
    if (!_inputView) {
        _inputView = [[CustomAlertView alloc]initWithFrame:RECT(ScreenWidth/2.0-150, ScreenHeight/2.0-135, 300, 270) type:3];
        _inputView.alertblock = ^(NSInteger type) {
            if (type==1) {
                if (weakSelf.inputView.inputView.text.length==0) {
                    [weakSelf showToastHUD:@"请输入订单号码"];
                    return;
                }else {
                    OrderDetailViewController *vc = [[OrderDetailViewController alloc]init];
                    vc.orderNo = weakSelf.inputView.inputView.text;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }
            [weakSelf.inputView removeFromSuperview];
            weakSelf.inputView = nil;
            [weakSelf hiddenShadowView];
        };
        [self.shadowView addSubview:_inputView];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
