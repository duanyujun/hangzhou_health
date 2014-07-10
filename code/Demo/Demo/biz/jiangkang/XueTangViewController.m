//
//  TizhongViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-29.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "XueTangViewController.h"
#import "XueYaViewController.h"
#import "MBSegmentControl.h"
#import "SoapHelper.h"
#import "MBIIRequest.h"
#import "MBLabel.h"
#import "XUeTangMBFundMapViewController.h"
#import "XueTangUploadViewController.h"
@interface XueTangViewController ()<MBSegmentControlDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *_fistView;
    UITableView *_tablevew;
    UIView *_sencodView;
    UIImageView *_zhihxenAbout;
    NSInteger _zhixenIndex;
}
@end

@implementation XueTangViewController

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
        _zhihxenAbout.transform=CGAffineTransformMakeRotation(DegreesToRadians(0));
        
        [UIView animateWithDuration:1 animations:^{
            
            _zhihxenAbout.transform=CGAffineTransformMakeRotation(DegreesToRadians(180/7*_zhixenIndex));
            
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
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(@"4"),@"paramType", nil]];//userId
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetHealthData"];
    
    __block XueTangViewController *blockSelf = self;
    
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
    XUeTangMBFundMapViewController *dound=[[XUeTangMBFundMapViewController alloc]init];
    dound.dataInfo=xmlDic;
    [self.navigationController pushViewController:dound animated:YES];
    //    [self presentViewController:dound animated:YES completion:nil];
}

-(void)uploadData
{
    XueTangUploadViewController *upload=[[XueTangUploadViewController alloc]init];
    [self.navigationController pushViewController:upload animated:YES];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"XueTangUploadSuccess" object:nil];
}
-(void)XueTangUploadSuccess
{
    [self getNewData];

}

-(void)getNewData
{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"customerId", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"4",@"paramType", nil]];
    
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetNewHealthDataAndResult"];
    
    __block XueTangViewController *blockSelf = self;
    
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
    [_tablevew removeFromSuperview];
    
    _fistView = nil;
    _sencodView=nil;
    _tablevew=nil;
    
    _fistView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, 320, kContentViewHeight+49-30)];
    _fistView.contentSize=CGSizeMake(kScreenWidth, kScreenHeight+150);
    _fistView.backgroundColor=HEX(@"#f0f8ff");
    [self.view addSubview:_fistView];
    _fistView.hidden=NO;
    
    _sencodView =[[UIView alloc]initWithFrame:CGRectMake(0, 30, 320, kContentViewHeight+49-30)];
    [self.view addSubview:_sencodView];
    _sencodView.backgroundColor=HEX(@"#f0f8ff");
    _sencodView.hidden=YES;
    [self initWithSenconView];

    [self initwDataView];

    [self initWithFirstVIew];
    
    
}

