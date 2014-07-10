//
//  XueYaViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-27.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "TiZhiViewController.h"
#import "MBSegmentControl.h"
#import <QuartzCore/QuartzCore.h>
#import "MBSegmentControl.h"
#import "MBIIRequest.h"
#import "SoapHelper.h"
#import "XMLDictionary.h"
#import "TiZhongMBFundMapViewController.h"
#import "MBLabel.h"
#import "TiZhongUploadViewController.h"
@interface TiZhiViewController ()<MBSegmentControlDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *_fistView;
    UIView *_sencodView;
    UIView *_thirdView;
    UIImageView *_zhihxenAbout;
    float _zhixenIndex;
}
@end

@implementation TiZhiViewController
CGFloat AbtoutDegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};

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
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)uploadData
{
    TiZhongUploadViewController *upload=[[TiZhongUploadViewController alloc]init];
    [self.navigationController pushViewController:upload animated:YES];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"TiZhiZiCheUploadSuccess" object:nil];
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
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"5",@"paramType", nil]];
    
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetNewHealthDataAndResult"];
    
    __block TiZhiViewController *blockSelf = self;
    
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
    
    _fistView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, 320, kContentViewHeight+49-30)];
    _fistView.contentSize=CGSizeMake(kScreenWidth, kScreenHeight+150);
    _fistView.backgroundColor=HEX(@"#f0f8ff");
    [self.view addSubview:_fistView];
    _fistView.hidden=NO;
    
    _sencodView =[[UIView alloc]initWithFrame:CGRectMake(0, 30, 320, kContentViewHeight+49-30)];
    [self.view addSubview:_sencodView];
    _sencodView.backgroundColor=HEX(@"#f0f8ff");
    _sencodView.hidden=YES;
    [self initViewAboutSecondeView];
    
    
    [self initViewAboutFirstView];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"体脂自测";
    self.view.backgroundColor=HEX(@"#5ec4fe");
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(XueTangUploadSuccess) name:@"TiZhiZiCheUploadSuccess" object:nil];
    
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
    
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"本次检测",@"数据分析",@"趋势图",nil];
    
    //初始化UISegmentedControl
    
    MBSegmentControl *segmentedControl=[[MBSegmentControl alloc]initWithFrame:CGRectMake(-5.0, 0.0, 330.0, 30.0)];
    segmentedControl.itemNameArray=segmentedArray;
    [segmentedControl setDelegate:self];
    segmentedControl.selectIndex=0;
    
    [self.view addSubview:segmentedControl];
    
    



    
    _thirdView =[[UIView alloc]initWithFrame:CGRectMake(0, 30, 320, kContentViewHeight+49-30)];
    [self.view addSubview:_thirdView];
    _thirdView.backgroundColor=HEX(@"#f0f8ff");
    _thirdView.hidden=YES;
    
    [self initViewAboutFirstView];
    [self initViewAboutSecondeView];
    NSLog(@"%@",_dicAboutInfo);

}
-(void)segmentedCOntrollerPressed:(UISegmentedControl*)con
{
    if (con.selectedSegmentIndex==0) {
        _fistView.hidden=NO;
        _sencodView.hidden=!_fistView.hidden;
        _thirdView.hidden=_sencodView.hidden;
    }if (con.selectedSegmentIndex==1) {
        _sencodView.hidden=NO;
        _fistView.hidden=!_sencodView.hidden;
        _thirdView.hidden=_fistView.hidden;
        
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
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(@"5"),@"paramType", nil]];//userId

    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetHealthData"];
    
    __block TiZhiViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetHealthData" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        
        [blockSelf GetNGetMissionaryArticleForSortdResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];}
}
-(void)GetNGetMissionaryArticleForSortdResultSuccess:(NSString*)str
{
    
    NSLog(@"%@",str);
    NSDictionary *xmlDic =[NSDictionary dictionaryWithXMLString:str];
    NSLog(@"%@",xmlDic);
    TiZhongMBFundMapViewController *dound=[[TiZhongMBFundMapViewController alloc]init];
    dound.dataInfo=xmlDic;
    [self.navigationController pushViewController:dound animated:YES];
//    [self presentViewController:dound animated:YES completion:nil];
}
-(void)MBSegment:(MBSegmentControl *)segment selectAtIndex:(NSInteger)index
{
    if (index==0) {
        _fistView.hidden=NO;
        _sencodView.hidden=!_fistView.hidden;
        _thirdView.hidden=_sencodView.hidden;
        _zhihxenAbout.transform=CGAffineTransformMakeRotation(DegreesToRadians(0));
        
        [UIView animateWithDuration:1 animations:^{
            
            _zhihxenAbout.transform=CGAffineTransformMakeRotation(DegreesToRadians(180/7*_zhixenIndex));
            
        } completion:^(BOOL finished) {
            
        }];
        

        
    }if (index==1) {
        _sencodView.hidden=NO;
        _fistView.hidden=!_sencodView.hidden;
        _thirdView.hidden=_fistView.hidden;
    }if (index==2) {
        [self GetHealthData];

    }
}
-(void)initViewAboutSecondeView
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
    tablevew.backgroundView=[[UIView alloc]init];
    [_sencodView addSubview:tablevew];
    
}
-(void)initViewAboutFirstView
{
    
    _fistView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, 320, kContentViewHeight+49-30)];
    _fistView.contentSize=CGSizeMake(kScreenWidth, kScreenHeight+150);
    _fistView.backgroundColor=HEX(@"#f0f8ff");
    [self.view addSubview:_fistView];
    _fistView.hidden=NO;
    
    UIImageView *headView =[[UIImageView alloc]initWithFrame:CGRectMake(60, 10, 200, 200)];
    headView.image=[UIImage imageNamed:@"yuan_xuetang.png"];
    [_fistView addSubview:headView];
    
    UIImageView *bgHelo =[[UIImageView alloc]initWithFrame:CGRectMake(40, 255, 240, 2)];
    bgHelo.backgroundColor=[UIColor blueColor];
    [_fistView addSubview:bgHelo];
    

    NSArray *array=_dicAboutInfo[@"soap:Body"][@"GetNewHealthDataAndResultResponse"][@"GetNewHealthDataAndResultResult"][@"data"][@"style"];
    NSMutableDictionary*dict=[NSMutableDictionary dictionaryWithCapacity:2];
    if ([array isKindOfClass:[NSArray class]]) {

    for (int i=0; i<array.count; i++) {
        NSDictionary*dic=array[i];
        if (![MBNonEmptyStringNo_(dic[@"HD28"]) isEqualToString:@""]) {
            [dict addEntriesFromDictionary:dic];
        }
    }
    
    }
    
    
    /////////////////////////////////

    
  
    
    [self.view addSubview:_fistView];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(130, 90, 60, 30)];
    [_fistView addSubview:view];
    view.backgroundColor=_fistView.backgroundColor;
    [_fistView addSubview:view];
    
    NSLog(@"%@",dict[@"result"]);
    NSString *statu=MBNonEmptyStringNo_([dict[@"result"] componentsSeparatedByString:@""][0]);
    if (statu.length>0) {
        _zhixenIndex=0;
        if ([statu isEqualToString:@"体重偏低"]) {
            _zhixenIndex=-1.5;
        }
        if ([statu isEqualToString:@"标准体重"]) {
            _zhixenIndex=0;
        }if ([statu isEqualToString:@"超重"]) {
            _zhixenIndex=1.5;
        }
        if ([statu isEqualToString:@"肥胖"]) {
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

    
    /////////////////////////////////
    UILabel *labelone =[[UILabel alloc]initWithFrame:CGRectMake(120, 158, 90, 30)];
    labelone.text=statu;
    labelone.textColor=[UIColor orangeColor];
    [_fistView addSubview:labelone];
    
   
    NSArray *imageArray =@[@"shou.png",@"shu.png",@"maibo.png"];
    for ( int i=0; i<imageArray.count; i++) {
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(30*(i+1)+66*i, 220, 66, 66)];
        imageView.image=[UIImage imageNamed:imageArray[i]];
        [_fistView addSubview:imageView];
        
        UILabel*labl =[[UILabel alloc]initWithFrame:CGRectMake(30*(i)+66*i+20, 300, 86, 30)];
        labl.backgroundColor=[UIColor clearColor];
        labl.textColor=HEX(@"#8a2be2");
        labl.font=kNormalTextFont;
        labl.textAlignment=NSTextAlignmentCenter;
        [_fistView addSubview:labl];
        
        UILabel*lablOne =[[UILabel alloc]initWithFrame:CGRectMake(30*(i+1)+66*i, 280, 66, 30)];
        lablOne.backgroundColor=[UIColor clearColor];
        lablOne.textColor=HEX(@"#5f9ea0");
        lablOne.font=kNormalTextFont;
        lablOne.textAlignment=NSTextAlignmentCenter;
        [_fistView addSubview:lablOne];
        
        
        if (i==0) {
            labl.text=[NSString stringWithFormat:@"%@Kg",MBNonEmptyStringNo_(dict[@"HD33"])];
            lablOne.text=@"体重";
        }
        if (i==1) {
            labl.text=[NSString stringWithFormat:@"%@%@",MBNonEmptyStringNo_(dict[@"HD28"]),@"%"];
            lablOne.text=@"体脂肪率";
            
        }
        if (i==2) {
            labl.text=[NSString stringWithFormat:@"%@%@",MBNonEmptyStringNo_(dict[@"HD40"]),@""];
            lablOne.text=@"BMI";
            
        }
        
        
    }
    NSLog(@"%@",_dicAboutInfo);
    
    CGSize size=[MBNonEmptyString(dict[@"result"]) sizeWithFont:kNormalTextFont constrainedToSize:CGSizeMake(300, 10000000)];

    UIImageView *bgViem=[[UIImageView alloc]initWithFrame:CGRectMake(10, 350, 40, 37)];
    bgViem.image=[UIImage imageNamed:@"bgViewAboutXue.png"];
    
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(10, 350, 300, size.height+90)];
    label.backgroundColor=HEX(@"#ffffff");
    label.text=MBNonEmptyStringNo_(dict[@"result"]);
    label.numberOfLines=0;
    label.font=kNormalTextFont;

    [_fistView addSubview:label];
    [_fistView addSubview:bgViem];

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
        label.backgroundColor=[UIColor clearColor];
        [cell addSubview:label];
        
    }
    MBLabel *label =(MBLabel*)[cell viewWithTag:9000];
    NSLog(@"%@",_dicAboutInfo);
    cell.textLabel.font=kNormalTextFont;
    if (indexPath.row==0) {
        cell.textLabel.text=@"体重最大值";
        NSArray *array=_dicAboutInfo[@"soap:Body"][@"GetNewHealthDataAndResultResponse"][@"GetNewHealthDataAndResultResult"][@"data"][@"style"];
        if ([array isKindOfClass:[NSArray class]]) {

        for (int i=0; i<array.count; i++) {
            NSDictionary*dic=array[i];
            if (![MBNonEmptyStringNo_(dic[@"maxHD33"]) isEqualToString:@""]) {
                label.text=[NSString stringWithFormat:@"%@Kg",MBNonEmptyStringNo_(dic[@"maxHD33"])];
            }
        }
        }
    }if (indexPath.row==1) {
        cell.textLabel.text=@"体脂率最大值";
        NSArray *array=_dicAboutInfo[@"soap:Body"][@"GetNewHealthDataAndResultResponse"][@"GetNewHealthDataAndResultResult"][@"data"][@"style"];
        if ([array isKindOfClass:[NSArray class]]) {

        for (int i=0; i<array.count; i++) {
            NSDictionary*dic=array[i];
            if (![MBNonEmptyStringNo_(dic[@"maxHD28"]) isEqualToString:@""]) {
                label.text=[NSString stringWithFormat:@"%@%@",MBNonEmptyStringNo_(dic[@"maxHD28"]),@"%"];
                
            }}
        }
    }if (indexPath.row==2) {
        cell.textLabel.text=@"BMI最大值";
        NSArray *array=_dicAboutInfo[@"soap:Body"][@"GetNewHealthDataAndResultResponse"][@"GetNewHealthDataAndResultResult"][@"data"][@"style"];
        if ([array isKindOfClass:[NSArray class]]) {

        for (int i=0; i<array.count; i++) {
            NSDictionary*dic=array[i];
            if (![MBNonEmptyStringNo_(dic[@"maxHD40"]) isEqualToString:@""]) {
                label.text=[NSString stringWithFormat:@"%@%@",MBNonEmptyStringNo_(dic[@"maxHD40"]),@""];
                
            }}
        }
        
    }
    return cell;
    
}

@end
