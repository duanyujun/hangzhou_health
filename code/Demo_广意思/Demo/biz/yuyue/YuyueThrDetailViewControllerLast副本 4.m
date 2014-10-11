//
//  ViewController.m
//  SKSTableView
//
//  Created by Sakkaras on 26/12/13.
//  Copyright (c) 2013 Sakkaras. All rights reserved.
//

#import "YuyueThrDetailViewControllerLast.h"
#import "YuyueTeleViewController.h"
#import "YuYueDtailTableViewCell.h"
#import "MBSelectView.h"
#import "LeveyPopListView.h"
@interface YuyueThrDetailViewControllerLast ()<YuYueDtailTableViewCellDelegate,LeveyPopListViewDelegate>
{
    NSMutableArray *_showDataArray;
    NSMutableArray *_originDataArray;
    NSArray *_tempStoreDate;
    UILabel *_showEfloLabel;
}

@end

@implementation YuyueThrDetailViewControllerLast

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
-(void)rightBtnUpload
{
    YuyueTeleViewController *all =[[YuyueTeleViewController alloc]init];
    all.infoAbout = _sendDataInfo;
    all.priceStr = _priceStr;
    all.dataAllArray = _dataArray;
    //    all.dataAllArray = arrayOfResult;
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:all];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    //    [self presentViewController:all animated:YES completion:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=HEX(@"#ffffff");
    
    _originDataArray = [[NSMutableArray alloc]initWithArray:_dataArray];
    
    _showEfloLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    _showEfloLabel.font = kNormalTextFont;
    _showEfloLabel.textAlignment = UITextAlignmentCenter;
    _showEfloLabel.text = [NSString stringWithFormat:@"%@      ￥%@",_nameStr,_priceStr];
    [self.view addSubview:_showEfloLabel];
    
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
    _showDataArray = [[NSMutableArray alloc]initWithCapacity:2];
    for (int i=0; i<_dataArray.count; i++) {
        if (i==0) {
            [_showDataArray addObject:@"YES"];
        }else
        {
            [_showDataArray addObject:@"NO"];
        }
    }
    
    NSLog(@"%@",_showDataArray);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, kContentViewHeight+9) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    UIButton *btnRight =[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame=CGRectMake(0, 0, 80, 30);
    [btnRight setTitle:@"确认预约" forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"backViewd.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(rightBtnUpload) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRight];

    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arrayOfONet=_dataArray[section][@"ChildItem"];
    NSString *showItem = _showDataArray[section];
    
    if ([showItem isEqualToString:@"YES"]) {
        
        return arrayOfONet.count;

    }else
    {
        return 0;

    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"5.png"]];
    
    UILabel *lbael = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 300, 40)];
    lbael.text = _dataArray[section][@"SortName"];
    lbael.font=kNormalTextFont;
    lbael.textColor =[UIColor whiteColor];
    [view addSubview:lbael];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame= view.frame;
    [view addSubview:btn];
    btn.tag = section;
    [btn addTarget:self action:@selector(btnShowRow:) forControlEvents:UIControlEventTouchUpInside];
    return view;
    
}
-(void)btnShowRow:(UIButton *)btn
{
    NSString *showItem = _showDataArray[btn.tag];
    NSLog(@"2222======%@,3333333====%d",showItem,btn.tag);
    if ([showItem isEqualToString:@"YES"]) {
        
        [_showDataArray replaceObjectAtIndex:btn.tag withObject:@"NO"];
        
    }else
    {
        [_showDataArray replaceObjectAtIndex:btn.tag withObject:@"YES"];
        
    }
    [_tableView reloadData];

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellStr = @"YuYueDtailTableViewCell";
    YuYueDtailTableViewCell *cell  = (YuYueDtailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"YuYueDtailTableViewCell" owner:self options:nil]lastObject];
        cell.isSelectAbout = NO;
        cell.delegateAbout = self;
    }
    
    NSArray *itemArray =_dataArray[indexPath.section][@"ChildItem"];
    NSArray *teimOne = itemArray[indexPath.row];
    if (teimOne.count>1) {
        cell.showMoreITem.hidden=NO;
    }else
    {
        cell.showMoreITem.hidden=YES;
    }
    NSDictionary *infoDic = teimOne[0];
    cell.infoDic = infoDic;
    cell.nameLabel.text = MBNonEmptyString(infoDic[@"TJ_Name"]);
    cell.priceLabel.text = MBNonEmptyString(infoDic[@"TJ_Price"]);
    cell.TJ_Code = MBNonEmptyStringNo_(infoDic[@"TJ_Code"]);
    
    if ([MBNonEmptyString(infoDic[@"Is_Check"]) isEqualToString:@"1"]) {
        if ([MBNonEmptyStringNo_(infoDic[@"Is_Cancel"]) isEqualToString:@"1"]) {
            
            for (int i=0; i<_originDataArray.count; i++) {
                
                NSMutableArray *itemArray =[NSMutableArray arrayWithArray:_originDataArray[i][@"ChildItem"]];
                for (int j=0; j<itemArray.count; j++) {
                    NSMutableArray *teiONeArray = [NSMutableArray arrayWithArray:itemArray[j]];
                    for (int k=0; k<teiONeArray.count; k++) {
                        
                        NSMutableDictionary *teimOne = [NSMutableDictionary dictionaryWithDictionary:teiONeArray[k]];
                        
                        if ([cell.TJ_Code isEqualToString:MBNonEmptyStringNo_(teimOne[@"TJ_Code"])]) {
                           
                            if ([MBNonEmptyStringNo_(teimOne[@"Is_Check"]) isEqualToString:@"2"]) {
                                
                                [cell.selectBtn setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
                                
                            }else
                            {
                                [cell.selectBtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];

                            }
                        }
                        
                    }
                }
                
                
            }

            
            
        }else{
            [cell.selectBtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
        }
    }else
    {
        [cell.selectBtn setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
        
    }
    return cell;

}
-(void)seleThisCell:(YuYueDtailTableViewCell *)cell
{
    cell.isSelectAbout = !cell.isSelectAbout;
    NSString *Is_Check = MBNonEmptyString(cell.infoDic[@"Is_Check"]);
    NSString *Is_Cancel = MBNonEmptyString(cell.infoDic[@"Is_Cancel"]);
    
    BOOL isSeleck=NO;
    if ([Is_Check isEqualToString:@"1"]) {
        
        if ([Is_Cancel isEqualToString:@"1"]) {
            MBAlert(@"此项目是必须项目，不可取消");
            isSeleck=YES;
            [cell.selectBtn setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
        }else
        {
            if (cell.isSelectAbout) {
                isSeleck=YES;

                [cell.selectBtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
            }else
            {
                [cell.selectBtn setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
                isSeleck=NO;

                
                
            }
        }
    }else
    {
        if (cell.isSelectAbout) {
            [cell.selectBtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
            isSeleck=YES;

        }else
        {
            [cell.selectBtn setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
            isSeleck=NO;

            
        }
    }
    
    
    for (int i=0; i<_dataArray.count; i++) {
        
        NSMutableArray *itemArray =[NSMutableArray arrayWithArray:_dataArray[i][@"ChildItem"]];
        NSString *SortName= MBNonEmptyStringNo_(_dataArray[i][@"SortName"]);
        for (int j=0; j<itemArray.count; j++) {
            NSMutableArray *teiONeArray = [NSMutableArray arrayWithArray:itemArray[j]];
            for (int k=0; k<1; k++) {
                
                NSMutableDictionary *teimOne = [NSMutableDictionary dictionaryWithDictionary:teiONeArray[k]];
                
                if ([cell.TJ_Code isEqualToString:MBNonEmptyStringNo_(teimOne[@"TJ_Code"])]) {
                    if (isSeleck==YES) {
                        
                        [teimOne setValue:@"1" forKey:@"Is_Check"];
                    }else
                    {
                        [teimOne setValue:@"2" forKey:@"Is_Check"];
                    }
                }
                [teiONeArray replaceObjectAtIndex:k withObject:teimOne];

            }
            [itemArray replaceObjectAtIndex:j withObject:teiONeArray];
        }
        
        [_dataArray replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithObjectsAndKeys:itemArray, @"ChildItem",SortName,@"SortName", nil]];
        
    }
    
    NSInteger sumAllMoney=0;
    for (int i=0; i<_dataArray.count; i++) {
        
        NSMutableArray *itemArray =[NSMutableArray arrayWithArray:_dataArray[i][@"ChildItem"]];

        for (int j=0; j<itemArray.count; j++) {
            NSMutableArray *teiONeArray = [NSMutableArray arrayWithArray:itemArray[j]];
            for (int k=0; k<teiONeArray.count; k++) {
                
                NSMutableDictionary *teimOne = [NSMutableDictionary dictionaryWithDictionary:teiONeArray[k]];
                
                if ([MBNonEmptyStringNo_(teimOne[@"Is_Check"]) isEqualToString:@"1"]) {
                    
                    sumAllMoney+= [MBNonEmptyStringNo_(teimOne[@"TJ_Price"]) integerValue];
  
                }
                
            }
        }
        
    }
    _priceStr = [NSString stringWithFormat:@"%d",sumAllMoney];
    _showEfloLabel.text = [NSString stringWithFormat:@"%@      ￥%d",_nameStr,sumAllMoney];

    
    
 
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *itemArray =_dataArray[indexPath.section][@"ChildItem"];
    NSArray *teimOne = itemArray[indexPath.row];
    if (teimOne.count>1) {
        NSMutableArray *arrayOf = [NSMutableArray arrayWithCapacity:2];
        for (int i=0; i<teimOne.count; i++) {
            NSDictionary *oneIteInfo = teimOne[i];
            [arrayOf addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@  ￥%@",MBNonEmptyStringNo_(oneIteInfo[@"TJ_Name"]),MBNonEmptyStringNo_(oneIteInfo[@"TJ_Price"])],@"text", nil]];
            
        }
        LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:@"请选择套餐" options:arrayOf];
        lplv.delegate = self;
        _tempStoreDate = teimOne;
        [lplv showInView:self.view animated:YES];
    }
}
#pragma mark - LeveyPopListView delegates
- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    NSLog(@"%@",_tempStoreDate[anIndex]);
    
    NSDictionary *selectItemInfo = _tempStoreDate[anIndex];
    
    for (int i=0; i<_dataArray.count; i++) {
        
        NSMutableArray *itemArray =[NSMutableArray arrayWithArray:_dataArray[i][@"ChildItem"]];
        NSString *SortName= MBNonEmptyStringNo_(_dataArray[i][@"SortName"]);
        for (int j=0; j<itemArray.count; j++) {
            NSMutableArray *teiONeArray = [NSMutableArray arrayWithArray:itemArray[j]];
            for (int k=0; k<teiONeArray.count; k++) {
                
                NSMutableDictionary *teimOne = [NSMutableDictionary dictionaryWithDictionary:teiONeArray[k]];
                
                
                if ([selectItemInfo[@"TJ_Code"] isEqualToString:MBNonEmptyStringNo_(teimOne[@"TJ_Code"])]) {
                   
                    [teimOne setValue:@"2" forKey:@"Is_Check"];
                    NSMutableDictionary *teimOneOnly = [NSMutableDictionary dictionaryWithDictionary:teiONeArray[0]];
                    [teimOneOnly setValue:@"2" forKey:@"Is_Check"];

                    [teiONeArray replaceObjectAtIndex:k withObject:teimOne];
                    [teiONeArray replaceObjectAtIndex:0 withObject:teimOneOnly];

                    [teiONeArray exchangeObjectAtIndex:0 withObjectAtIndex:k];

                }
                
            }
            [itemArray replaceObjectAtIndex:j withObject:teiONeArray];
        }
        
        [_dataArray replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithObjectsAndKeys:itemArray, @"ChildItem",SortName,@"SortName", nil]];
        
    }
    
    
    [_tableView reloadData];

}
-(void)leveyPopListViewDidCancel{
    
}


@end
