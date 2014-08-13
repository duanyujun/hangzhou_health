//
//  XueYaUploadViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-5-10.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "XueYangUploadViewController.h"
#import "MBTextField.h"
#import "MBBaseScrollView.h"
#import "MBAccessoryView.h"
#import "MBSelectView.h"
#import "SoapHelper.h"
#import "MBIIRequest.h"
#import "NSDateUtilities.h"
@interface XueYangUploadViewController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,MBAccessoryViewDelegate>
{
    UIDatePicker *_picker;
    MBSelectView *_seleView;
    MBTextField*_threeTF;
    MBTextField*_fourTF;
}
@end

@implementation XueYangUploadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)backViewUPloadView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"数据上传";
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
        [self.navigationItem.rightBarButtonItem setTintColor:HEX(@"#5ec4fe")];

    }
      self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(uploadData)];
    [self oneStepView];
}

-(void)goToLoginViewAbout
{
    MBNotLogViewController *notLogin =[[MBNotLogViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:notLogin];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)uploadData
{
    if (_threeTF.text.length<1) {
        MBAlert(@"请输入血氧饱和度");
        return;
    }
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        [self goToLoginViewAbout];
    }else{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"userID", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"8",@"paramType", nil]];

    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[_seleView.dateValue dateString],@"testTime", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"OML601",@"hardVender", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"手动输入",@"hardNo", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"OML601",@"computerName", nil]];


    NSString *valueStr =[NSString stringWithFormat:@"<string>%@</string><string>%@</string>",_threeTF.text,_fourTF.text];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:valueStr,@"value", nil]];

    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"AddHealthData"];
    NSLog(@"%@",soapMsg);
    __block XueYangUploadViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"AddHealthData" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf GetNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    }
    
}
-(void)GetNewHealthDataAndResultSuccess:(NSString*)str
{
    NSLog(@"%@",str);
    NSDictionary *dic=[NSDictionary dictionaryWithXMLString:str];
    NSLog(@"%@",dic);
    if ([MBNonEmptyStringNo_(dic[@"soap:Body"][@"AddHealthDataResponse"][@"AddHealthDataResult"]) isEqualToString:@"1"]) {
        MBAlertWithDelegate(@"上传成功", self);
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"XueYangHeloUploadSuccess" object:nil];

    [self backViewUPloadView];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"XueYangHeloUploadSuccess" object:nil];
}
-(void)oneStepView
{
    CGFloat heig0=8;
    if (IOS7_OR_LATER) {
        heig0=30;
    }
    UITableView *tablevew=[[UITableView alloc]initWithFrame:CGRectMake(0, -heig0, kScreenWidth, 250) style:UITableViewStyleGrouped];
    tablevew.delegate=self;
    tablevew.dataSource=self;
    tablevew.scrollEnabled=NO;
    tablevew.backgroundColor=[UIColor clearColor];
    tablevew.backgroundView=[[UIView alloc]init];
    [self.view addSubview:tablevew];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr =@"UITableViewCell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    
    }
    for (id sender in [cell subviews]) {
        if ([sender isKindOfClass:[UITextField class]]) {
            [sender removeFromSuperview];
        }if ([sender isKindOfClass:[MBSelectView class]]) {
            [sender removeFromSuperview];
        }
    }

    cell.textLabel.font=kNormalTextFont;
    if (indexPath.row==0) {
       
        
        cell.textLabel.text=@"测量日期:";
        
        
        
        _seleView=[[MBSelectView alloc]initWithFrame:CGRectMake(210, 10, 180, 30)];
        _seleView.selectType=MBSelectTypeDate;
        _seleView.tag=100000;
        _seleView.value=@"请选择日期";
        [cell addSubview:_seleView];
        
          }
    if (indexPath.row==1) {
        _threeTF=[[MBTextField alloc]initWithFrame:CGRectMake(40, 10, 270, 30)];
        _threeTF.textAlignment=UITextAlignmentRight;
        _threeTF.keyboardType=UIKeyboardTypeNumberPad;
        _threeTF.font=kNormalTextFont;
        [cell addSubview:_threeTF];
        cell.textLabel.text=@"血氧饱和度:";
        _threeTF.placeholder=@"请输入血氧饱和度%";

    }if (indexPath.row==2) {
        _fourTF=[[MBTextField alloc]initWithFrame:CGRectMake(40, 10, 270, 30)];
        _fourTF.textAlignment=UITextAlignmentRight;
        _fourTF.keyboardType=UIKeyboardTypeNumberPad;
        _fourTF.font=kNormalTextFont;
        [cell addSubview:_fourTF];
        cell.textLabel.text=@"脉搏:";
        _fourTF.placeholder=@"请输入脉搏";

    }
    return cell;
    
}

@end
