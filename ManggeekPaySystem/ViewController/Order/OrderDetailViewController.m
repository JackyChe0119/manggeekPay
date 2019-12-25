//
//  OrderDetailViewController.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()
@property (nonatomic,strong)UIScrollView *baseScrollView;
@property (nonatomic,strong)NSDictionary *resultDic;//请求返回的数据
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
    
    [self doRequest];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)doRequest {
    [self showProgressHud];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    [RequestEngine doRqquestWithMessage:[NSString stringWithFormat:@"order/queryOrderDetails/%@.do",self.orderNo] params:params callbackBlock:^(ResponseMessage *result) {
        [self hiddenProgressHud];
        if ([result isSuccessful]) {
            self.resultDic = result.bussinessInfo;
            [self layoutData];
        }else {
            [self showToastHUD:result.errorMessage];
        }
    }];
}
- (void)layoutUI {
    UIImageView *BGimageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, ScreenHeight) imageName:@"icon_loginbg"];
    [self.view addSubview:BGimageView];
    
    [self navgationLeftButtonImage:@"icon_backup"];
    [self NavigationItemTitle:@"订单详情" Color:ColorWhite];
    
    UIView *baseView = [UIView createViewWithFrame:RECT(0, NAVIGATION_BAR_HEIGHT+80, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-60) color:ColorWhite alpha:1];
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
    
    UILabel *order = [UILabel createLabelWith:RECT(15, 10, 60, 35) alignment:Left font:14 textColor:ColorWith3 bold:NO text:@"订单号"];
    [topView addSubview:order];
    
    UILabel *orderNumber= [UILabel createLabelWith:RECT(GETX(order.frame), 10, WIDTH(topView)-GETX(order.frame)-10, 35) alignment:Right font:16 textColor:ColorWith3 bold:NO text:self.resultDic[@"orderNo"]];
    [topView addSubview:orderNumber];
    
    NSString *oldPrice = [NSString stringWithFormat:@"¥%@",self.resultDic[@"orderAmount"]];
    NSString *payPrice = [NSString stringWithFormat:@"¥%@",self.resultDic[@"receiptAmount"]];
    NSString *payStatus;
    BOOL showRefundButton;
    if ([self.resultDic[@"state"] integerValue]==1) {
        payStatus = @"支付成功";
        showRefundButton = YES;
    }else if ([self.resultDic[@"state"] integerValue]==4) {
        payStatus = @"退款成功";
        showRefundButton = NO;
    }else if ([self.resultDic[@"state"] integerValue]==0) {
        payStatus = @"开始支付";
        showRefundButton = NO;
    }else if ([self.resultDic[@"state"] integerValue]==5) {
        payStatus = @"未支付";
        showRefundButton = NO;
    }else {
        payStatus = @"支付失败";
        showRefundButton = NO;
    }
    NSString *payType;
    if ([self.resultDic[@"payChannel"] integerValue]==1) {
        payType = @"支付宝";
    }else {
        payType = @"微信";
    }

    NSArray *array = @[@"订单金额",@"支付金额",@"订单状态",@"创建时间",@"支付时间",@"支付通道",@"店铺名称",@"收银员"];
    NSArray *array2 = @[oldPrice,payPrice,payStatus,self.resultDic[@"createTime"],self.resultDic[@"payTime"],payType,self.resultDic[@"storeName"],self.resultDic[@"cashierName"]];
    
    for (int i = 0; i<array.count; i++) {
        UILabel *label = [UILabel createLabelWith:RECT(15,5+45*i, 70, 45) alignment:Left font:15 textColor:ColorWith3 bold:NO text:array[i]];
        [_baseScrollView addSubview:label];
        
        UILabel *infoLabel = [UILabel createLabelWith:RECT(85, 45*i, WIDTH(_baseScrollView)-100, 45) alignment:Right font:15 textColor:Color_666666 bold:NO text:array2[i]];
        [_baseScrollView addSubview:infoLabel];
        if (i==0||i==1) {
            infoLabel.font = [UIFont fontWithName:CUSTOM_FONT size:18];
            infoLabel.frame = RECT(85, 8+45*i,WIDTH(_baseScrollView)-100,42);
        }else if (i==2) {
            infoLabel.textColor = ColorYellow;
        }
    }
    [_baseScrollView setContentSize:CGSizeMake(WIDTH(_baseScrollView), 45*array.count+5)];
    
    if (showRefundButton) {
        UIButton *operationButton = [UIButton createTextButtonWithFrame:RECT(15, ScreenHeight-59, ScreenWidth-30, 44) bgColor:ColorYellow textColor:ColorWhite font:16 bold:YES title:@"退款"];
        [operationButton addTarget:self action:@selector(operationClick) forControlEvents:UIControlEventTouchUpInside];
        operationButton.layer.cornerRadius = 3;
        operationButton.layer.masksToBounds = YES;
        [self.view addSubview:operationButton];
    }
}
#pragma mark mothod
- (void)operationClick {
    [AlertViewUtil showSelectAlertViewWithVC:self Title:@"执行退还金额？" Message:@"确认后，退还金额将原路返还。" LeftTitle:@"取消" RightTitle:@"确认" callBack:^(NSInteger type) {
        if (type==1) {
//            [CommonToastHUD showTips:@"取消退款了"];
        }else {
            [self refund];//执行退款操作
        }
    }];
}
- (void)refund {
    [self showProgressHud];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    NSString *payPrice = [NSString stringWithFormat:@"%@",self.resultDic[@"receiptAmount"]];
    [params setValue:payPrice forKey:@"amount"];
    [params setValue:self.orderNo forKey:@"orderNo"];
    [RequestEngine doRqquestWithMessage:@"pay/refundAmount.do" params:params callbackBlock:^(ResponseMessage *result) {
        [self hiddenProgressHud];
        if ([result isSuccessful]) {
            [CommonUtil playSound:@"退款成功"];
            [self showToastHUD:@"退款成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self showToastHUD:result.errorMessage];
        }
    }];
}
- (NSDictionary *)resultDic {
    if (!_resultDic) {
        _resultDic = [[NSDictionary alloc]init];
    }
    return _resultDic;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
