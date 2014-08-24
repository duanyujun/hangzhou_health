//
//  MBNotLogViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-21.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "MBNotLogViewController.h"
#import "MBConstant.h"
#import "UIColorAdditions.h"
#import "MBTextField.h"
#import "AFHTTPClient.h"
#import "AFXMLRequestOperation.h"
#import "MBIIRequest.h"
#import "SoapHelper.h"
#import <GHUnitIOS/GHUnit.h>
#import "XMLParser.h"
#import "MBSelectView.h"
#import "MBGlobalUICommon.h"
#define kCheckBoxSelectImage [UIImage imageNamed:@"gouxuan_yes.png"]
#define kCheckBoxUnSelectImage [UIImage imageNamed:@"gouxuan_no.png"]
@interface MBNotLogViewController ()<UITextFieldDelegate,NSXMLParserDelegate,NSXMLParserDelegate>
{
    UITextField *_moblieTF;
    UITextField *_pasTF;
    NSString *_userType;
    NSString *_webAddress;
    BOOL _isRemPad;
}
@end

@implementation MBNotLogViewController

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MBGETJIGOUINFO object:nil];
}
-(void)getJigoutCiyt:(NSNotification*)noc
{
    NSDictionary *dic=(NSDictionary*)[noc object];
    NSLog(@"%@",dic);
    _webAddress=MBNonEmptyStringNo_(dic[@"webAddress"]);
    [[NSUserDefaults standardUserDefaults]setValue:MBNonEmptyStringNo_(dic[@"organName"]) forKey:@"organName"];
    [[NSUserDefaults standardUserDefaults]setValue:MBNonEmptyStringNo_(_webAddress) forKey:@"webAddress"];
    
}
-(void)getWebService
{
    
    NSMutableArray *arr=[NSMutableArray array];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(ORGANIZATIONNAME),@"organName", nil]];
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetWebServiceAddress"];
    
    __block MBNotLogViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetWebServiceAddress" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestAboutVisXMLWithItems:@[item] success:^(id JSON) {
        
        
        NSLog(@"%@",[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]);
        [blockSelf getWebServiceResult:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
    } failure:^(NSError *error, id JSON) {
        
    }];

}
-(void)getWebServiceResult:(NSString*)string
{
    NSDictionary *xmlDic = [NSDictionary dictionaryWithXMLString:string];
    _webAddress = MBNonEmptyStringNo_(xmlDic[@"soap:Body"][@"GetWebServiceAddressResponse"][@"GetWebServiceAddressResult"]);
    [[NSUserDefaults standardUserDefaults]setValue:MBNonEmptyStringNo_(_webAddress) forKey:@"webAddress"];
    NSLog(@"11111=====%@",_webAddress);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
    [self getWebService];
    
    _webAddress=@"";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getJigoutCiyt:) name:MBGETJIGOUINFO object:nil];
    
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

    _userType = @"1";

    UIImageView *iamgeView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 220)];
    iamgeView.image=[UIImage imageNamed:@"loginBG.png"];
    [self.view addSubview:iamgeView];
    self.view.backgroundColor=HEX(@"#ffffff");
    self.title=@"用户登录";
    
    UIImageView *moble =[[UIImageView alloc]initWithFrame:CGRectMake(41, 110, 238, 40)];
    moble.image=[UIImage imageNamed:@"loginText.png"];
    [self.view addSubview:moble];
    

    _webAddress=MBNonEmptyString([[NSUserDefaults standardUserDefaults]valueForKey:@"webAddress"]);
   
    _moblieTF =[[UITextField alloc]initWithFrame:CGRectMake(55, moble.frame.origin.y, moble.frame.size.width, moble.frame.size.height)];
    _moblieTF.placeholder =@"请输入登录名";
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    NSLog(@"%@",allUserDic);
    NSString *loginName = [allUserDic allValues][0][@"UserName"];
    
    
    if (![MBNonEmptyStringNo_(loginName) isEqualToString:@""]) {
        _moblieTF.text = loginName;
    }
    _moblieTF.delegate=self;
    _moblieTF.font=[UIFont fontWithName:@"Helvetica Neue" size:16];
    [self.view addSubview:_moblieTF];
    
    UIImageView *moblepasd =[[UIImageView alloc]initWithFrame:CGRectMake(41, 165, 238, 40)];
    moblepasd.image=[UIImage imageNamed:@"loginText.png"];
    [self.view addSubview:moblepasd];
    
    _pasTF =[[UITextField alloc]initWithFrame:CGRectMake(55, moblepasd.frame.origin.y, moble.frame.size.width, moble.frame.size.height)];
    _pasTF.secureTextEntry=YES;
    _pasTF.placeholder =@"请输入密码";
    _pasTF.delegate=self;
    _pasTF.font=[UIFont fontWithName:@"Helvetica Neue" size:16];
    NSString *pad=MBNonEmptyStringNo_([[NSUserDefaults standardUserDefaults]valueForKey:LOGINREMPADPadAbout]);
    NSLog(@"%@",pad);
    if (pad.length>1) {
        _pasTF.text=pad;
    }
    [self.view addSubview:_pasTF];
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnLogin.png"] forState:UIControlStateNormal];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(userLoginBtnpressed:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.textColor=kNormalTextColor;
    btn.frame = CGRectMake(41, 230, 238, 40);
    [self.view addSubview:btn];
    
    UIButton *btnUser =[UIButton buttonWithType:UIButtonTypeCustom];
    [btnUser setBackgroundImage:[UIImage imageNamed:@"userName.png"] forState:UIControlStateNormal];
    btnUser.frame = CGRectMake(41, 290, 24, 24);
    [btnUser addTarget:self action:@selector(btnUserBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnUser];
    
    UIButton *btnUserTxt =[UIButton buttonWithType:UIButtonTypeCustom];
    btnUserTxt.frame = CGRectMake(60, 290, 100, 24);
    [btnUserTxt setTitle:@"用户体检" forState:UIControlStateNormal];
    [btnUserTxt setTitle:@"用户体检" forState:UIControlStateHighlighted];
    [btnUserTxt setTitleColor:kNormalTextColor forState:UIControlStateNormal];
    btnUserTxt.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:17];
    btnUserTxt.titleLabel.text=@"用户体检";
    btnUserTxt.titleLabel.textColor=kNormalTextColor;

    [btnUserTxt addTarget:self action:@selector(btnUserBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnUserTxt];

    
    UIButton *btnMoble =[UIButton buttonWithType:UIButtonTypeCustom];
    [btnMoble setBackgroundImage:[UIImage imageNamed:@"mobile.png"] forState:UIControlStateNormal];
    btnMoble.frame = CGRectMake(170, 290, 24, 24);
    [btnMoble addTarget:self action:@selector(btnMobleTxtPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btnMoble];
    
    UIButton *btnMobleTxt =[UIButton buttonWithType:UIButtonTypeCustom];
    btnMobleTxt.frame = CGRectMake(190, 290, 100, 24);
    [btnMobleTxt setTitle:@"手机用户" forState:UIControlStateNormal];
    [btnMobleTxt setTitleColor:kNormalTextColor forState:UIControlStateNormal];
    btnMobleTxt.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:17];
    [btnMobleTxt addTarget:self action:@selector(btnMobleTxtPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnMobleTxt setTitle:@"手机用户" forState:UIControlStateHighlighted];

    btnMobleTxt.titleLabel.textColor=kNormalTextColor;
    [self.view addSubview:btnMobleTxt];
    
    _isRemPad =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINREMPAD] boolValue];
    
    

    if (!IOS7_OR_LATER) {
        _moblieTF.frame=CGRectMake(_moblieTF.frame.origin.x, _moblieTF.frame.origin.y+10, _moblieTF.frame.size.width, _moblieTF.frame.size.height);
        _pasTF.frame=CGRectMake(_pasTF.frame.origin.x, _pasTF.frame.origin.y+10, _pasTF.frame.size.width, _pasTF.frame.size.height);
        [btnUserTxt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btnMobleTxt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_moblieTF]) {
        [_pasTF becomeFirstResponder];
    }else{
    [textField resignFirstResponder];
    }
    return YES;
}
//手机用户
-(void)btnMobleTxtPressed:(UIButton *)btn
{
    _userType = @"2";
    _moblieTF.placeholder =@"请输入手机号码";
    if(_pasTF.text.length>0){
        [self getLoad];
    }

}
//用户体验
-(void)btnUserBtnPressed:(UIButton*)btn
{
    _userType = @"1";
    _moblieTF.placeholder =@"请输入登录名";
    if(_pasTF.text.length>0){
       [self getLoad];
    }
 

}
//用户登录
- (void)userLoginBtnpressed:(UIButton*)btn
{
    if(_pasTF.text.length>0&&_moblieTF.text.length>0){
        [self getLoad];
    }else{
        MBAlert(@"请输入用户名或密码");
    }
}

