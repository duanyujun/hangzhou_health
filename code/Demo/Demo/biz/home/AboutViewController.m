//
//  AboutViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-4-12.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_leftArray ;
    NSArray *_leftImageArray ;
    NSArray *_righArray ;
}
@end

@implementation AboutViewController

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
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    _leftArray =[[NSArray alloc]initWithObjects:@"机构名称",@"联系电话",@"官方微博",@"微信公众账号",@"软件版本", nil];
    _leftImageArray =[[NSArray alloc]initWithObjects:@"setting_yijianfankui.png",@"setting_ruanjianfengxiang.png",@"setting_shiyongbangzhu.png",@"setting_guanyuzhangshangjiankang.png",@"setting_tuisongshezhi.png", nil];
    _righArray =[[NSArray alloc]initWithObjects:@"杭州希禾信息技术有限公司",@"0571-86733215",@"杭州希禾信息技术",@"hzxhxxjs",@"掌上健康1.1.0", nil];
    
    self.title=@"设置";
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
    UITableView*_tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, kContentViewHeight+49-250) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=HEX(@"#ffffff");
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.userInteractionEnabled=NO;
    [self.view addSubview:_tableView];
    
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(40, 190, 80, 80)];
    imageView.image=[UIImage imageNamed:@"hl_weibo.png"];
    [self.view addSubview:imageView];
    UILabel *lableOne =[[UILabel alloc]initWithFrame:CGRectMake(40, 240, 80, 80)];
    lableOne.text=@"官方微博二维码";
    lableOne.textColor=[UIColor blueColor];
    lableOne.adjustsFontSizeToFitWidth=YES;
    lableOne.backgroundColor=[UIColor clearColor];

    [self.view addSubview:lableOne];
    
    
    
    UIImageView *imageViewtwo =[[UIImageView alloc]initWithFrame:CGRectMake(200, 190, 80, 80)];
    imageViewtwo.image=[UIImage imageNamed:@"hl_weixin.jpg"];
    [self.view addSubview:imageViewtwo];
    UILabel *lableTwo =[[UILabel alloc]initWithFrame:CGRectMake(200, 240, 80, 80)];
    lableTwo.adjustsFontSizeToFitWidth=YES;
    lableTwo.textColor=[UIColor blueColor];
    lableTwo.text=@"公众微信二维码";
    lableTwo.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lableTwo];
    
    UILabel *lableTwo1 =[[UILabel alloc]initWithFrame:CGRectMake(0, 275, 320, 80)];
    lableTwo1.textColor=[UIColor grayColor];
    lableTwo1.text=@"杭州希禾信息技术有限公司  版权所有";
    lableTwo1.textAlignment=NSTextAlignmentCenter;
    lableTwo1.font=kSmallTitleFont;
    lableTwo1.backgroundColor=[UIColor clearColor];

    [self.view addSubview:lableTwo1];
    
    UILabel *lableTwo2 =[[UILabel alloc]initWithFrame:CGRectMake(0, 295, 320, 80)];
    lableTwo2.textColor=[UIColor grayColor];
    lableTwo2.text=@"Copyright 2012-2014 Seehealth.";
    lableTwo2.textAlignment=NSTextAlignmentCenter;
    lableTwo2.font=kSmallTitleFont;
    lableTwo2.backgroundColor=[UIColor clearColor];

    [self.view addSubview:lableTwo2];
    
    UILabel *lableTwo3 =[[UILabel alloc]initWithFrame:CGRectMake(0, 315, 320, 80)];
    lableTwo3.textColor=[UIColor grayColor];
    lableTwo3.text=@"All Rights Reserved.";
    lableTwo3.textAlignment=NSTextAlignmentCenter;
    lableTwo3.font=kSmallTitleFont;
    lableTwo3.backgroundColor=[UIColor clearColor];

    [self.view addSubview:lableTwo3];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr =@"allFoodType";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        UIImageView *labelView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 20, 20)];
        labelView.tag=10001;
        [cell addSubview:labelView];
        
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(150, 0, 160, 30)];
        label.textAlignment=NSTextAlignmentRight;
        label.tag=1000;
        label.font=[UIFont fontWithName:@"Helvetica Neue" size:13];
        [cell addSubview:label];
        
        UILabel *labelleft =[[UILabel alloc]initWithFrame:CGRectMake(35, 0, 120, 30)];
        labelleft.textAlignment=NSTextAlignmentLeft;
        labelleft.tag=1100;
        labelleft.font=[UIFont fontWithName:@"Helvetica Neue" size:13];
        [cell addSubview:labelleft];
    }
    UIImageView *labelView =(UIImageView*)[cell viewWithTag:10001];
    labelView.image=[UIImage imageNamed:_leftImageArray[indexPath.row]];

    UILabel *labelLeft =(UILabel*)[cell viewWithTag:1100];
    labelLeft.text=_leftArray[indexPath.row];
    UILabel *label =(UILabel*)[cell viewWithTag:1000];
    label.text=_righArray[indexPath.row];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
@end
