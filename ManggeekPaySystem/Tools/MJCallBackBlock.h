//
//  MJCallBackBlock.h
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/23.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#ifndef MJCallBackBlock_h
#define MJCallBackBlock_h
/*
 * 参数：索引返回类 block
 */
typedef void (^MJTypeCallbackBlock)(NSInteger type);
/*
 * 参数：返回类型不确定
 */
typedef void (^MJIdCallbackBlock) (id  *object);
/*
 * 参数：不需要返回数据
 */
typedef void (^MJVoidCallbackBlock) (void);


#endif /* MJCallBackBlock_h */
