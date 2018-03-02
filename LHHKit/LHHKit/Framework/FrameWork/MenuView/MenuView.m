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
#import "MenuView.h"

@interface MenuView () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView * tableView;
@property (weak, nonatomic) IBOutlet UIButton *bgButton;
@end

@implementation MenuView

- (void)awakeFromNib
{
	[super awakeFromNib];

	self.backgroundColor = [UIColor clearColor];
	[self setupTableView];
}

- (void)setupTableView
{
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 120, 98)];

	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

	self.tableView.backgroundColor = [UIColor clearColor];

	self.tableView.delegate = self;
	self.tableView.dataSource = self;

	for ( NSString * cellStr in @[@"MenuCell"] )
	{
		[self.tableView registerNib:cellStr];
	}

	self.tableView.scrollEnabled = NO;

	[self addSubview:self.tableView];
}

#pragma mark -

- (void)layoutSubviews
{
	if ( [self.data isKindOfClass:[NSArray class]] )
	{
		self.tableView.x = self.tableViewPoint.x;
		self.tableView.y = self.tableViewPoint.y;
	}
    [super layoutSubviews];
}

#pragma mark -

- (void)dataDidChange
{
	if ( [self.data isKindOfClass:[NSArray class]] )
	{
		[self.tableView reloadData];
	}
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ( [self.data isKindOfClass:[NSArray class]] )
	{
		NSArray * datas = self.data;
		return datas.count;
	}

	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];

	if ( [self.data isKindOfClass:[NSArray class]] )
	{
		NSArray * datas = self.data;

		MENU_INFO * info = [datas safeObjectAtIndex:indexPath.row];

		if ( indexPath.row == 0 )
		{
			info.bgImage = [UIImage imageNamed:@"search_bg1"];
		}
		else
		{
			info.bgImage = [UIImage imageNamed:@"search_bg2"];
		}

		cell.data = info;
	}

	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ( indexPath.row == 0 )
	{
		return 53;
	}

	return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.selectedIndex = indexPath.row;

	if ( self.whenSelected )
	{
		if ( [self.data isKindOfClass:[NSArray class]] )
		{
			NSArray * datas = self.data;
			MENU_INFO * info = [datas safeObjectAtIndex:indexPath.row];
			self.whenSelected(info.title);
		}
	}
}

+ (NSMutableArray *)menuDataWithTitles:(NSArray *)titles image:(NSArray *)images
{
	NSMutableArray * datas = [NSMutableArray array];

	for ( int i = 0 ; i < titles.count; i++ )
	{
		MENU_INFO * menuInfo = [MENU_INFO new];
		menuInfo.title = titles[i];
		menuInfo.image = images[i];
		[datas addObject:menuInfo];
	}

	return datas;
}

#pragma mark -

handleSignal( hideView )
{
	[self close];
}

- (void)showInView:(UIView *)view
{
    self.tableView.x = self.tableViewPoint.x;
    self.tableView.y = self.tableViewPoint.y;
	self.isOpen = YES;

	self.tableView.height = 0;

	[view addSubview:self];

	[UIView animateWithDuration:0.3 animations:^ {
		self.tableView.height = 98;
	}];
}

- (void)close
{
	self.isOpen = NO;
	[self removeFromSuperview];
}

@end
