//
//  CustomTimeSelectView.h
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomTimeSelectView;
@protocol CustomTimeSelectViewDelegate <NSObject>
@required
- (void)customeTimeSelectViewClickView:(CustomTimeSelectView *)view viewTag:(NSInteger)viewTag;
@end
@interface CustomTimeSelectView : UIView
@property (nonatomic,strong)UILabel *beginTimeLabel;
@property (nonatomic,strong)UILabel *endTimeLabel;
@property (nonatomic,assign) id<CustomTimeSelectViewDelegate> delegate;
@property (nonatomic,copy)NSString *beginTime,*endTime;
@end
