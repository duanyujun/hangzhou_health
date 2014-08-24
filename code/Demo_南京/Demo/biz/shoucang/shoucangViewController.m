//
//  SysTemMessageViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-29.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "shoucangViewController.h"
#import "MBIIRequest.h"
#import "XMLDictionary.h"
#import "SoapHelper.h"
#import "AppDelegate.h"
#import "ShocCanDetailViewController.h"
#import "MBAlertView.h"
@interface shoucangViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    int _startIndex;
    NSMutableArray *_dataArray;
    UITableView *_tableView ;
    BOOL _isShowMore;//yes ==加载更多
    UIButton*_tableViewFoodBtn;//加载更多按钮
    NSInteger _deleIndexAboutArray;

}
@end

@implementation shoucangViewController

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
    self.title=@"资讯收藏";
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

    
    _dataArray =[[NSMutableArray alloc]init];
    _startIndex =0;
    _isShowMore=NO;
    
    UIView *BgView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, kScreenHeight)];
    BgView.backgroundColor=HEX(@"#ffffff");
    [self.view addSubview:BgView];
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, kContentViewHeight) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [BgView addSubview:_tableView];
    
    _tableViewFoodBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _tableViewFoodBtn.frame=CGRectMake(0, 0, 320, 40);
    _tableViewFoodBtn.backgroundColor=[UIColor clearColor];
    [_tableViewFoodBtn addTarget:self action:@selector(loadMoreAboutdata) forControlEvents:UIControlEventTouchUpInside];
    [_tableViewFoodBtn setTitle:@"加载更多数据" forState:UIControlStateNormal];
    [_tableViewFoodBtn setTitleColor:kNormalTextColor forState:UIControlStateNormal];
    _tableView.tableFooterView=_tableViewFoodBtn;
    [self getUserData];

    
}
//返回到上个页面
-(void)backViewUPloadView
{
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goToLoginViewAbout
{
    MBNotLogViewController *notLogin =[[MBNotLogViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:notLogin];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)getUserData
{
    
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        [self goToLoginViewAbout];
    }else{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    
    NSMutableArray *arr=[NSMutableArray array];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",_startIndex],@"startIndex", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",_startIndex+10],@"endIndex", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"userID", nil]];

    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetMissionaryArticleForCollect"];
    
    __block shoucangViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetMissionaryArticleForCollect" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
       
        [blockSelf GetNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];

        
    } failure:^(NSError *error, id JSON) {
        
    }];
    }
}

-(void)GetNewHealthDataAndResultSuccess:(NSString *)string
{
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:string];
    
    NSArray *array=xmlDoc[@"soap:Body"][@"GetMissionaryArticleForCollectResponse"][@"GetMissionaryArticleForCollectResult"][@"data"][@"style"];

    if ([array isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *reseDataArray =[NSMutableArray arrayWithCapacity:2];
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic =array[i];
            if (!dic[@"isOrNo"]) {
                [reseDataArray addObject:dic];
            }
        }
        if (reseDataArray.count==0) {
            _isShowMore=NO;
            [_tableViewFoodBtn setTitle:@"暂无更多数据" forState:UIControlStateNormal];
            _tableViewFoodBtn.userInteractionEnabled=NO;
            
        }else
        {
            [_dataArray addObjectsFromArray:reseDataArray];
            _isShowMore=YES;
            [_tableViewFoodBtn setTitle:@"加载更多数据" forState:UIControlStateNormal];
            _tableViewFoodBtn.userInteractionEnabled=YES;
            
        }
        if (reseDataArray.count<10) {
            _isShowMore=NO;

            [_tableViewFoodBtn setTitle:@"暂无更多数据" forState:UIControlStateNormal];
            _tableViewFoodBtn.userInteractionEnabled=NO;

        }
        _tableView.tableFooterView=nil;
        _tableView.tableFooterView=_tableViewFoodBtn;
        [_tableView reloadData];
    }
    else
    {
        [_tableViewFoodBtn setTitle:@"暂无更多数据" forState:UIControlStateNormal];
        _tableViewFoodBtn.userInteractionEnabled=NO;
        _isShowMore=NO;
        [_tableView reloadData];
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    static NSString *cellStr =@"_isShowMore";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text=MBNonEmptyStringNo_(_dataArray[indexPath.row][@"articleTitle"]);
    cell.textLabel.font=kNormalTextFont;
    cell.textLabel.textColor=kNormalTextColor;
    cell.detailTextLabel.text=MBNonEmptyStringNo_(_dataArray[indexPath.row][@"createTime"]);
    cell.detailTextLabel.font=kSmallTitleFont;
    cell.detailTextLabel.textColor=kStepViewTextColor;
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [longPressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [longPressGestureRecognizer setMinimumPressDuration:1.0f];
    [longPressGestureRecognizer setAllowableMovement:50.0];
    [cell addGestureRecognizer:longPressGestureRecognizer];
    cell.tag=indexPath.row;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
}
-(void)gestureRecognizerHandle:(UILongPressGestureRecognizer*)longgest
{
    UITableViewCell *cell=(UITableViewCell*)[longgest view];
    _deleIndexAboutArray=cell.tag;
    MBAlertView *alterView =[[MBAlertView alloc]initWithTitle:Nil message:@"确定删除此资讯吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alterView.tag=10004;
    [alterView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10004) {
        if (buttonIndex==1) {
            
            NSLog(@"%@",_dataArray[_deleIndexAboutArray]);
            [self deleteAboutNews];
           
            
        }
    }
}
-(void)deleteAboutNews
{
    
    
    NSDictionary *deleInfo =_dataArray[_deleIndexAboutArray];
    NSMutableArray *arr=[NSMutableArray array];
    
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(deleInfo[@"collectID"]),@"articleID", nil]];

    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"DeleteCollectMissionaryArticle"];
    NSLog(@"%@",soapMsg);
    
    __block shoucangViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"DeleteCollectMissionaryArticle" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        
        [blockSelf deleNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    

}
-(void)deleNewHealthDataAndResultSuccess:(NSString *)str
{
    NSLog(@"%@",str);
    [_dataArray removeObjectAtIndex:_deleIndexAboutArray];
    _deleIndexAboutArray=0;
    [_tableView reloadData];
}
-(void)loadMoreAboutdata
{
    _startIndex+=10;
    [self getUserData];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShocCanDetailViewController *xueYa =[[ShocCanDetailViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:xueYa];
    xueYa.dicAboutInfo=_dataArray[indexPath.row];
    AppDelegate *appDele =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDele.tabBarController presentViewController:nav animated:YES completion:nil];
}

@end
