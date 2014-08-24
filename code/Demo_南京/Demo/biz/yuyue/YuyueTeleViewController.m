//
//  YuyueTeleViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-29.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "YuyueTeleViewController.h"
#import "MBSelectView.h"
#import "XMLDictionary.h"
#import "MBIIRequest.h"
#import "SoapHelper.h"
#import "NSDateUtilities.h"
#import "NSDateUtilities.h"
#import "XMLDictionary.h"
@interface YuyueTeleViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField*_nameTF;
    UITextField*_telTF;
    UITextField*_noteTF;
    MBSelectView*_timeSele;
    UITextField*_peopleIDTF;
    UITextField*_peopleCountTF;

    
}
@end

@implementation YuyueTeleViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"预约信息";
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

    
   
    
    
    NSString *moblie =[[NSUserDefaults standardUserDefaults]valueForKey:@"MobileNO"];
    
    NSDictionary*allUserDic =[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE][moblie];
    
    NSArray *itemArray =@[@"套餐名称:",@"套餐价格:",@"预约时间:",@"姓名:",@"身份证号:",@"联系电话:",@"人数:",@"备注:"];
    for (int i=0; i<itemArray.count; i++) {
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10+i*40, 80, 35)];
        label.textAlignment=NSTextAlignmentLeft;
        label.text=itemArray[i];
        label.font=kNormalTextFont;
        [self.view addSubview:label];
        if (i==0) {
            NSLog(@"%@",_infoAbout);
            UILabel *value=[[UILabel alloc]initWithFrame:CGRectMake(150, 10+i*40, 170, 35)];
            value.textAlignment=NSTextAlignmentLeft;
            value.text=MBNonEmptyStringNo_(_infoAbout[@"PackageName"]);
            value.font=kNormalTextFont;
            [self.view addSubview:value];
        }
        if (i==1) {
            UILabel *value=[[UILabel alloc]initWithFrame:CGRectMake(150, 10+i*40, 170, 35)];
            value.textAlignment=NSTextAlignmentLeft;
            if (_priceStr.length>=1) {
                value.text=[NSString stringWithFormat:@"￥%@",MBNonEmptyStringNo_(_priceStr)];

            }else{
                value.text=[NSString stringWithFormat:@"￥%@",MBNonEmptyStringNo_(_infoAbout[@"PackagePrice"])];

            }
            value.font=kNormalTextFont;
            [self.view addSubview:value];
        }
        if (i==2) {

            _timeSele =[[MBSelectView alloc]initWithFrame:CGRectMake(150, 15+40*2, 160, 35)];
            _timeSele.dateValue=[[NSDate date]daysLater:1];

            _timeSele.minDate=[[NSDate date]daysLater:1];
            [_timeSele setSelectedDate:[[NSDate date]daysLater:1]];
            _timeSele.selectType=MBSelectTypeDate;
            [self.view addSubview:_timeSele];
            
        }
        if (i==1+2) {
            _nameTF=[[UITextField alloc]initWithFrame:CGRectMake(160, 10+40+40*2, 160, 35)];
            _nameTF.placeholder=@"请输入预约姓名";
            _nameTF.delegate=self;

            if (![MBNonEmptyStringNo_(allUserDic[@"Name"]) isEqualToString:@""]) {
                _nameTF.text=MBNonEmptyStringNo_(allUserDic[@"Name"]);
            }
            [self.view addSubview:_nameTF];
        }if (i==4) {
            _peopleIDTF=[[UITextField alloc]initWithFrame:CGRectMake(160, 10+40+40+40*2, 160, 35)];
            _peopleIDTF.returnKeyType=UIReturnKeyDone;
            _peopleIDTF.keyboardAppearance=UIKeyboardAppearanceDefault;//键盘外观
            _peopleIDTF.placeholder=@"请输入身份证";
            _peopleIDTF.delegate=self;

            
            [self.view addSubview:_peopleIDTF];
        }if (i==5) {
            _telTF=[[UITextField alloc]initWithFrame:CGRectMake(160, 10+40+40+40*3, 160, 35)];
            _telTF.placeholder=@"请输入联系电话";
            _telTF.returnKeyType=UIReturnKeyDone;
            _telTF.keyboardType=UIKeyboardTypeNumberPad;
            _telTF.keyboardAppearance=UIKeyboardAppearanceDefault;//键盘外观
            _telTF.delegate=self;
            
            if (![MBNonEmptyStringNo_(allUserDic[@"MobileNO"]) isEqualToString:@""]) {
                _telTF.text=MBNonEmptyStringNo_(allUserDic[@"MobileNO"]);
            }
            
            [self.view addSubview:_telTF];
        }if (i==6) {
            _peopleCountTF=[[UITextField alloc]initWithFrame:CGRectMake(160, 10+40+40+40*4, 160, 35)];
            _peopleCountTF.returnKeyType=UIReturnKeyDone;
            _peopleCountTF.keyboardType=UIKeyboardTypeNumberPad;
            _peopleCountTF.keyboardAppearance=UIKeyboardAppearanceDefault;//键盘外观
            _peopleCountTF.placeholder=@"请输入预约人数";
            _peopleCountTF.delegate=self;

          
            [self.view addSubview:_peopleCountTF];
        }if (i==7) {
            _noteTF=[[UITextField alloc]initWithFrame:CGRectMake(160, 10+40+40+40+40*4, 160, 35)];
            _noteTF.placeholder=@"请输入备注";
            _noteTF.delegate=self;
            [self.view addSubview:_noteTF];
        }
    }
 
    for (int i=1; i<5+2+2; i++) {
        UIImageView *iameg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10+i*38, 300, 1)];
        iameg.backgroundColor=kTipTextColor;
        [self.view addSubview:iameg];
    }
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_red_big_xiayibu.png"] forState:UIControlStateNormal];
    [btn setTitle:@"确定预约" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(yueyuBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(10, 200+80*2, 300, 40);
    [self.view addSubview:btn];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    [_nameTF resignFirstResponder];
    [_telTF resignFirstResponder];
    [_noteTF resignFirstResponder];
    [_timeSele resignFirstResponder];
    [_peopleIDTF resignFirstResponder];
    [_peopleCountTF resignFirstResponder];
    [_telTF resignFirstResponder];
}
//确定预约
-(void)yueyuBtnPressed
{
    if (_peopleIDTF.text.length!=18) {
        MBAlert(@"身份格式不正确");
        return;
    }
    if (_telTF.text.length!=11) {
        MBAlert(@"手机格式不正确");
        return;
    }
    
    NSMutableArray *arr=[NSMutableArray array];

    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    NSLog(@"%@",allUserDic);
    
    NSString *recodePO = [NSString stringWithFormat:@"<PackageName>%@</PackageName><PackagePrice>%@</PackagePrice><PackageSex>%@</PackageSex><PackageExplain>%@</PackageExplain><YuYueDate>%@</YuYueDate><Name>%@</Name><Sex>%@</Sex><Mobile>%@</Mobile><CardNo>%@</CardNo><Persons>%@</Persons><Company></Company><Remark>%@</Remark><Source>3</Source>",MBNonEmptyStringNo_(_infoAbout[@"PackageName"]),MBNonEmptyStringNo_(_infoAbout[@"PackagePrice"]),MBNonEmptyStringNo_(_infoAbout[@"PackageSex"]),MBNonEmptyStringNo_(_infoAbout[@"PackageExplain"]),MBNonEmptyStringNo_([_timeSele.dateValue dateString]),MBNonEmptyStringNo_(_nameTF.text),MBNonEmptyStringNo_([allUserDic allValues][0][@"Sex"]),MBNonEmptyStringNo_(_telTF.text),MBNonEmptyStringNo_(_peopleIDTF.text),MBNonEmptyStringNo_(_peopleCountTF.text),MBNonEmptyStringNo_(_noteTF.text)];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(recodePO),@"recordPO", nil]];

    
    NSString *YYDetail;
    for (int i=0; i<_dataAllArray.count; i++) {
        NSDictionary *dicOnfOut =_dataAllArray[i];
        NSArray *childItemArray = dicOnfOut[@"ChildItem"];
        if ([childItemArray isKindOfClass:[NSArray class]]) {
            for (int j=0; j<childItemArray.count; j++) {
                NSArray *dicOnfOfAllArray =childItemArray[j];

                if ([dicOnfOfAllArray isKindOfClass:[NSArray class]]) {
                    for (int k=0; k<dicOnfOfAllArray.count; k++) {
                        NSDictionary *dicOnf =dicOnfOfAllArray[k];
                        NSLog(@"%@",dicOnf);
                        if (!YYDetail) {
                            YYDetail =[NSString stringWithFormat:@"<YYDetail><TJ_Code>%@</TJ_Code><TJ_Name>%@</TJ_Name><TJ_Price>%@</TJ_Price><TJ_Explain>%@</TJ_Explain><TJ_OrderID>%@</TJ_OrderID></YYDetail>",MBNonEmptyStringNo_(dicOnf[@"TJ_Code"]),MBNonEmptyStringNo_(dicOnf[@"TJ_Name"]),MBNonEmptyStringNo_(dicOnf[@"TJ_Price"]),MBNonEmptyStringNo_(dicOnf[@"TJ_Explain"]),MBNonEmptyStringNo_(dicOnf[@"TJ_OrderID"])];
                        }else
                        {
                            YYDetail =[NSString stringWithFormat:@"%@<YYDetail><TJ_Code>%@</TJ_Code><TJ_Name>%@</TJ_Name><TJ_Price>%@</TJ_Price><TJ_Explain>%@</TJ_Explain><TJ_OrderID>%@</TJ_OrderID></YYDetail>",YYDetail,MBNonEmptyStringNo_(dicOnf[@"TJ_Code"]),MBNonEmptyStringNo_(dicOnf[@"TJ_Name"]),MBNonEmptyStringNo_(dicOnf[@"TJ_Price"]),MBNonEmptyStringNo_(dicOnf[@"TJ_Explain"]),MBNonEmptyStringNo_(dicOnf[@"TJ_OrderID"])];
                        }
                        
                    }
                }
                


                
            }
           
            
        }
    }
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(YYDetail),@"details", nil]];

    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"AddYuYueRecord"];
    NSLog(@"%@",soapMsg);
    __block YuyueTeleViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"AddYuYueRecord" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf AddReservationBodycheckSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
       
        [blockSelf AddReservationBodycheckSuccess:@""];

    }];

}
-(void)AddReservationBodycheckSuccess:(NSString *)string
{
    MBAlertWithDelegate(@"预约成功", self);

    return;
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:string];
    NSLog(@"1111=====%@",xmlDoc);
    if ([MBNonEmptyStringNo_(xmlDoc[@"soap:Body"][@"AddReservationBodycheckResponse"][@"AddReservationBodycheckResult"]) isEqualToString:@"1"]) {
        MBAlertWithDelegate(@"预约成功", self);

    }else
    {
        MBAlert(@"未成功预约,请重新预约");
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self backViewUPloadView];
}
//返回到上个页面
-(void)backViewUPloadView
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
