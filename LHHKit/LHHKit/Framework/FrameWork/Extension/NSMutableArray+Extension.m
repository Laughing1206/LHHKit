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


#import "NSMutableArray+Extension.h"

static const void *    __RetainFunc( CFAllocatorRef allocator, const void * value ) { return value; }
static void            __ReleaseFunc( CFAllocatorRef allocator, const void * value ) {}

#pragma mark -

@implementation NSMutableArray(Extension)

+ (NSMutableArray *)nonRetainingArray    // copy from Three20
{
    CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
    callbacks.retain = __RetainFunc;
    callbacks.release = __ReleaseFunc;
    return (__bridge_transfer NSMutableArray *)CFArrayCreateMutable( nil, 0, &callbacks );
}

- (void)addUniqueObject:(id)object compare:(NSArrayCompareBlock)compare
{
    BOOL found = NO;
    
    for ( id obj in self )
    {
        if ( compare )
        {
            NSComparisonResult result = compare( obj, object );
            if ( NSOrderedSame == result )
            {
                found = YES;
                break;
            }
        }
        else if ( [obj class] == [object class] && [obj respondsToSelector:@selector(compare:)] )
        {
            NSComparisonResult result = [obj compare:object];
            if ( NSOrderedSame == result )
            {
                found = YES;
                break;
            }
        }
    }
    
    if ( NO == found )
    {
        [self addObject:object];
    }
}

- (void)addUniqueObjects:(const __unsafe_unretained id [])objects count:(NSUInteger)count compare:(NSArrayCompareBlock)compare
{
    for ( NSUInteger i = 0; i < count; ++i )
    {
        BOOL    found = NO;
        id        object = objects[i];
        
        for ( id obj in self )
        {
            if ( compare )
            {
                NSComparisonResult result = compare( obj, object );
                if ( NSOrderedSame == result )
                {
                    found = YES;
                    break;
                }
            }
            else if ( [obj class] == [object class] && [obj respondsToSelector:@selector(compare:)] )
            {
                NSComparisonResult result = [obj compare:object];
                if ( NSOrderedSame == result )
                {
                    found = YES;
                    break;
                }
            }
        }
        
        if ( NO == found )
        {
            [self addObject:object];
        }
    }
}

- (void)addUniqueObjectsFromArray:(NSArray *)array compare:(NSArrayCompareBlock)compare
{
    for ( id object in array )
    {
        BOOL found = NO;
        
        for ( id obj in self )
        {
            if ( compare )
            {
                NSComparisonResult result = compare( obj, object );
                if ( NSOrderedSame == result )
                {
                    found = YES;
                    break;
                }
            }
            else if ( [obj class] == [object class] && [obj respondsToSelector:@selector(compare:)] )
            {
                NSComparisonResult result = [obj compare:object];
                if ( NSOrderedSame == result )
                {
                    found = YES;
                    break;
                }
            }
        }
        
        if ( NO == found )
        {
            [self addObject:object];
        }
    }
}

- (void)unique
{
    [self unique:^NSComparisonResult(id left, id right) {
        return [left compare:right];
    }];
}

- (void)unique:(NSArrayCompareBlock)compare
{
    if ( self.count <= 1 )
    {
        return;
    }
    
    // Optimize later ...
    
    NSMutableArray * dupArray = [NSMutableArray nonRetainingArray];
    NSMutableArray * delArray = [NSMutableArray nonRetainingArray];
    
    [dupArray addObjectsFromArray:self];
    [dupArray sortUsingComparator:compare];
    
    for ( NSUInteger i = 0; i < dupArray.count; ++i )
    {
        id elem1 = [dupArray safeObjectAtIndex:i];
        id elem2 = [dupArray safeObjectAtIndex:(i + 1)];
        
        if ( elem1 && elem2 )
        {
            if ( NSOrderedSame == compare(elem1, elem2) )
            {
                [delArray addObject:elem1];
            }
        }
    }
    
    for ( id delElem in delArray )
    {
        [self removeObject:delElem];
    }
}

- (void)sort
{
    [self sort:^NSComparisonResult(id left, id right) {
        return [left compare:right];
    }];
}

- (void)sort:(NSArrayCompareBlock)compare
{
    [self sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return compare( obj1, obj2 );
    }];
}

- (void)shrink:(NSUInteger)count
{
    if ( 0 == count )
    {
        [self removeAllObjects];
    }
    else if ( count <= self.count )
    {
        [self removeObjectsInRange:NSMakeRange(count, self.count - count)];
    }
}

- (void)append:(id)object
{
    [self addObject:object];
}

- (NSMutableArray *)pushHead:(NSObject *)obj
{
    if ( obj )
    {
        [self insertObject:obj atIndex:0];
    }
    
    return self;
}

- (NSMutableArray *)pushHeadN:(NSArray *)all
{
    if ( [all count] )
    {
        for ( NSUInteger i = [all count]; i > 0; --i )
        {
            [self insertObject:[all objectAtIndex:i - 1] atIndex:0];
        }
    }
    
    return self;
}

- (NSMutableArray *)popTail
{
    if ( [self count] > 0 )
    {
        [self removeObjectAtIndex:[self count] - 1];
    }
    
    return self;
}

- (NSMutableArray *)popTailN:(NSUInteger)n
{
    if ( [self count] > 0 )
    {
        if ( n >= [self count] )
        {
            [self removeAllObjects];
        }
        else
        {
            NSRange range;
            range.location = n;
            range.length = [self count] - n;
            
            [self removeObjectsInRange:range];
        }
    }
    
    return self;
}

- (NSMutableArray *)pushTail:(NSObject *)obj
{
    if ( obj )
    {
        [self addObject:obj];
    }
    
    return self;
}

- (NSMutableArray *)pushTailN:(NSArray *)all
{
    if ( [all count] )
    {
        [self addObjectsFromArray:all];
    }
    
    return self;
}

- (NSMutableArray *)popHead
{
    if ( [self count] )
    {
        [self removeLastObject];
    }
    
    return self;
}

- (NSMutableArray *)popHeadN:(NSUInteger)n
{
    if ( [self count] > 0 )
    {
        if ( n >= [self count] )
        {
            [self removeAllObjects];
        }
        else
        {
            NSRange range;
            range.location = 0;
            range.length = n;
            
            [self removeObjectsInRange:range];
        }
    }
    
    return self;
}

- (NSMutableArray *)keepHead:(NSUInteger)n
{
    if ( [self count] > n )
    {
        NSRange range;
        range.location = n;
        range.length = [self count] - n;
        
        [self removeObjectsInRange:range];
    }
    
    return self;
}

- (NSMutableArray *)keepTail:(NSUInteger)n
{
    if ( [self count] > n )
    {
        NSRange range;
        range.location = 0;
        range.length = [self count] - n;
        
        [self removeObjectsInRange:range];
    }
    
    return self;
}
@end
