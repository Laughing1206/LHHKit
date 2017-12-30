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

#import "UIView+Signal.h"
#import <objc/runtime.h>
#import "UIView+BlocksKit.h"

static const char kSignalKey;

static const char kPreferedSourceKey;

@implementation UIView(Signal)

@dynamic signal;
@dynamic signalType;
@dynamic preferedSource;

- (void)setSignal:(NSString *)signal
{
    objc_setAssociatedObject( self, &kSignalKey, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    
    __weak typeof(self) weakSelf = self;
    
    if ( signal == nil )
    {
        [self bk_whenTapped:^{
            [weakSelf sendSignal:UIControl.click];
        }];
    }
    else
    {
        if ( ![self isKindOfClass:UIControl.class] )
        {
            if ( [self isKindOfClass:UIImageView.class] )
                self.userInteractionEnabled = YES;
            
            [self bk_whenTapped:^{
                [weakSelf sendSignal:UIControl.click];
            }];
        }
    }
}

- (NSString *)signal
{
    return     objc_getAssociatedObject(self, &kSignalKey);
}

- (void)setPreferedSource:(id)preferedSource
{
    objc_setAssociatedObject( self, &kPreferedSourceKey, preferedSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (id)preferedSource
{
    return     objc_getAssociatedObject(self, &kPreferedSourceKey);
}

#pragma mark - config signal routes

- (NSString *)signalNamespace
{
    return [[self class] description];
}

- (NSString *)signalTag
{
    return self.signal;
}

- (NSString *)sam_domTag
{
    return [[self class] description];
}

- (NSString *)signalDescription
{
    if ( [self sam_domTag] && self.signal )
    {
        return [NSString stringWithFormat:@"%@, <%@ id='%@'/>", [[self class] description], [self sam_domTag], self.signal];
    }
    else if ( [self sam_domTag] )
    {
        return [NSString stringWithFormat:@"%@, <%@/>", [[self class] description], [self sam_domTag]];
    }
    else
    {
        return [NSString stringWithFormat:@"%@", [[self class] description]];
    }
}

- (id)signalResponders
{
    NSObject * nextResponder = [self nextResponder];
    
    if ( nextResponder && [nextResponder isKindOfClass:[UIViewController class]] )
    {
        return nextResponder;
    }
    else
    {
        return self.superview;
    }
}

- (id)signalAlias
{
    NSMutableArray * array = [NSMutableArray nonRetainingArray];

    if ( self.signal )
    {
        [array addObject:self.signal];
    }
    
    return array;
}

@end
