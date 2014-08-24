//
//  YuyueDetailViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-29.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "YuyueThrDetailViewControllerLast.h"
#import "TiJianReprotCell.h"
#import "YuYueDtailTableViewCell.h"
#import "YuyueTeleViewController.h"
@interface YuyueThrDetailViewControllerLast ()<UITableViewDataSource,UITableViewDelegate,YuYueDtailTableViewCellDelegate>

@end

@implementation YuyueThrDetailViewControllerLast



- (void)viewDidLoad
{
    [super viewDidLoad];
    _newAddDic = [[NSMutableArray alloc]initWithCapacity:2];
    
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
    
   
    UITableView *treeView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kContentViewHeight+49) style:UITableViewStylePlain];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    [self.view addSubview:treeView];

    
    UIButton *btnRight =[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame=CGRectMake(0, 0, 80, 30);
    [btnRight setTitle:@"确认预约" forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"backViewd.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(rightBtnUpload) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    
    NSLog(@"%@",_dataArray);
    _goupidArray =[NSMutableArray arrayWithCapacity:2];
    [_goupidArray addObject:_dataArray[0]];
    for (int i=0; i<_dataArray.count; i++) {
        NSDictionary *dicOFI = _dataArray[i];
        BOOL isHave = NO;
        for (int j=0; j<_goupidArray.count; j++) {
            NSDictionary *dicOFJ = _goupidArray[j];
            
            if ([MBNonEmptyStringNo_(dicOFI[@"TJ_GroupID"]) isEqualToString:MBNonEmptyStringNo_(dicOFJ[@"TJ_GroupID"])]) {
                isHave = YES;
            }
            
        }
        if (!isHave) {
            [_goupidArray addObject:dicOFI];

        }
        
    }
    NSLog(@"%@",_goupidArray);
    NSLog(@"%@",_dataArray);
    
    
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else{
        return _goupidArray.count;
    }
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return nil;
    }else
    {
        return @"其他项目";
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellStr = @"TiJianReprotCell";
        TiJianReprotCell *cell  = (TiJianReprotCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell = [[TiJianReprotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.yuyueBtn.hidden=YES;
        cell.rightLabl.text=[NSString stringWithFormat:@"￥%@",MBNonEmptyStringNo_(_priceStr)];
        cell.itemLbl.text=MBNonEmptyStringNo_(_nameStr);
        return cell;

    }else{
    
        static NSString *cellStr = @"YuYueDtailTableViewCell";
        YuYueDtailTableViewCell *cell  = (YuYueDtailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"YuYueDtailTableViewCell" owner:self options:nil]lastObject];
            cell.isSelectAbout = NO;
            cell.delegateAbout = self;
        }
        NSDictionary *infoDic = _goupidArray[indexPath.row];
        cell.infoDic = infoDic;
        cell.nameLabel.text = MBNonEmptyString(infoDic[@"TJ_Name"]);
        cell.priceLabel.text = MBNonEmptyString(infoDic[@"TJ_Price"]);
        
        if ([MBNonEmptyString(infoDic[@"Is_Check"]) isEqualToString:@"1"]) {
            if ([MBNonEmptyStringNo_(infoDic[@"Is_Cancel"]) isEqualToString:@"1"]) {
                [cell.selectBtn setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
                cell.selectBtn.userInteractionEnabled=NO;
                
            }else{
            [cell.selectBtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
            }
        }else
        {
            cell.selectBtn.userInteractionEnabled=YES;
            [cell.selectBtn setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
            
        }
        return cell;
    }

}
-(void)seleThisCell:(YuYueDtailTableViewCell *)cell
{
    cell.isSelectAbout = !cell.isSelectAbout;
    NSString *Is_Check = MBNonEmptyString(cell.infoDic[@"Is_Check"]);
    NSString *Is_Cancel = MBNonEmptyString(cell.infoDic[@"Is_Cancel"]);

    if ([Is_Check isEqualToString:@"1"]) {
        
        if ([Is_Cancel isEqualToString:@"1"]) {
            MBAlert(@"此项目是必须项目，不可取消");
            [cell.selectBtn setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
        }else
        {
            if (cell.isSelectAbout) {
                [cell.selectBtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
            }else
            {
                [cell.selectBtn setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
                
                
            }
        }
    }else
    {
        if (cell.isSelectAbout) {
            [cell.selectBtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
        }else
        {
            [cell.selectBtn setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];

        }
    }
    
    
}
//返回到上个页面
-(void)backViewUPloadView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *showInfoArray = [NSMutableArray arrayWithCapacity:2];
    
    for (int i=0; i<_goupidArray.count; i++) {
        
        NSDictionary *dicInfoI = _goupidArray[i];
        
        for (int j=0; j<_dataArray.count; j++) {
            
            NSDictionary *dicInfoJ = _dataArray[j];
            
            if ([MBNonEmptyStringNo_(dicInfoI[@"TJ_GroupID"]) isEqualToString:MBNonEmptyStringNo_(dicInfoJ[@"TJ_GroupID"])]) {
                
                [showInfoArray addObject:dicInfoJ];
            }
        }
    }
    NSLog(@"%@",showInfoArray);
    NSLog(@"%@",_dataArray);
    
}

@end
