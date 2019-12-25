//
//  MainViewController.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/23.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "DataViewController.h"
#import "OrderViewController.h"
#import "MineViewController.h"
@interface MainViewController ()<UITabBarControllerDelegate> {
    NSInteger _currentIndex;
}
@end

@implementation MainViewController
- (instancetype)init{
    self = [super init];
    if (self) {
        HomeViewController *homeVC = [[HomeViewController alloc]init];
        UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
        homeNav.tabBarItem.image=[UIImage imageNamed:@"icon_homeUnselect"];
        homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_homeSelect"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        homeNav.tabBarItem.title=@"首页";
        [homeNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#111111"],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
        DataViewController *NearVC = [[DataViewController alloc]init];
        UINavigationController *NearNav = [[UINavigationController alloc]initWithRootViewController:NearVC];
        NearNav.tabBarItem.image=[UIImage imageNamed:@"icon_shujuUnselect"];
        NearNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_shujuSelect"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        NearNav.tabBarItem.title=@"数据";
        [NearNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#111111"],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];

        OrderViewController *messageVc = [[OrderViewController alloc]init];
        UINavigationController *messageNav = [[UINavigationController alloc]initWithRootViewController:messageVc];
        messageNav.tabBarItem.image=[UIImage imageNamed:@"icon_orderUnselect"];
        messageNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_orderSelect"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        messageNav.tabBarItem.title=@"订单";
        [messageNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#111111"],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
        MineViewController *MineVc = [[MineViewController alloc]init];
        UINavigationController *MineNav = [[UINavigationController alloc]initWithRootViewController:MineVc];
        MineNav.tabBarItem.image=[UIImage imageNamed:@"icon_mineUnselect"];
        MineNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_mineSelect"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        MineNav.tabBarItem.title=@"我的";
        [MineNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#111111"],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        self.viewControllers = @[homeNav,NearNav,messageNav,MineNav];
        self.delegate = self;
        
    }
    return self;
}
#pragma mark - UITabBarController代理方法 点击事件
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //点击tabBarItem动画
    if (self.selectedIndex != _currentIndex)[self tabBarButtonClick:[self getTabBarButton]];
}

- (UIControl *)getTabBarButton{
    
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc] initWithCapacity:0];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    return tabBarButton;
}

- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews) {
        
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画,这里根据需求自定义
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.1,@0.9,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            //把动画添加上去就OK了
            [imageView.layer addAnimation:animation forKey:nil];
            
        }
    }
    _currentIndex = self.selectedIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
