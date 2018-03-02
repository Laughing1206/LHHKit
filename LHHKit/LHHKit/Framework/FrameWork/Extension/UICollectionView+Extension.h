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


#import <UIKit/UIKit.h>

@interface UICollectionViewCell (Extension)
+ (void)registerNibTo:(UICollectionView *)collectionView;
+ (void)registerClassTo:(UICollectionView *)collectionView;
@end

@interface UICollectionReusableView (Extension)
+ (void)registerNibTo:(UICollectionView *)collectionView kind:(NSString *)kind;
+ (void)registerClassTo:(UICollectionView *)collectionView kind:(NSString *)kind;
@end

#pragma mark -

@interface UICollectionView (Extension)

// Register reusing cell
- (void)registerNib:(NSString *)nibName;
- (void)registerNib:(NSString *)nibName bundle:(NSBundle *)bundle;
- (void)registerClass:(NSString *)className;
// Register reusing header or footer
- (void)registerNib:(NSString *)nibName kind:(NSString *)kind;
- (void)registerNib:(NSString *)nibName bundle:(NSBundle *)bundle kind:(NSString *)kind;
- (void)registerClass:(NSString *)className kind:(NSString *)kind;

// Dequeue cell
- (id)dequeue:(id)identifier forIndexPath:(NSIndexPath*)indexPath;
- (id)dequeue:(id)identifier kind:(NSString *)kind forIndexPath:(NSIndexPath*)indexPath;

@end

