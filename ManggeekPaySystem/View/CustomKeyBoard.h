//
//  CustomKeyBoard.h
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^customKeyBoardReturnBlock) (NSString *text,NSInteger tag);
@interface CustomKeyBoard : UIView

@property (nonatomic,strong)customKeyBoardReturnBlock returnBlock;
@end
