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
#import "XMLParser.h"
#import "MBGlobalUICommon.h"
#import "TiJianReprotCellForTijianYuyue.h"
#import "TijianReportAllViewController.h"
#import "YuyueThrDetailViewControllerLast.h"
#import "YuyueTeleViewController.h"
#import "JSONKit.h"
@interface YuyueViewController ()<UITableViewDelegate,UITableViewDataSource,TiJianReprotCellForTijianYuyueDelegate>
{
    NSInteger _startIndex;
    NSMutableArray *_dataArray;
    UITableView *_tableView ;
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

    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:ORGANIZATIONNAME,@"organName", nil]];


    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetYuYuePackageJSON"];
    
    __block YuyueViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetYuYuePackageJSON" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItemsPhone:@[item] success:^(id JSON) {
        
        NSLog(@"%@",[NSDictionary dictionaryWithXMLData:JSON]);
        
        [blockSelf getUserDataSuccess:[NSDictionary dictionaryWithXMLData:JSON]];
        
    } failure:^(NSError *error, id JSON) {
        
    }];

}

-(void)getUserDataSuccess:(NSDictionary *)dataDic
{
    
    NSString *array = dataDic[@"soap:Body"][@"GetYuYuePackageJSONResponse"][@"GetYuYuePackageJSONResult"] ;
    NSArray *arrayOfResult = [array objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode][@"Package"] ;
    [_dataArray addObjectsFromArray:arrayOfResult];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _dataArray.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellStr =@"_isShowMore";
    TiJianReprotCellForTijianYuyue *cell =[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[TiJianReprotCellForTijianYuyue alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        cell.delegateAbout = self;
       
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
        NSLog(@"%@",_dataArray[0]);
    
    NSString *rankStr =@"";
    if (MBNonEmptyStringNo_(_dataArray[indexPath.row][@"PackageExplain"]).length>0) {
        
        rankStr =MBNonEmptyStringNo_(_dataArray[indexPath.row][@"PackageExplain"]);
        
    }else
    {
        rankStr = @"暂无说明";
    }
    cell.itemNameLbl.text=[NSString stringWithFormat:@"%@",MBNonEmptyStringNo_(_dataArray[indexPath.row][@"PackageName"])];

    cell.itemLbl.text=[NSString stringWithFormat:@"%@",rankStr];

        cell.itemCountLbl.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        cell.yuyueBtn.hidden=NO;
        cell.rightLabl.text=[NSString stringWithFormat:@"￥%@",MBNonEmptyStringNo_(_dataArray[indexPath.row][@"PackagePrice"])];
        cell.yuyueBtn.tag=indexPath.row;
        if (_seleIndex==indexPath.row) {
            [cell.yuyueBtn setBackgroundImage:[UIImage imageNamed:@"youy_yes.png"] forState:UIControlStateNormal];
        }else {
            [cell.yuyueBtn setBackgroundImage:[UIImage imageNamed:@"gouy_no.png"] forState:UIControlStateNormal];

        }
        [cell hiddleLoadMoreView];
    cell.tag = indexPath.row;
    return cell;
}
-(void)seeDetailBtnPressed:(TiJianReprotCellForTijianYuyue *)selfCell
{
    
    NSMutableDictionary *allUserDic =_dataArray[selfCell.tag];
    _sendDataInfo =allUserDic;
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(allUserDic[@"PackageGUID"]),@"packageID", nil]];
    
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetPackageDeatilJSON"];
    NSLog(@"%@",soapMsg);
    
    __block YuyueViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetPackageDeatilJSON" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf getGetReportAbnoramlAndItemsSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        NSLog(@"%@",error);
    }];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        view.backgroundColor=HEX(@"#f0f0f6");
        UILabel *label =[[UILabel alloc]init];
        NSString *organName=MBNonEmptyStringNo_(ORGANIZATIONNAME);
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
//        [btnGoSeleCity addTarget:self action:@selector(goToSeleShengFeng) forControlEvents:UIControlEventTouchUpInside];
        _tableView.tableHeaderView=view;
        
        
    }else{
        UILabel *label =[[UILabel alloc]init];
        NSString *organName=MBNonEmptyStringNo_(ORGANIZATIONNAME);
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
    [self getDetailAboutYuyue];
    
}
-(void)getDetailAboutYuyue
{
    NSMutableDictionary *allUserDic =_dataArray[_seleIndex];
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(allUserDic[@"PackageGUID"]),@"packageID", nil]];
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetPackageDeatilJSON"];
    
    __block YuyueViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetPackageDeatilJSON" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf getGetReportAbnoramlAndItemsSuccessAboutTwo:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];

}
-(void)getGetReportAbnoramlAndItemsSuccessAboutTwo:(NSString *)string
{
    
    NSString *resutlDic =[NSDictionary dictionaryWithXMLString:string][@"soap:Body"][@"GetPackageDeatilJSONResponse"][@"GetPackageDeatilJSONResult"];
    NSArray *arrayOfResult = [resutlDic objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode][@"PackageDetail"] ;
    
    YuyueTeleViewController *all =[[YuyueTeleViewController alloc]init];
    all.infoAbout = _dataArray[_seleIndex];
    all.dataAllArray = arrayOfResult;
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
    _sendDataInfo =allUserDic;
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(allUserDic[@"PackageGUID"]),@"packageID", nil]];
    
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetPackageDeatilJSON"];
    NSLog(@"%@",soapMsg);
    
    __block YuyueViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetPackageDeatilJSON" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf getGetReportAbnoramlAndItemsSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];

        
    } failure:^(NSError *error, id JSON) {
        NSLog(@"%@",error);
    }];

}
-(void)getGetReportAbnoramlAndItemsSuccess:(NSString *)string
{
    
    NSString *resutlDic =[NSDictionary dictionaryWithXMLString:string][@"soap:Body"][@"GetPackageDeatilJSONResponse"][@"GetPackageDeatilJSONResult"];
    NSLog(@"%@",resutlDic);
    NSArray *arrayOfResult = [resutlDic objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode][@"PackageDetail"] ;
    _detailName = MBNonEmptyString([resutlDic objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode][@"PackageName"]);
    _detailPrice = MBNonEmptyString([resutlDic objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode][@"PackagePrice"]);

    _getDataArray = arrayOfResult;
    
    [self getSendLogbtnThre];
    
}

-(void)getSendLogbtnThre
{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    NSMutableArray *arr=[NSMutableArray array];
    
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:ORGANIZATIONNAME,@"OrganName", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserName"]),@"ClientNo", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"Name"]),@"ClientName", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"MobileNO"]),@"Mobile", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"查看体检套餐",@"ActExplain", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"Remark", nil]];
    
    
    NSString *soapMsg=[SoapHelper arraySendLogToDefaultSoapMessage:arr methodName:@"AddWenXinOperateLog"];
    
    __block YuyueViewController *blockSelf =self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"AddWenXinOperateLog" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestSendLogXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf goToView];
        
    } failure:^(NSError *error, id JSON) {
        
    }];
}
-(void)goToView
{
    YuyueThrDetailViewControllerLast *all =[[YuyueThrDetailViewControllerLast alloc]init];
    all.dataArray = [[NSMutableArray alloc]initWithArray:_getDataArray];
    all.priceStr = _detailPrice;
    all.nameStr = _detailName;
    all.sendDataInfo = _sendDataInfo;
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:all];
    AppDelegate *appDele =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDele.tabBarController presentViewController:nav animated:YES completion:nil];
}

@end
