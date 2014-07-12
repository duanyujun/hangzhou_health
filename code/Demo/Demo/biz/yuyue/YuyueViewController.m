//
//  HomeViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-20.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "YuyueViewController.h"
#import "MBConstant.h"
#import "MBNotLogViewController.h"
#import "AppDelegate.h"
#import "MBUserTransViewController.h"
#import "MBIIRequest.h"
#import "SoapHelper.h"
//#import <GHUnitIOS/GHUnit.h>
#import "ShengTableViewController.h"
#import "XMLParser.h"
#import "MBGlobalUICommon.h"
#import "TiJianReprotCell.h"
#import "TijianReportAllViewController.h"
#import "YuyueThrDetailViewController.h"
#import "YuyueTeleViewController.h"
@interface YuyueViewController ()<UITableViewDelegate,UITableViewDataSource,TijianReproTcellDelegate>
{
    NSInteger _startIndex;
    NSMutableArray *_dataArray;
    UITableView *_tableView ;
    BOOL _isShowMore;//yes ==加载更多
    NSInteger _seleIndex;
}
@end

@implementation YuyueViewController
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
    _dataArray =[[NSMutableArray alloc]init];
    _startIndex =0;
    _isShowMore=NO;
    [self makeViewAboutDownLoadView];
    self.title=@"体检预约";
   self.view.backgroundColor= HEX(@"#5ec4fe");

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
-(void)getUserData
{

    NSMutableArray *arr=[NSMutableArray array];

    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",_startIndex],@"startIndex", nil]];

    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",_startIndex+100000000],@"endIndex", nil]];

    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetRecordTemplateList"];
    
    __block YuyueViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetRecordTemplateList" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        XMLParser *xmlParser = [[XMLParser alloc] init];
        
        [xmlParser parseData:JSON
                     success:^(id parsedData) {
                         
                         NSDictionary *send=(NSDictionary *)parsedData;
                         [blockSelf getUserDataSuccess:send];
                     }
                     failure:^(NSError *error) {
                         
                     }];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];

}

-(void)getUserDataSuccess:(NSDictionary *)dataDic
{
    NSArray *array = dataDic[@"soap:Envelope"][@"soap:Body"][@"GetRecordTemplateListResponse"][@"GetRecordTemplateListResult"][@"data"][@"stylesArray"];
    NSMutableArray *reseDataArray =[NSMutableArray arrayWithCapacity:2];
    if ([array isKindOfClass:[NSArray class]]) {
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic =array[i];
            if (!dic[@"isOrNo"]) {
                [reseDataArray addObject:dic];
            }
        }
    }
    if (reseDataArray.count==0) {
        _isShowMore=NO;
    }else
    {
        [_dataArray addObjectsFromArray:reseDataArray];
        _isShowMore=NO;
    }
    [_tableView reloadData];
}


