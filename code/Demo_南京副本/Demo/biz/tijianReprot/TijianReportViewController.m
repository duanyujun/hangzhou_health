//
//  HomeViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-20.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "TijianReportViewController.h"
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
#import "TijianReportAllViewController.h"
#import "TijianReportMoreDetialViewController.h"
@interface TijianReportViewController ()<UITableViewDelegate,UITableViewDataSource,TijianReproTcellDelegate>
{
    UIImageView *_headImageView;
    UILabel *_userName;
    NSInteger _startIndex;
    NSMutableArray *_dataArray;
    UITableView *_tableView ;
    BOOL _isShowMore;//yes ==加载更多
    UIView *_headTableView;
    UIView *_allSHowView;
}
@end

@implementation TijianReportViewController

//中间人头像按钮

-(void)showUserAllCust
{
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    
    if (isLogin) {
        
        MBUserTransViewController *userTrans =[[MBUserTransViewController alloc]init];
        UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:userTrans];
        AppDelegate *appDele =(AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDele.tabBarController presentViewController:nav animated:YES completion:nil];
        
    }else
    {
        [self goToLoginViewAbout];
    }
}
-(void)goToLoginViewAbout
{
    MBNotLogViewController *notLogin =[[MBNotLogViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:notLogin];
    AppDelegate *appDele =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDele.tabBarController presentViewController:nav animated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (_dataArray.count>0) {
        [_dataArray removeAllObjects];
    }
    [super viewWillAppear:animated];
    [self loadViewAboutUserLuccessView];
    _startIndex =0;
    [self getUserData];
}
-(void)backViewUPloadView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _dataArray =[[NSMutableArray alloc]init];
    _startIndex =0;
    _isShowMore=NO;
    
    
    _allSHowView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, kScreenHeight)];
    _allSHowView.backgroundColor=HEX(@"#ffffff");
    [self.view addSubview:_allSHowView];
    NSInteger indexo=0;
    if (kScreenHeight>500) {
        indexo=95;
    }
    _headTableView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, kScreenHeight-49-8-85-8-8-85-3+30-60-indexo)];
    _headTableView.backgroundColor=HEX(@"#5ec4fe");
    
    [self makeViewAboutDownLoadView];
    self.title=@"体检报告";
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

    
    _headImageView =[[UIImageView alloc]initWithFrame:CGRectMake(110, 100-60, 100, 101)];
    _headImageView.image =[UIImage imageNamed:@"man.png"];
    [_headTableView addSubview:_headImageView];
    _userName =[[UILabel alloc]initWithFrame:CGRectMake(0, _headImageView.frame.origin.y+100, 320, 40)];
    _userName.textAlignment=NSTextAlignmentCenter;
    _userName.font=[UIFont fontWithName:@"Helvetica Neue" size:20];
    _userName.textColor=HEX(@"#ffffff");
    _userName.text=@"请先登录";
    _userName.backgroundColor=[UIColor clearColor];
    [_headTableView addSubview:_userName];
    
    _tableView.tableHeaderView=_headTableView;
    _tableView.tableFooterView=[[UIView alloc]init];
    UIButton *btnShowBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    btnShowBtn.frame=_headImageView.frame;
    [btnShowBtn addTarget:self action:@selector(showUserAllCust) forControlEvents:UIControlEventTouchUpInside];
    [_headTableView addSubview:btnShowBtn];
    
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    if (allUserDic) {
        _userName.text= MBNonEmptyStringNo_([allUserDic allValues][0][@"Name"]);
        _headImageView.image =[UIImage imageNamed:@"woman.png"];
        
    }
    

}
-(void)GetReportInfoList{

    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"userID", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)_startIndex],@"startIndex", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",_startIndex+10],@"endIndex", nil]];
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetReportInfoList"];
    NSLog(@"%@",soapMsg);
    __block TijianReportViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetReportInfoList" params:@{@"soapMessag":soapMsg}];
    
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
-(void)getUserData
{
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        [self goToLoginViewAbout];
    }else{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    NSMutableArray *arr=[NSMutableArray array];


    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:ORGANIZATIONNAME,@"OrganName", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"UserName"],@"ClientNo", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"Name"],@"ClientName", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"MobileNO"],@"Mobile", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"查询体检报告",@"ActExplain", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"Remark", nil]];

    
    NSString *soapMsg=[SoapHelper arraySendLogToDefaultSoapMessage:arr methodName:@"AddWenXinOperateLog"];
    NSLog(@"111111111111===========%@",soapMsg);
    __block TijianReportViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"AddWenXinOperateLog" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestSendLogXMLWithItems:@[item] success:^(id JSON) {
        
        NSLog(@"444444=====%@",[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]);
        [blockSelf GetReportInfoList];
        
    } failure:^(NSError *error, id JSON) {
        [blockSelf GetReportInfoList];

    }];
    }

}

