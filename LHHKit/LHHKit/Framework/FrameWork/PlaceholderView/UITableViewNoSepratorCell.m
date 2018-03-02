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
#import "UITableViewNoSepratorCell.h"

#pragma mark -

@interface UIView (_UITableViewNoSepratorCellPrivate)
- (void)_removeAllSeparator;
@end

@implementation UIView (_UITableViewNoSepratorCellPrivate)

- (void)_removeAllSeparator
{
    [self.subviews enumerateObjectsUsingBlock:^(UIView * subview, NSUInteger idx, BOOL *stop) {
        [subview _removeAllSeparator];
    }];
    
    if ( [self isKindOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")] ) {
        [self removeFromSuperview];
    }
}

@end

#pragma mark -

@interface UITableViewNoSepratorCell ()
@end

@implementation UITableViewNoSepratorCell

- (void)layoutSubviews
{
	[super layoutSubviews];
    
    [self _removeAllSeparator];
}

@end
