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



#import "LHHStreamModel.h"
#import "TradeEncryption.h"
#import "Transformer.h"
@implementation LHHStreamModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = [NSMutableArray array];
    }
    return self;
}

- (BOOL)isEmpty
{
    return nil == self.items || 0 == self.items.count;
}

- (void)loadMore
{
    NSAssert(NO, @"Must be overwrite");
}

#pragma mark -

- (NSString *)cacheKey
{
    return NSStringFromClass(self.class);
}

- (void)loadCache
{
    // 默认缓存路径
    [LHHCache switchCacheWithName:nil];
    
    if ([[LHHCache objectForKey:[self cacheKey]] isKindOfClass:[NSData class]])
    {
        NSData *teaData = [LHHCache objectForKey:[self cacheKey]];
        
        NSData *dicData = [TradeEncryption decrypt:teaData key:[TRACE_ENCRYPTION_KEY MD5Data] sign:YES];
        
        NSArray * items = [NSKeyedUnarchiver unarchiveObjectWithData:dicData];
        
        if ( items )
        {
            [self.items removeAllObjects];
            [self.items addObjectsFromArray:items];
        }
    }
}

- (void)saveCache
{
    // 默认缓存路径
    [LHHCache switchCacheWithName:nil];
    
    NSData *dicData = [NSKeyedArchiver archivedDataWithRootObject:self.items];
    
    NSData *teaData = [TradeEncryption encrypt:dicData key:[TRACE_ENCRYPTION_KEY MD5Data] sign:YES];
    
    [LHHCache setObject:teaData forKey:[self cacheKey]];
}

- (void)clearCache
{
    // 默认缓存路径
    [LHHCache switchCacheWithName:nil];
    
    [LHHCache removeObjectForKey:[self cacheKey]];
}

@end