-(void)getLoad
{

    [_moblieTF resignFirstResponder];
    [_pasTF resignFirstResponder];
    
    if (_webAddress.length<=0) {
        [self getWebService];
        
    }else{
   
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(_moblieTF.text),@"loginName", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(_pasTF.text),@"loginPwd", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(_userType), @"type",nil]];
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"CheckLoginInfo"];
    
    __block MBNotLogViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"CheckLoginInfo" params:@{@"soapMessag":soapMsg}];
    
   [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
       
       
       NSLog(@"%@",[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]);

       XMLParser *xmlParser = [[XMLParser alloc] init];
       
       [xmlParser parseData:JSON
                    success:^(id parsedData) {
                        
                        NSDictionary *send=(NSDictionary *)parsedData;
                        [blockSelf getUerInfo:send];
                    }
                    failure:^(NSError *error) {
                    }];
       
       
   } failure:^(NSError *error, id JSON) {
//       MBAlert(@"请确定你选择的机构是否开通此项服务");

   }];
    
    }

}
-(void)getUerInfo:(NSDictionary *)dic
{
    
    
    NSMutableDictionary *allUserDic =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE]];
    if (!allUserDic) {
        allUserDic=[[NSMutableDictionary alloc]initWithCapacity:2];
    }else
    {   if([allUserDic allKeys].count>0){
        [allUserDic removeAllObjects];
    }
    }
    NSArray *resutlArray = dic[@"soap:Envelope"][@"soap:Body"][@"CheckLoginInfoResponse"][@"CheckLoginInfoResult"][@"data"][@"stylesArray"];
    NSLog(@"%@",resutlArray);
    if (resutlArray.count>1) {
        
        NSString *MobileNO= MBNonEmptyStringNo_(dic[@"soap:Envelope"][@"soap:Body"][@"CheckLoginInfoResponse"][@"CheckLoginInfoResult"][@"data"][@"stylesArray"][1][@"MobileNO"][@"content"]);
        
        NSString *HeadImg= MBNonEmptyStringNo_(dic[@"soap:Envelope"][@"soap:Body"][@"CheckLoginInfoResponse"][@"CheckLoginInfoResult"][@"data"][@"stylesArray"][1][@"HeadImg"][@"content"]);
        
        NSString *Name= MBNonEmptyStringNo_(dic[@"soap:Envelope"][@"soap:Body"][@"CheckLoginInfoResponse"][@"CheckLoginInfoResult"][@"data"][@"stylesArray"][1][@"Name"][@"content"]);
        
        NSString *Password= MBNonEmptyStringNo_(dic[@"soap:Envelope"][@"soap:Body"][@"CheckLoginInfoResponse"][@"CheckLoginInfoResult"][@"data"][@"stylesArray"][1][@"Password"][@"content"]);
        
        NSString *Sex= MBNonEmptyStringNo_(dic[@"soap:Envelope"][@"soap:Body"][@"CheckLoginInfoResponse"][@"CheckLoginInfoResult"][@"data"][@"stylesArray"][1][@"Sex"][@"content"]);
        
        NSString *UserID= MBNonEmptyStringNo_(dic[@"soap:Envelope"][@"soap:Body"][@"CheckLoginInfoResponse"][@"CheckLoginInfoResult"][@"data"][@"stylesArray"][1][@"UserID"][@"content"]);
        
        NSString *UserName= MBNonEmptyStringNo_(dic[@"soap:Envelope"][@"soap:Body"][@"CheckLoginInfoResponse"][@"CheckLoginInfoResult"][@"data"][@"stylesArray"][1][@"UserName"][@"content"]);
        
        
        NSDictionary *loginInfo =@{MBNonEmptyStringNo_(MobileNO):@{@"MobileNO": MobileNO,@"HeadImg": HeadImg,@"Name": Name,@"Password": Password,@"Sex": Sex,@"UserID": UserID,@"UserName": UserName,}};
        
        if ([allUserDic allKeys].count==0) {
            
            [allUserDic addEntriesFromDictionary:loginInfo];
            
        }else{
            for (int i=0; i<[allUserDic allKeys].count; i++) {
                
                if ([[allUserDic allKeys][i] isEqualToString:MobileNO]) {
                    
                }else
                {
                    [allUserDic addEntriesFromDictionary:loginInfo];
                    
                }
            }
        }
        [[NSUserDefaults standardUserDefaults]setObject:MobileNO forKey:@"MobileNO"];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"LOGINSTATUS"];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:LOGINREMPAD];
        [[NSUserDefaults standardUserDefaults]setObject:_pasTF.text forKey:LOGINREMPADPadAbout];
        
        
        
        if ([allUserDic allKeys].count>0) {
            [[NSUserDefaults standardUserDefaults]setObject:allUserDic forKey:ALLLOGINPEROPLE];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        MBAlert(@"密码不对，请稍后登录");
    }
   
    
}



@end
