//
//  YuyueTeleViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-29.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "YuyueJiluViewController.h"
#import "MBSelectView.h"
#import "XMLDictionary.h"
#import "MBIIRequest.h"
#import "SoapHelper.h"
#import "NSDateUtilities.h"
#import "YuyuejiLiuAllController.h"
#import "XMLDictionary.h"
@interface YuyueJiluViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField*_nameTF;
    UITextField*_telTF;
}
@end

@implementation YuyueJiluViewController

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
    
    
    self.title=@"预约查询";
    self.view.backgroundColor=HEX(@"#ffffff");

    
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
    


    
    UIView *bgView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, kScreenHeight)];
    bgView.backgroundColor=HEX(@"#ffffff");
    [self.view addSubview:bgView];
    NSString *moblie =[[NSUserDefaults standardUserDefaults]valueForKey:@"MobileNO"];
    
    NSDictionary*allUserDic =[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE][moblie];
    
    NSArray *itemArray =@[@"姓名",@"手机号"];
    for (int i=0; i<itemArray.count; i++) {
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10+i*40, 80, 35)];
        label.textAlignment=NSTextAlignmentLeft;
        label.text=itemArray[i];
        label.font=kNormalTextFont;
        [self.view addSubview:label];
        
        if (i==0) {
            _nameTF=[[UITextField alloc]initWithFrame:CGRectMake(160, 10, 160, 35)];
            _nameTF.placeholder=@"请输入预约姓名";
            _nameTF.delegate=self;

            BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
            if (isLogin) {
            if (![MBNonEmptyStringNo_(allUserDic[@"Name"]) isEqualToString:@""]) {
                _nameTF.text=MBNonEmptyStringNo_(allUserDic[@"Name"]);
            }
            }
            [bgView addSubview:_nameTF];
        }if (i==1) {
            _telTF=[[UITextField alloc]initWithFrame:CGRectMake(160, 10+40, 160, 35)];
            _telTF.placeholder=@"请输入联系电话";
            _telTF.delegate=self;

            BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
            if (isLogin) {
            if (![MBNonEmptyStringNo_(allUserDic[@"MobileNO"]) isEqualToString:@""]) {
                _telTF.text=MBNonEmptyStringNo_(allUserDic[@"MobileNO"]);
            }
            }

            [bgView addSubview:_telTF];
        }
    }
 
    for (int i=1; i<3; i++) {
        UIImageView *iameg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10+i*38, 300, 1)];
        iameg.backgroundColor=kTipTextColor;
        [bgView addSubview:iameg];
    }
    
    if (IOS7_OR_LATER) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"查询" style:UIBarButtonItemStyleBordered target:self action:@selector(yueyuBtnPressed)];
    }else
    {
        UIButton *btnLeft =[UIButton buttonWithType:UIButtonTypeCustom];
        btnLeft.frame=CGRectMake(0, 0, 40, 40);
        [btnLeft setTitle:@"查询" forState:UIControlStateNormal];
        [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnLeft addTarget:self action:@selector(yueyuBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    }
    
    
}

//预约查询
-(void)yueyuBtnPressed
{
    if (_telTF.text.length!=11) {
        MBAlert(@"手机格式不正确");
        return;
    }
    

    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(_nameTF.text),@"name", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(_telTF.text),@"mobile", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",0],@"startIndex", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",10000000],@"endIndex", nil]];

    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetReservationBodycheckList"];
    
    __block YuyueJiluViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetReservationBodycheckList" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf AddReservationBodycheckSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
       

    }];

}
-(void)AddReservationBodycheckSuccess:(NSString *)string
{
    
    NSDictionary *resutlDic =[NSDictionary dictionaryWithXMLString:string][@"soap:Body"][@"GetReservationBodycheckListResponse"][@"GetReservationBodycheckListResult"];
    
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
   


    
    YuyuejiLiuAllController *allview =[[YuyuejiLiuAllController alloc]init];
    allview.resultArray=itemArray;
    [self.navigationController pushViewController:allview animated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self backViewUPloadView];
}
//返回到上个页面
-(void)backViewUPloadView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