-(void)makeViewAboutDownLoadView
{
    UIView *viewBG =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, kScreenHeight)];
    viewBG.backgroundColor=HEX(@"#ffffff");
    [self.view addSubview:viewBG];
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, kContentViewHeight) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [viewBG addSubview:_tableView];
    
    
}
-(void)goToSeleShengFeng
{
    ShengTableViewController *sheng=[[ShengTableViewController alloc]init];
    sheng.isFromKuai=YES;
    [self.navigationController pushViewController:sheng animated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isShowMore) {
        return _dataArray.count+1;
    }else
    {
        return _dataArray.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellStr =@"_isShowMore";
    TiJianReprotCell *cell =[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[TiJianReprotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        cell.delegateAbout=self;
        UILabel *loadMore=[[UILabel alloc]initWithFrame:cell.frame];
        loadMore.text=@"加载更多";
        loadMore.textAlignment=UITextAlignmentCenter;
        loadMore.tag=100000;
        loadMore.backgroundColor=[UIColor clearColor];
        [cell addSubview:loadMore];
    }
    UILabel *loadMore=(UILabel*)[cell viewWithTag:100000];
    if (indexPath.row==_dataArray.count) {
        loadMore.hidden=NO;
    }else
    {
        loadMore.hidden=YES;
    }
    
    if (indexPath.row==_dataArray.count) {
        [cell showLoadMoreVIew];
    }else
    {
       
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
        
        cell.itemLbl.text=MBNonEmptyStringNo_(_dataArray[indexPath.row][@"templateName"][@"content"]);

        cell.itemCountLbl.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        cell.yuyueBtn.hidden=NO;
        cell.rightLabl.text=[NSString stringWithFormat:@"￥%@",MBNonEmptyStringNo_(_dataArray[indexPath.row][@"price"][@"content"])];
        cell.yuyueBtn.tag=indexPath.row;
        if (_seleIndex==indexPath.row) {
            [cell.yuyueBtn setBackgroundImage:[UIImage imageNamed:@"youy_yes.png"] forState:UIControlStateNormal];
        }else {
            [cell.yuyueBtn setBackgroundImage:[UIImage imageNamed:@"gouy_no.png"] forState:UIControlStateNormal];

        }
        [cell hiddleLoadMoreView];
    }
    return cell;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        view.backgroundColor=HEX(@"#f0f0f6");
        UILabel *label =[[UILabel alloc]init];
        NSString *organName=MBNonEmptyStringNo_([[NSUserDefaults standardUserDefaults]valueForKey:@"organName"]);
        label.frame= CGRectMake(0, 0, 320, 40);
        label.textColor=HEX(@"#8e8e93");
        label.text=[NSString stringWithFormat:@"  当前机构: %@",organName];
        label.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
        //backRight@2x
        UIImageView *imaveiw=[[UIImageView alloc]initWithFrame:CGRectMake(300, 14, 12, 12)];
        imaveiw.image=[UIImage imageNamed:@"backRight"];
        [view addSubview:imaveiw];
        [view addSubview:label];
        UIButton *btnGoSeleCity=[UIButton buttonWithType:UIButtonTypeCustom];
        btnGoSeleCity.frame=label.frame;
        [view addSubview:btnGoSeleCity];
        [btnGoSeleCity addTarget:self action:@selector(goToSeleShengFeng) forControlEvents:UIControlEventTouchUpInside];
        _tableView.tableHeaderView=view;
        
        
    }else{
        UILabel *label =[[UILabel alloc]init];
        NSString *organName=MBNonEmptyStringNo_([[NSUserDefaults standardUserDefaults]valueForKey:@"organName"]);
        label.frame= CGRectMake(0, 0, 320, 40);
        label.backgroundColor=HEX(@"#f0f0f6");
        label.textColor=HEX(@"#8e8e93");
        label.text=[NSString stringWithFormat:@"  当前机构: %@",organName];
        label.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
        _tableView.tableHeaderView=label;
        
    }
    if (_dataArray.count>0) {
        [_dataArray removeAllObjects];
    }
    [self getUserData];

    [_tableView reloadData];
}
-(void)yuyueBtnPressed:(UIButton *)btn
{
    [btn setBackgroundImage:[UIImage imageNamed:@"youy_yes.png"] forState:UIControlStateNormal];
    _seleIndex=btn.tag;
    YuyueTeleViewController *all =[[YuyueTeleViewController alloc]init];
    all.infoAbout = _dataArray[btn.tag];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:all];
    AppDelegate *appDele =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDele.tabBarController presentViewController:nav animated:YES completion:nil];
}
-(void)loadMoreAboutdata
{
    _startIndex+=10;
    [self getUserData];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    NSMutableDictionary *allUserDic =_dataArray[indexPath.row];
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(allUserDic[@"templateID"][@"content"]),@"templateID", nil]];
    
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetRecordTemplateItems"];
    
    __block YuyueViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetRecordTemplateItems" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf getGetReportAbnoramlAndItemsSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];

        
    } failure:^(NSError *error, id JSON) {
        
    }];

}
-(void)getGetReportAbnoramlAndItemsSuccess:(NSString *)string
{
    
    NSDictionary *resutlDic =[NSDictionary dictionaryWithXMLString:string][@"soap:Body"][@"GetRecordTemplateItemsResponse"][@"GetRecordTemplateItemsResult"];
    
    NSArray *array =resutlDic[@"data"][@"style"];
    
    NSMutableArray *itemArray =[NSMutableArray arrayWithCapacity:2];
    if ([array isKindOfClass:[NSArray class]]) {
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic =array[i];
            if (!dic[@"isOrNo"]) {
                [itemArray addObject:dic];
            }
        }
    }
    _getDataArray = itemArray;
    
    [self getSendLogbtnThre];
    
   
    

    
}

-(void)getSendLogbtnThre
{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    NSMutableArray *arr=[NSMutableArray array];
    
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:ORGANIZATIONNAME,@"OrganName", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"UserName"],@"ClientNo", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"Name"],@"ClientName", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"MobileNO"],@"Mobile", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"查看体检套餐",@"ActExplain", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"Remark", nil]];
    
    
    NSString *soapMsg=[SoapHelper arraySendLogToDefaultSoapMessage:arr methodName:@"AddWenXinOperateLog"];
    NSLog(@"111111111111===========%@",soapMsg);
    
    __block YuyueViewController *blockSelf =self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"AddWenXinOperateLog" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestSendLogXMLWithItems:@[item] success:^(id JSON) {
        
        NSLog(@"444444=====%@",[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]);
        [blockSelf goToView];
        
    } failure:^(NSError *error, id JSON) {
        
    }];
}
-(void)goToView
{
    YuyueThrDetailViewController *all =[[YuyueThrDetailViewController alloc]init];
    all.dataArray = _getDataArray;
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:all];
    AppDelegate *appDele =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDele.tabBarController presentViewController:nav animated:YES completion:nil];
}

@end
