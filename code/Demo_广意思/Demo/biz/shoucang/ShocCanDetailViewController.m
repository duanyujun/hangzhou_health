//
//  ShocCanDetailViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-29.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "ShocCanDetailViewController.h"
#import "SoapHelper.h"
#import "MBIIRequest.h"
#import "XMLDictionary.h"
@interface ShocCanDetailViewController ()

@end

@implementation ShocCanDetailViewController

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
    
    self.title=@"资讯内容";
    self.view.backgroundColor=HEX(@"#5ec4fe");
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
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
    UIWebView*webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, kContentViewHeight+49)];
    [webView loadHTMLString:_dicAboutInfo[@"content"] baseURL:nil];
    [self.view addSubview:webView];
    
    if (IOS7_OR_LATER) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"收藏" style:UIBarButtonItemStyleBordered target:self action:@selector(shouChangBtnPressed)];
    }else
    {
        UIButton *btnLeft =[UIButton buttonWithType:UIButtonTypeCustom];
        btnLeft.frame=CGRectMake(0, 0, 40, 40);
        [btnLeft setTitle:@"收藏" forState:UIControlStateNormal];
        [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnLeft addTarget:self action:@selector(shouChangBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    }
    

}
-(void)goToLoginViewAbout
{
    MBNotLogViewController *notLogin =[[MBNotLogViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:notLogin];
    [self presentViewController:nav animated:YES completion:nil];
}
//收藏文章
-(void)shouChangBtnPressed
{
    
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        [self goToLoginViewAbout];
    }else{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    
    NSMutableArray *arr=[NSMutableArray array];
    
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(_dicAboutInfo[@"articleID"]),@"articleID", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"userID", nil]];
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"CollectMissionaryArticle"];
    
    __block ShocCanDetailViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"CollectMissionaryArticle" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        
        [blockSelf GetNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        MBAlert(@"此资讯您已收藏");

    }];
    }
}
-(void)GetNewHealthDataAndResultSuccess:(NSString *)string
{
    NSDictionary*xmlDic =[NSDictionary dictionaryWithXMLString:string];
    if ([MBNonEmptyStringNo_(xmlDic[@"soap:Body"][@"CollectMissionaryArticleResponse"][@"CollectMissionaryArticleResult"]) isEqualToString:@"1"]) {
        MBAlert(@"收藏成功");
    }
    else
    {
        MBAlert(@"此资讯您已收藏");


    }
}
//返回到上个页面
-(void)backViewUPloadView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
