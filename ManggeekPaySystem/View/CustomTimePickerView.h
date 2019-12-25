//
//  CustomTimePickerView.h
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomTimePickerView;
@protocol CustomPickerViewDelegate<NSObject>
@optional
- (void)customPickerSelectInView:(CustomTimePickerView *)pickerView year:(NSString *)year month:(NSString *)momth days:(NSString *)days;
- (void)customPickerSelectCancelInView:(CustomTimePickerView *)pickerView;
@end;
@interface CustomTimePickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong)UIPickerView *YearPicker,*MonthPicker,*DayPicker;
@property (nonatomic,strong)NSArray *monthsArray,*daysArray;
@property (nonatomic,strong)NSMutableArray *yearsArray;
@property (nonatomic,strong)NSArray *allDaysArray;
@property (nonatomic,copy)NSString *currentYear,*currentmonth,*currentDay;
@property (nonatomic,assign)BOOL leapYear;//当前选择是否是闰年
@property (nonatomic,assign)BOOL isSecondMonth;//当前选择是不是二月
@property (nonatomic,assign)id <CustomPickerViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;
@end
