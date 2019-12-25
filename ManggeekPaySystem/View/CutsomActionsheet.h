//
//  CutsomActionsheet.h
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CutsomActionsheet;
@protocol CustomActionSheetDelegate <NSObject>
@optional
- (void)customActionSheetClickInView:(CutsomActionsheet *)sheet index:(NSInteger)index;
- (void)customActionSheetClickCancelInView:(CutsomActionsheet *)sheet;

@end;
@interface CutsomActionsheet : UIView
@property (nonatomic,strong)NSArray *itemArray;
@property (nonatomic,assign)id<CustomActionSheetDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title listArray:(NSArray *)array;
@end
