//
//  MBPersonSetPadViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-25.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "MBPersonSetPadViewController.h"
#import "MBTextField.h"
#import "MBIIRequest.h"
#import "SoapHelper.h"
@interface MBPersonSetPadViewController ()<UIAlertViewDelegate>

{
    MBTextField*_oldPadTF;
    MBTextField*_newPadTF;
    MBTextField*_agagNewPadTF;
}
@end

@implementation MBPersonSetPadViewController

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additionl setup after loading the view.
    self.title=@"修改密码";
    self.view.backgroundColor =HEX(@"#ffffff");
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
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

    
    _oldPadTF =[[MBTextField alloc]initWithFrame:CGRectMake(10, 10, 300, 40)];
    _oldPadTF.borderStyle = UITextBorderStyleRoundedRect;
    _oldPadTF.secureTextEntry=YES;
    _oldPadTF.placeholder=@"请输入旧密码";
    [self.view addSubview:_oldPadTF];
    
    
    _newPadTF =[[MBTextField alloc]initWithFrame:CGRectMake(10, 53, 300, 40)];
    _newPadTF.borderStyle = UITextBorderStyleRoundedRect;
    _newPadTF.placeholder=@"请输入新密码";
    _newPadTF.secureTextEntry=YES;
    [self.view addSubview:_newPadTF];
    
    
    _agagNewPadTF =[[MBTextField alloc]initWithFrame:CGRectMake(10, 96, 300, 40)];
    _agagNewPadTF.borderStyle = UITextBorderStyleRoundedRect;
    _agagNewPadTF.placeholder=@"请确认密码";
    _agagNewPadTF.secureTextEntry=YES;
    [self.view addSubview:_agagNewPadTF];
    
    if (IOS7_OR_LATER) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(submitPad)];
    }else
    {
        UIButton *btnLeft =[UIButton buttonWithType:UIButtonTypeCustom];
        btnLeft.frame=CGRectMake(0, 0, 40, 40);
        [btnLeft setTitle:@"提交" forState:UIControlStateNormal];
        [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnLeft addTarget:self action:@selector(submitPad) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    }
    
    
}

-(void)submitPad
{
    if (_oldPadTF.text.length==0) {
        MBAlert(@"请输入旧密码");
        return;
    }
    if (_newPadTF.text.length==0) {
        MBAlert(@"请输入新密码");
        return;
    }if (_agagNewPadTF.text.length==0) {
        MBAlert(@"请确认密码");
        return;
    }
    
    NSMutableDictionary *allUserDic =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE]];
    NSString *loginName = [[NSUserDefaults standardUserDefaults]valueForKey:@"MobileNO"];
    NSDictionary *useInfo=[allUserDic valueForKey:loginName];
    
    if (![_oldPadTF.text isEqualToString:MBNonEmptyStringNo_(useInfo[@"Password"])]) {
        MBAlert(@"旧密码不正确");
        return;
    }
    if (![_newPadTF.text isEqualToString:_agagNewPadTF.text]) {
        MBAlert(@"确认密码与新密码不一致，请重新输入");
        return;
        

    }
    [self UpdatePassWord];
    
    
    
}
-(void)goToLoginViewAbout
{
    MBNotLogViewController *notLogin =[[MBNotLogViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:notLogin];
    [self presentViewController:nav animated:YES completion:nil];
}
/// 修改密码
-(void)UpdatePassWord
{
    
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        [self goToLoginViewAbout];
    }else{
    NSMutableDictionary *allUserDic =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE]];
    NSString *loginName = [[NSUserDefaults standardUserDefaults]valueForKey:@"MobileNO"];
    NSDictionary *useInfo=[allUserDic valueForKey:loginName];
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(useInfo[@"UserID"]),@"userID", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(_agagNewPadTF.text),@"newPassword", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(_oldPadTF.text),@"oldPassword", nil]];

    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"UpdatePassWord"];
    
    __block MBPersonSetPadViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"UpdatePassWord" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        
        NSLog(@"%@",[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]);
        
        
        [blockSelf UpdatePassWordSUccessBack:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadSUccess" object:nil];
    
    [self dismissViewControllerAnimated:NO completion:^{
        [_sender goToLoginViewAbout];
    }];

}
-(void)UpdatePassWordSUccessBack:(NSString *)string{
    
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:string];
    if ([xmlDoc[@"soap:Body"][@"UpdatePassWordResponse"][@"UpdatePassWordResult"] isEqualToString:@"1"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"LOGINSTATUS"];

        MBAlertWithDelegate(@"密码修改成功",self);

        NSMutableDictionary *allUserDic =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE]];
        NSString *loginName = [[NSUserDefaults standardUserDefaults]valueForKey:@"MobileNO"];
        NSMutableDictionary *useInfo=[NSMutableDictionary dictionaryWithDictionary:[allUserDic valueForKey:loginName]];
        [useInfo setValue:_newPadTF.text forKey:@"Password"];
        [allUserDic setValue:useInfo forKey:loginName];

        [[NSUserDefaults standardUserDefaults] setValue:allUserDic forKey:ALLLOGINPEROPLE];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
    }else{
        MBAlert(@"密码修改失败，请重新修改");
    }
    
}
@end
