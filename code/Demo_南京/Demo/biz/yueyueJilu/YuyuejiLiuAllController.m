//
//  HomeViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-20.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "YuyuejiLiuAllController.h"
#import "MBConstant.h"
#import "MBNotLogViewController.h"
#import "AppDelegate.h"
#import "MBUserTransViewController.h"
#import "MBIIRequest.h"
#import "SoapHelper.h"
//#import <GHUnitIOS/GHUnit.h>
#import "XMLParser.h"
#import "MBGlobalUICommon.h"
#import "TiJianReprotCell.h"
#import "TijianReportMoreDetialViewController.h"
#import "TijianReportMoreNotNorDetialViewController.h"
#import "YuyueJiluDetialViewController.h"
#import "YuyueJiluViewController.h"
@interface YuyuejiLiuAllController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *_tableView ;
}
@end

@implementation YuyuejiLiuAllController
-(void)uploadFoodKC
{
    YuyueJiluViewController*chaXue=[[YuyueJiluViewController alloc]init];
    [self.navigationController pushViewController:chaXue animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
   self.title=@"体检记录";
   self.view.backgroundColor= HEX(@"#ffffff");

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
    if (IOS7_OR_LATER) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"查询" style:UIBarButtonItemStyleBordered target:self action:@selector(uploadFoodKC)];
    }else
    {
        UIButton *btnLeft =[UIButton buttonWithType:UIButtonTypeCustom];
        btnLeft.frame=CGRectMake(0, 0, 40, 40);
        [btnLeft setTitle:@"上传" forState:UIControlStateNormal];
        [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnLeft addTarget:self action:@selector(uploadFoodKC) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    }
    

    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, kScreenHeight)];
    view.backgroundColor=[UIColor whiteColor];
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, kContentViewHeight) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=HEX(@"#ffffff");
    [view addSubview:_tableView];
    [self.view addSubview:view];
    
}
//返回到上个页面
-(void)backViewUPloadView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _resultArray.count;
   
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
   //
        cell.itemLbl.text=MBNonEmptyStringNo_([_resultArray[indexPath.row][@"reservationDate"] componentsSeparatedByString:@" "][0]);
    
        cell.itemCountLbl.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        cell.rightLabl.text=[MBNonEmptyStringNo_(_resultArray[indexPath.row][@"nowState"]) isEqualToString:@"1"]?@"未处理":@"已处理";
      cell.rightLabl.frame=CGRectMake(200, cell.rightLabl.frame.origin.y, cell.rightLabl.frame.size.width, cell.rightLabl.frame.size.height);
        [cell hiddleLoadMoreView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    YuyueJiluDetialViewController *deail =[[YuyueJiluDetialViewController alloc]init];
    deail.dicInfoAbout=_resultArray[indexPath.row];
    [self.navigationController pushViewController:deail animated:YES];
    
}
@end
