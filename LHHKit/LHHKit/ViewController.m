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

#import "ViewController.h"
#import "Model.h"
#import "TestView.h"
#import "WebViewController.h"
@interface ViewController ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) Model *model;
@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [Model update];
    [self setupUI];
}

- (void)setupUI
{
    self.navigationItem.title = @"LHHKit";
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
    self.currentPage = 1;
    [self setupViews];
}

- (void)setupViews
{
    TestView * testView = [[TestView alloc] initWithFrame:CGRectMake(0, NavibarHeight, [UIScreen mainScreen].bounds.size.width, 100)];
    testView.backgroundColor = [UIColor redColor];
    [self.view addSubview:testView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, testView.bottom, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - testView.bottom - TabbarBottomOffset) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F3F5F9"];
    if (@available(iOS 11.0, *))
    {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:self.tableView];
    [self setupRefreshHeaderView];
    [self.tableView.header beginRefreshing];
}

- (void)setupRefreshHeaderView
{
    @weakify(self);
    [self.tableView addLegendHeaderWithRefreshingBlock:^ {
        @strongify( self );
        [self reloadForFisrtPage:YES];
        
    }];
}

- (void)setupRefreshFooterView
{
    if ( self.tableView.footer == nil )
    {
        @weakify(self);
        [self.tableView addLegendFooterWithRefreshingBlock:^ {
            @strongify( self );
            [self reloadForFisrtPage:NO];
        }];
    }
}

- (void)reloadForFisrtPage:(BOOL)isFirstPage
{
    if ( isFirstPage )
    {
        self.currentPage = 1;
    }

    [self.tableView.header endRefreshing];
    if ( isFirstPage )
    {
        self.currentPage = 1;
        [self.dataArray removeAllObjects];
    }
    self.currentPage += 1;
    
    [self setupRefreshFooterView];
    if (self.currentPage < 5)
    {
        for (NSInteger index = 0; index < 10; index++)
        {
            [self.dataArray addObject:@(index)];
        }
        [self.tableView.footer endRefreshing];
    }
    else
    {
        [self.tableView.footer noticeNoMoreData];
    }
    [self.tableView reloadData];
    

    
}

#pragma mark - <UITableViewDelegate , UITableViewDataSource>代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}


handleSignal(test)
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"我是Signal" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        WebViewController * webViewController = [[WebViewController alloc] init];
        webViewController.titleString = @"LHHKit";
        webViewController.urlString = @"http://www.jianshu.com/u/3c6ff28fdc63";
        [self.navigationController pushViewController:webViewController animated:YES];
    }];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:NULL];
    
    
    NSLog(@"ViewController");
}


@end
