//
//  JianKangTestViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-26.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "JianKangTestViewController.h"
#import "MBUserTransViewController.h"
#import "AppDelegate.h"
#import "MBNotLogViewController.h"
#import "XMLDictionary.h"
#import "MBTabBarController.h"
#import "JIanKangBtn.h"
#import "SoapHelper.h"
#import "XMLDictionary.h"
#import "MBIIRequest.h"
#import "XueYaViewController.h"
#import "AppDelegate.h"
#import "TizhongViewController.h"
#import "XueTangViewController.h"
#import "XindianViewController.h"
#import "xueYangViewController.h"
#import "TiZhiViewController.h"
@interface JianKangTestViewController ()
{
    UIImageView *_headImageView;
    UILabel *_userName;
    NSString *_type;
}
@end

@implementation JianKangTestViewController


-(void)makeViewAboutDownLoadView
{
    UIView *viewBG =[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-49-8-85-8-8-85-3+30-60-20, 320, -(-49-8-85-8-8-85-20))];
    viewBG.backgroundColor=HEX(@"#ffffff");
    [self.view addSubview:viewBG];
    
    UILabel *label =[[UILabel alloc]init];
    label.frame= CGRectMake(0, viewBG.frame.origin.y-30, 320, 30);
    label.backgroundColor=HEX(@"#0ec0ff");
    label.textColor=HEX(@"#ffffff");
    label.text = @"  在这里跟踪您的健康情况:";
    label.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    [self.view addSubview:label];

    NSArray *itemArray = @[@"血压",@"体重脂肪",@"血糖",@"心电",@"能量消耗",@"血氧"];
    NSArray *itemAImagerray = @[@"zice_0.png",@"zice_1.png",@"zice_2.png",@"zice_3.png",@"zice_4.png",@"zice_5.png"];
    
        for (int i = 0; i < 6; i++) {
            JIanKangBtn*btnItem =[JIanKangBtn buttonWithType:UIButtonTypeCustom];
            btnItem.buttonName=itemArray[i];
            [btnItem addTarget:self action:@selector(showCurmenu:) forControlEvents:UIControlEventTouchUpInside];
            btnItem.tag=i;
            [btnItem setBackgroundImage:[UIImage imageNamed:itemAImagerray[i]] forState:UIControlStateNormal];
            [self.view addSubview:btnItem];

            UILabel *itemName =[[UILabel alloc]init];
            itemName.textColor=HEX(@"#000000");
            itemName.font=kSmallTextFont;
            itemName.text=itemArray[i];
            itemName.textAlignment=NSTextAlignmentCenter;
            if (i<4) {
                btnItem.frame = CGRectMake(20*(i+1)+58*i-4, kScreenHeight-160-100-10-15, 58, 58);
                itemName.frame = CGRectMake(20*(i+1)+58*i-4, kScreenHeight-160-100-10+40-15, 58, 58);
                
            }else
            {
                if (i==4) {
                    
                    btnItem.frame = CGRectMake(20-4, kScreenHeight-160+5+10-30-10-3-2-15, 58, 58);
                    itemName.frame = CGRectMake(20-4, kScreenHeight-160+5+10-30-10-3+40-2-15, 58, 58);

                }if (i==5) {
                    btnItem.frame = CGRectMake(20*(i+1-4)+58*(i-4)-4, kScreenHeight-160+5+10-30-10-3-2-15, 58, 58);
                    itemName.frame = CGRectMake(20*(i+1-4)+58*(i-4)-4, kScreenHeight-160+5+10-30-10-3+40-2-15, 58, 58);

                }
               
            }
            [self.view addSubview:itemName];
            [self.view addSubview:btnItem];
        }

    
}

-(void)showCurmenu:(JIanKangBtn*)gesutre
{
 
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        [self goToLoginViewAbout];
    }else{
    if (gesutre.tag==0) {
        _type=@"2";//血压
    }
    if (gesutre.tag==1) {
        _type=@"5";//体重脂肪
    }if (gesutre.tag==2) {
        _type=@"4";//血糖
    }if (gesutre.tag==3) {
        _type=@"7";//心电
    }if (gesutre.tag==4) {
        _type=@"6";//能量
    }if (gesutre.tag==5) {
        _type=@"8";//血氧
    }
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"customerId", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:_type,@"paramType", nil]];
    
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetNewHealthDataAndResult"];
    
    __block JianKangTestViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetNewHealthDataAndResult" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf GetNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];

        
    } failure:^(NSError *error, id JSON) {
        
    }];}

}
-(void)GetNewHealthDataAndResultSuccess:(NSString *)string
{
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:string];
    NSLog(@"%@",xmlDoc);
    
    if ([_type isEqualToString:@"2"]) {
        
        XueYaViewController *xueYa =[[XueYaViewController alloc]init];
        UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:xueYa];
        xueYa.dicAboutInfo=xmlDoc;
        AppDelegate *appDele =(AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDele.tabBarController presentViewController:nav animated:YES completion:nil];
        
    } if ([_type isEqualToString:@"5"]) {
        
        TiZhiViewController *xueYa =[[TiZhiViewController alloc]init];
        UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:xueYa];
        xueYa.dicAboutInfo=xmlDoc;
        AppDelegate *appDele =(AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDele.tabBarController presentViewController:nav animated:YES completion:nil];
        
    } if ([_type isEqualToString:@"4"]) {
        
        XueTangViewController *xueYa =[[XueTangViewController alloc]init];
        UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:xueYa];
        xueYa.dicAboutInfo=xmlDoc;
        AppDelegate *appDele =(AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDele.tabBarController presentViewController:nav animated:YES completion:nil];
        
    } if ([_type isEqualToString:@"7"]) {
        
        XindianViewController *xueYa =[[XindianViewController alloc]init];
        UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:xueYa];
        xueYa.dicAboutInfo=xmlDoc;
        AppDelegate *appDele =(AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDele.tabBarController presentViewController:nav animated:YES completion:nil];
        
    } if ([_type isEqualToString:@"6"]) {
        
        
        TizhongViewController *xueYa =[[TizhongViewController alloc]init];
        UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:xueYa];
        xueYa.dicAboutInfo=xmlDoc;
        AppDelegate *appDele =(AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDele.tabBarController presentViewController:nav animated:YES completion:nil];

        
    } if ([_type isEqualToString:@"8"]) {
        
        xueYangViewController *xueYa =[[xueYangViewController alloc]init];
        UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:xueYa];
        xueYa.dicAboutInfo=xmlDoc;
        AppDelegate *appDele =(AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDele.tabBarController presentViewController:nav animated:YES completion:nil];
    }


}
-(void)backViewUPloadView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeViewAboutDownLoadView];
    self.title=@"健康自测";
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

    _headImageView =[[UIImageView alloc]initWithFrame:CGRectMake(110, 100-60-20, 100, 101)];
    _headImageView.image =[UIImage imageNamed:@"man.png"];
    _headImageView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_headImageView];
    _userName =[[UILabel alloc]initWithFrame:CGRectMake(0, _headImageView.frame.origin.y+100, 320, 40)];
    _userName.textAlignment=NSTextAlignmentCenter;
    _userName.font =[UIFont fontWithName:@"Helvetica Neue" size:20];
    _userName.textColor=HEX(@"#ffffff");
    _userName.text=@"请先登录";
    _userName.backgroundColor=[UIColor clearColor];
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
    [super viewWillAppear:animated];
    [self loadViewAboutUserLuccessView];
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



@end
