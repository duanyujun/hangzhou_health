//
//  TijianReportMoreDetialViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-23.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "TijianReportMoreDetialViewController.h"
#import "TiJianDetailReprotCell.h"
@interface TijianReportMoreDetialViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation TijianReportMoreDetialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title=@"体检报告";
    UITableView*tableVewi =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, kContentViewHeight+49) style:UITableViewStylePlain];
    tableVewi.delegate=self;
    tableVewi.dataSource=self;
    [self.view addSubview:tableVewi];
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
}
-(void)backViewUPloadView
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_resultDic[@"items"][@"item"] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr =@"TiJianDetailReprotCell";
    TiJianDetailReprotCell *cell =[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[TiJianDetailReprotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    
    if ([_resultDic[@"items"][@"item"] isKindOfClass:[NSArray class]]) {
        
        cell.itemLbl.text=MBNonEmptyStringNo_(_resultDic[@"items"][@"item"][indexPath.row][@"itemName"]);
        cell.itemCountLbl.text=[NSString stringWithFormat:@"%0.2f%@",[MBNonEmptyStringNo_(_resultDic[@"items"][@"item"][indexPath.row][@"itemValue"]) floatValue],MBNonEmptyStringNo_(_resultDic[@"items"][@"item"][indexPath.row][@"unit"])];
    }else
    {
        cell.itemLbl.text=MBNonEmptyStringNo_(_resultDic[@"items"][@"item"][@"itemName"]);
        cell.itemCountLbl.text=[NSString stringWithFormat:@"%0.2f%@",[MBNonEmptyStringNo_(_resultDic[@"items"][@"item"][@"itemValue"]) floatValue],MBNonEmptyStringNo_(_resultDic[@"items"][@"item"][@"unit"])];
    }
  

 
    
    return cell;

    
}


@end
