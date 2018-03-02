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

#pragma mark -

@interface UITableViewCell (Extension)
+ (void)registerNibTo:(UITableView *)tableView;
+ (void)registerClassTo:(UITableView *)tableView;
@end

@interface UITableViewHeaderFooterView (Extension)
+ (void)registerNibTo:(UITableView *)tableView;
+ (void)registerClassTo:(UITableView *)tableView;
@end

#pragma mark -

@interface UITableView (Extension)

// Register reusing cell
- (void)registerNib:(NSString *)nibName;
- (void)registerNib:(NSString *)nibName identifier:(NSString *)identifier;
- (void)registerNib:(NSString *)nibName bundle:(NSBundle *)bundle;
- (void)registerNib:(NSString *)nibName bundle:(NSBundle *)bundle identifier:(NSString *)identifier;
- (void)registerClass:(NSString *)className;
// Register reusing header or footer
- (void)registerHeaderFooterNib:(NSString *)nibName;
- (void)registerHeaderFooterNib:(NSString *)nibName bundle:(NSBundle *)bundle;
- (void)registerHeaderFooterClass:(NSString *)className;

// Dequeue cell
// identifier is NSString or Class
- (id)dequeue:(id)identifier;
- (id)dequeue:(id)identifier forIndexPath:(NSIndexPath*)indexPath;
- (id)dequeueHeaderFooter:(id)identifier;

@end