- (void)viewDidLoad
{
//    XueTangUploadSuccess
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(XueTangUploadSuccess) name:@"XueTangUploadSuccess" object:nil];

    // Do any additional setup after loading the view.
    self.title=@"血糖自测";
    self.view.backgroundColor=HEX(@"#f0f8ff");

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
    
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(uploadData)];
    
    UIImageView *bgView =[[UIImageView alloc]initWithFrame:self.view.frame];
    bgView.image=[UIImage imageNamed:@"nengbgview.png"];
    [self.view addSubview:bgView];
   
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"本次检测",@"数据分析",@"趋势图",nil];
    
    //初始化UISegmentedControl
    MBSegmentControl *segmentedControl=[[MBSegmentControl alloc]initWithFrame:CGRectMake(-5.0, 0.0, 330.0, 30.0)];
    segmentedControl.selectIndex=0;
    segmentedControl.delegate=self;
    segmentedControl.itemNameArray=segmentedArray;

    [self.view addSubview:segmentedControl];

    

    [self initWithSenconView];
    
    [self initwDataView];
    
    [self initWithFirstVIew];
    
    
}
-(void)initWithSenconView
{
    _sencodView =[[UIView alloc]initWithFrame:CGRectMake(0, 30, 320, kContentViewHeight+49-30)];
    [self.view addSubview:_sencodView];
    _sencodView.backgroundColor=HEX(@"#f0f8ff");
    _sencodView.hidden=YES;
}
-(void)initWithFirstVIew
{
    _fistView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, 320, kContentViewHeight+49-30)];
    _fistView.contentSize=CGSizeMake(kScreenWidth, kScreenHeight+150);
    _fistView.backgroundColor=HEX(@"#f0f8ff");
    
    NSArray *array=_dicAboutInfo[@"soap:Body"][@"GetNewHealthDataAndResultResponse"][@"GetNewHealthDataAndResultResult"][@"data"][@"style"];
    NSMutableDictionary*dict=[NSMutableDictionary dictionaryWithCapacity:2];
    if ([array isKindOfClass:[NSArray class]]) {

    for (int i=0; i<array.count; i++) {
        NSDictionary*dic=array[i];
        if (![MBNonEmptyStringNo_(dic[@"HD38"]) isEqualToString:@""]) {
            [dict addEntriesFromDictionary:dic];
        }
    }
    }
    
    UIImageView *headView =[[UIImageView alloc]initWithFrame:CGRectMake(60, 10, 200, 200)];
    headView.image=[UIImage imageNamed:@"yuan_xuetang.png"];
    [_fistView addSubview:headView];
    
    [self.view addSubview:_fistView];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(130, 90, 60, 30)];
    [_fistView addSubview:view];
    view.backgroundColor=_fistView.backgroundColor;
    [_fistView addSubview:view];
    
    NSLog(@"%@",dict[@"result"]);
    NSString *statu=MBNonEmptyStringNo_([dict[@"result"] componentsSeparatedByString:@"|"][0]);
    if (statu.length>0) {
        _zhixenIndex=0;
        if ([statu isEqualToString:@"血糖偏低"]) {
            _zhixenIndex=-1.5;
        }
        if ([statu isEqualToString:@"正常血糖"]) {
            _zhixenIndex=0;
        }if ([statu isEqualToString:@"空腹血糖受损"]) {
            _zhixenIndex=1.5;
        }
        if ([statu isEqualToString:@"糖尿病"]) {
            _zhixenIndex=2.9;
        }
        
        _zhihxenAbout =[[UIImageView alloc]initWithFrame:CGRectMake(150, 60, 20, 110)];
        _zhihxenAbout.image=[UIImage imageNamed:@"zhizhen.png"];//yuan_xueya@2x
        _zhihxenAbout.transform=CGAffineTransformMakeRotation(DegreesToRadians(0));
        
        [UIView animateWithDuration:1 animations:^{
            
            _zhihxenAbout.transform=CGAffineTransformMakeRotation(DegreesToRadians(180/4*_zhixenIndex));
            
        } completion:^(BOOL finished) {
            
        }];
        [_fistView addSubview:_zhihxenAbout];
    }
    
    UILabel *labelone =[[UILabel alloc]initWithFrame:CGRectMake(115, 175, 90, 40)];
    labelone.numberOfLines=2;
    labelone.text=statu;
    labelone.textColor=[UIColor orangeColor];
    labelone.textAlignment=NSTextAlignmentCenter;
    [_fistView addSubview:labelone];
    
    

    UIImageView *bgHelo =[[UIImageView alloc]initWithFrame:CGRectMake(80, 255, 150, 2)];
    bgHelo.backgroundColor=[UIColor blueColor];
    [_fistView addSubview:bgHelo];
    
    
    NSArray *imageArray =@[@"xuetang.png",@"xuetagnfanghou.png"];
    for ( int i=0; i<imageArray.count; i++) {
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(62*(i+1)+66*i, 220, 66, 66)];
        imageView.image=[UIImage imageNamed:imageArray[i]];
        [_fistView addSubview:imageView];
        
        UILabel*labl =[[UILabel alloc]initWithFrame:CGRectMake(62*(i+1)+66*i-5, 300, 86, 30)];
        labl.backgroundColor=[UIColor clearColor];
        labl.textColor=HEX(@"#8a2be2");
        labl.font=kNormalTextFont;
        labl.textAlignment=NSTextAlignmentCenter;
        [_fistView addSubview:labl];
        
        UILabel*lablOne =[[UILabel alloc]initWithFrame:CGRectMake(62*(i+1)+66*i-5, 280, 66, 30)];
        lablOne.backgroundColor=[UIColor clearColor];
        lablOne.textColor=HEX(@"#5f9ea0");
        lablOne.font=kNormalTextFont;
        lablOne.textAlignment=NSTextAlignmentCenter;
        [_fistView addSubview:lablOne];
        
        
        if (i==0) {
            labl.text=[NSString stringWithFormat:@"%@mol/L",MBNonEmptyStringNo_(dict[@"HD38"])];
            lablOne.text=@"餐前";
        }
        if (i==1) {
            labl.text=[NSString stringWithFormat:@"%@mol/L",MBNonEmptyStringNo_(dict[@"HD58"])];
            lablOne.text=@"餐后";
            
        }
        
    }
    
    CGSize size=[MBNonEmptyString(dict[@"result"]) sizeWithFont:kNormalTextFont constrainedToSize:CGSizeMake(300, 10000000)];
    
    UIImageView *bgViem=[[UIImageView alloc]initWithFrame:CGRectMake(10, 350, 40, 37)];
    bgViem.image=[UIImage imageNamed:@"bgViewAboutXue.png"];
    
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(10, 350, 300, size.height+80)];
    label.backgroundColor=HEX(@"#ffffff");
    label.text=MBNonEmptyStringNo_(dict[@"result"]);
    label.numberOfLines=0;
    label.font=kNormalTextFont;
    [_fistView addSubview:label];
    [_fistView addSubview:bgViem];
    
   
}

