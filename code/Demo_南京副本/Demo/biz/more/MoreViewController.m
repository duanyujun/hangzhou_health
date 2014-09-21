//
//  MoreViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-30.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "MoreViewController.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <MessageUI/MessageUI.h>
#import "AboutViewController.h"
#import "MBIIRequest.h"
#import "SoapHelper.h"
#import "XMLDictionary.h"
@interface MoreViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>
{
    NSArray *_imageArray;
    NSArray *_itemaArray;
    MFMessageComposeViewController *_picker;
}
@end

@implementation MoreViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    _imageArray=@[@"upload.png",@"huanchun.png",@"share.png",@"help.png"];
    _itemaArray=@[@"检查更新",@"清除缓存"];
    //    _itemaArray=@[@"检查更新",@"清除缓存",@"软件分享",@"关于掌上健康"];
    
    self.title=@"设置";
    self.view.backgroundColor=HEX(@"#ffffff");
    
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    view.backgroundColor=HEX(@"#ffffff");
    self.tableView.tableFooterView=view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellStr =@"nsstasd";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.imageView.image=[UIImage imageNamed:_imageArray[indexPath.row]];
    cell.textLabel.text=_itemaArray[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        UIActionSheet *sheet =[[UIActionSheet alloc]initWithTitle:@"软件分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"新浪分享" otherButtonTitles:@"微信分享",@"短信分享", nil];
        [sheet showInView:self.view];
    }
    if (indexPath.row==1) {
        UIAlertView *alterView =[[UIAlertView alloc]initWithTitle:nil message:@"您确定要清楚缓存吗？清楚缓存会消除本地存储的信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alterView show];
    }if (indexPath.row==3) {
        AboutViewController*about=[[AboutViewController alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }if (indexPath.row==0) {
        [self getUserBanCheck];
    }
}
-(void)getUserBanCheck
{
    
    NSMutableArray *arr=[NSMutableArray array];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"通用版本ios",@"packageName", nil]];
    
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"CheckUpdate"];
    
    __block MoreViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"CheckUpdate" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestAboutVisXMLWithItems:@[item] success:^(id JSON) {
        
        
        [blockSelf GetNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    
}
-(void)GetNewHealthDataAndResultSuccess:(NSString*)string
{
    
    //查看数据格式 你看看 根据格式来判断
    
    NSLog(@"%@",string);
    
    NSDictionary *xmlDic =[NSDictionary dictionaryWithXMLString:string];
    NSDictionary *array=xmlDic[@"soap:Body"][@"CheckUpdateResponse"][@"CheckUpdateResult"][@"data"];
    NSLog(@"%@",array);
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];      //获取项目版本号
    if ([MBNonEmptyStringNo_(array[@"Item"][@"VERSION_CODE"]) integerValue]>[version integerValue]) {
        UIAlertView *alterView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"有新版本更新，前往appStore 下载" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        alterView.tag=9999;
        [alterView show];
    }else
    {
        
        MBAlert(@"此版本是最新的版本");
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==9999) {
        if (buttonIndex==0) {
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com"];
            
            [[UIApplication sharedApplication]openURL:url];
            
        }
    }else{
        if (buttonIndex==0) {
            
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:LOGINREMPAD];
            [[NSUserDefaults standardUserDefaults]setValue:MBNonEmptyStringNo_(@"") forKey:@"organName"];
            [[NSUserDefaults standardUserDefaults]setValue:MBNonEmptyStringNo_(@"") forKey:@"webAddress"];
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:LOGINSTATUS];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [self backViewUPloadView];
        }}
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"gotologing" object:nil];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
        request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        request.shouldOpenWeiboAppInstallPageIfNotInstalled = YES;
        [WeiboSDK sendRequest:request];
        
    }
    if (buttonIndex==1) {
        
        [self sendNewsContent];
    }
    if (buttonIndex==2) {
        Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
        
        
        
        if (messageClass != nil) {
            
            // Check whether the current device is configured for sending SMS messages
            
            if ([messageClass canSendText]) {
                
                [self displaySMSComposerSheet];
                
            }
            
            
        }
        
        
    }
}

-(void)backViewAbout
{
    [_picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller                  didFinishWithResult:(MessageComposeResult)result {
    
    [self backViewAbout];
}
-(void)displaySMSComposerSheet

{
    
    _picker = [[MFMessageComposeViewController alloc] init];
    
    _picker.messageComposeDelegate =self;
    
    NSString *smsBody =@"掌上健康很好用，欢迎下载使用";
    
    _picker.body=smsBody;
    
    [self presentViewController:_picker animated:YES completion:nil];
    
    
}
- (void) sendNewsContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"掌上健康app";
    message.description = @"掌上健康简单应用";
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://view.news.qq.com/zt2012/mdl/index.htm";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    
    [WXApi sendReq:req];
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    
    
    message.text = @"测试通过WeiboSDK发送文字到微博!";
    
    
    return message;
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
    [actionSheet resignFirstResponder];
}
@end
