//
//  YuyueDetailViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-29.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "YuyueThrDetailViewController.h"
#import "RATreeView.h"
#import "RADataObject.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface YuyueThrDetailViewController ()<RATreeViewDataSource,RATreeViewDelegate>
{
    NSMutableArray *_dataArrayTree;

}
@end

@implementation YuyueThrDetailViewController



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
    
    NSLog(@"%@",_dataArray);
    NSMutableArray *allData =[NSMutableArray arrayWithCapacity:2];
    for (int i=0; i<_dataArray.count; i++) {
        NSMutableArray *oneArray =[NSMutableArray arrayWithCapacity:2];
        NSDictionary*dicON=_dataArray[i];
        NSArray *dicONallKey=[dicON allKeys];
        NSMutableArray *keyArray=[NSMutableArray arrayWithCapacity:2];
        for (int j=0; j<dicONallKey.count; j++) {
            if ([MBNonEmptyStringNo_(dicONallKey[j]) rangeOfString:@"itemName"].length>0) {
                [keyArray addObject:MBNonEmptyStringNo_(dicONallKey[j])];
            }
        }
        NSLog(@"11111======%@",keyArray);
        
        for (int j=0; j<[keyArray count]; j++) {
            RADataObject *phone1 = [RADataObject dataObjectWithName:_dataArray[i][keyArray[j]] children:nil];
            if (i==0&&j==0) {
                self.expanded=phone1;
            }
            [oneArray addObject:phone1];
        }
        RADataObject *phone = [RADataObject dataObjectWithName:_dataArray[i][@"departmentsName"] children:oneArray];
        [allData addObject:phone];
    }
    _dataArrayTree=[[NSMutableArray alloc]initWithArray:allData];
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0, 0, 320, kContentViewHeight+49)];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    
    [treeView reloadData];
    [self.view addSubview:treeView];

}

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 47;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 2 * treeNodeInfo.treeDepthLevel;
}

- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return YES;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    if ([item isEqual:self.expanded]) {
        return YES;
    }
    return NO;
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
    } else if (treeNodeInfo.treeDepthLevel == 1) {
        cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
    }
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    //    NSInteger numberOfChildren = [treeNodeInfo.children count];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.textLabel.text = ((RADataObject *)item).name;
    cell.textLabel.font=kNormalTextFont;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.detailTextLabel.textColor = [UIColor clearColor];
        cell.textLabel.font=[UIFont boldSystemFontOfSize:15];
        
    }
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [_dataArrayTree count];
    }
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [_dataArrayTree objectAtIndex:index];
    }
    return [data.children objectAtIndex:index];
}

//返回到上个页面
-(void)backViewUPloadView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
