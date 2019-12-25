//
//  OrderViewController.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "OrderViewController.h"
#import "CustomTimeSelectView.h"
#import "SelectButtonView.h"
#import "CutsomActionsheet.h"
#import "orderCell.h"
#import "OrderDetailViewController.h"
#import "CustomTimePickerView.h"
@interface OrderViewController ()<CustomTimeSelectViewDelegate,selectButtonDelegate,CustomActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,ShadowViewDelegate,CustomPickerViewDelegate>
@property (nonatomic,copy)NSString *orderType;//支付通道 默认全部
@property (nonatomic,copy)NSString *orderValue;//订单状态  默认全部
@property (nonatomic,strong)SelectButtonView *payTypeButton,*payValueButton;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)CustomTimeSelectView *timeView;
@property (nonatomic,strong)NSMutableArray *listArray;//数据
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    _orderType = nil;
    
    _orderValue = nil;
    
    [self layoutUI];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)layoutUI {
    UIImageView *BGimageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, ScreenHeight) imageName:@"icon_loginbg"];
    [self.view addSubview:BGimageView];

    UILabel *TipLabel = [UILabel createLabelWith:RECT(15, STATUS_BAR_HEIGHT+15, ScreenWidth-80, 30) alignment:Left font:20 textColor:ColorWhite bold:YES text:@"最近订单"];
    TipLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:TipLabel];
    
    _timeView = [[CustomTimeSelectView alloc]initWithFrame:RECT(15, GETY(TipLabel.frame)+40, ScreenWidth-30, 40)];
    _timeView.delegate = self;
    [self.view addSubview:_timeView];
    
    UIView *sectionView = [UIView createViewWithFrame:RECT(0, GETY(_timeView.frame)+15, ScreenWidth, 44) color:[UIColor whiteColor] alpha:1];
    sectionView.backgroundColor = [ColorWhite colorWithAlphaComponent:.9];
    [self.view addSubview:sectionView];
    
    _payTypeButton = [[SelectButtonView alloc]initWithFrame:RECT(0, 0, 100, 44)];
    _payTypeButton.font = 14;
    _payTypeButton.imageStr = IMAGE(@"icon_xiala");
    _payTypeButton.title = @"全部通道 ";
    _payTypeButton.titleColor = @"#555555";
    _payTypeButton.delegate = self;
    _payTypeButton.tag = 300;
    [sectionView addSubview:_payTypeButton];
    
    _payValueButton = [[SelectButtonView alloc]initWithFrame:RECT(100, 0, 100, 44)];
    _payValueButton.font = 14;
    _payValueButton.imageStr = IMAGE(@"icon_xiala");
    _payValueButton.title = @"全部订单 ";
    _payValueButton.titleColor = @"#555555";
    _payValueButton.delegate = self;
    _payValueButton.tag = 400;
    [sectionView addSubview:_payValueButton];
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:RECT(0, GETY(sectionView.frame), ScreenWidth, ScreenHeight-GETY(sectionView.frame)-TAB_BAR_HEIGHT) style:0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorColor:ColorLine];
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        [_tableView registerNib:[UINib nibWithNibName:@"orderCell" bundle:nil] forCellReuseIdentifier:@"orderCell"];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
        [self addRefreshHeader:_tableView];
        [self addRefreshFooter:_tableView];
        [self.view addSubview:_tableView];
    }
    
    [self doRequest:1 first:YES];
}
- (void)refreshNewData {
    self.currentPage = 1;
    [self doRequest:self.currentPage first:NO];
}
- (void)loadMoreData:(NSInteger)page {
    [self doRequest:page first:NO];
}
#pragma mark request
- (void)doRequest:(NSInteger)page first:(BOOL)first {
    if (first) {
        [self showProgressHud];
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:@"storeId"];
    [params setValue:[NSNumber numberWithInteger:[object integerValue]] forKey:@"storeId"];
    if (_orderType) {
        [params setValue:[NSNumber numberWithInteger:[_orderType integerValue] ] forKey:@"payChannel"];
    }
    if (_orderValue) {
        [params setValue:[NSNumber numberWithInteger:[_orderValue integerValue]] forKey:@"orderStatus"];
    }
    [params setValue:_timeView.beginTime forKey:@"startTime"];
    [params setValue:_timeView.endTime forKey:@"endTime"];
    [params setValue:[NSNumber numberWithInteger:page] forKey:@"currentPage"];
    [params setValue:@"10" forKey:@"pageSize"];
    [RequestEngine doRqquestWithMessage:@"order/queryOrderList.do" params:params callbackBlock:^(ResponseMessage *result) {
        if (first) {
            [self hiddenProgressHud];
        }else {
            [self endRefreshControlLoading];
        }
        if ([result isSuccessful]) {
            if (page==1) {
                [self.listArray removeAllObjects];
            }
            NSArray *array = result.list;
            if (array.count==0) {
                [self setCurrentPageEqualTotalPage];
            }else {
                [self setCurrentPageLessTotalPage];
            }
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.listArray addObject:obj];
            }];
            [_tableView reloadData];
        }else {
            [self showToastHUD:result.errorMessage];
        }
    }];
}
#pragma mark mothod

