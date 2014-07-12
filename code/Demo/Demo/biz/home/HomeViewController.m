//
//  HomeViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-20.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "HomeViewController.h"
#import "MBConstant.h"
#import "MBNotLogViewController.h"
#import "AppDelegate.h"
#import "MBUserTransViewController.h"
#import "TijianReportViewController.h"
#import "JianKangTestViewController.h"
#import "YuyueViewController.h"
#import "ChartViewController.h"
#import "SysTemMessageViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "JSONKit.h"
#import "AFJSONRequestOperation.h"
#import "SoapHelper.h"
#import "MBIIRequest.h"
#import "XMLDictionary.h"
#import "MBAlertView.h"
#import "NSDateUtilities.h"
@interface HomeViewController ()<UIAlertViewDelegate>
{
    UIImageView *_headImageView;
    UILabel *_userName;
    NSInteger _indexOf;
    NSString *_phoneNum;
    NSString *_webAddress;
    NSDate *_lastGetSysDate;
}
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    _webAddress=MBNonEmptyStringNo_([[NSUserDefaults standardUserDefaults]valueForKey:@"webAddress"]);
    
    [super viewWillAppear:animated];
    [self loadViewAboutUserLuccessView];
    if (_webAddress.length>0) {
        
        [self getPhone];
        
        BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
        if (isLogin) {
            _lastGetSysDate=[NSDate date];
            [self getSystemNew];
        }
    }
}
-(void)getPhone
{
    
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    NSString *organName=MBNonEmptyStringNo_(ORGANIZATIONNAME);
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"organ_id", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",organName],@"_organName", nil]];
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetConsoluPhone"];
    
    __block HomeViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetConsoluPhone" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItemsPhone:@[item] success:^(id JSON) {
        
        
        [blockSelf GetNewHealthDataAndResultSuccessphone:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    
    
}
-(void)GetNewHealthDataAndResultSuccessphone:(NSString*)string
{
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:string];
    NSLog(@"%@",xmlDoc);
    NSString *array=MBNonEmptyStringNo_(xmlDoc[@"soap:Body"][@"GetConsoluPhoneResponse"][@"GetConsoluPhoneResult"]);
    if (![array isEqualToString:@""]) {
        _phoneNum=array;
    }
}
-(void)getJigoutCiyt:(NSNotification*)noc
{
    NSDictionary *dic=(NSDictionary*)[noc object];
    NSLog(@"%@",dic);
    _webAddress=MBNonEmptyStringNo_(dic[@"webAddress"]);
    [[NSUserDefaults standardUserDefaults]setValue:MBNonEmptyStringNo_(dic[@"organName"]) forKey:@"organName"];
    [[NSUserDefaults standardUserDefaults]setValue:MBNonEmptyStringNo_(_webAddress) forKey:@"webAddress"];
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MBGETJIGOUINFO object:nil];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getJigoutCiyt:) name:MBGETJIGOUINFO object:nil];
    _webAddress=MBNonEmptyStringNo_([[NSUserDefaults standardUserDefaults]valueForKey:@"webAddress"]);
    _indexOf=0;
    self.view.backgroundColor= HEX(@"#5ec4fe");
    
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        UIBarButtonItem *rightBarItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"phone.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemBtnPressed:)];
        self.navigationItem.rightBarButtonItem=rightBarItem;
    }else{
        
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0, 0, 24, 24);
        [btn setBackgroundImage:[UIImage imageNamed:@"phone.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightBarItemBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
        
    }
    UIButton *btnLeft =[UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame=CGRectMake(0, 0, 27, 27);
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"noMessage.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(showSysteMesage) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    _headImageView =[[UIImageView alloc]initWithFrame:CGRectMake(110, 100-65, 100, 101)];
    _headImageView.image =[UIImage imageNamed:@"man.png"];
    _headImageView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:_headImageView];
    _userName =[[UILabel alloc]initWithFrame:CGRectMake(0, _headImageView.frame.origin.y+100-5, 320, 40)];
    _userName.textAlignment=NSTextAlignmentCenter;
    _userName.backgroundColor=[UIColor clearColor];
    _userName.font =[UIFont fontWithName:@"Helvetica Neue" size:20];
    _userName.textColor=HEX(@"#ffffff");
    _userName.text=@"请先登录";
    [self.view addSubview:_userName];
    
    
    UIButton *btnShowBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    btnShowBtn.frame=_headImageView.frame;
    [btnShowBtn addTarget:self action:@selector(showUserAllCust) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnShowBtn];
    
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    if (allUserDic) {
        _userName.text= MBNonEmptyStringNo_([allUserDic allValues][0][@"Name"]);
        _headImageView.image =[UIImage imageNamed:@"woman.png"];
        
    }
    
    [self makeViewAboutDownLoadView];
}

