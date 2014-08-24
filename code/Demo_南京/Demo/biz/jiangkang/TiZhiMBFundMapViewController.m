//
//  MBFundMapViewController.m
//  BOCMBCI
//
//  Created by Tracy E on 13-6-26.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "TiZhiMBFundMapViewController.h"
#import "PCLineChartView.h"

@interface TiZhiMBFundMapViewController ()

@end

@implementation TiZhiMBFundMapViewController

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
    self.title = @"体脂走势图";

    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        UIBarButtonItem *leftBarItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backView.png"] style:UIBarButtonItemStylePlain target:self action:@selector(closeSelf)];
        self.navigationItem.leftBarButtonItem=leftBarItem;
    }else
    {
        UIButton *btnLeft =[UIButton buttonWithType:UIButtonTypeCustom];
        btnLeft.frame=CGRectMake(0, 0, 12, 20);
        [btnLeft setBackgroundImage:[UIImage imageNamed:@"backView.png"] forState:UIControlStateNormal];
        [btnLeft addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    }

    
    PCLineChartView *lineChart = [[PCLineChartView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, kContentViewHeight-115)];
    NSLog(@"%@",_dataInfo);
    NSMutableArray *dateArray =[NSMutableArray arrayWithCapacity:2];
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    self.view.backgroundColor=HEX(@"#ffffff");
    NSArray *array=_dataInfo[@"soap:Body"][@"GetHealthDataResponse"][@"GetHealthDataResult"][@"data"][@"style"];
    
    NSLog(@"%@",array);
    NSMutableArray *reseDataArray =[NSMutableArray arrayWithCapacity:2];
    if ([array isKindOfClass:[NSArray class]]) {
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic =array[i];
            if (!dic[@"isOrNo"]) {
                [reseDataArray addObject:dic];
            }
        }
    }
    for (int i=0; i<reseDataArray.count; i++) {
        [dateArray addObject:[reseDataArray[i][@"testDate"] componentsSeparatedByString:@" "][0] ];
    }
    NSMutableArray *one=[NSMutableArray arrayWithCapacity:2];
    NSMutableArray *two=[NSMutableArray arrayWithCapacity:2];
    NSMutableArray *three=[NSMutableArray arrayWithCapacity:2];
    for (int i=0; i<reseDataArray.count; i++) {
        [one addObject:MBNonEmptyStringNo_(reseDataArray[i][@"HD33"])];
        [two addObject:MBNonEmptyStringNo_(reseDataArray[i][@"HD30"])];
        [three addObject:MBNonEmptyStringNo_(reseDataArray[i][@"HD28"])];
        
    }
    NSLog(@"%@",dateArray);
    
    PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
    [component setPoints:one];
    [component setShouldLabelValues:NO];
    [component setColour:[UIColor redColor]];
    
    PCLineChartViewComponent *componenttwo = [[PCLineChartViewComponent alloc] init];
    [componenttwo setPoints:two];
    [componenttwo setShouldLabelValues:NO];
    [componenttwo setColour:[UIColor blueColor]];
    
    PCLineChartViewComponent *componentthre = [[PCLineChartViewComponent alloc] init];
    [componentthre setPoints:three];
    [componentthre setShouldLabelValues:NO];
    [componentthre setColour:[UIColor greenColor]];
    
    lineChart.interval = 5;
    
    [lineChart setComponents:@[component,componenttwo,componentthre]];
    [lineChart setXLabels:dateArray];
    
    [self.view addSubview:lineChart];
    for (int i=0; i<3; i++) {
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10+110*i,  kContentViewHeight-65,20, 3)];
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(50+i*(50+40),  kContentViewHeight-75, 80, 20)];
        label.font=kSmallButtonTitleFont;
        if (i==0) {
            imageView.backgroundColor=[UIColor redColor];
            label.text=@"体重(kg)";
        }if (i==1) {
            imageView.backgroundColor=[UIColor greenColor];
            label.text=@"体脂率(%)";
        }if (i==2) {
            imageView.backgroundColor=[UIColor blueColor];
            label.text=@"内脏指数(%)";
            imageView.frame=CGRectMake(imageView.frame.origin.x-20, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
        }
        [self.view addSubview:imageView];
        [self.view addSubview:label];
    }
}

- (void)closeSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}



@end
