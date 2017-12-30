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


#import "NSArray+Extension.h"

@implementation NSArray (Extension)
- (id)serialize
{
    if ( 0 == [self count] )
        return nil;
    
    NSMutableArray * array = [NSMutableArray array];
    
    for ( NSObject * element in self )
    {
        [array addObject:[element serialize]];
    }
    
    return array;
}

- (void)unserialize:(id)obj
{
}

- (void)zerolize
{
}

- (NSArray *)head:(NSUInteger)count
{
    if ( 0 == self.count || 0 == count )
    {
        return nil;
    }
    
    if ( self.count < count )
    {
        return self;
    }
    
    NSRange range;
    range.location = 0;
    range.length = count;
    
    return [self subarrayWithRange:range];
}

- (NSArray *)tail:(NSUInteger)count
{
    if ( 0 == self.count || 0 == count )
    {
        return nil;
    }
    
    if ( self.count < count )
    {
        return self;
    }
    
    NSRange range;
    range.location = self.count - count;
    range.length = count;
    
    return [self subarrayWithRange:range];
}

- (NSString *)join
{
    return [self join:nil];
}

- (NSString *)join:(NSString *)delimiter
{
    if ( 0 == self.count )
    {
        return @"";
    }
    else if ( 1 == self.count )
    {
        return [[self objectAtIndex:0] description];
    }
    else
    {
        NSMutableString * result = [NSMutableString string];
        
        for ( NSUInteger i = 0; i < self.count; ++i )
        {
            [result appendString:[[self objectAtIndex:i] description]];
            
            if ( delimiter )
            {
                if ( i + 1 < self.count )
                {
                    [result appendString:delimiter];
                }
            }
        }
        
        return result;
    }
}

#pragma mark -

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if ( index >= self.count )
        return nil;
    
    return [self objectAtIndex:index];
}

- (id)safeSubarrayWithRange:(NSRange)range
{
    if ( 0 == self.count )
        return [NSArray array];
    
    if ( range.location >= self.count )
        return [NSArray array];
    
    range.length = MIN( range.length, self.count - range.location );
    if ( 0 == range.length )
        return [NSArray array];
    
    return [self subarrayWithRange:NSMakeRange(range.location, range.length)];
}

- (id)safeSubarrayFromIndex:(NSUInteger)index
{
    if ( 0 == self.count )
        return [NSArray array];
    
    if ( index >= self.count )
        return [NSArray array];
    
    return [self safeSubarrayWithRange:NSMakeRange(index, self.count - index)];
}

- (id)safeSubarrayWithCount:(NSUInteger)count
{
    if ( 0 == self.count )
        return [NSArray array];
    
    return [self safeSubarrayWithRange:NSMakeRange(0, count)];
}

#pragma mark  数组转字符串
- (NSString *)stringWithIdentifier:(NSString *)identifier
{
    if(self==nil || self.count==0) return @"";
    
    NSMutableString *str=[NSMutableString string];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"%@%@",obj,identifier];
    }];
    
    //删除最后一个identifier
    NSString *strForRight = [str substringWithRange:NSMakeRange(0, str.length-1)];
    
    return strForRight;
}

#pragma mark  数组比较
- (BOOL)compareIgnoreObjectOrderWithArray:(NSArray *)array
{
    NSSet *set1=[NSSet setWithArray:self];
    
    NSSet *set2=[NSSet setWithArray:array];
    
    return [set1 isEqualToSet:set2];
}

/**
 *  数组计算交集
 */
- (NSArray *)arrayForIntersectionWithOtherArray:(NSArray *)otherArray
{
    NSMutableArray *intersectionArray=[NSMutableArray array];
    
    if(self.count==0) return nil;
    if(otherArray==nil) return nil;
    
    //遍历
    for (id obj in self) {
        
        if(![otherArray containsObject:obj]) continue;
        
        //添加
        [intersectionArray addObject:obj];
    }
    
    return intersectionArray;
}



/**
 *  数据计算差集
 */
- (NSArray *)arrayForMinusWithOtherArray:(NSArray *)otherArray
{
    if(self==nil) return nil;
    
    if(otherArray==nil) return self;
    
    NSMutableArray *minusArray=[NSMutableArray arrayWithArray:self];
    
    //遍历
    for (id obj in otherArray)
    {    
        if(![self containsObject:obj]) continue;
        
        //添加
        [minusArray removeObject:obj];
        
    }
    
    return minusArray;
}

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *msr = [NSMutableString string];
    [msr appendString:@"["];
    for (id obj in self)
    {
        [msr appendFormat:@"\n\t%@,",obj];
    }
    //去掉最后一个逗号（,）
    if ([msr hasSuffix:@","])
    {
        NSString *str = [msr substringToIndex:msr.length - 1];
        msr = [NSMutableString stringWithString:str];
    }
    [msr appendString:@"\n]"];
    return msr;
}

@end
