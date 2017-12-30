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


#import "UITableView+Extension.h"
static inline NSString * StringifyIdentifier(id identifier)
{
    NSString * result = nil;
    
    if ( ![identifier isKindOfClass:NSString.class] )
    {
        result = NSStringFromClass(identifier);
    }
    else
    {
        result = identifier;
    }
    
    return result;
}

#pragma mark - UITableViewCell (Extension)

@implementation UITableViewCell (Extension)

+ (void)registerNibTo:(UITableView *)tableView
{
    [tableView registerNib:[self nib] forCellReuseIdentifier:NSStringFromClass(self)];
}

+ (void)registerClassTo:(UITableView *)tableView
{
    [tableView registerClass:self forCellReuseIdentifier:NSStringFromClass(self)];
}

@end

@implementation UITableViewHeaderFooterView (Extension)

+ (void)registerNibTo:(UITableView *)tableView
{
    [tableView registerNib:[self nib] forHeaderFooterViewReuseIdentifier:NSStringFromClass(self)];
}

+ (void)registerClassTo:(UITableView *)tableView
{
    [tableView registerClass:self forHeaderFooterViewReuseIdentifier:NSStringFromClass(self)];
}

@end

#pragma mark - UITableView (Extension)

@implementation UITableView (Extension)

#pragma mark - Cell

- (void)registerNib:(NSString *)nibName
{
    [self registerNib:nibName bundle:[NSBundle mainBundle]];
}

- (void)registerNib:(NSString *)nibName identifier:(NSString *)identifier
{
    [self registerNib:nibName bundle:[NSBundle mainBundle] identifier:identifier];
}

- (void)registerNib:(NSString *)nibName bundle:(NSBundle *)bundle
{
    [self registerNib:[UINib nibWithNibName:nibName bundle:bundle] forCellReuseIdentifier:nibName];
}

- (void)registerNib:(NSString *)nibName bundle:(NSBundle *)bundle identifier:(NSString *)identifier
{
    [self registerNib:[UINib nibWithNibName:nibName bundle:bundle] forCellReuseIdentifier:identifier];
}

- (void)registerClass:(NSString *)className
{
    [self registerClass:NSClassFromString(className) forCellReuseIdentifier:className];
}

#pragma mark - HeaderFooter

- (void)registerHeaderFooterNib:(NSString *)nibName
{
    [self registerNib:nibName bundle:[NSBundle mainBundle]];
}

- (void)registerHeaderFooterNib:(NSString *)nibName bundle:(NSBundle *)bundle
{
    [self registerNib:[UINib nibWithNibName:nibName bundle:bundle] forHeaderFooterViewReuseIdentifier:nibName];
}

- (void)registerHeaderFooterClass:(NSString *)className
{
    [self registerClass:NSClassFromString(className) forHeaderFooterViewReuseIdentifier:className];
}

#pragma mark - Dequeue

- (id)dequeue:(id)identifier
{
    return [self dequeueReusableCellWithIdentifier:StringifyIdentifier(identifier)];
}

- (id)dequeue:(id)identifier forIndexPath:(NSIndexPath *)indexPath
{
    return [self dequeueReusableCellWithIdentifier:StringifyIdentifier(identifier) forIndexPath:indexPath];
}

- (id)dequeueHeaderFooter:(id)identifier
{
    return [self dequeueReusableHeaderFooterViewWithIdentifier:StringifyIdentifier(identifier)];
}

@end
