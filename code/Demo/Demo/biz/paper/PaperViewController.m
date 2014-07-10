//
//  PaperViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-4-13.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "PaperViewController.h"

@interface PaperViewController ()
{
    UISlider *_slider;
    UIScrollView *_xinliWen;
    UIScrollView *_shenghuo;
    UIScrollView *_zhongyi;
}
@end

@implementation PaperViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title=@"问卷调查";
    self.view.backgroundColor=HEX(@"#ffffff");
    
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
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
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"心里问卷",@"生活问卷",@"中医问卷",nil];
    
    //初始化UISegmentedControl
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    
    segmentedControl.frame = CGRectMake(10.0, 0, 300.0, 30.0);
    
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    segmentedControl.tintColor = [UIColor blueColor];
    [segmentedControl setTitleTextAttributes:
     @{
       NSForegroundColorAttributeName: HEX(@"#ffffff"),
       NSFontAttributeName:kNormalTextFont
       }
                                    forState:UIControlStateSelected];
    segmentedControl.layer.cornerRadius=0.1;
    segmentedControl.selectedSegmentIndex=0;
    segmentedControl.userInteractionEnabled=YES;
    [segmentedControl addTarget:self action:@selector(segmentedCOntrollerPressed:) forControlEvents:UIControlEventValueChanged];
    [self segmentedCOntrollerPressed:segmentedControl];
    [self.view addSubview:segmentedControl];
    
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, kScreenHeight-49-30-40, 320, 49)];
 	_slider.minimumValue = 0;
 	_slider.maximumValue = 100;
    _slider.value = 50;
    [_slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:_slider];
    
    
    
}
-(void)updateValue:(UISlider*)sender{
    
}

-(void)segmentedCOntrollerPressed:(UISegmentedControl*)con
{
    NSString *titName=nil;
    NSString *conten=nil;
    if (con.selectedSegmentIndex==0) {
        titName=@"心里问卷";
        conten=@"医学研究证明，许多个人行为和生活因素会影响个体健康趋势。通过对收集的生活方式信息进行汇总分析后得出以下报告，总结了您目前主要的生活方式情况并给出指导意见，同时根据人群数据估计出相关的健康风险。希望您通过此报告，发现并改善不良健康习惯，有效控制健康风险。";
    }if (con.selectedSegmentIndex==1) {
         titName=@"生活问卷";
        conten=@"医学研究证明，许多个人行为和生活因素会影响个体健康趋势。通过对收集的生活方式信息进行汇总分析后得出以下报告，总结了您目前主要的生活方式情况并给出指导意见，同时根据人群数据估计出相关的健康风险。希望您通过此报告，发现并改善不良健康习惯，有效控制健康风险。";

    }if (con.selectedSegmentIndex==2) {
         titName=@"中医问卷";
        conten=@"医学研究证明，许多个人行为和生活因素会影响个体健康趋势。通过对收集的生活方式信息进行汇总分析后得出以下报告，总结了您目前主要的生活方式情况并给出指导意见，同时根据人群数据估计出相关的健康风险。希望您通过此报告，发现并改善不良健康习惯，有效控制健康风险。";

    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titName
                                                    message:conten
                                                   delegate:nil
                                          cancelButtonTitle:@"我知道了"
                                          otherButtonTitles:nil];
    [alert show];
    
    
}

@end
