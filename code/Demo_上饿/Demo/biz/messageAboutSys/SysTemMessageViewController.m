//
//  SysTemMessageViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-29.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "SysTemMessageViewController.h"
#import "MBIIRequest.h"
#import "XMLDictionary.h"
#import "SoapHelper.h"
#import "TiJianReprotCell.h"
#import "SystemMessageTableViewCell.h"
@interface SysTemMessageViewController ()<UITableViewDelegate,UITableViewDataSource,TijianReproTcellDelegate,UIAlertViewDelegate>
{
    NSInteger _startIndex;
    NSMutableArray *_dataArray;
    UITableView *_tableView ;
    BOOL _isShowMore;//yes ==加载更多
    UIButton *_tableFoodView;
}
@end

@implementation SysTemMessageViewController

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
    self.title=@"系统消息";
    self.view.backgroundColor=HEX(@"#ffffff");
    
    
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
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
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kContentViewHeight+49)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];

    
    _tableFoodView =[UIButton buttonWithType:UIButtonTypeCustom];
    _tableFoodView.frame=CGRectMake(0, 0, 320, 40);
    [_tableFoodView addTarget:self action:@selector(loadMoreAboutdata) forControlEvents:UIControlEventTouchUpInside];
    [_tableFoodView setTitle:@"加载更多数据" forState:UIControlStateNormal];
    [_tableFoodView setTitleColor:kNormalTextColor forState:UIControlStateNormal];
    _tableFoodView.titleLabel.font=kNormalTextFont;
    _tableView.tableFooterView=_tableFoodView;

    _dataArray =[[NSMutableArray alloc]init];
    _startIndex =0;
    _isShowMore=NO;
    
    [self getSystemNew];
    

    
}
//返回到上个页面
-(void)backViewUPloadView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)goToLoginViewAbout
{
    MBNotLogViewController *notLogin =[[MBNotLogViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:notLogin];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)getSystemNew
{
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        [self goToLoginViewAbout];
    }else{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"userId", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",_startIndex],@"startIndex", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",_startIndex+10],@"endIndex", nil]];
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetPushMessageList"];
    NSLog(@"%@",soapMsg);
    __block SysTemMessageViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetPushMessageList" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        
        [blockSelf GetNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    }
    
}
-(void)GetNewHealthDataAndResultSuccess:(NSString *)string
{
    NSDictionary *dataDic=[NSDictionary dictionaryWithXMLString:string];
    NSLog(@"%@",dataDic);
    
    NSArray *resutlArray = dataDic[@"soap:Body"][@"GetPushMessageListResponse"][@"GetPushMessageListResult"][@"data"][@"pushMessageList"];
    NSLog(@"%@",resutlArray);
    if (!resutlArray) {
        MBAlert(@"暂无更多系统消息");
        _isShowMore=NO;
        return;
    }
    if ([resutlArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *reseDataArray =[NSMutableArray arrayWithCapacity:2];
        for (int i=0; i<resutlArray.count; i++) {
            NSDictionary *dic =resutlArray[i];
            if (!dic[@"isOrNo"]) {
                [reseDataArray addObject:dic];
            }
        }
        if (reseDataArray.count==0) {
            _isShowMore=NO;
        }else
        {
            [_dataArray addObjectsFromArray:reseDataArray];
            _isShowMore=YES;
        }

    }else
    {[_dataArray addObject:resutlArray];
        _isShowMore=NO;
    }
    if (_isShowMore) {
        _tableFoodView.userInteractionEnabled=YES;
        [_tableFoodView setTitle:@"加载更多数据" forState:UIControlStateNormal];
        _tableView.tableFooterView.hidden=NO;


    }else
    {
        _tableFoodView.userInteractionEnabled=NO;
        _tableView.tableFooterView.hidden=YES;
        [_tableFoodView setTitle:@"暂无更多数据" forState:UIControlStateNormal];

    }
        [_tableView reloadData];
    if (_dataArray.count==0) {
        MBAlertWithDelegate(@"暂无系统消息",self);
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self backViewUPloadView];
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
    SystemMessageTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[SystemMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];

        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    [cell setLablVaule:_dataArray[indexPath.row]];
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(void)loadMoreAboutdata
{
    _startIndex+=10;
    [self getSystemNew];
    
}
@end
