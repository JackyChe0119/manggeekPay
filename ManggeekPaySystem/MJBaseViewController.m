//
//  MJBaseViewController.m
//  KangDuKe
//
//  Created by 车杰 on 16/12/11.
//  Copyright © 2016年 Jacky. All rights reserved.
//

#import "MJBaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"

@interface MJBaseViewController ()<ShadowViewDelegate>

@end

@implementation MJBaseViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //设置返回按钮默认图片    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //友盟页面访问统计
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //TODO
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
//布局导航条左侧图片按钮
- (void)navgationLeftButtonImage:(NSString *)iocn {

    UIButton *leftButton = [UIButton createimageButtonWithFrame:RECT(0, STATUS_BAR_HEIGHT, 44, 44) imageName:iocn];
    [leftButton addTarget:self action:@selector(navgationLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
}
//布局导航条右侧图片按钮
- (void)navgationRightButtonImage:(NSString *)icon {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *rightImage = [UIImage imageNamed:icon];
    rightButton.bounds = CGRectMake(0, 0, rightImage.size.width, rightImage.size.height);
    [rightButton setImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(navgationRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
/**
 *    @brief    设置标题颜色和大小
 */
- (void)NavigationItemTitle:(NSString *)title Color:(UIColor *)color {
    UILabel *titleLabel = [UILabel createLabelWith:RECT(44, STATUS_BAR_HEIGHT, ScreenWidth-88, 44) alignment:Center font:17 textColor:color bold:YES text:title];
    [self.view addSubview:titleLabel];
}
//布局导航条左侧标题按钮，颜色
- (void)navgationLeftButtonTitle:(NSString *)title color:(UIColor *)color {
    UIButton * button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    button.bounds = CGRectMake(0, 0, 40, 40);
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    [button sizeToFit];
    [button addTarget:self action:@selector(navgationLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}
//布局导航条右侧标题按钮，颜色
- (void)navgationRightButtonTitle:(NSString *)title color:(UIColor *)color {
    UIButton * button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    button.bounds = CGRectMake(0, 0, 40, 40);
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button sizeToFit];
    [button addTarget:self action:@selector(navgationRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}
//展示shadow//是否有颜色
- (void)showShadowViewWithColor:(BOOL)color {
    if (!_shadowView) {
        self.shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
    if (color) {
        self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    }else {
        self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }
    self.shadowView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapInshadowView:)];
    tap.delegate = self;
    [self.shadowView addGestureRecognizer:tap];
    [MainWindow addSubview:self.shadowView];
}
//隐藏蒙版
- (void)hiddenShadowView {
    [UIView animateWithDuration:.3 animations:^{
        self.shadowView.alpha = 0;
    } completion:^(BOOL finished) {
        [_shadowView removeFromSuperview];
        _shadowView= nil;
    }];
}
- (void)tapInshadowView:(UIGestureRecognizer *)tap {
    NSLog(@"点击蒙版了");
    // 判断如果调用了代理 执行代理方法
    if ([_shadowViewDelegate respondsToSelector:@selector(touchesInShadowView)]) {
        [_shadowViewDelegate touchesInShadowView];
    }
}
//左侧按钮点击事件，子类重写实现自己的方法
- (void)navgationLeftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

//右侧按钮点击事件，子类重写实现自己的方法
- (void)navgationRightButtonClick {NSLog(@"...");}
-(void)dealloc{
    //TODO
}
- (void)showToastHUD:(NSString *)message {
    [CommonToastHUD showTips:message];
}
- (NSString *)getToken {
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return token;
}
- (NSString *)getInfoWithKey:(NSString *)key {
    NSString *value = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return value;
    
}
//获取表底部视图
- (UIImageView *)backGroundView:(NSString *)imageName superView:(UIView *)view{
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:view.frame];
    imageview.image = [UIImage imageNamed:imageName];
    imageview.contentMode = UIViewContentModeCenter;
    imageview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapInBackGroundView:)];
    [imageview addGestureRecognizer:tap];
    return imageview;
}
- (void)tapInBackGroundView:(UITapGestureRecognizer *)tap {
    [self navgationRightButtonClick];
}
- (void)hideAlertAnimation:(UIView *)view  {
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView animateWithDuration:0.35 animations:^{
        view.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}
- (void)showProgressHud {
    [MBProgressHUD showHUDAddedTo:MainWindow animated:YES];
}
- (void)showProgressHudWithTitle:(NSString *)title {
    [MBProgressHUD showHUDAddedTo:MainWindow animated:YES title:title];
}
- (void)hiddenProgressHud {
    [MBProgressHUD hideHUDForView:MainWindow animated:YES];
}
//跳转页面并隐藏tabbar
- (void)pushViewControllerHidesBottomBar:(UIViewController *)vc{
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

//隐藏导航栏底部黑线
- (void)hideNavBarLineView{
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
- (void)setNavLineColor:(UIColor *)color {
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault]; //此处使底部线条颜色为红色
    [navigationBar setShadowImage:[self imageWithColor:color]];
    
}
- (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return image;
}

-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 10;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

@end