-(void)getUserDataSuccess:(NSDictionary *)dataDic
{
    NSLog(@"%@",dataDic);
    NSMutableArray *ressultArrayhel=[NSMutableArray arrayWithCapacity:2];
    NSArray *resutlArray = dataDic[@"soap:Envelope"][@"soap:Body"][@"GetReportInfoListResponse"][@"GetReportInfoListResult"][@"data"];
    if ([resutlArray isKindOfClass:[NSDictionary class]]) {
        
        [ressultArrayhel addObject:resutlArray];
        
    }else if ([resutlArray isKindOfClass:[NSArray class]])
    {
        [ressultArrayhel addObjectsFromArray:resutlArray];
    }
    NSMutableArray *reseDataArray =[NSMutableArray arrayWithCapacity:2];
    if ([ressultArrayhel isKindOfClass:[NSArray class]]) {
        for (int i=0; i<ressultArrayhel.count; i++) {
            NSDictionary *dic =ressultArrayhel[i];
            if (!dic[@"isOrNo"]) {
                [reseDataArray addObject:dic];
            }
            
        }
    }

    NSLog(@"%@",reseDataArray);
    if (reseDataArray.count<10) {
        _isShowMore=NO;
        if ([reseDataArray[0][@"reportInfosArray"] count]>0) {
            [_dataArray addObjectsFromArray:reseDataArray[0][@"reportInfosArray"]];
        }else{
            [_dataArray addObjectsFromArray:reseDataArray];

        }

    }else
    {
        if ([reseDataArray[0][@"reportInfosArray"] count]>0) {
            [_dataArray addObjectsFromArray:reseDataArray[0][@"reportInfosArray"]];
        }else{
            [_dataArray addObjectsFromArray:reseDataArray];
            
        }
        _isShowMore=YES;
    }
    [_tableView reloadData];
}
-(void)loadViewAboutUserLuccessView
{
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (isLogin) {
        NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
        if (allUserDic) {
            _userName.text= MBNonEmptyStringNo_([allUserDic allValues][0][@"Name"]);
            if ([MBNonEmptyStringNo_([allUserDic allValues][0][@"Sex"]) isEqualToString:@"2"]) {
                _headImageView.image =[UIImage imageNamed:@"woman.png"];

            }else
            {
                _headImageView.image =[UIImage imageNamed:@"man.png"];

            }
            
        }
    }
    else
    {
        _userName.text= @"请先登录";
    }

}