- (void)touchesInShadowView {
    if (self.shadowView) {
        UIView *view = [self.shadowView subviews][0];
        CGRect rect = view.frame;
        rect.origin.y = ScreenHeight;
        [UIView animateWithDuration:.3 animations:^{
            view.frame = rect;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            [self hiddenShadowView];
            self.shadowViewDelegate = nil;
        }];
    }
}
#pragma mark delegate
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
- (void)DelegateDidClickAtAnyImageView:(SelectButtonView *)selectButton {
    if (selectButton.tag == 300) {
        [self showShadowViewWithColor:YES];
        self.shadowViewDelegate = self;
        NSArray *array = @[@"全部通道",@"支付宝通道",@"微信通道"];
        CutsomActionsheet *sheet = [[CutsomActionsheet alloc]initWithFrame:RECT(0, ScreenHeight, ScreenWidth, 50+60*array.count) title:@"选择支付通道" listArray:array];
        sheet.delegate = self;
        [UIView animateWithDuration:.3 animations:^{
            sheet.frame = RECT(0, ScreenHeight-50-array.count*60, ScreenWidth, 50+array.count*60);
        }];
        sheet.tag = 500;
        [self.shadowView addSubview:sheet];
    }else {
        [self showShadowViewWithColor:YES];
        self.shadowViewDelegate = self;
        NSArray *array = @[@"全部订单",@"有效订单",@"退款订单",@"无效订单"];
        CutsomActionsheet *sheet = [[CutsomActionsheet alloc]initWithFrame:RECT(0, ScreenHeight, ScreenWidth, 50+60*array.count) title:@"选择支付状态" listArray:array];
        sheet.delegate = self;
        sheet.tag = 600;
        [UIView animateWithDuration:.3 animations:^{
            sheet.frame = RECT(0, ScreenHeight-50-array.count*60, ScreenWidth, 50+array.count*60);
        }];
        [self.shadowView addSubview:sheet];
    }
}
#pragma mark delegate
- (void)customActionSheetClickInView:(CutsomActionsheet *)sheet index:(NSInteger)index {
    if (sheet.tag == 500) {
        switch (index) {
            case 0:
                _orderType = nil;
                _payTypeButton.title = @"全部通道";
                break;
            case 1:
                _orderType = @"1";
                _payTypeButton.title = @"支付宝通道";
                break;
            case 2:
                _orderType = @"2";
                _payTypeButton.title = @"微信通道";
                break;
            default:
                break;
        }
    }else {
        switch (index) {
            case 0:
                _orderValue = nil;
                _payValueButton.title = @"全部订单";
                break;
            case 1:
                _orderValue = @"1";
                _payValueButton.title = @"有效订单";
                break;
            case 2:
                _orderValue = @"4";
                _payValueButton.title = @"退款订单";
                break;
            case 3:
                _orderValue = @"2";
                _payValueButton.title = @"无效订单";
                break;
            default:
                break;
        }
    }
    [self doRequest:1 first:YES];
    [self hiddenView:sheet];
}
- (void)customActionSheetClickCancelInView:(CutsomActionsheet *)sheet {
    [self hiddenView:sheet];
}
- (void)hiddenView:(CutsomActionsheet *)sheet {
    CGRect rect = sheet.frame;
    rect.origin.y = ScreenHeight;
    [UIView animateWithDuration:.3 animations:^{
        sheet.frame = rect;
    } completion:^(BOOL finished) {
        [sheet removeFromSuperview];
        [self hiddenShadowView];
    }];
}
#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]initWithFrame:RECT(0, 0, ScreenWidth, .5)];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    orderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    NSDictionary *result = self.listArray[indexPath.row];
    [cell showCellWithDic:result];
    cell.payPriceLabel.font = [UIFont fontWithName:CUSTOM_FONT size:20];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderDetailViewController *vc = [[OrderDetailViewController alloc]init];
    NSDictionary *result = self.listArray[indexPath.row];
    vc.orderNo = result[@"orderNo"];
    [self.navigationController pushViewController:vc animated:YES];
}
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
    [self touchesInShadowView];
}
- (void)customPickerSelectCancelInView:(CustomTimePickerView *)pickerView {
    [self touchesInShadowView];
}
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _listArray;
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
