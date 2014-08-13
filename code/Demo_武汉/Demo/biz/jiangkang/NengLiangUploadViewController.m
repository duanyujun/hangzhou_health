//
//  XueYaUploadViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-5-10.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "NengLiangUploadViewController.h"
#import "MBTextField.h"
#import "MBBaseScrollView.h"
#import "MBAccessoryView.h"
#import "MBSelectView.h"
#import "SoapHelper.h"
#import "MBIIRequest.h"
#import "NSDateUtilities.h"
@interface NengLiangUploadViewController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,MBAccessoryViewDelegate,UITextFieldDelegate>
{
    UIDatePicker *_picker;
    MBSelectView *_seleView;
    MBTextField*_threeTF;
    MBTextField*_fourTF;
    MBTextField*_fiveTF;
    MBTextField*_sixTF;
    MBBaseScrollView *_baseView;
}
@end

@implementation NengLiangUploadViewController

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
    _baseView=[[MBBaseScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_baseView];
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
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _baseView.frame=CGRectMake(_baseView.frame.origin.x, _baseView.frame.origin.y-50, _baseView.frame.size.width, _baseView.frame.size.height);
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _baseView.frame=CGRectMake(_baseView.frame.origin.x, _baseView.frame.origin.y+50, _baseView.frame.size.width, _baseView.frame.size.height);
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
        MBAlert(@"请输入里程数");
        return;
    }
    if (_fourTF.text.length<1) {
        MBAlert(@"请输入步数");
        return;
    }
    if (_fiveTF.text.length<1) {
        MBAlert(@"请输入能耗");
        return;
    }
    if (_sixTF.text.length<1) {
        MBAlert(@"请输入脂肪消耗");
        return;
    }
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        [self goToLoginViewAbout];
    }else{
        
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"userID", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"paramType", nil]];

    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[_seleView.dateValue dateString],@"testTime", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"OML601",@"hardVender", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"手动输入",@"hardNo", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"OML601",@"computerName", nil]];


    NSString *valueStr =[NSString stringWithFormat:@"<string>%@</string><string>%@</string><string>%@</string><string>%@</string>",_threeTF.text,_fourTF.text,_fiveTF.text,_sixTF.text];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:valueStr,@"value", nil]];

    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"AddHealthData"];
    NSLog(@"%@",soapMsg);
    __block NengLiangUploadViewController *blockSelf = self;
    
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
    [self backViewUPloadView];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"nengliangUploadSuccess" object:nil];
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"nengliangUploadSuccess" object:nil];
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
    [_baseView addSubview:tablevew];
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
    return 5;
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
        cell.textLabel.text=@"里程数:";
        _threeTF.placeholder=@"请输入里程数";

    }if (indexPath.row==2) {
        _fourTF=[[MBTextField alloc]initWithFrame:CGRectMake(40, 10, 270, 30)];
        _fourTF.textAlignment=UITextAlignmentRight;
        _fourTF.keyboardType=UIKeyboardTypeNumberPad;
        _fourTF.font=kNormalTextFont;
        [cell addSubview:_fourTF];
        cell.textLabel.text=@"步数:";
        _fourTF.placeholder=@"请输入步数";

    }if (indexPath.row==3) {
        _fiveTF=[[MBTextField alloc]initWithFrame:CGRectMake(40, 10, 270, 30)];
        _fiveTF.textAlignment=UITextAlignmentRight;
        _fiveTF.keyboardType=UIKeyboardTypeNumberPad;
        _fiveTF.font=kNormalTextFont;
        [cell addSubview:_fiveTF];
        cell.textLabel.text=@"能耗:";
        _fiveTF.placeholder=@"请输入能耗";

    }
    if (indexPath.row==4) {
        _sixTF=[[MBTextField alloc]initWithFrame:CGRectMake(40, 10, 270, 30)];
        _sixTF.textAlignment=UITextAlignmentRight;
        _sixTF.keyboardType=UIKeyboardTypeNumberPad;
        _sixTF.font=kNormalTextFont;
        [cell addSubview:_sixTF];
        _sixTF.delegate=self;
        cell.textLabel.text=@"脂肪消耗:";
        _sixTF.placeholder=@"请输入脂肪消耗";
        
    }
    return cell;
    
}

@end
