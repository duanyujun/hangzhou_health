//
//  ShanShiTuijianViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-30.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "ShanShiTuijianViewController.h"
#import "SoapHelper.h"
#import "MBIIRequest.h"
#import "TiJianReprotCell.h"
#import "MBLabel.h"
@interface ShanShiTuijianViewController ()<UITableViewDataSource,UITableViewDelegate,TijianReproTcellDelegate>
{
    MBLabel *_zaoCanlbl;
    MBLabel *_zhongcanlbl;
    MBLabel *_wancanlbl;
    
    UILabel *_dataLbl;
    UILabel *_xingqilbl;
    
    
    NSInteger _startIndex;
    NSMutableArray *_dataArray;
    UITableView *_tableView ;
    BOOL _isShowMore;//yes ==加载更多
}
@end

@implementation ShanShiTuijianViewController

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
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"膳食推荐";
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

    _dataArray=[[NSMutableArray alloc]initWithCapacity:2];
    
    UIView *bgView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, kScreenHeight)];
    bgView.backgroundColor=HEX(@"#ffffff");
    [self.view addSubview:bgView];
    
    UIImageView *bgImaeView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 158)];
    bgImaeView.image=[UIImage imageNamed:@"shanshiBg.png"];
    [bgView addSubview:bgImaeView];
    
    UIImageView *zaoCan =[[UIImageView alloc]initWithFrame:CGRectMake(25, 72, 20, 20)];
    zaoCan.image=[UIImage imageNamed:@"zancan.png"];
    [bgView addSubview:zaoCan];
    UILabel *labl =[[UILabel alloc]initWithFrame:CGRectMake(50, 72, 25, 20)];
    labl.text=@"早餐";
    labl.font=[UIFont fontWithName:@"Helvetica Neue" size:11];
    labl.backgroundColor=[UIColor clearColor];
    labl.textColor=[UIColor whiteColor];
    [bgView addSubview:labl];
    
    _dataLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 40)];
    _dataLbl.textAlignment=NSTextAlignmentLeft;
    _dataLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:24];
    _dataLbl.textColor=[UIColor whiteColor];
    _dataLbl.backgroundColor=[UIColor clearColor];

//    _dataLbl.text=@"2014-09-09";
    [bgView addSubview:_dataLbl];
    
    
    _xingqilbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 35, 300, 40)];
    _xingqilbl.backgroundColor=[UIColor clearColor];
    _xingqilbl.textAlignment=NSTextAlignmentLeft;
    _xingqilbl.font=[UIFont fontWithName:@"Helvetica Neue" size:22];
    _xingqilbl.textColor=[UIColor whiteColor];
//    _xingqilbl.text=@"星期五";
    _xingqilbl.backgroundColor=[UIColor clearColor];

    [bgView addSubview:_xingqilbl];
    
    
    _zaoCanlbl=[[MBLabel alloc]initWithFrame:CGRectMake(0, 92, 107, 65)];
    _zaoCanlbl.backgroundColor=[UIColor clearColor];
    _zaoCanlbl.numberOfLines=0;
    _zaoCanlbl.textAlignment=NSTextAlignmentCenter;
    _zaoCanlbl.font=[UIFont fontWithName:@"Helvetica Neue" size:13];
    _zaoCanlbl.textColor=[UIColor whiteColor];
    _zaoCanlbl.backgroundColor=[UIColor clearColor];
//    _zaoCanlbl.text=@"asldjfiwejlasdf好啊是来得及服务iojlasjdfioalsjdf阿斯顿发生地方";

    [bgView addSubview:_zaoCanlbl];
    

    
    
    UIImageView *wuCan =[[UIImageView alloc]initWithFrame:CGRectMake(25+110, 72, 20, 20)];
    wuCan.image=[UIImage imageNamed:@"zhongcan.png"];
    [bgView addSubview:wuCan];
    UILabel *lablwu =[[UILabel alloc]initWithFrame:CGRectMake(50+110, 72, 25, 20)];
    lablwu.text=@"午餐";
    lablwu.font=[UIFont fontWithName:@"Helvetica Neue" size:11];
    lablwu.textColor=[UIColor whiteColor];
    lablwu.backgroundColor=[UIColor clearColor];

    [bgView addSubview:lablwu];
    
    
    _zhongcanlbl=[[MBLabel alloc]initWithFrame:CGRectMake(107, 92, 107, 65)];
    _zhongcanlbl.backgroundColor=[UIColor clearColor];
    _zhongcanlbl.numberOfLines=0;
    _zhongcanlbl.textAlignment=NSTextAlignmentCenter;
    _zhongcanlbl.font=[UIFont fontWithName:@"Helvetica Neue" size:13];
    _zhongcanlbl.textColor=[UIColor whiteColor];
    _zhongcanlbl.backgroundColor=[UIColor clearColor];
