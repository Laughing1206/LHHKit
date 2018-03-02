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

#ifndef LHHSignalHeader_h
#define LHHSignalHeader_h

// ----------------------------------
// Unix include headers
// ----------------------------------

#import <stdio.h>
#import <stdlib.h>
#import <stdint.h>
#import <string.h>
#import <assert.h>
#import <errno.h>

#import <sys/errno.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <sys/stat.h>
#import <sys/mman.h>

#import <math.h>
#import <unistd.h>
#import <limits.h>
#import <execinfo.h>

#import <netdb.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>

#import <mach/mach.h>
#import <mach/machine.h>
#import <machine/endian.h>
#import <malloc/malloc.h>

#import <sys/utsname.h>

#import <fcntl.h>
#import <dirent.h>
#import <dlfcn.h>
#import <spawn.h>

#import <mach-o/fat.h>
#import <mach-o/dyld.h>
#import <mach-o/arch.h>
#import <mach-o/nlist.h>
#import <mach-o/loader.h>
#import <mach-o/getsect.h>

#import <zlib.h>
//#import <libxml2/libxml/HTMLparser.h>
//#import <libxml2/libxml/tree.h>
//#import <libxml2/libxml/xpath.h>

#ifdef __IPHONE_8_0
#import <spawn.h>
#endif

// ----------------------------------
// Mac/iOS include headers
// ----------------------------------

#ifdef __OBJC__

#import <Availability.h>
#import <Foundation/Foundation.h>

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <TargetConditionals.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreImage/CoreImage.h>
#import <CoreLocation/CoreLocation.h>

#import <objc/runtime.h>
#import <objc/message.h>
#import <dlfcn.h>

#else    // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>

#import <objc/objc-class.h>

#endif    // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import <CommonCrypto/CommonDigest.h>

#endif    // #ifdef __OBJC__

typedef id      BlockType;
typedef void (^ BlockTypeVoid )( void );
typedef void (^ BlockTypeVarg )( id first, ... );

// ----------------------------------
// Meta macro
// ----------------------------------

#define macro_first(...)                                    macro_first_( __VA_ARGS__, 0 )
#define macro_first_( A, ... )                                A

#define macro_concat( A, B )                                macro_concat_( A, B )
#define macro_concat_( A, B )                                A##B

#define macro_count(...)                                    macro_at( 8, __VA_ARGS__, 8, 7, 6, 5, 4, 3, 2, 1 )
#define macro_more(...)                                        macro_at( 8, __VA_ARGS__, 1, 1, 1, 1, 1, 1, 1, 1 )

#define macro_at0(...)                                        macro_first(__VA_ARGS__)
#define macro_at1(_0, ...)                                    macro_first(__VA_ARGS__)
#define macro_at2(_0, _1, ...)                                macro_first(__VA_ARGS__)
#define macro_at3(_0, _1, _2, ...)                            macro_first(__VA_ARGS__)
#define macro_at4(_0, _1, _2, _3, ...)                        macro_first(__VA_ARGS__)
#define macro_at5(_0, _1, _2, _3, _4 ...)                    macro_first(__VA_ARGS__)
#define macro_at6(_0, _1, _2, _3, _4, _5 ...)                macro_first(__VA_ARGS__)
#define macro_at7(_0, _1, _2, _3, _4, _5, _6 ...)            macro_first(__VA_ARGS__)
#define macro_at8(_0, _1, _2, _3, _4, _5, _6, _7, ...)        macro_first(__VA_ARGS__)
#define macro_at(N, ...)                                    macro_concat(macro_at, N)( __VA_ARGS__ )

#define macro_join0( ... )
#define macro_join1( A )                                    A
#define macro_join2( A, B )                                    A##____##B
#define macro_join3( A, B, C )                                A##____##B##____##C
#define macro_join4( A, B, C, D )                            A##____##B##____##C##____##D
#define macro_join5( A, B, C, D, E )                        A##____##B##____##C##____##D##____##E
#define macro_join6( A, B, C, D, E, F )                        A##____##B##____##C##____##D##____##E##____##F
#define macro_join7( A, B, C, D, E, F, G )                    A##____##B##____##C##____##D##____##E##____##F##____##G
#define macro_join8( A, B, C, D, E, F, G, H )                A##____##B##____##C##____##D##____##E##____##F##____##G##____##H
#define macro_join( ... )                                    macro_concat(macro_join, macro_count(__VA_ARGS__))(__VA_ARGS__)

#define macro_cstr( A )                                        macro_cstr_( A )
#define macro_cstr_( A )                                    #A

#define macro_string( A )                                    macro_string_( A )
#define macro_string_( A )                                    @(#A)


#import "LHHProperty.h"
#import "LHHTrigger.h"
#import "LHHSignal.h"
#import "LHHSignal+Extension.h"
#import "UIView+Signal.h"
#import "UIControl+Signal.h"
#import "UIButton+Signal.h"
#import "UISegmentedControl+Signal.h"
#import "UISlider+Signal.h"
#import "UIStepper+Signal.h"
#import "UISwitch+Signal.h"
#import "UITextField+Signal.h"

#endif /* LHHSignalHeader_h */
