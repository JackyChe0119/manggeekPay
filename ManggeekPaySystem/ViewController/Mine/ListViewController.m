//
//  ListViewController.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "ListViewController.h"
#import "orderCell.h"
#import "WithdrawManageViewController.h"
@interface ListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *listArray;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
    
    self.currentPage = 0;
    [self requestwithDrawlist:0];
}
- (void)refreshNewData {
    self.currentPage = 0;
    [self requestwithDrawlist:0];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)layoutUI{
    UIImageView *BGimageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, ScreenHeight) imageName:@"icon_loginbg"];
    [self.view addSubview:BGimageView];
    
    [self navgationLeftButtonImage:@"icon_backup"];
    [self NavigationItemTitle:@"申请列表" Color:ColorWhite];
    
    _tableView = [[UITableView alloc]initWithFrame:RECT(0, NAVIGATION_BAR_HEIGHT, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT) style:0];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.alwaysBounceVertical = YES;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerNib:[UINib nibWithNibName:@"orderCell" bundle:nil] forCellReuseIdentifier:@"orderCell"];
    [_tableView setSeparatorColor:colorWithHexString(@"#e9e9e9")];
    [self addRefreshFooter:_tableView];
    [self addRefreshHeader:_tableView];
    [self.view addSubview:_tableView];
    
}
- (void)loadMoreData:(NSInteger)page {
    [self requestwithDrawlist:page];
}
- (void)requestwithDrawlist:(NSInteger)page {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    NSString *merchantId =  [[NSUserDefaults standardUserDefaults] objectForKey:@"merchantId"];
    [params setValue:[NSNumber numberWithInteger:[merchantId integerValue] ]  forKey:@"merchantIdStrInt"];
    [params setValue:[NSNumber numberWithInteger:page] forKey:@"pageNum"];
    [RequestEngine doRqquestWithMessage:@"withdraw_audit/list.do" params:params callbackBlock:^(ResponseMessage *result) {
        if (page==0) {
            [_tableView headerEndRefreshing];
        }else {
            [_tableView footerEndRefreshing];
        }
        if ([result isSuccessful]) {
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView createViewWithFrame:RECT(0, 0, ScreenWidth, .5) color:[UIColor whiteColor] alpha:1];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    orderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    NSDictionary *result = self.listArray[indexPath.row];
    if ([result[@"payType"] isEqualToString:@"alipay"]) {
        cell.typeimageView.image = IMAGE(@"icon_zhifubao_big");
    }else {
        cell.typeimageView.image = IMAGE(@"iocn_bankcard");
    }
    cell.timeLabel.text = result[@"account"];
    cell.orderNumberLabel.text =result[@"createTime"];
    if ([result[@"withdrawState"] isEqualToString:@"wait"]) {
        cell.psyTypeLabel.text = @"未处理";
    }else if ([result[@"withdrawState"] isEqualToString:@"fish"]) {
        cell.psyTypeLabel.text = @"已完成";
    }else {
        cell.psyTypeLabel.text = @"已拒绝";
    }
    cell.payPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[result[@"amount"] doubleValue] ];
    cell.psyTypeLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.psyTypeLabel.textColor = ColorWith3;
    cell.payPriceLabel.textColor = ColorYellow;
    cell.payPriceLabel.font = FONT(14);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *result = self.listArray[indexPath.row];
    if ([result[@"withdrawState"] isEqualToString:@"wait"]) {
        WithdrawManageViewController *VC = [[WithdrawManageViewController alloc]init];
        VC.resultDic = result;
        [self.navigationController pushViewController:VC animated:YES];
    }else if ([result[@"withdrawState"] isEqualToString:@"fish"]) {
        [self showToastHUD:@"该提现提通过"];
    }else {
        [self showToastHUD:@"该订单已拒绝通过"];
    }
}
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _listArray;
}

@end
