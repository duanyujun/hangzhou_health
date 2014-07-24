//
//  ViewController.m
//  HeaderViewDemo
//
//  Created by Rannie on 13-9-8.
//  Copyright (c) 2013年 Rannie. All rights reserved.
//

#import "YuyueThrDetailViewControllerLast.h"
#import "HRFriendsCell.h"
#import "HeaderButton.h"
#import "YuyueTeleViewController.h"
#define RTagOffset 10
#define RRowHeight 50.0f
#define RHeaderHeight 45.0f

@interface YuyueThrDetailViewControllerLast ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_groupNames;
    
    NSMutableDictionary *_headers;
}
@end

static NSString * const CellIdentifier = @"FriendCell";
@implementation YuyueThrDetailViewControllerLast

//返回到上个页面
-(void)backViewUPloadView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)rightBtnUpload
{
    YuyueTeleViewController *all =[[YuyueTeleViewController alloc]init];
    all.infoAbout = _sendDataInfo;
    //    all.dataAllArray = arrayOfResult;
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:all];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    //    [self presentViewController:all animated:YES completion:nil];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=HEX(@"#ffffff");
    self.title=@"套餐详情";
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        UIBarButtonItem *leftBarItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backView.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backViewUPloadView)];
        self.navigationItem.leftBarButtonItem=leftBarItem;
    }else
    {
        UIButton *btnLeft =[UIButton buttonWithType:UIButtonTypeCustom];
        btnLeft.frame=CGRectMake(0, 0, 12, 20);
        [btnLeft setBackgroundImage:[UIImage imageNamed:@"backView.png"] forState:UIControlStateNormal];
        [btnLeft addTarget:self action:@selector(backViewUPloadView) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    }
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kContentViewHeight+49) style:UITableViewStylePlain];
    
    NSLog(@"%@",_dataArray[0]);
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    UIButton *btnRight =[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame=CGRectMake(0, 0, 80, 30);
    [btnRight setTitle:@"确认预约" forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"backViewd.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(rightBtnUpload) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRight];

    
    [self loadData];
}

- (void)loadData
{
    _headers = [NSMutableDictionary dictionaryWithCapacity:_dataArray.count];
    
    _groupNames = [NSMutableArray arrayWithCapacity:_dataArray.count];
    for (NSInteger i = 0; i < _dataArray.count; i++)
    {
        NSDictionary *dict = _dataArray[i];
        [_groupNames addObject:dict[@"SortName"]];
    }
}

- (NSArray *)arrayWithSection:(NSInteger)number
{
    NSDictionary *dict = _dataArray[number];
    NSArray *friendsArray = dict[@"ChildItem"];
    NSLog(@"%@",friendsArray);
    return friendsArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _groupNames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HeaderButton *header = _headers[@(section)];
    NSArray *array = [self arrayWithSection:section];
    NSInteger count = header.isOpen?array.count:0;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSArray *array = [self arrayWithSection:indexPath.section];
    [cell bindFriend:array[indexPath.row]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderButton *header = _headers[@(section)];
    if (!header)
    {
        header = [HeaderButton buttonWithType:UIButtonTypeCustom];
        header.bounds = CGRectMake(0, 0, 320, RHeaderHeight);
        header.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.8 alpha:1.0];
        header.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        NSString *title = _groupNames[section];
        [header setTitle:title forState:UIControlStateNormal];
        [header addTarget:self action:@selector(expandFriends:) forControlEvents:UIControlEventTouchUpInside];
        [_headers setObject:header forKey:@(section)];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return RHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RRowHeight;
}

- (void)expandFriends:(HeaderButton *)header
{
    header.open = !header.isOpen;
    [self.tableView reloadData];
}

@end
