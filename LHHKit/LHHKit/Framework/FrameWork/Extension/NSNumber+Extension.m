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


#import "NSNumber+Extension.h"

@implementation NSNumber (Extension)

- (NSString *)currencyString
{
    static NSNumberFormatter * formatter = nil;
    
    if ( !formatter )
    {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setGroupingSeparator:@","];
        [formatter setGroupingSize:3];
        [formatter setUsesGroupingSeparator:YES];
    }
    
    return [formatter stringFromNumber:self];
}

- (NSString *)countStrWithCount
{
    NSString * countStr = @"0";
    
    if ( self.floatValue < 10000 )
    {
        countStr = [NSString stringWithFormat:@"%@", self];
    }
    else if ( self.floatValue >= 100000000 )
    {
        countStr = [NSString stringWithFormat:@"%d亿", self.intValue / 100000000];
    }
    else if ( self.floatValue >= 10000000 )
    {
        countStr = [NSString stringWithFormat:@"%d千万", self.intValue / 10000000];
    }
    else if ( self.floatValue >= 1000000 )
    {
        countStr = [NSString stringWithFormat:@"%d百万", self.intValue / 1000000];
    }
    else if ( self.floatValue >= 10000 )
    {
        if (self.intValue % 10000 > 100) {
            
            countStr = [NSString stringWithFormat:@"%.2f万", self.floatValue / 10000];
        }
        else
        {
            countStr = [NSString stringWithFormat:@"%d万", self.intValue / 10000];
        }
    }
    return countStr;
}

@end
