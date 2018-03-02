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

#import "UITabBar+CustomBadge.h"
#import <objc/runtime.h>

static NSString * const kBadgeViewInitedKey = @"kBadgeViewInited";
static NSString * const kBadgeDotViewsKey = @"kBadgeDotViewsKey";
static NSString * const kBadgeNumberViewsKey = @"kBadgeNumberViewsKey";
static NSString * const kTabIconWidth = @"kTabIconWidth";
static NSString * const kBadgeTop = @"kBadgeTop";

@implementation UITabBar (CustomBadge)

- (void)setTabIconWidth:(CGFloat)width
{
    [self setValue:@(width) forUndefinedKey:kTabIconWidth];
}

- (void)setBadgeTop:(CGFloat)top
{
    [self setValue:@(top) forUndefinedKey:kBadgeTop];
}

- (void)setBadgeStyle:(CustomBadgeType)type value:(NSInteger)badgeValue atIndex:(NSInteger)index
{
    if ( index > 10 ) return;
        
    if( ![[self valueForKey:kBadgeViewInitedKey] boolValue] )
	{
        [self setValue:@(YES) forKey:kBadgeViewInitedKey];
        [self addBadgeViews];
    }

    NSMutableArray *badgeDotViews = [self valueForKey:kBadgeDotViewsKey];
    NSMutableArray *badgeNumberViews = [self valueForKey:kBadgeNumberViewsKey];
    
    [badgeDotViews[index] setHidden:YES];
    [badgeNumberViews[index] setHidden:YES];

    if(type == kCustomBadgeStyleRedDot){
        [badgeDotViews[index] setHidden:NO];
        
    }else if(type == kCustomBadgeStyleNumber){
        [badgeNumberViews[index] setHidden:NO];
        UILabel *label = badgeNumberViews[index];
        [self adjustBadgeNumberViewWithLabel:label number:badgeValue];
        
    }else if(type == kCustomBadgeStyleNone){
    }
}

- (void)addBadgeViews{
    id idIconWith = [self valueForKey:kTabIconWidth];
    CGFloat tabIconWidth = idIconWith ? [idIconWith floatValue] : 32;
    id idBadgeTop = [self valueForKey:kBadgeTop];
    CGFloat badgeTop = idBadgeTop ? [idBadgeTop floatValue] : 11;
    
    NSInteger itemsCount = self.items.count;
    CGFloat itemWidth = self.bounds.size.width / itemsCount;
    
    //dot views
    NSMutableArray *badgeDotViews = [NSMutableArray new];

    for(int i = 0;i < itemsCount;i ++)
	{
        UIView *redDot = [UIView new];
        redDot.bounds = CGRectMake(0, 0, 10, 10);
        redDot.center = CGPointMake(itemWidth*(i+0.5)+tabIconWidth/2, badgeTop);
        redDot.layer.cornerRadius = redDot.bounds.size.width/2;
        redDot.clipsToBounds = YES;
        redDot.backgroundColor = [UIColor redColor];
        redDot.hidden = YES;
        [self addSubview:redDot];
        [badgeDotViews addObject:redDot];
    }

    [self setValue:badgeDotViews forKey:kBadgeDotViewsKey];
    
    //number views
    NSMutableArray *badgeNumberViews = [NSMutableArray new];

    for(int i = 0;i < itemsCount;i ++)
	{
        UILabel *redNum = [UILabel new];
        redNum.layer.anchorPoint = CGPointMake(0, 0.5);
        redNum.bounds = CGRectMake(0, 0, 16, 16);
        redNum.center = CGPointMake(itemWidth*(i+0.5)+tabIconWidth/2-10, badgeTop);
        redNum.layer.cornerRadius = redNum.bounds.size.height/2;
        redNum.clipsToBounds = YES;
        redNum.backgroundColor = [UIColor redColor];
        redNum.hidden = YES;

        redNum.textAlignment = NSTextAlignmentCenter;
        redNum.font = [UIFont systemFontOfSize:12];
        redNum.textColor = [UIColor whiteColor];
        
        [self addSubview:redNum];
        [badgeNumberViews addObject:redNum];
    }

    [self setValue:badgeNumberViews forKey:kBadgeNumberViewsKey];
}

- (void)adjustBadgeNumberViewWithLabel:(UILabel *)label number:(NSInteger)number{
    [label setText:(number > 99 ? @"99+" : @(number).stringValue)];
    if(number < 10){
        label.bounds = CGRectMake(0, 0, 16, 16);
    }else if(number < 99){
        label.bounds = CGRectMake(0, 0, 20, 16);
    }else{
        label.bounds = CGRectMake(0, 0, 25, 16);
    }
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return objc_getAssociatedObject(self, (__bridge const void *)(key));
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    objc_setAssociatedObject(self, (__bridge const void *)(key), value, OBJC_ASSOCIATION_COPY);
}

@end
