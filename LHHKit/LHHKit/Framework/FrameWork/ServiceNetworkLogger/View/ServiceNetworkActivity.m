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

#import "ServiceNetworkActivity.h"
#import "ServiceNetwork.h"
#import "ServiceNetworkWindow.h"

@interface ServiceNetworkActivity ()
@end

@implementation ServiceNetworkActivity

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(setNeedsUpdateData)
												 name:ServiceNetworkLogDidChangeNotification
											   object:nil];
}

- (IBAction)done:(id)sender
{
	[[ServiceNetwork sharedServiceNetwork] hide];
}

- (IBAction)refresh:(id)sender
{
	[self setNeedsUpdateData];
}

- (void)setNeedsUpdateData
{
	[self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self setNeedsUpdateData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ServiceNetwork sharedServiceNetwork].logs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceNetworkActivityCell" forIndexPath:indexPath];
	cell.data = [ServiceNetwork sharedServiceNetwork].logs[indexPath.row];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
	UIViewController * vc = [segue destinationViewController];
	vc.data = sender.data;
}

@end
