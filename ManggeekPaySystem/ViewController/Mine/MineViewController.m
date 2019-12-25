//
//  MineViewController.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MineViewController.h"
#import "ChangePswViewController.h"
#import "CustomAlertView.h"
#import "LoginViewController.h"
#import "WithdrawViewController.h"
#import "ListViewController.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *typeLabel;
@property (nonatomic,strong)UILabel *companyLabel;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)CustomAlertView *exitView;
@property (nonatomic,strong)CustomAlertView *contactView;
@property (nonatomic,assign)NSInteger role;
@end

@implementation MineViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self layoutUI];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)layoutUI {
    UIImageView *BGimageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, ScreenHeight) imageName:@"icon_loginbg"];
    [self.view addSubview:BGimageView];
    
    UIButton *searchButton = [UIButton createimageButtonWithFrame:RECT(ScreenWidth-54, STATUS_BAR_HEIGHT+12, 44, 44) imageName:@"iocn_loginout"];
    [searchButton addTarget:self action:@selector(LoginOutButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
    
    _nameLabel = [UILabel createLabelWith:RECT(15, STATUS_BAR_HEIGHT+30, ScreenWidth-65, 30) alignment:Left font:20 textColor:ColorWhite bold:YES text:[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
    [self.view addSubview:_nameLabel];
    
    _typeLabel = [UILabel createLabelWith:RECT(15, GETY(_nameLabel.frame)+5,50 , 17) alignment:Center font:12 textColor:ColorWhite bold:YES text:@""];
    _typeLabel.backgroundColor = ColorYellow;
    NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"role"];
    self.role = [type integerValue];
    if ([type integerValue]==1) {
        _typeLabel.text = @"服务商";
    }else if ([type integerValue]==2) {
        _typeLabel.text = @"商家";
    }else if ([type integerValue]==3) {
        _typeLabel.text = @"门店";
    }else {
        _typeLabel.text = @"收银员";
    }
    [self.view addSubview:_typeLabel];
    
    UIImageView *companyImage = [UIImageView createImageViewWithFrame:RECT(15, GETY(_typeLabel.frame)+15, 15,15) imageName:@"iocn_company"];
    [self.view addSubview:companyImage];
    
    _companyLabel = [UILabel createLabelWith:RECT(GETX(companyImage.frame)+5, GETY(_typeLabel.frame)+10, ScreenWidth-65, 26) alignment:Left font:13 textColor:ColorWhite bold:YES text:[[NSUserDefaults standardUserDefaults] objectForKey:@"storeName"]];
    [self.view addSubview:_companyLabel];
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:RECT(0, GETY(_companyLabel.frame)+20, ScreenWidth, ScreenHeight-GETY(_companyLabel.frame)-20) style:0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorColor:ColorLine];
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
        [self.view addSubview:_tableView];
    }
}
#pragma mark method
- (void)LoginOutButtonClick {
    [self showShadowViewWithColor:YES];
    __weak typeof(self)weakSelf = self;
    if (!_exitView) {
        _exitView = [[CustomAlertView alloc]initWithFrame:RECT(ScreenWidth/2.0-150, ScreenHeight/2.0-100, 300, 200) type:1];
        _exitView.alertblock = ^(NSInteger type) {
            if (type==1) {
                [weakSelf logout];
            }
            [weakSelf.exitView removeFromSuperview];
            weakSelf.exitView = nil;
            [weakSelf hiddenShadowView];
        };
        [self.shadowView addSubview:_exitView];
    }
}
- (void)logout {
    [self showProgressHud];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    [RequestEngine doRqquestWithMessage:@"user/logOut.do" params:params callbackBlock:^(ResponseMessage *result) {
        [self hiddenProgressHud];
        if ([result isSuccessful]) {
            NSHTTPCookieStorage *manager = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSArray *cookieStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
            for (NSHTTPCookie *cookie in cookieStorage) {
                [manager deleteCookie:cookie];
            }
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Cookie"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCESS_TOKEN];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            LoginViewController *loginVc = [[LoginViewController alloc]init];
            [UIApplication sharedApplication].delegate.window.rootViewController = loginVc;
        }else {
            [self showToastHUD:result.errorMessage];
        }
    }];
}
#pragma mark delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.role==2||self.role==3) {
        return 4;
    }else {
        return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView createViewWithFrame:RECT(0,0 , ScreenWidth, 1) color:ColorLine alpha:1];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mineCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mineCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.role==2||self.role==3) {
        switch (indexPath.row) {
            case 0:
            {
                if (self.role==3) {
                    cell.textLabel.text = @"提现";
                    cell.detailTextLabel.text = @"";
                }else {
                    cell.textLabel.text = @"提现管理";
                    cell.detailTextLabel.text = @"";
                }
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"修改登录密码";
                cell.detailTextLabel.text = @"";
            }
                break;
            case 2:
            {
                cell.textLabel.text = @"联系我们";
                cell.detailTextLabel.text = @"";
            }
                break;
            case 3:
            {
                cell.textLabel.text = @"版本";
                cell.detailTextLabel.text = @"V1.1.0";
                cell.accessoryType = UITableViewCellAccessoryNone;
                
            }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"修改登录密码";
                cell.detailTextLabel.text = @"";
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"联系我们";
                cell.detailTextLabel.text = @"";
            }
                break;
            case 2:
            {
                cell.textLabel.text = @"版本";
                cell.detailTextLabel.text = @"V1.1.0";
                cell.accessoryType = UITableViewCellAccessoryNone;
                
            }
                break;
            default:
                break;
        }
    }

    cell.textLabel.font = FONT(15);
    cell.textLabel.textColor = ColorWith3;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = colorWithHexString(@"#a8a8a8");
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.role==2||self.role==3) {
        switch (indexPath.row) {
            case 0:
            {
                if (self.role==3) {
                    WithdrawViewController *vc = [[WithdrawViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else {
                    ListViewController *vc = [[ListViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
            case 1:
            {
                ChangePswViewController *changeVC = [[ChangePswViewController alloc]init];
                [self.navigationController pushViewController:changeVC animated:YES];
            }
                break;
            case 2:
            {
                [self showContactView];
            }
                break;
            default:
                break;
        }
    }else {
        switch (indexPath.row) {
            case 0:
            {
                ChangePswViewController *changeVC = [[ChangePswViewController alloc]init];
                [self.navigationController pushViewController:changeVC animated:YES];
            }
                break;
            case 1:
            {
                [self showContactView];
            }
                break;
            default:
                break;
        }
    }
}
- (void)showContactView {
    [self showShadowViewWithColor:YES];
    __weak typeof(self)weakSelf = self;
    if (!_contactView) {
        _contactView = [[CustomAlertView alloc]initWithFrame:RECT(ScreenWidth/2.0-150, ScreenHeight/2.0-120, 300, 240) type:2];
        _contactView.alertblock = ^(NSInteger type) {
            if (type==1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4006701855"]];
            }
            [weakSelf.contactView removeFromSuperview];
            weakSelf.contactView = nil;
            [weakSelf hiddenShadowView];
        };
        [self.shadowView addSubview:_contactView];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