-(void)makeViewAboutDownLoadView
{

    
    UILabel *label =[[UILabel alloc]init];
    label.frame= CGRectMake(0, _headImageView.frame.origin.y+173, 320, 30);
    label.backgroundColor=HEX(@"#0ec0ff");
    label.textColor=HEX(@"#ffffff");
    label.text = @"  在这里跟踪您的健康情况:";
    label.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    [_headTableView addSubview:label];
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, kContentViewHeight) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=HEX(@"#ffffff");
     [_allSHowView addSubview:_tableView];
    _tableView.backgroundColor=[UIColor clearColor];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
        NSLog(@"111======%@",_dataArray[indexPath.row]);
        NSLog(@"222======%@",_dataArray[indexPath.row][@"reportInfo"]);
        
        if (_dataArray[indexPath.row]) {
            cell.itemLbl.text=MBNonEmptyStringNo_(_dataArray[indexPath.row][@"date"][@"content"]);

        }
        if (_dataArray[indexPath.row][@"reportInfo"]) {
            cell.itemLbl.text=MBNonEmptyStringNo_(_dataArray[indexPath.row][@"reportInfo"][@"date"][@"content"]);

        }

        cell.itemCountLbl.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        [cell hiddleLoadMoreView];
    }
    return cell;
}
-(void)loadMoreAboutdata
{
    _startIndex+=10;
    [self getUserData];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *allUserDic =_dataArray[indexPath.row];
    NSLog(@"%@",allUserDic);
    NSMutableArray *arr=[NSMutableArray array];
    if (!_dataArray[indexPath.row][@"reportInfo"]) {

        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(allUserDic[@"healthReportId"][@"content"]),@"reportID", nil]];

        NSLog(@"1111===");
        _reportID = MBNonEmptyStringNo_(allUserDic[@"healthReportId"][@"content"]);

    }else
    {
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(allUserDic[@"reportInfo"][@"healthReportId"][@"content"]),@"reportID", nil]];
        _reportID =MBNonEmptyStringNo_(allUserDic[@"reportInfo"][@"healthReportId"][@"content"]);
    }

    
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetReportAbnoramlAndItems"];
    NSLog(@"%@",soapMsg);
    __block TijianReportViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetReportAbnoramlAndItems" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf getGetReportAbnoramlAndItemsSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];

        
    } failure:^(NSError *error, id JSON) {
        
    }];

    
    

}
-(void)getGetReportAbnoramlAndItemsSuccess:(NSString *)string
{
    
    @try {
        NSDictionary *resutlDic =[NSDictionary dictionaryWithXMLString:string][@"soap:Body"][@"GetReportAbnoramlAndItemsResponse"][@"GetReportAbnoramlAndItemsResult"];
        
        NSMutableArray *array;
        NSArray *arrayIfKind =resutlDic[@"data"][@"departments"][@"department"];
        
        if ([arrayIfKind isKindOfClass:[NSDictionary class]]) {
            
            array = [NSMutableArray arrayWithObject:resutlDic[@"data"][@"departments"][@"department"]];
            
        }else
        {
            array =resutlDic[@"data"][@"departments"][@"department"];
            
        }

        NSMutableArray *itemArray =[NSMutableArray arrayWithCapacity:2];
        
        if ([array isKindOfClass:[NSArray class]]) {
            for (int i=0; i<array.count; i++) {
                [itemArray addObject:array[i][@"departMentName"]];
            }

            NSArray *arrrayAboutHel =resutlDic[@"data"][@"healthAbnoramls"][@"abnoraml"];
            if (arrrayAboutHel) {
                if ([arrrayAboutHel isKindOfClass:[NSArray class]]) {
                    for (int i=0; i<arrrayAboutHel.count; i++) {
                        [itemArray addObject:arrrayAboutHel[i][@"abnoramlName"]];
                    }
                }else
                {
                    [itemArray addObject:resutlDic[@"data"][@"healthAbnoramls"][@"abnoraml"][@"abnoramlName"]];
                    
                }
            }
            
           
            


            TijianReportAllViewController *all =[[TijianReportAllViewController alloc]init];
            
            all.resultArray = [[NSMutableArray alloc]initWithArray:array];
            all.itemArray = [[NSArray alloc]initWithArray:itemArray];
            all.reportID = _reportID;
            all.allDataInfo = resutlDic;

            if (resutlDic[@"data"]) {
                

                all.healthAbnoramlsDic = [[NSDictionary alloc]initWithDictionary:resutlDic[@"data"][@"healthAbnoramls"] ];

            }

            all.advice=MBNonEmptyStringNo_(resutlDic[@"data"][@"advice"]);
            all.summarize=MBNonEmptyStringNo_(resutlDic[@"data"][@"summarize"]);
            UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:all];
            AppDelegate *appDele =(AppDelegate*)[UIApplication sharedApplication].delegate;
            [appDele.tabBarController presentViewController:nav animated:YES completion:nil];
        }
        

    }
    @catch (NSException *exception) {
        
        
        MBAlert(@"暂无相关记录");
    }
    @finally {
        
    }

    

    
}
@end
