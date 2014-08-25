//
//  XueYaUploadViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-5-10.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "XueTangUploadViewController.h"
#import "MBTextField.h"
#import "MBBaseScrollView.h"
#import "MBAccessoryView.h"
#import "MBSelectView.h"
#import "SoapHelper.h"
#import "MBIIRequest.h"
#import "NSDateUtilities.h"
@interface XueTangUploadViewController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,MBAccessoryViewDelegate>
{
    UIDatePicker *_picker;
    MBSelectView *_seleView;
    MBTextField*_threeTF;
    UITableView *_tablevew;
    BOOL _isCanHou;
}
@end

@implementation XueTangUploadViewController

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
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        [self goToLoginViewAbout];
    }else{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"userID", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"4",@"paramType", nil]];

    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[_seleView.dateValue dateString],@"testTime", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"OML601",@"hardVender", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"手动输入",@"hardNo", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"OML601",@"computerName", nil]];


    if (_isCanHou) {
        NSString *valueStr =[NSString stringWithFormat:@"<string>%@</string><string>%@</string>",@"-1",_threeTF.text];
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:valueStr,@"value", nil]];


    }else
    {
        NSString *valueStr =[NSString stringWithFormat:@"<string>%@</string><string>%@</string>",_threeTF.text,@"-1"];
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:valueStr,@"value", nil]];
    }

    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"AddHealthData"];
    NSLog(@"%@",soapMsg);
    __block XueTangUploadViewController *blockSelf = self;
    
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
    [[NSNotificationCenter defaultCenter]postNotificationName:@"XueTangUploadSuccess" object:nil];

    [self backViewUPloadView];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"XueTangUploadSuccess" object:nil];
}
-(void)oneStepView
{
    CGFloat heig0=8;
    if (IOS7_OR_LATER) {
        heig0=30;
    }
    _tablevew=[[UITableView alloc]initWithFrame:CGRectMake(0, -heig0, kScreenWidth, 250) style:UITableViewStyleGrouped];
    _tablevew.delegate=self;
    _tablevew.dataSource=self;
    _tablevew.scrollEnabled=NO;
    _tablevew.backgroundColor=[UIColor clearColor];
    _tablevew.backgroundView=[[UIView alloc]init];
    [self.view addSubview:_tablevew];
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
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
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

        NSArray *selectArr=@[@"餐前",@"餐后"];
        cell.textLabel.text=@"餐前/餐后:";
        for (NSInteger i=0; i<selectArr.count; i++) {
            UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            selectBtn.frame = CGRectMake(180+i*(20+10+20+20), 7+3, 20, 20);
            if (i==0) {
                [selectBtn setBackgroundImage:[UIImage imageNamed:@"acc_dian_red.png"] forState:UIControlStateNormal];
            }else{
                [selectBtn setBackgroundImage:[UIImage imageNamed:@"acc_dian.png"] forState:UIControlStateNormal];
            }
            selectBtn.tag = 1000+i;
            [selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            [cell addSubview:selectBtn];
            
            UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            nameBtn.frame = CGRectMake(170+30+i*(20+10+20+20), 10, 40, 20);
            nameBtn.tag = 2000+i;
            [nameBtn setTitle:selectArr[i] forState:UIControlStateNormal];
            [nameBtn setTitleColor:kNormalTextColor forState:UIControlStateNormal];
            nameBtn.backgroundColor=[UIColor clearColor];
            nameBtn.titleLabel.font = kButtonTitleFont;
            [cell addSubview:nameBtn];
        }


    }if (indexPath.row==2) {
        _threeTF=[[MBTextField alloc]initWithFrame:CGRectMake(40, 10, 270, 30)];
        _threeTF.textAlignment=UITextAlignmentRight;
        _threeTF.keyboardType=UIKeyboardTypeNumberPad;
        _threeTF.font=kNormalTextFont;
        [cell addSubview:_threeTF];
        cell.textLabel.text=@"血糖:";
        _threeTF.placeholder=@"请输入血糖mmol/L";
        
    }
    return cell;
    
}

- (void)selectBtnAction:(UIButton *)sender
{
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell*cell=[_tablevew cellForRowAtIndexPath:indexPath];
    for (NSInteger i=0; i<2; i++) {
        UIButton *btn = (UIButton *)[cell viewWithTag:1000+i];
        [btn setBackgroundImage:[UIImage imageNamed:@"acc_dian.png"] forState:UIControlStateNormal];
    }
    [sender setBackgroundImage:[UIImage imageNamed:@"acc_dian_red.png"] forState:UIControlStateNormal];
    if (sender.tag==1000) {
        _isCanHou=NO;
    }else
    {
        _isCanHou=YES;
    }
}
@end
