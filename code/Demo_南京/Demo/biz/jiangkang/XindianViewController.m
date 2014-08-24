//
//  TizhongViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-29.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "XindianViewController.h"
#import "MBSegmentControl.h"
#import "XinDianMBFundMapViewController.h"
#import "SoapHelper.h"
#import "MBIIRequest.h"
#import "MBLabel.h"
@interface XindianViewController ()<MBSegmentControlDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView *_fistView;
    UIView *_sencodView;
}
@end

@implementation XindianViewController

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

    }if (index==1) {
        _fistView.hidden=YES;
        _sencodView.hidden=NO;
    }if (index==2) {
        MBAlert(@"不支持此功能");
        return;
        
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
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(@"7"),@"paramType", nil]];//userId
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetHealthData"];
    
    __block XindianViewController *blockSelf = self;
    
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
    XinDianMBFundMapViewController *dound=[[XinDianMBFundMapViewController alloc]init];
    dound.dataInfo=xmlDic;
    [self.navigationController pushViewController:dound animated:YES];
    //    [self presentViewController:dound animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"心电自测";
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
    MBSegmentControl *segmentedControl=[[MBSegmentControl alloc]initWithFrame:CGRectMake(-5.0, 0.0, 330.0, 30.0)];
    segmentedControl.selectIndex=0;
    segmentedControl.delegate=self;
    segmentedControl.itemNameArray=segmentedArray;
    

    [self.view addSubview:segmentedControl];

    
    NSMutableDictionary*dict=[NSMutableDictionary dictionaryWithCapacity:2];

    NSArray *array=_dicAboutInfo[@"soap:Body"][@"GetNewHealthDataAndResultResponse"][@"GetNewHealthDataAndResultResult"][@"data"][@"style"];
    if ([array isKindOfClass:[NSArray class]]) {
        
        for (int i=0; i<array.count; i++) {
            NSDictionary*dic=array[i];
            if (![MBNonEmptyStringNo_(dic[@"HD02"]) isEqualToString:@""]) {
                [dict addEntriesFromDictionary:dic];
            }
        }

    }
    
    NSLog(@"%@",_dicAboutInfo);
    _fistView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, 320, kContentViewHeight+49-30)];
    _fistView.contentSize=CGSizeMake(kScreenWidth, kScreenHeight);
    _fistView.backgroundColor=HEX(@"#f0f8ff");
    [self.view addSubview:_fistView];
    _fistView.hidden=NO;
    
    _sencodView =[[UIView alloc]initWithFrame:CGRectMake(0, 30, 320, kContentViewHeight+49-30)];
    [self.view addSubview:_sencodView];
    _sencodView.backgroundColor=HEX(@"#f0f8ff");
    _sencodView.hidden=YES;
    
    UILabel*lablOne =[[UILabel alloc]initWithFrame:CGRectMake(30*(0+1)+66*0+50, 60, 66, 30)];
    lablOne.backgroundColor=[UIColor clearColor];
    lablOne.textColor=HEX(@"#5f9ea0");
    lablOne.font=kNormalTextFont;
    lablOne.textAlignment=NSTextAlignmentCenter;
    [_fistView addSubview:lablOne];
    
    
    UILabel*labl =[[UILabel alloc]initWithFrame:CGRectMake(30*(0)+66*0+20+70+50,60, 86, 30)];
    labl.backgroundColor=[UIColor clearColor];
    labl.textColor=HEX(@"#8a2be2");
    labl.font=kNormalTextFont;
    labl.textAlignment=NSTextAlignmentCenter;
    [_fistView addSubview:labl];
    
    labl.text=[NSString stringWithFormat:@"%@dpm",MBNonEmptyStringNo_(dict[@"HD02"])];
    lablOne.text=@"心率：";

    

    CGSize size=[MBNonEmptyString(dict[@"result"]) sizeWithFont:kNormalTextFont constrainedToSize:CGSizeMake(300, 10000000)];
    
    UIImageView *bgViem=[[UIImageView alloc]initWithFrame:CGRectMake(10, 150, 40, 37)];
    bgViem.image=[UIImage imageNamed:@"bgViewAboutXue.png"];
    
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(10,150, 300, size.height+80)];
    label.backgroundColor=HEX(@"#ffffff");
    label.text=MBNonEmptyStringNo_(dict[@"result"]);
    label.numberOfLines=0;
    label.font=kNormalTextFont;
    [_fistView addSubview:label];
    [_fistView addSubview:bgViem];
    
    [self initViewAboutSecondeView];
}

-(void)initViewAboutSecondeView
{
    
    UITableView *tablevew=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 240) style:UITableViewStyleGrouped];
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
    NSLog(@"%@",_dicAboutInfo);
    cell.textLabel.font=kNormalTextFont;
    if (indexPath.row==0) {
        cell.textLabel.text=@"平均PR期间";
        NSArray *array=_dicAboutInfo[@"soap:Body"][@"GetNewHealthDataAndResultResponse"][@"GetNewHealthDataAndResultResult"][@"data"][@"style"];
        
        if ([array isKindOfClass:[NSArray class]]) {
            for (int i=0; i<array.count; i++) {
                NSDictionary*dic=array[i];
                if (![MBNonEmptyStringNo_(dic[@"maxHD14"]) isEqualToString:@""]) {
                    label.text=[NSString stringWithFormat:@"%@mmHg",MBNonEmptyStringNo_(dic[@"maxHD14"])];
                }
            }
        }
        
    }if (indexPath.row==1) {
        cell.textLabel.text=@"平均QT期间";
        NSArray *array=_dicAboutInfo[@"soap:Body"][@"GetNewHealthDataAndResultResponse"][@"GetNewHealthDataAndResultResult"][@"data"][@"style"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int i=0; i<array.count; i++) {
                NSDictionary*dic=array[i];
                if (![MBNonEmptyStringNo_(dic[@"maxHD14"]) isEqualToString:@""]) {
                    label.text=[NSString stringWithFormat:@"%@mmHg",MBNonEmptyStringNo_(dic[@"maxHD15"])];
                    
                }
            }

        }
            }if (indexPath.row==2) {
        cell.textLabel.text=@"平均R波";
        NSArray *array=_dicAboutInfo[@"soap:Body"][@"GetNewHealthDataAndResultResponse"][@"GetNewHealthDataAndResultResult"][@"data"][@"style"];
                if ([array isKindOfClass:[NSArray class]]) {
                    for (int i=0; i<array.count; i++) {
                        NSDictionary*dic=array[i];
                        if (![MBNonEmptyStringNo_(dic[@"total"]) isEqualToString:@""]) {
                            label.text=[NSString stringWithFormat:@"%@次",MBNonEmptyStringNo_(dic[@"total"])];
                            
                        }
                    }

                }
                
    }if (indexPath.row==3) {
        cell.textLabel.text=@"平均P波电压";
        NSArray *array=_dicAboutInfo[@"soap:Body"][@"GetNewHealthDataAndResultResponse"][@"GetNewHealthDataAndResultResult"][@"data"][@"style"];
        
        if ([array isKindOfClass:[NSArray class]]) {
            for (int i=0; i<array.count; i++) {
                NSDictionary*dic=array[i];
                if (![MBNonEmptyStringNo_(dic[@"total"]) isEqualToString:@""]) {
                    label.text=[NSString stringWithFormat:@"%@次",MBNonEmptyStringNo_(dic[@"total"])];
                    
                }
            }

        }
        
    }
    return cell;
    
}
@end