-(void)getSystemNew
{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"userId", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",0],@"startIndex", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",10],@"endIndex", nil]];
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetPushMessageList"];
    
    __block HomeViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetPushMessageList" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        
        [blockSelf GetNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    
}
-(void)GetNewHealthDataAndResultSuccess:(NSString*)string
{
    NSDictionary *xmlDic =[NSDictionary dictionaryWithXMLString:string];
    NSArray *array=xmlDic[@"soap:Body"][@"GetPushMessageListResponse"][@"GetPushMessageListResult"][@"data"][@"pushMessageList"];
    NSLog(@"%@",array);
    NSLog(@"%@",xmlDic);
    
    if ([array isKindOfClass:[NSArray class]]) {
        NSMutableArray *reseDataArray =[NSMutableArray arrayWithCapacity:2];
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic =array[i];
            if (!dic[@"isOrNo"]) {
                [reseDataArray addObject:dic];
            }
        }
        NSString *meesgageImage=@"";

        for (int i=0; i<reseDataArray.count; i++) {
            NSDictionary *dic=reseDataArray[i];
            NSDate *messgae=[NSDate dateWithString:MBNonEmptyStringNo_(dic[@"pushTime"])];
            if ([_lastGetSysDate isEarlierThanDate:messgae]) {
                meesgageImage=@"haveMessage.png";
                break;
            }else
            {
                meesgageImage=@"noMessage.png";

            }
        }
        _indexOf+=1;
        

        
            UIButton *btnLeft =[UIButton buttonWithType:UIButtonTypeCustom];
            btnLeft.frame=CGRectMake(0, 0, 27, 27);
            [btnLeft setBackgroundImage:[UIImage imageNamed:meesgageImage] forState:UIControlStateNormal];
            [btnLeft addTarget:self action:@selector(showSysteMesage) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
            
    }else
    {
        NSString * meesgageImage=@"noMessage.png";
        
        
            UIButton *btnLeft =[UIButton buttonWithType:UIButtonTypeCustom];
            btnLeft.frame=CGRectMake(0, 0, 27, 27);
            [btnLeft setBackgroundImage:[UIImage imageNamed:meesgageImage] forState:UIControlStateNormal];
            [btnLeft addTarget:self action:@selector(showSysteMesage) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
            
    }
    
    
}
//系统消息
-(void)showSysteMesage
{

        BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
        
        if (!isLogin) {
           
            [self goToLoginViewAbout];
            
        }else
        {
            SysTemMessageViewController *tijian=[[SysTemMessageViewController alloc]init];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:tijian];
            [self presentViewController:nav animated:YES completion:nil];
        }
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
-(void)rightBarItemBtnPressed:(UIBarButtonItem*)rightBtn
{
    
    
        MBAlertView *show=[[MBAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"确定呼叫%@吗?",_phoneNum] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [show show];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneNum]]];
    }
}
-(void)makeViewAboutDownLoadView
{
    UIView *viewBG =[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-49-8-85-8-8-85-3-60, 320, -(-49-8-85-8-8-85))];
    viewBG.backgroundColor=HEX(@"#ffffff");
    [self.view addSubview:viewBG];
    UIButton *btnOne =[UIButton buttonWithType:UIButtonTypeCustom];
    btnOne.frame = CGRectMake(8, 8, 148, 85);
    [btnOne addTarget:self action:@selector(tijiaoReprot) forControlEvents:UIControlEventTouchUpInside];
    [btnOne setBackgroundImage:[UIImage imageNamed:@"tjbg.png"] forState:UIControlStateNormal];
    [viewBG addSubview:btnOne];
    
    UIButton *btnTwo =[UIButton buttonWithType:UIButtonTypeCustom];
    btnTwo.frame = CGRectMake(8+8+148, 8, 148, 85);
    [btnTwo setBackgroundImage:[UIImage imageNamed:@"jkzc.png"] forState:UIControlStateNormal];
    [btnTwo addTarget:self action:@selector(btnTwoBressed) forControlEvents:UIControlEventTouchUpInside];
    [viewBG addSubview:btnTwo];
    
    UIButton *btnThree =[UIButton buttonWithType:UIButtonTypeCustom];
    btnThree.frame = CGRectMake(8, 8+8+85, 148, 85);
    [btnThree setBackgroundImage:[UIImage imageNamed:@"tjyy.png"] forState:UIControlStateNormal];
    [btnThree addTarget:self action:@selector(btnThreeBressed) forControlEvents:UIControlEventTouchUpInside];
    [viewBG addSubview:btnThree];
    
    UIButton *btnFour =[UIButton buttonWithType:UIButtonTypeCustom];
    btnFour.frame = CGRectMake(8+8+148, 8+8+85, 148, 85);
    [btnFour setBackgroundImage:[UIImage imageNamed:@"gdzx.png"] forState:UIControlStateNormal];
    [btnFour addTarget:self action:@selector(weCHart) forControlEvents:UIControlEventTouchUpInside];
    
    [viewBG addSubview:btnFour];
    
    
}
//互动咨询
-(void)weCHart
{
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        [self goToLoginViewAbout];
    }else{
        [self getSendLogAboutCharts];
        

    }
}
-(void)getSendLogAboutCharts
{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    NSMutableArray *arr=[NSMutableArray array];
    
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:ORGANIZATIONNAME,@"OrganName", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"UserName"],@"ClientNo", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"Name"],@"ClientName", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"MobileNO"],@"Mobile", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"在线互动",@"ActExplain", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"Remark", nil]];
    
    
    NSString *soapMsg=[SoapHelper arraySendLogToDefaultSoapMessage:arr methodName:@"AddWenXinOperateLog"];
    NSLog(@"111111111111===========%@",soapMsg);
    __block HomeViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"AddWenXinOperateLog" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestSendLogXMLWithItems:@[item] success:^(id JSON) {
        
        NSLog(@"444444=====%@",[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]);
        [blockSelf goToChartsView];
        
    } failure:^(NSError *error, id JSON) {
        [blockSelf goToChartsView];
        
    }];
}

