//
//  NewsItemViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-4-20.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "NewsItemViewController.h"
#import "RATreeView.h"
#import "RADataObject.h"
#import "NewsAllViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface NewsItemViewController ()<RATreeViewDataSource,RATreeViewDelegate>
{
    NSMutableArray *_dataArray;
}
@property (strong, nonatomic) id expanded;

@end

@implementation NewsItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//返回到上个页面
-(void)backViewUPloadView
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    self.title=@"资讯";
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
    
    self.view.backgroundColor=HEX(@"#ffffff");
    NSArray *allkey=[_allDataInfo allKeys];
    NSMutableArray *allData =[NSMutableArray arrayWithCapacity:2];
    for (int i=0; i<allkey.count; i++) {
        NSMutableArray *oneArray =[NSMutableArray arrayWithCapacity:2];
        
        for (int j=0; j<[_allDataInfo[allkey[i]] count]; j++) {
            RADataObject *phone1 = [RADataObject dataObjectWithName:_allDataInfo[allkey[i]][j][@"typeName"] children:nil];
            if (i==0&&j==0) {
                self.expanded=phone1;
            }
            [oneArray addObject:phone1];

        }
        RADataObject *phone = [RADataObject dataObjectWithName:allkey[i] children:oneArray];

        [allData addObject:phone];

    }
    _dataArray=[[NSMutableArray alloc]initWithArray:allData];
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
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"Number of children %d", numberOfChildren];
    cell.textLabel.text = ((RADataObject *)item).name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [_dataArray count];
    }
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [_dataArray objectAtIndex:index];
    }
    return [data.children objectAtIndex:index];
}
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    NSLog(@"%@",_dataArray);
    NSLog(@"%@",_allDataInfo);

    NSLog(@"%@",treeNodeInfo.children);
    NSLog(@"%@",[(RADataObject*)treeNodeInfo.item name]);
    if (treeNodeInfo.children.count==0) {
        
        NSString *name =[(RADataObject*)treeNodeInfo.item name];
        NSDictionary *itemInfoDic=nil;
        
        NSArray *allkey=[_allDataInfo allKeys];
        for (int i=0; i<allkey.count; i++) {
            
            for (int j=0; j<[_allDataInfo[allkey[i]] count]; j++) {
                if([name isEqualToString:_allDataInfo[allkey[i]][j][@"typeName"]])
                {
                    itemInfoDic =_allDataInfo[allkey[i]][j];
                    break;
                }
            }

            
        }
        
        NSLog(@"%@",itemInfoDic);
        NewsAllViewController *news=[[NewsAllViewController alloc]init];
        news.typeID=MBNonEmptyStringNo_(itemInfoDic[@"articleID"]);
        news.title=MBNonEmptyStringNo_(itemInfoDic[@"typeName"]);
        [self.navigationController pushViewController:news animated:YES];
        

    }

}


@end
