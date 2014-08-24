//
//  TizhongViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-29.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "TizhongViewController.h"
#import "MBSegmentControl.h"
#import "NengHaoMBFundMapViewController.h"
#import "SoapHelper.h"
#import "MBIIRequest.h"
#import "MBLabel.h"
#import "NengLiangUploadViewController.h"

CGFloat DegreesToRadiansHellos(CGFloat degrees) {return degrees * M_PI / 180;};

@interface TizhongViewController ()<MBSegmentControlDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *_fistView;
    UIView *_sencodView;
    UIImageView *_zhihxenAbout;
    float _zhixenIndex;
}
@end

@implementation TizhongViewController

//返回到上个页面
-(void)backViewUPloadView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)MBSegment:(MBSegmentControl *)segment selectAtIndex:(NSInteger)index
{
    if (index==0) {
        _fistView.hidden=NO;
        _sencodView.hidden=YES;
        _zhihxenAbout.transform=CGAffineTransformMakeRotation(DegreesToRadiansHellos(0));
        
        [UIView animateWithDuration:1 animations:^{
            
            _zhihxenAbout.transform=CGAffineTransformMakeRotation(DegreesToRadiansHellos(180/4*_zhixenIndex));
            
        } completion:^(BOOL finished) {
            
        }];

        
    }if (index==1) {
        _fistView.hidden=YES;
        _sencodView.hidden=NO;

    }if (index==2) {
        [self GetHealthData];
    }
}
-(void)goToLoginViewAbout
{
    MBNotLogViewController *notLogin =[[MBNotLogViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:notLogin];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)GetHealthData
{
    
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        [self goToLoginViewAbout];
    }else{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    
    NSMutableArray *arr=[NSMutableArray array];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"customerId", nil]];//userId
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",0],@"startIndex", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",10],@"endIndex", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(@"6"),@"paramType", nil]];//userId
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetHealthData"];
    
    __block TizhongViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetHealthData" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        
        [blockSelf GetNGetMissionaryArticleForSortdResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    }
}
-(void)GetNGetMissionaryArticleForSortdResultSuccess:(NSString*)str
{
    
    NSLog(@"%@",str);
    NSDictionary *xmlDic =[NSDictionary dictionaryWithXMLString:str];
    NSLog(@"%@",xmlDic);
    NengHaoMBFundMapViewController *dound=[[NengHaoMBFundMapViewController alloc]init];
    dound.dataInfo=xmlDic;
    [self.navigationController pushViewController:dound animated:YES];
    //    [self presentViewController:dound animated:YES completion:nil];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"nengliangUploadSuccess" object:nil];
}
-(void)uploadSuccess
{
    [self getNewData];

}

