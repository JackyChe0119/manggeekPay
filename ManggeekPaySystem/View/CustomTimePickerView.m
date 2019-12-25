//
//  CustomTimePickerView.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "CustomTimePickerView.h"

@implementation CustomTimePickerView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ColorWhite;
        
        UIView *topView = [UIView createViewWithFrame:RECT(0, 0, WIDTH(self), 50) color:colorWithHexString(@"#eeeeee") alpha:1];
        [self addSubview:topView];
        
        UILabel *titleLabel = [UILabel createLabelWith:RECT(15, 10, 150, 30) alignment:Left font:16 textColor:colorWithHexString(@"#555555") bold:YES text:@"请选择开始时间"];
        if (type==2) {
            titleLabel.text = @"请选择结束时间";
        }
        [self addSubview:titleLabel];
        
        _currentYear = @"2017";
        _currentmonth = @"01";
        _currentDay = @"01";
        
        UIButton *cancelButton = [UIButton createimageButtonWithFrame:CGRectMake(WIDTH(self)-45, 5, 30, 40) imageName:@"icon_xxxxx"];
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        UIImageView *imageView = [UIImageView createImageViewWithFrame:RECT(15, 60, ScreenWidth-30, 202) imageName:@"iocn_timeSelect_bg"];
        [self addSubview:imageView];
        
        NSDate *currentYearDate = [NSDate date];
        NSString * currentYear=  [CommonUtil getStringForDate:currentYearDate format:@"yyyy-MM-dd HH:mm"];
        NSInteger year = [[currentYear substringWithRange:NSMakeRange(0, 4)] integerValue];
        _yearsArray = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i = 0; i<=(year-2017); i++) {
            [_yearsArray addObject:[NSString stringWithFormat:@"%d",i+2017]];
        }
        
        _monthsArray = [NSArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];
       
        _allDaysArray = @[@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"18",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"],@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"18",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30"],@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"18",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29"],@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"18",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28"]];
      
        _daysArray = _allDaysArray[0];
        
        _YearPicker = [[UIPickerView alloc]initWithFrame:RECT(15, 60, (ScreenWidth-30)*104.0/345.0, 202)];
        _YearPicker.delegate = self;
        _YearPicker.dataSource = self;
        [self addSubview:_YearPicker];
        
        _MonthPicker = [[UIPickerView alloc]initWithFrame:RECT(15+WIDTH(_YearPicker), 60,WIDTH(_YearPicker), 202)];
        _MonthPicker.delegate = self;
        _MonthPicker.dataSource = self;
        [self addSubview:_MonthPicker];
        
        _DayPicker = [[UIPickerView alloc]initWithFrame:RECT(ScreenWidth-WIDTH(_YearPicker)-15, 60,WIDTH(_YearPicker), 202)];
        _DayPicker.delegate = self;
        _DayPicker.dataSource = self;
        [self addSubview:_DayPicker];
        
        UIButton *sureButton = [UIButton createTextButtonWithFrame:RECT(15, HEIGHT(self)-59, WIDTH(self)-30, 44) bgColor:ColorYellow textColor:ColorWhite font:16 bold:YES title:@"确定"];
        [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        sureButton.layer.cornerRadius = 3;
        sureButton.layer.masksToBounds = YES;
        [self addSubview:sureButton];

    }
    return self;
}
#pragma mark delegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView==_YearPicker) {
        return _yearsArray.count;
    }else if (pickerView ==_MonthPicker) {
        return _monthsArray.count;
    }else {
        return _daysArray.count;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView==_YearPicker) {
        return _yearsArray[row];
    }else if (pickerView==_MonthPicker) {
        return _monthsArray[row];
    }else {
        return _daysArray[row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView==_YearPicker) {
        NSString *year = _yearsArray[row];
        NSInteger currentYear = [year integerValue];
        if (currentYear%4==0) {
            self.leapYear = YES;//是闰年
        }else {
            self.leapYear = NO;
        }
        if (self.leapYear&&self.isSecondMonth) {
            self.daysArray = self.allDaysArray[2];
        }else if (!self.leapYear&&self.isSecondMonth) {
            self.daysArray = self.allDaysArray[3];
        }
        _currentYear = year;
        NSLog(@"year===%@",_currentYear);
        [_DayPicker reloadAllComponents];
    }else if (pickerView ==_MonthPicker) {
        if (row==1) {
            self.isSecondMonth = YES;
            if (self.leapYear&&self.isSecondMonth) {
                self.daysArray = self.allDaysArray[2];
            }else if (!self.leapYear&&self.isSecondMonth) {
                self.daysArray = self.allDaysArray[3];
            }
        }else if ((row==0||row==2||row==4||row==6||row==7||row==9||row==11)) {
            self.isSecondMonth = NO;
            self.daysArray = self.allDaysArray[0];
        }else {
            self.isSecondMonth = NO;
            self.daysArray = self.allDaysArray[1];
        }
        _currentmonth  = _monthsArray[row];
        NSLog(@"month===%@",_currentmonth);
        [_DayPicker reloadAllComponents];
    }else {
        _currentDay = _daysArray[row];
        NSLog(@"day===%@",_currentDay);
    }
}
/**
 *   取消按钮点击
 **/
- (void)cancelButtonClick {
    if (_delegate&&[_delegate respondsToSelector:@selector(customPickerSelectCancelInView:)]) {
        [_delegate customPickerSelectCancelInView:self];
    }
}
/**
 *   确定按钮点击
 **/
- (void)sureButtonClick {
    if (_delegate&&[_delegate respondsToSelector:@selector(customPickerSelectInView:year:month:days:)]) {
        [_delegate customPickerSelectInView:self year:self.currentYear month:self.currentmonth days:self.currentDay];
    }
}
@end