-(void)initwDataView
{

    _tablevew=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 230) style:UITableViewStyleGrouped];
    _tablevew.delegate=self;
    _tablevew.dataSource=self;
    _tablevew.scrollEnabled=YES;
    _tablevew.userInteractionEnabled=NO;
    _tablevew.backgroundColor=[UIColor clearColor];
    [_sencodView addSubview:_tablevew];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    cell.textLabel.font=kNormalTextFont;
    if (indexPath.row==0) {
        cell.textLabel.text=@"空腹血糖最大值";
        NSArray *array=_dicAboutInfo[@"soap:Body"][@"GetNewHealthDataAndResultResponse"][@"GetNewHealthDataAndResultResult"][@"data"][@"style"];
        if ([array isKindOfClass:[NSArray class]]) {

        for (int i=0; i<array.count; i++) {
            NSDictionary*dic=array[i];
            if (![MBNonEmptyStringNo_(dic[@"maxHD38"]) isEqualToString:@""]&&[MBNonEmptyStringNo_(dic[@"maxHD38"]) integerValue]>0) {
                label.text=[NSString stringWithFormat:@"%@mmol/L",MBNonEmptyStringNo_(dic[@"maxHD38"])];
                NSLog(@"%@",dic);

            }
        }}
    }if (indexPath.row==1) {
        cell.textLabel.text=@"空腹血糖最小值";
        NSArray *array=_dicAboutInfo[@"soap:Body"][@"GetNewHealthDataAndResultResponse"][@"GetNewHealthDataAndResultResult"][@"data"][@"style"];
        if ([array isKindOfClass:[NSArray class]]) {

        for (int i=0; i<array.count; i++) {
            NSDictionary*dic=array[i];
            if (![MBNonEmptyStringNo_(dic[@"minHD38"]) isEqualToString:@""]&&[MBNonEmptyStringNo_(dic[@"minHD38"]) integerValue]>0) {
                label.text=[NSString stringWithFormat:@"%@mmol/L",MBNonEmptyStringNo_(dic[@"minHD38"])];
                NSLog(@"%@",dic);

            }
        }}
    }if (indexPath.row==2) {
        cell.textLabel.text=@"餐后血糖最大值";
        NSArray *array=_dicAboutInfo[@"soap:Body"][@"GetNewHealthDataAndResultResponse"][@"GetNewHealthDataAndResultResult"][@"data"][@"style"];
        if ([array isKindOfClass:[NSArray class]]) {

        for (int i=0; i<array.count; i++) {
            NSDictionary*dic=array[i];
            if (![MBNonEmptyStringNo_(dic[@"maxHD58"]) isEqualToString:@""]&&[MBNonEmptyStringNo_(dic[@"maxHD58"]) integerValue]>0) {
                label.text=[NSString stringWithFormat:@"%@mmol/L",MBNonEmptyStringNo_(dic[@"maxHD58"])];
                NSLog(@"%@",dic);

            }
        }}
        
    }if (indexPath.row==3) {
        cell.textLabel.text=@"餐后血糖最小值";
        NSArray *array=_dicAboutInfo[@"soap:Body"][@"GetNewHealthDataAndResultResponse"][@"GetNewHealthDataAndResultResult"][@"data"][@"style"];
        if ([array isKindOfClass:[NSArray class]]) {

        for (int i=0; i<array.count; i++) {
            NSDictionary*dic=array[i];
            if (![MBNonEmptyStringNo_(dic[@"minHD58"]) isEqualToString:@""]&&[MBNonEmptyStringNo_(dic[@"minHD58"]) integerValue]>0) {
                label.text=[NSString stringWithFormat:@"%@mmol/L",MBNonEmptyStringNo_(dic[@"minHD58"])];
                
            }
        }}
        
    }
    return cell;
    
}
@end