-(void)getNewData
{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"customerId", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"paramType", nil]];
    
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetNewHealthDataAndResult"];
    
    __block TizhongViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetNewHealthDataAndResult" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf GetNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    
}
-(void)GetNewHealthDataAndResultSuccess:(NSString *)string
{
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:string];
    _dicAboutInfo=nil;
    _dicAboutInfo=xmlDoc;
    
    [_fistView removeFromSuperview];
    [_sencodView removeFromSuperview];
    
    _fistView = nil;
    _sencodView=nil;
    
 

    [self initwDataView];
    [self initWithViewAboutSecond];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadSuccess) name:@"nengliangUploadSuccess" object:nil];
    
    self.title=@"能耗自测";
    self.view.backgroundColor=HEX(@"#5ec4fe");
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
    
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    UIImageView *bgView =[[UIImageView alloc]initWithFrame:self.view.frame];
    bgView.image=[UIImage imageNamed:@"nengbgview.png"];
    [self.view addSubview:bgView];
   
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"本次检测",@"数据分析",@"趋势图",nil];
    
    //初始化UISegmentedControl
    MBSegmentControl *segmentedControl=[[MBSegmentControl alloc]initWithFrame:CGRectMake(-5.0, 0.0, 330.0, 30.0)];
    segmentedControl.selectIndex=0;
    segmentedControl.delegate=self;
    segmentedControl.itemNameArray=segmentedArray;

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(uploadData)];
    
    [self.view addSubview:segmentedControl];

    [self initwDataView];
    [self initWithViewAboutSecond];
}
-(void)uploadData
{
    
    NengLiangUploadViewController *upload=[[NengLiangUploadViewController alloc]init];
    [self.navigationController pushViewController:upload animated:YES];
}
-(void)initwDataView
{
    
    _fistView =[[UIView alloc]initWithFrame:CGRectMake(0, 30, 320, kContentViewHeight+49-30)];
    _fistView.backgroundColor=HEX(@"#ffffff");
    [self.view addSubview:_fistView];

    UIImageView *bgViewushub =[[UIImageView alloc]initWithFrame:CGRectMake(47, 50, 227, 200)];
    bgViewushub.image=[UIImage imageNamed:@"nengliangbaio.png"];
    [_fistView addSubview:bgViewushub];
    NSArray *array=_dicAboutInfo[@"soap:Body"][@"GetNewHealthDataAndResultResponse"][@"GetNewHealthDataAndResultResult"][@"data"][@"style"];
    NSLog(@"%@",array);
    
    NSMutableDictionary*dict=[NSMutableDictionary dictionaryWithCapacity:2];
    if ([array isKindOfClass:[NSArray class]]) {

    for (int i=0; i<array.count; i++) {
        NSDictionary*dic=array[i];
        if (![MBNonEmptyStringNo_(dic[@"HD55"]) isEqualToString:@""]&&[MBNonEmptyStringNo_(dic[@"HD55"]) integerValue]>1) {
            [dict addEntriesFromDictionary:dic];
        }if (![MBNonEmptyStringNo_(dic[@"sumHD55"]) isEqualToString:@""]) {
            [dict addEntriesFromDictionary:dic];
        }
    }}
    
    
    
    ////////////////////////
    
    UIImageView *headView =[[UIImageView alloc]initWithFrame:CGRectMake(60, 10, 200, 200)];
    headView.image=[UIImage imageNamed:@"yuan_xueyang.png"];
    [_fistView addSubview:headView];
    
    [self.view addSubview:_fistView];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(130, 90, 60, 30)];
    [_fistView addSubview:view];
    view.backgroundColor=_fistView.backgroundColor;
    [_fistView addSubview:view];
    
    
    
    NSLog(@"%@",dict[@"result"]);
    NSString *statu=MBNonEmptyStringNo_(dict[@"HD55"]);
    if (statu.length>0) {
        _zhixenIndex=0;
        
        if ([statu floatValue]>5000) {
            _zhixenIndex=1.5;

        }else
        {
            _zhixenIndex=-1.5;

        }
        _zhihxenAbout =[[UIImageView alloc]initWithFrame:CGRectMake(150, 60, 20, 110)];
        _zhihxenAbout.image=[UIImage imageNamed:@"zhizhen.png"];//yuan_xueya@2x
        _zhihxenAbout.transform=CGAffineTransformMakeRotation(DegreesToRadiansHellos(0));
        
        [UIView animateWithDuration:1 animations:^{
            
            _zhihxenAbout.transform=CGAffineTransformMakeRotation(DegreesToRadiansHellos(180/4*_zhixenIndex));
            
        } completion:^(BOOL finished) {
            
        }];
        [_fistView addSubview:_zhihxenAbout];
    }
    
    UILabel *labelone =[[UILabel alloc]initWithFrame:CGRectMake(115, 175, 90, 40)];
    labelone.numberOfLines=2;
    labelone.text=[NSString stringWithFormat:@"%@步",statu];
    labelone.textColor=[UIColor orangeColor];
    labelone.textAlignment=NSTextAlignmentCenter;
    [_fistView addSubview:labelone];
    
    UILabel *labelTwo =[[UILabel alloc]initWithFrame:CGRectMake(115, 175+30, 90, 40)];
    labelTwo.text=@"步数";
    labelTwo.textColor=[UIColor orangeColor];
    labelTwo.textAlignment=NSTextAlignmentCenter;
    [_fistView addSubview:labelTwo];
    
    UIImageView *bgHelo =[[UIImageView alloc]initWithFrame:CGRectMake(80, 295, 150, 2)];
    bgHelo.backgroundColor=[UIColor blueColor];
    [_fistView addSubview:bgHelo];

    ////////////////////////
    NSLog(@"%@",dict);
    
    NSArray *imageArray =@[@"bushuy.png",@"nnlaing.png",@"zhifang.png"];
    for ( int i=0; i<imageArray.count; i++) {
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(30*(i+1)+66*i, 260, 66, 66)];
        imageView.image=[UIImage imageNamed:imageArray[i]];
        [_fistView addSubview:imageView];
        
        UILabel*labl =[[UILabel alloc]initWithFrame:CGRectMake(30*(i)+66*i+20, 270+50+15+10, 86, 30)];
        labl.backgroundColor=[UIColor clearColor];
        labl.textColor=HEX(@"#8a2be2");
        labl.font=kNormalTextFont;
        labl.textAlignment=NSTextAlignmentCenter;
        [_fistView addSubview:labl];
        
        UILabel*lablOne =[[UILabel alloc]initWithFrame:CGRectMake(30*(i+1)+66*i, 240+40+20+15+10, 66, 30)];
        lablOne.backgroundColor=[UIColor clearColor];
        lablOne.textColor=HEX(@"#5f9ea0");
        lablOne.font=kNormalTextFont;
        lablOne.textAlignment=NSTextAlignmentCenter;
        [_fistView addSubview:lablOne];
        
        
        if (i==0) {
            labl.text=[NSString stringWithFormat:@"%@km",MBNonEmptyStringNo_(dict[@"HD54"])];
            lablOne.text=@"里程数";
        }
        if (i==1) {
            labl.text=[NSString stringWithFormat:@"%@cal",MBNonEmptyStringNo_(dict[@"HD19"])];
            lablOne.text=@"能耗";
            
        }
        if (i==2) {
            labl.text=[NSString stringWithFormat:@"%@",MBNonEmptyStringNo_(dict[@"HD56"])];
            lablOne.text=@"脂肪燃烧";
            
        }
        
        
    }

}
-(void)initWithViewAboutSecond
{
    _sencodView =[[UIView alloc]initWithFrame:CGRectMake(0, 30, 320, kContentViewHeight+49-30)];
    [self.view addSubview:_sencodView];
    _sencodView.backgroundColor=HEX(@"#f0f8ff");
    _sencodView.hidden=YES;
    
    UITableView *tablevew=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200) style:UITableViewStyleGrouped];
    tablevew.delegate=self;
    tablevew.dataSource=self;
    tablevew.scrollEnabled=YES;
    tablevew.userInteractionEnabled=NO;
    tablevew.backgroundColor=[UIColor clearColor];
    [_sencodView addSubview:tablevew];
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
        
        MBLabel *label=[[MBLabel alloc]initWithFrame:CGRectMake(40, 10, 270, 30)];
        label.textAlignment=UITextAlignmentRight;
        label.font=kNormalTextFont;
        label.tag=9000;
        [cell addSubview:label];
        
    }
    MBLabel *label =(MBLabel*)[cell viewWithTag:9000];
    NSLog(@"%@",_dicAboutInfo);
    cell.textLabel.font=kNormalTextFont;
    if (indexPath.row==0) {
        cell.textLabel.text=@"累计里程";
        NSArray *array=_dicAboutInfo[@"soap:Body"][@"GetNewHealthDataAndResultResponse"][@"GetNewHealthDataAndResultResult"][@"data"][@"style"];
        if ([array isKindOfClass:[NSArray class]]) {

        for (int i=0; i<array.count; i++) {
            NSDictionary*dic=array[i];
            if (![MBNonEmptyStringNo_(dic[@"sumHD54"]) isEqualToString:@""]&&[MBNonEmptyStringNo_(dic[@"sumHD54"]) integerValue]>0) {
                label.text=[NSString stringWithFormat:@"%@公里",MBNonEmptyStringNo_(dic[@"sumHD54"])];
            }
        }}
    }if (indexPath.row==1) {
        cell.textLabel.text=@"累计步数";
        NSArray *array=_dicAboutInfo[@"soap:Body"][@"GetNewHealthDataAndResultResponse"][@"GetNewHealthDataAndResultResult"][@"data"][@"style"];
        if ([array isKindOfClass:[NSArray class]]) {

        for (int i=0; i<array.count; i++) {
            NSDictionary*dic=array[i];
            if (![MBNonEmptyStringNo_(dic[@"sumHD55"]) isEqualToString:@""]&&[MBNonEmptyStringNo_(dic[@"sumHD55"]) integerValue]>0) {
                label.text=[NSString stringWithFormat:@"%@步",MBNonEmptyStringNo_(dic[@"sumHD55"])];
                
            }
        }}
    }if (indexPath.row==2) {
        cell.textLabel.text=@"累计能耗";
        NSArray *array=_dicAboutInfo[@"soap:Body"][@"GetNewHealthDataAndResultResponse"][@"GetNewHealthDataAndResultResult"][@"data"][@"style"];
        if ([array isKindOfClass:[NSArray class]]) {

        for (int i=0; i<array.count; i++) {
            NSDictionary*dic=array[i];
            if (![MBNonEmptyStringNo_(dic[@"sumHD19"]) isEqualToString:@""]&&[MBNonEmptyStringNo_(dic[@"sumHD19"]) integerValue]>0) {
                label.text=[NSString stringWithFormat:@"%@卡路里",MBNonEmptyStringNo_(dic[@"sumHD19"])];
                
            }
        }}
        
    }
    return cell;
    
}
@end
