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

#import "NSObject+AutoCoding.h"
#import "AutoCoding.h"
#import "NSObject+AutoRuntime.h"

@implementation NSObject (AutoModelCoding)

+ (instancetype)ac_objectWithAny:(id)any
{
    if ( nil == any )
    {
        return nil;
    }
    
    // TODO: handle more gracefully
    NSParameterAssert([any isKindOfClass:NSArray.class] || [any isKindOfClass:NSDictionary.class]);
    
    if ( [any isKindOfClass:NSArray.class] )
    {
        NSArray * protocols = [self conformedProtocols];
        if ( !protocols )
            return nil;
        
        NSAssert1(protocols.count, @"%@ should confirmes at least one protocol, or it can't determine what's in the array.", [self class]);
        Class clazz = NSClassFromString([protocols firstObject]);
        if ( !clazz )
            return nil;
        return [NSObject ac_objectsWithArray:(NSArray *)any objectClass:clazz];;
    }
    else if ( [any isKindOfClass:NSDictionary.class] )
    {
        return [self ac_objectWithDictionary:(NSDictionary *)any];
    }
    
    return nil;
}

+ (id)ac_objectsWithArray:(id)array objectClass:(__unsafe_unretained Class)clazz
{
    NSMutableArray * objects = [NSMutableArray array];
    
    for ( NSDictionary * obj in array )
    {
        if ( [obj isKindOfClass:[NSDictionary class]] )
        {
            id convertedObj = [clazz ac_objectWithDictionary:obj];
            if ( convertedObj ) {
                [objects addObject:convertedObj];
            }
        }
        else
        {
            [objects addObject:obj];
        }
    }
    
    return [objects copy];
}

+ (instancetype)ac_objectWithDictionary:(NSDictionary *)dictionary
{
	if ( !dictionary || !dictionary.count )
	{
		return nil;
	}

    id object = [[self alloc] init];
		
    NSDictionary * properties = [object codableProperties];
    
    for ( __unsafe_unretained NSString *property in properties )
    {
        id value = dictionary[property];
        Class clazz = properties[property][@"class"];
        Class subClazz = properties[property][@"subclass"];
        
        if ( value )
        {
            id convertedValue = value;
            
            if ( [value isKindOfClass:[NSArray class]] )
            {
                if ( subClazz != NSNull.null ) {
                    convertedValue = [NSObject ac_objectsWithArray:value objectClass:subClazz];
                }
                // TODO: handle else
            }
            else if ( [value isKindOfClass:[NSDictionary class]] )
            {
                convertedValue = [clazz ac_objectWithDictionary:value];
            }

            if ( convertedValue && ![convertedValue isKindOfClass:[NSNull class]] )
            {
                if ( [self conformsToProtocol:@protocol(AutoModelCoding)] )
                {
                    convertedValue = [(id<AutoModelCoding>)self processedValueForKey:property originValue:value convertedValue:convertedValue class:clazz subClass:subClazz];
                }

                [object setValue:convertedValue forKey:property];

                if ( ![convertedValue isKindOfClass:clazz] )
                {
//                    NSLog( @"The type of '%@' in <%@> is <%@>, but not compatible with expected <%@>, please see detail in the <AutoModelCoding> protocol.", property, [self class], [value class], clazz );
                }
            }
        }
    }
    
    return object;
}

- (NSString *)JSONStringRepresentation
{
    NSError * error = nil;
    
    id data = nil;
    
    if ( [self isKindOfClass:NSArray.class] )
    {
        data = [NSMutableArray array];
        
        [((NSArray *)self) enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
            if ( [obj isKindOfClass:NSString.class]
                 || [obj isKindOfClass:NSValue.class]
                 || [obj isKindOfClass:NSData.class]
                 || [obj isKindOfClass:NSDate.class]
                )
            {
                [data addObject:obj];
            } else {
                [data addObject:[obj dictionaryRepresentation]];
            }
        }];
    }
    else
    {
        data = [self dictionaryRepresentation];
    }
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    if ( !error ) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (instancetype)ac_clone
{
    NSDictionary * dict = [[self dictionaryRepresentation] copy];
    return [[self class] ac_objectWithDictionary:dict];
}

@end
