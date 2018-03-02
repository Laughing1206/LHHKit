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
#import "MenuCell.h"

@interface MenuView : UIView
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) void (^whenSelected)(id data);

@property (nonatomic, assign) CGPoint tableViewPoint;

+ (NSMutableArray *)menuDataWithTitles:(NSArray *)titles image:(NSArray *)images;

- (void)close;
- (void)showInView:(UIView *)view;
@end
