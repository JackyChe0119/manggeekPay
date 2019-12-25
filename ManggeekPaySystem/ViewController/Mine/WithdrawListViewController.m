//
//  WithdrawListViewController.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "WithdrawListViewController.h"
#import "WithdrawListCell.h"
#import "WithDrawDetailViewController.h"
@interface WithdrawListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *listArray;
@end

@implementation WithdrawListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
    
    self.currentPage = 0;
    [self requestwithDrawlist:0];
}
- (void)layoutUI{
    UIImageView *BGimageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, ScreenHeight) imageName:@"icon_loginbg"];
    [self.view addSubview:BGimageView];
    
    [self navgationLeftButtonImage:@"icon_backup"];
    [self NavigationItemTitle:@"提现列表" Color:ColorWhite];
    
    _tableView = [[UITableView alloc]initWithFrame:RECT(0, NAVIGATION_BAR_HEIGHT, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT) style:0];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.alwaysBounceVertical = YES;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerNib:[UINib nibWithNibName:@"WithdrawListCell" bundle:nil] forCellReuseIdentifier:@"WithdrawListCell"];
    [_tableView setSeparatorColor:colorWithHexString(@"#e9e9e9")];
    [self addRefreshFooter:_tableView];
    [self.view addSubview:_tableView];
    
}
- (void)loadMoreData:(NSInteger)page {
    [self requestwithDrawlist:page];
}
- (void)requestwithDrawlist:(NSInteger)page {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    NSString *storeid =  [[NSUserDefaults standardUserDefaults] objectForKey:@"storeId"];
    [params setValue:[NSNumber numberWithInteger:[storeid integerValue] ]  forKey:@"storeId"];
    [params setValue:[NSNumber numberWithInteger:page] forKey:@"pageNum"];
    [RequestEngine doRqquestWithMessage:@"withdraw_apply/list.do" params:params callbackBlock:^(ResponseMessage *result) {
        [_tableView footerEndRefreshing];
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
    WithdrawListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WithdrawListCell"];
    NSDictionary *result = self.listArray[indexPath.row];
    if ([result[@"payType"] isEqualToString:@"alipay"]) {
        cell.typeIamgeView.image = IMAGE(@"icon_zhifubao_big");
    }else {
        cell.typeIamgeView.image = IMAGE(@"iocn_bankcard");
    }
    cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",[result[@"amount"] doubleValue] ];
    cell.timelAabel.text =result[@"createTime"];
    if ([result[@"withdrawState"] isEqualToString:@"wait"]) {
        cell.statusLabel.text = @"审核中";
    }else if ([result[@"withdrawState"] isEqualToString:@"fish"]) {
        cell.statusLabel.text = @"已到账";
    }else {
        cell.statusLabel.text = @"未通过";
    }
    return cell ;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WithDrawDetailViewController *vc = [[WithDrawDetailViewController alloc]init];
    vc.resultDic = self.listArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _listArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
