//
//  MBFundMapViewController.m
//  BOCMBCI
//
//  Created by Tracy E on 13-6-26.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBFundMapViewController.h"
#import "PCLineChartView.h"

@interface MBFundMapViewController ()

@end

@implementation MBFundMapViewController

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
    self.title = @"血压走势图";
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
    
    
    PCLineChartView *lineChart = [[PCLineChartView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, kContentViewHeight-95)];
    NSLog(@"%@",_dataInfo);
    NSMutableArray *dateArray =[NSMutableArray arrayWithCapacity:2];
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    self.view.backgroundColor=HEX(@"#ffffff");
    NSArray *array=_dataInfo[@"soap:Body"][@"GetHealthDataResponse"][@"GetHealthDataResult"][@"data"][@"style"];
    
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
        [one addObject:MBNonEmptyStringNo_(reseDataArray[i][@"HD14"])];
        [two addObject:MBNonEmptyStringNo_(reseDataArray[i][@"HD15"])];
        [three addObject:MBNonEmptyStringNo_(reseDataArray[i][@"HD16"])];

    }
    NSLog(@"%@",dateArray);
    
    PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
    [component setPoints:one];
    [component setShouldLabelValues:NO];
    [component setColour:[UIColor blueColor]];
  
    PCLineChartViewComponent *componenttwo = [[PCLineChartViewComponent alloc] init];
    [componenttwo setPoints:two];
    [componenttwo setShouldLabelValues:NO];
    [componenttwo setColour:[UIColor greenColor]];
    
    PCLineChartViewComponent *componentthre = [[PCLineChartViewComponent alloc] init];
    [componentthre setPoints:three];
    [componentthre setShouldLabelValues:NO];
    [componentthre setColour:[UIColor redColor]];

    lineChart.interval = 5;

    [lineChart setComponents:@[component,componenttwo,componentthre]];
    [lineChart setXLabels:dateArray];
    
    [self.view addSubview:lineChart];
    for (int i=0; i<3; i++) {
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10+90*i,  kContentViewHeight-65,20, 3)];
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(50+i*(50+40),  kContentViewHeight-75, 60, 20)];
        if (i==0) {
            imageView.backgroundColor=[UIColor redColor];
            label.text=@"脉搏";
        }if (i==1) {
            imageView.backgroundColor=[UIColor greenColor];
            label.text=@"收缩压";
        }if (i==2) {
            imageView.backgroundColor=[UIColor blueColor];
            label.text=@"舒张压";
            imageView.frame=CGRectMake(imageView.frame.origin.x+10, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
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