//    _zhongcanlbl.text=@"asldjfiwejlasdf好啊是来得及服务iojlasjdfioalsjdf阿斯顿发生地方";

    [bgView addSubview:_zhongcanlbl];
    
    UIImageView *wancan =[[UIImageView alloc]initWithFrame:CGRectMake(25+220, 72, 20, 20)];
    wancan.image=[UIImage imageNamed:@"wancan.png"];
    [bgView addSubview:wancan];
    UILabel *wanlabl =[[UILabel alloc]initWithFrame:CGRectMake(50+220, 72, 25, 20)];
    wanlabl.text=@"晚餐";
    wanlabl.font=[UIFont fontWithName:@"Helvetica Neue" size:11];
    wanlabl.textColor=[UIColor whiteColor];
    wanlabl.backgroundColor=[UIColor clearColor];

    [bgView addSubview:wanlabl];
    
    _wancanlbl=[[MBLabel alloc]initWithFrame:CGRectMake(107*2, 92, 107,65)];
    _wancanlbl.backgroundColor=[UIColor clearColor];
    _wancanlbl.numberOfLines=0;
    _wancanlbl.textAlignment=NSTextAlignmentCenter;
    _wancanlbl.font=[UIFont fontWithName:@"Helvetica Neue" size:13];
    _wancanlbl.textColor=[UIColor whiteColor];
    _wancanlbl.backgroundColor=[UIColor clearColor];
//    _wancanlbl.text=@"asldjfiwejlasdf好啊是来得及服务iojlasjdfioalsjdf阿斯顿发生地方";

    [bgView addSubview:_wancanlbl];
    
    
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 165, 320, kScreenHeight-49-260) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [bgView addSubview:_tableView];
    _startIndex=0;
    [self getUserData];
    
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
    
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",_startIndex],@"dateTypeIndex", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"userID", nil]];
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetRecommendedFoodList"];
    
    __block ShanShiTuijianViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetRecommendedFoodList" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf GetNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    }
}

-(void)GetNewHealthDataAndResultSuccess:(NSString *)string
{
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:string];
    NSLog(@"%@",xmlDoc);
    NSArray *array=xmlDoc[@"soap:Body"][@"GetRecommendedFoodListResponse"][@"GetRecommendedFoodListResult"][@"data"][@"foods"][@"food"];
    if ([array isKindOfClass:[NSArray class]]) {
        if (array.count==0) {
            _isShowMore=NO;
        }else
        {
            [_dataArray addObjectsFromArray:array];
            _isShowMore=YES;
        }
        NSLog(@"111=====%@",array);

        NSLog(@"222=====%@",_dataArray);

    }else
    {
        _isShowMore=NO;
    }
    
    if (_startIndex==0) {
        if (_dataArray.count>0) {
            NSMutableDictionary *allUserDic =_dataArray[0];
            NSLog(@"%@",allUserDic);
            
            _zaoCanlbl.text=MBNonEmptyStringNo_(allUserDic[@"breakfastFoodNames"]);
            _zhongcanlbl.text=MBNonEmptyStringNo_(allUserDic[@"lunchFoodNames"]);
            _wancanlbl.text=MBNonEmptyStringNo_(allUserDic[@"dinnerFoodNames"]);
            _dataLbl.text=MBNonEmptyStringNo_(allUserDic[@"date"]);
            _xingqilbl.text=MBNonEmptyStringNo_(allUserDic[@"dayOfWeek"]);
        }else{
        
            MBAlert(@"暂无更多数据");
        }
     
    }
    [_tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (_isShowMore) {
        return _dataArray.count+1;
    }else
    {
        return _dataArray.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellStr =@"_isShowMore";
    TiJianReprotCell *cell =[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[TiJianReprotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        cell.delegateAbout=self;
        cell.backgroundColor=[UIColor clearColor];
        UILabel *loadMore=[[UILabel alloc]initWithFrame:cell.frame];
        loadMore.text=@"加载更多";
        loadMore.textAlignment=UITextAlignmentCenter;
        loadMore.tag=100000;
        loadMore.backgroundColor=[UIColor clearColor];
        [cell addSubview:loadMore];
        
    }
    UILabel *loadMore=(UILabel*)[cell viewWithTag:100000];

    if (indexPath.row==_dataArray.count) {
        [cell showLoadMoreVIew];
        loadMore.hidden=NO;
    }else
    {
        if (indexPath.row%5==0) {
            cell.bgView.image=[UIImage imageNamed:@"one.png"];
        } if (indexPath.row%5==1) {
            cell.bgView.image=[UIImage imageNamed:@"two.png"];
        } if (indexPath.row%5==2) {
            cell.bgView.image=[UIImage imageNamed:@"three.png"];
        } if (indexPath.row%5==3) {
            cell.bgView.image=[UIImage imageNamed:@"four.png"];
        } if (indexPath.row%5==4) {
            cell.bgView.image=[UIImage imageNamed:@"five.png"];
        }
        
        cell.itemCountLbl.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        cell.itemLbl.text=[NSString stringWithFormat:@"%@  %@",MBNonEmptyStringNo_(_dataArray[indexPath.row][@"date"]),MBNonEmptyStringNo_(_dataArray[indexPath.row][@"dayOfWeek"])];
        
        [cell hiddleLoadMoreView];

        loadMore.hidden=YES;
    }

    return cell;
}

-(void)loadMoreAboutdata
{
    _startIndex+=1;
    [self getUserData];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *allUserDic =_dataArray[indexPath.row];
    NSLog(@"%@",allUserDic);

    _zaoCanlbl.text=MBNonEmptyStringNo_(allUserDic[@"breakfastFoodNames"]);
    _zhongcanlbl.text=MBNonEmptyStringNo_(allUserDic[@"lunchFoodNames"]);
    _wancanlbl.text=MBNonEmptyStringNo_(allUserDic[@"dinnerFoodNames"]);
    _dataLbl.text=MBNonEmptyStringNo_(allUserDic[@"date"]);
    _xingqilbl.text=MBNonEmptyStringNo_(allUserDic[@"dayOfWeek"]);
    
}
@end
