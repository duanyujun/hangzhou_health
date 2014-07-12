//
//  MBUserTransViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-22.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "MBUserTransViewController.h"
#import "MBConstant.h"
#import "MBIIRequest.h"
//#import <GHUnitIOS/GHUnit.h>
#import "XMLParser.h"
#import "SoapHelper.h"
#import "MBGlobalUICommon.h"
@interface MBUserTransViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation MBUserTransViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr =@"allFoodType";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(60, 5, 210, 30)];
        label.textAlignment=NSTextAlignmentRight;
        label.tag=100;
        label.backgroundColor=[UIColor clearColor];
        [cell addSubview:label];
        
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 30)];
        imageView.tag=101;
        [cell addSubview:imageView];
    }
    NSDictionary*dicOne =_dataArray[indexPath.row];
    NSString *boyIsGir=@"女";
    if ([MBNonEmptyStringNo_(dicOne[@"Sex"]) isEqualToString:@"1"]) {
        boyIsGir=@"男";
    }
    UILabel *labe =(UILabel*)[cell viewWithTag:100];
    NSString *itemName =[NSString stringWithFormat:@"%@        %@         %@",MBNonEmptyStringNo_(dicOne[@"Name"]),boyIsGir,[NSString stringWithFormat:@"%@岁",MBNonEmptyStringNo_(dicOne[@"Age"])]];
    NSLog(@"%@",_dataArray[0]);
    
    labe.text=itemName;
    UIImageView *imageVeiew =(UIImageView*)[cell viewWithTag:101];
    [MBIIRequest getValidationImageForView:imageVeiew withUrlStr:MBNonEmptyString(dicOne[@"HeadImg"])];
    NSLog(@"%@",dicOne[@"HeadImg"]);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];

    NSLog(@"%@",_dataArray[indexPath.row]);
    NSMutableDictionary *userInfo =[NSMutableDictionary dictionaryWithDictionary:[allUserDic allValues][0]];
    NSLog(@"%@",userInfo);

    [userInfo addEntriesFromDictionary:_dataArray[indexPath.row]];
    NSLog(@"%@",userInfo);
    
    NSDictionary *dicSend=@{[allUserDic allKeys][0]: userInfo};
    NSLog(@"%@",dicSend);

    [[NSUserDefaults standardUserDefaults]setObject:dicSend forKey:ALLLOGINPEROPLE];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self backViewUPloadView];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title=@"用户切换";
    
    if (IOS7_OR_LATER) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBtnPressed)];
    }else
    {
        UIButton *btnLeft =[UIButton buttonWithType:UIButtonTypeCustom];
        btnLeft.frame=CGRectMake(0, 0, 40, 40);
        [btnLeft setTitle:@"注销" forState:UIControlStateNormal];
        [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnLeft addTarget:self action:@selector(rightBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    }
    
    self.view.backgroundColor= HEX(@"#ffffff");
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
    _dataArray =[[NSMutableArray alloc]initWithCapacity:2];
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, kContentViewHeight-10) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
    [self GetFamilyInfo];
}
-(void)goToLoginViewAbout
{
    MBNotLogViewController *notLogin =[[MBNotLogViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:notLogin];
    [self presentViewController:nav animated:YES completion:nil];
}
//取家庭成员及其相关信息
-(void)GetFamilyInfo
{
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        [self goToLoginViewAbout];
    }else{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];

    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"customerId", nil]];

    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetFamilyInfo"];
    
    __block MBUserTransViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetFamilyInfo" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        
        NSLog(@"%@",[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]);
        
        
        [blockSelf GetNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    }

}
-(void)GetNewHealthDataAndResultSuccess:(NSString*)string
{
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:string];
    NSLog(@"%@",xmlDoc);
    NSArray *array=xmlDoc[@"soap:Body"][@"GetFamilyInfoResponse"][@"GetFamilyInfoResult"][@"data"][@"style"];
    NSMutableArray *reseDataArray =[NSMutableArray arrayWithCapacity:2];

    if ([array isKindOfClass:[NSArray class]]) {
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic =array[i];
            if (!dic[@"isOrNo"]) {
                [reseDataArray addObject:dic];
            }
        }
    }
    
    if (reseDataArray.count>0) {
        [_dataArray addObjectsFromArray:reseDataArray];
    }else
    {
         MBAlert(@"您暂时没有家庭成员");
    }
    [_tableView reloadData];

}
//返回到上个页面
-(void)backViewUPloadView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//注销按钮
-(void)rightBtnPressed
{

    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"LOGINSTATUS"];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
