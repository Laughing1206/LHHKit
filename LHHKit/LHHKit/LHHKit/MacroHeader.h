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

#ifndef MacroHeader_h
#define MacroHeader_h

#define SingletonInterface(classname)              +(instancetype)shared##classname;

#if __has_feature(objc_arc)
#define SingletonImplemention(class) \
static id instanse;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onesToken;\
dispatch_once(&onesToken, ^{\
instanse = [super allocWithZone:zone];\
});\
return instanse;\
}\
+ (instancetype)shared##class\
{\
static dispatch_once_t onestoken;\
dispatch_once(&onestoken, ^{\
instanse = [[self alloc] init];\
});\
return instanse;\
}\
- (id)copyWithZone:(NSZone *)zone\
{\
return instanse;\
};
#else
#define SingletonImplemention(class)  \
static id instanse;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onesToken;\
dispatch_once(&onesToken, ^{\
instanse = [super allocWithZone:zone];\
});\
return instanse;\
}\
+ (instancetype)shared##class\
{\
static dispatch_once_t onestoken;\
dispatch_once(&onestoken, ^{\
instanse = [[self alloc] init];\
});\
return instanse;\
}\
- (id)copyWithZone:(NSZone *)zone\
{\
return instanse;\
}\
- (oneway void)release {} \
- (instancetype)retain {return instance;} \
- (instancetype)autorelease {return instance;} \
- (NSUInteger)retainCount {return ULONG_MAX;}

#endif

// ----------------------------------
// Common use macros
// ----------------------------------

#ifndef    IN
#define IN
#endif

#ifndef    OUT
#define OUT
#endif

#ifndef    INOUT
#define INOUT
#endif

#ifndef    UNUSED
#define    UNUSED( __x )        { id __unused_var__ __attribute__((unused)) = (id)(__x); }
#endif

#ifndef    ALIAS
#define    ALIAS( __a, __b )    __typeof__(__a) __b = __a;
#endif

#ifndef    DEPRECATED
#define    DEPRECATED            __attribute__((deprecated))
#endif

#ifndef    TODO
#define TODO( X )            _Pragma(macro_cstr(message("✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖ TODO: " X)))
#endif

#ifndef    EXTERN_C
#if defined(__cplusplus)
#define EXTERN_C            extern "C"
#else
#define EXTERN_C            extern
#endif
#endif

#ifndef    INLINE
#define    INLINE                __inline__ __attribute__((always_inline))
#endif

// ----------------------------------
// Custom keywords
// ----------------------------------

#undef    var
#define var    NSObject *

#if !defined(__clang__) || __clang_major__ < 3

#ifndef __bridge
#define __bridge
#endif

#ifndef __bridge_retain
#define __bridge_retain
#endif

#ifndef __bridge_retained
#define __bridge_retained
#endif

#ifndef __autoreleasing
#define __autoreleasing
#endif

#ifndef __strong
#define __strong
#endif

#ifndef __unsafe_unretained
#define __unsafe_unretained
#endif

#ifndef __weak
#define __weak
#endif

#endif    // #if !defined(__clang__) || __clang_major__ < 3

// ----------------------------------
// Code block
// ----------------------------------

#ifndef    weakify
#if __has_feature(objc_arc)

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#else

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
_Pragma("clang diagnostic pop")

#endif
#endif

#ifndef    strongify
#if __has_feature(objc_arc)

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")

#else

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __block_##x##__; \
_Pragma("clang diagnostic pop")

#endif
#endif

#undef  PERFORM_BLOCK_SAFELY
#define PERFORM_BLOCK_SAFELY( b, ... ) if ( (b) ) { (b)(__VA_ARGS__); }

#undef  dispatch_main_sync_safe
#define dispatch_main_sync_safe(block) if ([NSThread isMainThread]) { block(); \
} else { dispatch_sync(dispatch_get_main_queue(), block); }

#undef  dispatch_main_async_safe
#define dispatch_main_async_safe(block) if ([NSThread isMainThread]) { block(); \
} else { dispatch_async(dispatch_get_main_queue(), block); }


#ifndef __OPTIMIZE__
#define NSLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
# define NSLog(...)
#endif

#define RGBA(r,g,b,a)       [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGB(r,g,b)          RGBA(r,g,b,1)
#define RGBEqualColor(c)    RGB(c,c,c)
#define RGBRandom           RGB(arc4random()%255,arc4random()%255,arc4random()%255)

#define kscreen_width ([UIScreen mainScreen].bounds.size.width)
#define kscreen_height ([UIScreen mainScreen].bounds.size.height)

#define IS_iPhoneX               (kscreen_width == 375.f && kscreen_height == 812.f ? YES:NO)
#define NavibarHeight            (IS_iPhoneX ? 88.f : 64.f)
#define TabbarHeight             (IS_iPhoneX ? (49.f + 34.f) : 49.f)
#define StatusbarHeight          (IS_iPhoneX ? 44.f : 20.f)
#define TabbarBottomOffset             (IS_iPhoneX ? 34.f:0) //底部高度差

#endif /* MacroHeader_h */
