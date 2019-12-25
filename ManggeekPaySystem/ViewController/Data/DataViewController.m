//
//  DataViewController.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "DataViewController.h"
#import "CustomTimeSelectView.h"
#import "ReceiptMoneryView.h"
#import "PayTypeView.h"
#import "CustomTimePickerView.h"
@interface DataViewController ()<CustomTimeSelectViewDelegate,CustomPickerViewDelegate,ShadowViewDelegate>
@property (nonatomic,strong)ReceiptMoneryView *moneryDataView;
@property (nonatomic,strong)PayTypeView *payTypeView;
@property (nonatomic,strong)CustomTimeSelectView *timeView;
@property (nonatomic,strong)NSDictionary *resultData;
@property (nonatomic,strong)UIScrollView *baseScrollView;
@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.shadowViewDelegate = self;
    [self layoutUI];
    [self doRequest:1 first:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)doRequest:(NSInteger)page first:(BOOL)first {
    if (first) {
        [self showProgressHud];
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:@"storeId"];
    [params setValue:[NSNumber numberWithInteger:[object integerValue]] forKey:@"storeId"];
    [params setValue:_timeView.beginTime forKey:@"startTime"];
    [params setValue:_timeView.endTime forKey:@"endTime"];
    [RequestEngine doRqquestWithMessage:@"order/queryOrderCountForApp.do" params:params callbackBlock:^(ResponseMessage *result) {
        if (first) {
            [self hiddenProgressHud];
        }else {
            [self endRefreshControlLoading];
        }
        if ([result isSuccessful]) {
            self.resultData = result.bussinessInfo;
            [self setData];
        }else {
            [self showToastHUD:result.errorMessage];
        }
    }];
}
- (void)refreshNewData {
    [self doRequest:1 first:NO];
}
- (void)layoutUI {
    UIImageView *BGimageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, ScreenHeight) imageName:@"icon_loginbg"];
    [self.view addSubview:BGimageView];
    
    UILabel *TipLabel = [UILabel createLabelWith:RECT(15, STATUS_BAR_HEIGHT+15, ScreenWidth-80, 30) alignment:Left font:20 textColor:ColorWhite bold:YES text:@"订单统计"];
    TipLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:TipLabel];
    
    _timeView = [[CustomTimeSelectView alloc]initWithFrame:RECT(15, GETY(TipLabel.frame)+40, ScreenWidth-30, 40)];
    _timeView.delegate = self;
    [self.view addSubview:_timeView];
    
    _baseScrollView = [[UIScrollView alloc]initWithFrame:RECT(0, GETY(_timeView.frame)+15, ScreenWidth, ScreenHeight-GETY(_timeView.frame)-15-TAB_BAR_HEIGHT)];
    _baseScrollView.alwaysBounceVertical = YES;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    _baseScrollView.bounces = YES;
    _baseScrollView.backgroundColor = [UIColor whiteColor];
    [self addRefreshHeader:_baseScrollView];
    [self.view addSubview:_baseScrollView];
    
    _moneryDataView = [[ReceiptMoneryView alloc]initWithFrame:RECT(15, 15, ScreenWidth-30, 220)];
    _moneryDataView.allMoery = @"0.00";
    _moneryDataView.orderNumber = @"0";
    _moneryDataView.returnMoery = @"0.00";
    [_baseScrollView addSubview:_moneryDataView];
    
    _payTypeView = [[PayTypeView alloc]initWithFrame:RECT(15, GETY(_moneryDataView.frame)+15, ScreenWidth-30, 170)];
    _payTypeView.alipayOrderNumber = @"0 笔";
    _payTypeView.alipayOrderMonery = @"0.00 元";
    _payTypeView.weChatOrderNumber = @"0 笔";
    _payTypeView.weChatOrderMonery = @"0.00 元";
    [_baseScrollView addSubview:_payTypeView];
    
    [_baseScrollView setContentSize:CGSizeMake(ScreenWidth, GETY(_payTypeView.frame)+30)];
    
}
- (void)setData {
    _moneryDataView.allMoery =[NSString stringWithFormat:@"%.2f",[self.resultData[@"actualAmt"] doubleValue]];
    _moneryDataView.orderNumber =[NSString stringWithFormat:@"%ld",[self.resultData[@"orderNum"] integerValue]];
    _moneryDataView.returnMoery = [NSString stringWithFormat:@"%.2f",[self.resultData[@"refundAmd"] doubleValue]];
    NSArray *array = self.resultData[@"payTypeCounts"];
    if (array.count==0) {
        _payTypeView.alipayOrderNumber = @"0 笔";
        _payTypeView.alipayOrderMonery = @"0.00 元";
        _payTypeView.weChatOrderNumber = @"0 笔";
        _payTypeView.weChatOrderMonery = @"0.00 元";
        return;
    }else if (array.count==1) {
        NSDictionary *result1 = array[0];
        if ([result1[@"payChannel"] integerValue]==1) {
            _payTypeView.alipayOrderNumber = [NSString stringWithFormat:@"%ld 笔",[result1[@"orderNum"] integerValue]];
            _payTypeView.alipayOrderMonery =[NSString stringWithFormat:@"%.2f 元",[result1[@"totalAmt"] doubleValue]];
            _payTypeView.weChatOrderNumber = @"0 笔";
            _payTypeView.weChatOrderMonery = @"0.00 元";
        }else {
            _payTypeView.alipayOrderNumber = @"0 笔";
            _payTypeView.alipayOrderMonery = @"0.00 元";
            _payTypeView.weChatOrderNumber = [NSString stringWithFormat:@"%ld 笔",[result1[@"orderNum"] integerValue]];
            _payTypeView.weChatOrderMonery = [NSString stringWithFormat:@"%.2f 元",[result1[@"totalAmt"] doubleValue]];
        }
     
    }else {
        NSDictionary *result1 = array[0];
        NSDictionary *result2 = array[1];
        if ([result1[@"payChannel"] integerValue]==1) {
            _payTypeView.alipayOrderNumber = [NSString stringWithFormat:@"%ld 笔",[result1[@"orderNum"] integerValue]];
            _payTypeView.alipayOrderMonery = [NSString stringWithFormat:@"%.2f 元",[result1[@"totalAmt"] doubleValue]];
            _payTypeView.weChatOrderNumber = [NSString stringWithFormat:@"%ld 笔",[result2[@"orderNum"] integerValue]];
            _payTypeView.weChatOrderMonery = [NSString stringWithFormat:@"%.2f 元",[result2[@"totalAmt"] doubleValue]];
        }else {
            _payTypeView.alipayOrderNumber = [NSString stringWithFormat:@"%ld 笔",[result2[@"orderNum"] integerValue]];
            _payTypeView.alipayOrderMonery =[NSString stringWithFormat:@"%.2f 元",[result2[@"totalAmt"] doubleValue]];
            _payTypeView.weChatOrderNumber = [NSString stringWithFormat:@"%ld 笔",[result1[@"orderNum"] integerValue]];
            _payTypeView.weChatOrderMonery = [NSString stringWithFormat:@"%.2f 元",[result1[@"totalAmt"] doubleValue]];
        }
    }
}
- (void)customeTimeSelectViewClickView:(CustomTimeSelectView *)view viewTag:(NSInteger)viewTag {
    [self showShadowViewWithColor:YES];
    self.shadowViewDelegate = self;
    CustomTimePickerView *pickerview;
    if (viewTag==100) {
        pickerview = [[CustomTimePickerView alloc]initWithFrame:RECT(0, ScreenHeight, ScreenWidth, 350) type:1];
        pickerview.delegate = self;
        pickerview.tag = 888;
        [self.shadowView addSubview:pickerview];
    }else {
        pickerview = [[CustomTimePickerView alloc]initWithFrame:RECT(0, ScreenHeight, ScreenWidth, 350) type:2];
        pickerview.delegate = self;
        pickerview.tag = 999;
        [self.shadowView addSubview:pickerview];
    }
    [UIView animateWithDuration:.3 animations:^{
        pickerview.frame = RECT(0, ScreenHeight-350, ScreenWidth, 350);
    }];
}
#pragma mark delegate
- (void)customPickerSelectInView:(CustomTimePickerView *)pickerView year:(NSString *)year month:(NSString *)momth days:(NSString *)days {
    if (pickerView.tag==888) {
        NSString *string = [NSString stringWithFormat:@"%@-%@-%@",year,momth,days];
        if (![CommonUtil compareOneDay:string withAnotherDay:_timeView.endTime]) {
            [self showToastHUD:@"起始时间不能大于终止时间"];
            return;
        }
        _timeView.beginTime = string;
        self.currentPage = 1;
        [self doRequest:1 first:YES];
    }else {
        NSString *string = [NSString stringWithFormat:@"%@-%@-%@",year,momth,days];
        if (![CommonUtil compareOneDay:_timeView.beginTime withAnotherDay:string]) {
            [self showToastHUD:@"终止时间不能小于于开始时间"];
            return;
        }
        _timeView.endTime = string;
        self.currentPage = 1;
        [self doRequest:1 first:YES];
    }
   [self touchesInShadowView:pickerView];
}
- (void)customPickerSelectCancelInView:(CustomTimePickerView *)pickerView {
    [self touchesInShadowView:pickerView];
}
- (void)touchesInShadowView:(CustomTimePickerView *)picker  {
    CGRect rect = picker.frame;
    rect.origin.y = ScreenHeight;
    [UIView animateWithDuration:.3 animations:^{
        picker.frame = rect;
    } completion:^(BOOL finished) {
        [picker removeFromSuperview];
        [self hiddenShadowView];
    }];
}
- (NSDictionary *)resultData {
    if (!_resultData) {
        _resultData = [[NSDictionary alloc]init];
    }
    return _resultData;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
