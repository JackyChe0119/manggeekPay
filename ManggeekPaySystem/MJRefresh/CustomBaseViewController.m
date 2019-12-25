//
//  CustomBaseViewController.m
//  hehe
//
//  Created by xiaorandsnow on 15/7/27.
//  Copyright (c) 2015年 xiaorandsnow. All rights reserved.
//

#import "CustomBaseViewController.h"
#import "MJRefresh.h"
#import "CommonToastHUD.h"

#define REFRESH_TIME_OUT 10

@interface CustomBaseViewController () {
    UIScrollView *_dataScrollView;
    NSTimer *refreshTimeoutTimer;
}
@end

@implementation CustomBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
}
- (void)setTotalPages:(NSInteger)totalPage {
    _totalPages =totalPage;
}
- (void)setCurrentPageWith:(NSInteger)currentPage {
    self.currentPage = currentPage;
}
- (void)removeFooterWith:(UIScrollView *)scrollView {
    _dataScrollView = scrollView;
    [_dataScrollView removeFooter];
}
- (void)addRefreshHeader:(UIScrollView *)scrollView {
    _dataScrollView =scrollView;
    [_dataScrollView addHeaderWithTarget:self action:@selector(headerRereshing)];
    if (_isFirstRefresh) {
        [_dataScrollView headerBeginRefreshing];
    }else {
    }
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _dataScrollView.headerPullToRefreshText = @"下拉可以刷新";
    _dataScrollView.headerReleaseToRefreshText = @"松开马上刷新";
    _dataScrollView.headerRefreshingText = @"刷新数据中";
    
}
- (void)addRefreshFooter:(UIScrollView *)scrollView{
    _dataScrollView =scrollView;
    [_dataScrollView addFooterWithTarget:self action:@selector(footerRereshing)];
    _dataScrollView.footerPullToRefreshText = @"上拉可以加载更多数据";
    _dataScrollView.footerReleaseToRefreshText = @"松开马上加载更多数据";
    _dataScrollView.footerRefreshingText = @"加载数据中";
}
- (void)addRefreshHeaderAndFooterView:(UIScrollView *)scrollView {
    _dataScrollView =scrollView;
    [_dataScrollView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_dataScrollView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_dataScrollView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _dataScrollView.headerPullToRefreshText = @"下拉可以刷新";
    _dataScrollView.headerReleaseToRefreshText = @"松开马上刷新";
    _dataScrollView.headerRefreshingText = @"正在帮你刷新中";
    
    if (self.isDefault) {
        _dataScrollView.footerPullToRefreshText = @"上拉可以加载全部数据";
        _dataScrollView.footerReleaseToRefreshText = @"松开马上加载全部数据";
        _dataScrollView.footerRefreshingText = @"";
    }
    else {
        _dataScrollView.footerPullToRefreshText = @"上拉可以加载更多数据";
        _dataScrollView.footerReleaseToRefreshText = @"松开马上加载更多数据";
        _dataScrollView.footerRefreshingText = @"正在帮你加载中";
    }
}
- (void)endRefreshControlLoading {
    if (self.currentPage ==1){
        [_dataScrollView headerEndRefreshing];
    }
    else {
        [_dataScrollView headerEndRefreshing];
        [_dataScrollView footerEndRefreshing];
    }
    [self removeTimeoutCheck];
}
- (void)tableViewEndRefresh:(UITableView *)currentView {
    if (self.currentPage ==1) {
        [currentView headerEndRefreshing];
    } else {
        [currentView footerEndRefreshing];
    }
}
#pragma mark -override
- (void)refreshNewData {
    self.currentPage = 1;
}
- (void)loadAllDataWithOtherVC{ }
- (void)headerRereshing {
    [self refreshNewData];
    [self addTimeoutCheck];
}
- (void)setCurrentPageLessTotalPage {
    _totalPages = self.currentPage+1;
}
- (void)setCurrentPageEqualTotalPage {
    if (self.currentPage!=1) {
        [CommonToastHUD showTips:@"没有更多数据了哦"];
    }
    _totalPages = self.currentPage ;
}
- (void)footerRereshing {
    if (self.isDefaultRefresh) {
        return;
    }
    if (self.currentPage < _totalPages) {
        self.currentPage++;
        [self loadMoreData:self.currentPage];
        [self addTimeoutCheck];
    } else {
        if (self.isDefault) {
            [_dataScrollView footerEndRefreshing];
            [self loadAllDataWithOtherVC];
        }
        else {
            [CommonToastHUD showTips:@"没有更多数据了哦"];
            [_dataScrollView footerEndRefreshing];
        }
    }
}
- (void)loadMoreData:(NSInteger)page { }
- (void)resetFirstLoadData {
    self.currentPage = 1;
    [(UITableView *)_dataScrollView reloadData];
}
- (void)addLabelNoDataToView:(UIView *)view AndText:(NSString *)str  andFrame:(CGRect)rect {
    self.labelNoData.frame =rect;
    self.labelNoData.text =str;
    [view addSubview:self.labelNoData];
}
-(void)addTimeoutCheck{
    if (refreshTimeoutTimer) {
        [refreshTimeoutTimer invalidate];
        refreshTimeoutTimer = nil;
    }
    refreshTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:REFRESH_TIME_OUT target:self selector:@selector(endRefreshControlLoading) userInfo:nil repeats:NO];
}
-(void)removeTimeoutCheck {
    if (refreshTimeoutTimer) {
        [refreshTimeoutTimer invalidate];
        refreshTimeoutTimer = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