-(void)goToChartsView
{
    ChartViewController *tijian=[[ChartViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:tijian];
    [self presentViewController:nav animated:YES completion:nil];
}
//体检预约
-(void)btnThreeBressed
{
    
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        [self goToLoginViewAbout];
    }else{
        [self getSendLogbtnThre];

    }
    
}
-(void)getSendLogbtnThre
{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    NSMutableArray *arr=[NSMutableArray array];
    
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:ORGANIZATIONNAME,@"OrganName", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"UserName"],@"ClientNo", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"Name"],@"ClientName", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"MobileNO"],@"Mobile", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"体检预约",@"ActExplain", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"Remark", nil]];
    
    
    NSString *soapMsg=[SoapHelper arraySendLogToDefaultSoapMessage:arr methodName:@"AddWenXinOperateLog"];
    NSLog(@"111111111111===========%@",soapMsg);
    __block HomeViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"AddWenXinOperateLog" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestSendLogXMLWithItems:@[item] success:^(id JSON) {
        
        NSLog(@"444444=====%@",[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]);
        [blockSelf goTotijiaoResViewbtnThre];
        
    } failure:^(NSError *error, id JSON) {
        [blockSelf goTotijiaoResViewbtnThre];
        
    }];
}


-(void)goTotijiaoResViewbtnThre
{
    YuyueViewController *tijian=[[YuyueViewController alloc]init];
    [self.navigationController pushViewController:tijian animated:YES];
}

-(void)getSendLog
{
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
    __block HomeViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"AddWenXinOperateLog" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestSendLogXMLWithItems:@[item] success:^(id JSON) {
        
        NSLog(@"444444=====%@",[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]);
        [blockSelf goTotijiaoResView];
        
    } failure:^(NSError *error, id JSON) {
        [blockSelf goTotijiaoResView];
        
    }];
}


-(void)goTotijiaoResView
{
    TijianReportViewController *tijian=[[TijianReportViewController alloc]init];
    [self.navigationController pushViewController:tijian animated:YES];
}
//提交报告
- (void)tijiaoReprot
{
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        [self goToLoginViewAbout];
    }else{
        [self getSendLog];
    }
}
// 体检自测
-(void)btnTwoBressed
{
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        [self goToLoginViewAbout];
    }else{
        [self getSendLogbtnThreZihce];
    }
}
-(void)getSendLogbtnThreZihce
{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    NSMutableArray *arr=[NSMutableArray array];
    
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:ORGANIZATIONNAME,@"OrganName", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"UserName"],@"ClientNo", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"Name"],@"ClientName", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"MobileNO"],@"Mobile", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"健康数据监测",@"ActExplain", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"Remark", nil]];
    
    
    NSString *soapMsg=[SoapHelper arraySendLogToDefaultSoapMessage:arr methodName:@"AddWenXinOperateLog"];
    NSLog(@"111111111111===========%@",soapMsg);
    __block HomeViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"AddWenXinOperateLog" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestSendLogXMLWithItems:@[item] success:^(id JSON) {
        
        NSLog(@"444444=====%@",[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]);
        [blockSelf goTotijiaoResViewbtnThreZhice];
        
    } failure:^(NSError *error, id JSON) {
        [blockSelf goTotijiaoResViewbtnThreZhice];
        
    }];
}


-(void)goTotijiaoResViewbtnThreZhice
{
    JianKangTestViewController *text =[[JianKangTestViewController alloc]init];
    [self.navigationController pushViewController:text animated:YES];
}
@end
