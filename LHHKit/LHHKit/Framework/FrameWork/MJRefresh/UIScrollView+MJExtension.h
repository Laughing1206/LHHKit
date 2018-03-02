//
//   ___           ___        ___      ___        ___
//  /\  \         /\  \      /\  \    /\  \      /\  \
//  \ \  \        \ \  \_____\ \  \   \ \  \_____\ \  \
//   \ \  \        \ \  \_____\ \  \   \ \  \_____\ \  \
//    \ \  \______  \ \  \     \ \  \   \ \  \     \ \  \
//     \ \________\  \ \__\     \ \__\   \ \__\     \ \__\
//      \/________/   \/__/      \/__/    \/__/      \/__/
//
//  欢欢为人民服务
//  有问题请联系我，http://www.jianshu.com/u/3c6ff28fdc63
//
// -----------------------------------------------------------------------------


#import <UIKit/UIKit.h>

@interface UIScrollView (MJExtension)
@property (assign, nonatomic) CGFloat mj_insetT;
@property (assign, nonatomic) CGFloat mj_insetB;
@property (assign, nonatomic) CGFloat mj_insetL;
@property (assign, nonatomic) CGFloat mj_insetR;

@property (assign, nonatomic) CGFloat mj_offsetX;
@property (assign, nonatomic) CGFloat mj_offsetY;

@property (assign, nonatomic) CGFloat mj_contentSizeW;
@property (assign, nonatomic) CGFloat mj_contentSizeH;
@end
