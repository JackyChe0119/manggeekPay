//
//  ColorMaco.h
//  KongGeekSample
//
//  Created by Robin on 16/7/2.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#ifndef ColorMaco_h
#define ColorMaco_h

// RGB
#define RGB_A(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A];
// 16进制颜色赋值  a6bfcc
#define colorWithHexString(hex) [UIColor colorWithHexString:hex]
#define ColorYellow colorWithHexString(@"#fed431")
#define ColorGreen colorWithHexString(@"#25c36f")
#define ColorWhite colorWithHexString(@"#ffffff")
#define ColorLine colorWithHexString(@"#dddddd")
#define ColorBlack colorWithHexString(@"#000000")
#define ColorWith3 colorWithHexString(@"#333333")
#define Color_Common colorWithHexString(@"#3bb1ff")
#define Color_LineE9 colorWithHexString(@"#f0f0f0")
#define Color_F5F5F5 colorWithHexString(@"#f5f5f5")
#define Color_999999 colorWithHexString(@"#999999")
#define Color_333333 colorWithHexString(@"#333333")
#define Color_666666 colorWithHexString(@"#666666")
#define Color_777777 colorWithHexString(@"#777777")
#define Color_shadow colorWithHexString(@"#859fac")


#endif /* ColorMaco_h */
