//
//  HomeViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-20.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "TijianReportAllViewController.h"
#import "MBConstant.h"
#import "MBNotLogViewController.h"
#import "AppDelegate.h"
#import "MBUserTransViewController.h"
#import "MBIIRequest.h"
#import "SoapHelper.h"
#import <GHUnitIOS/GHUnit.h>
#import "XMLParser.h"
#import "MBGlobalUICommon.h"
#import "TiJianReprotCell.h"
#import "TijianReportMoreDetialViewController.h"
#import "TijianReportMoreNotNorDetialViewController.h"
@interface TijianReportAllViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *_tableView ;
}
@end

@implementation TijianReportAllViewController
//返回到上个页面
-(void)backViewUPloadView
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
    
   self.title=@"体检报告";
   self.view.backgroundColor= HEX(@"#ffffff");

    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, kContentViewHeight+49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=HEX(@"#ffffff");
    [self.view addSubview:_tableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _itemArray.count;
   
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellStr =@"_isShowMore";
    TiJianReprotCell *cell =[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[TiJianReprotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        UIImageView *mg_liebia=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_liebiao_arrow.png"]];
        mg_liebia.frame = CGRectMake(290, 14, 12, 12);
        [cell addSubview:mg_liebia];
        
    }
        if (indexPath.row%5==0) {
            cell.bgView.image=[UIImage imageNamed:@"one.png"];
        } if (indexPath.row%5==1) {
            cell.bgView.image=[UIImage imageNamed:@"two.png"];
        } if (indexPath.row%5==2) {
            cell.bgView.image=[UIImage imageNamed:@"three.png"];
        } if (indexPath.row%5==3) {
            cell.bgView.image=[UIImage imageNamed:@"four.png"];
        } if (indexPath.row%5==4) {
            cell.bgView.image=[UIImage imageNamed:@"five.png"];
        }
   
        cell.itemLbl.text=MBNonEmptyStringNo_(_itemArray[indexPath.row]);

        cell.itemCountLbl.text = [NSString stringWithFormat:@"%d",indexPath.row+1];

        [cell hiddleLoadMoreView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *name =_itemArray[indexPath.row];
    BOOL isNoro=NO;
    NSInteger index=-1;
    for (int i=0; i<_resultArray.count; i++) {
        if ([name isEqualToString:_resultArray[i][@"departMentName"] ]) {
            index=i;
            isNoro=YES;
        }
    }
    NSInteger notNorINdex=-1;
    NSArray *notNorArray =_healthAbnoramlsDic[@"abnoraml"];
    for (int i=0; i<notNorArray.count; i++) {
        if ([name isEqualToString:notNorArray[i][@"abnoramlName"] ]) {
            notNorINdex=i;
            isNoro=NO;
        }
    }
    if (isNoro) {
        TijianReportMoreDetialViewController *help=[[TijianReportMoreDetialViewController alloc]init];
        help.resultDic=_resultArray[index];
        [self.navigationController pushViewController:help animated:YES];
    }else
    {
        TijianReportMoreNotNorDetialViewController *help=[[TijianReportMoreNotNorDetialViewController alloc]init];
        help.resultDic=notNorArray[notNorINdex];
        [self.navigationController pushViewController:help animated:YES];

    }
   
}
@end
