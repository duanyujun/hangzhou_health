//
//  PaperViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-4-13.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "PaperViewController.h"
#import "MBBaseScrollView.h"
@interface PaperViewController ()
{
    UISlider *_slider;
    MBLabel *_showItemLabel;
    
    UIScrollView *_oneScrollo;
    NSMutableArray *_oneScrollAnserBtn;
    NSMutableArray *_oneScrollTwoAnserBtn;
    
    UIScrollView *_twoScrollo;
    UIScrollView *_threeScrollo;
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

-(void)showOneView
{
    if (!_oneScrollo) {
        _oneScrollo = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, 320, kScreenHeight-30-120)];
        _oneScrollo.backgroundColor =[UIColor clearColor];
        [self.view addSubview:_oneScrollo];
        //youy_yes@2x  gouy_no.png
        
        
        NSArray *oneLabeQuertin = @[@"1.本人患病情况 (多选题)",@"2.父亲患病情况 (多选题)",@"3.母亲患病情况 (多选题)",@"4.祖父母患病情况 (多选题)",@"5.(外)祖父母患病情况 (多选题)",@"1.米、面、薯类平均日摄入量： (一碗指2两)",@"2.肉类及肉制品平均日摄入量：",@"3.鱼类及水产品平均日摄入量：",@"4.蛋类及蛋制品平均日摄入量：(一个是指约50克)",@"5.奶类及奶制品平均日摄入量：(一杯是指约200ml)",@"6.大豆及豆制品平均日摄入量：",@"7.新鲜蔬菜平均日摄入量：",@"8.新鲜水果平均日摄入量：",@"9.平均日饮水摄入量：(一杯是指约200ml)",@"1.您平均每周吃早餐的天数：",@"2.您平均每周吃夜宵的天数：",@"3.您目前饮食方面的喜好： (多选题)",@"4.您目前饮食的不良习惯： (多选题)",@"1.您当前吸烟情况的描述是：",@"2.平均每天吸香烟的支数是：",@"3.您总共吸烟的年数是：",@"4.平均每周被动吸烟情况：",@"1.您当前饮酒情况的描述是：",@"2.您最常饮酒的类型：",@"3.平均每天饮酒的两数是：（折算成白酒）",@"4.您总共饮酒的年数是：",@"1.您是否受一些重大意外困扰：",@"2.您的情绪对工作或生活的影响：",@"3.您感觉到自己的精神压力：",@"4.您感觉自己的睡眠充足吗：",@"5.您的糖皮质激素服用情况： ",@"6.您经常接触到有害因素："];
        
        _showItemLabel = [[MBLabel alloc]initWithFrame:CGRectMake(10, 35, 310, 30)];
        _showItemLabel.font=kNormalTextFont;
        _showItemLabel.adjustsFontSizeToFitWidth=YES;
        _showItemLabel.text = @"第一部分:患病部分";
        [self.view addSubview:_showItemLabel];
        
        NSArray *allbingArray  = @[@"高血压",@"糖尿病",@"冠心病",@"高脂血糖",@"肥胖",@"中风",@"肺癌",@"牵累腺癌",@"乳腺癌",@"骨质疏松",@"老年痴呆",@"肝癌",@"胃癌",@"肝癌",@"胃癌"];
        
        NSArray *allBinTwoArray = @[@"不吃",@"<1两",@"1-2两",@"2-5两",@">=5两",
                                    @"不吃",@"<1个",@"1-2个",@"2-3个",@">=3个",
                                    @"不吃",@"<1杯",@"1-2杯",@"2-3杯",@">=3杯",
                                    @"不吃",@"<0.5两",@"0.5-1两",@"1-2两",@">=2两",
                                    @"<2两",@"2-6两",@"6-10两",@"10-15两",@">=15两",
                                    @"<2两",@"2-6两",@"6-10两",@"10-15两",@">=15两",

                                    @"不吃",@"",@"",@"",@"",
                                    @"不吃",@"",@"",@"",@"",
                                    @"不吃",@"",@"",@"",@"",
                                    @"不吃",@"",@"",@"",@"",
                                    @"不吃",@"",@"",@"",@"",
                                    @"不吃",@"",@"",@"",@"",
                                    @"不吃",@"",@"",@"",@""];
        for (int i=0; i<oneLabeQuertin.count; i++) {
            
            MBBaseScrollView *contenView  =[[MBBaseScrollView alloc]initWithFrame:CGRectMake(320*i, 0, 320, kScreenHeight-30-120)];
            contenView.backgroundColor =[UIColor clearColor];
            MBLabel *label = [[MBLabel alloc]initWithFrame:CGRectMake(10, 10, 310, 30)];
            label.font=kNormalTextFont;
            label.adjustsFontSizeToFitWidth=YES;
            label.text = oneLabeQuertin[i];
            [contenView addSubview:label];
            
            if (i<5) {
                
                if (i==0) {
                    
                }
                for (int j=0; j<5; j++) {
                    for (int k=0; k<3; k++) {
                        
                        if (j==4) {
                            if (k==1) {
                                
                            }
                            if (k==2) {
                                
                            }if(k==0){
                            
                                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                                [btn addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
                                [btn setBackgroundImage:[UIImage imageNamed:@"btn_check_off_normal"] forState:UIControlStateNormal];
                                btn.frame= CGRectMake(5+105*k, 60+50*j, 25, 25);
                                btn.tag=13*i+3*j+k;
                                MBLabel *labelShow = [[MBLabel alloc]initWithFrame:CGRectMake(30+105*k, 57+50*j, 80, 30)];
                                labelShow.font=kNormalTextFont;
                                
                                
                                labelShow.text = allbingArray[3*j+k];
                                
                                [contenView addSubview:labelShow];
                                
                                [contenView addSubview:btn];
                                
                            }
                        }else
                        {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            [btn setBackgroundImage:[UIImage imageNamed:@"btn_check_off_normal"] forState:UIControlStateNormal];
                            btn.frame= CGRectMake(5+105*k, 60+50*j, 25, 25);
                            [btn addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
                            btn.tag=13*i+3*j+k;

                            MBLabel *labelShow = [[MBLabel alloc]initWithFrame:CGRectMake(30+105*k, 57+50*j, 80, 30)];
                            labelShow.font=kNormalTextFont;

                            
                            labelShow.text = allbingArray[3*j+k];
                            
                            [contenView addSubview:labelShow];
                            
                            [contenView addSubview:btn];
                        }
                       
                        
                    }
                }
            }
            
            if (i>=5&&i<=13) {
                
            }
            [_oneScrollo addSubview:contenView];
            
        }
        _oneScrollo.contentSize = CGSizeMake(320*oneLabeQuertin.count, kScreenHeight-150);
        _oneScrollo.showsHorizontalScrollIndicator = YES;
        _oneScrollo.showsVerticalScrollIndicator = YES;
        _oneScrollo.pagingEnabled=YES;
        
    }
}
-(void)btnSelect:(UIButton*)btn
{
    NSLog(@"11111======%d",btn.tag);
    
    NSString *btnItemStr = _oneScrollAnserBtn[btn.tag];
    if ([btnItemStr isEqualToString:@"YES"]) {
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_check_off_normal.png"] forState:UIControlStateNormal];
        btnItemStr = @"NO";
    }else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_check_on_normal.png"] forState:UIControlStateNormal];
        btnItemStr = @"YES";

    }
    [_oneScrollAnserBtn replaceObjectAtIndex:btn.tag withObject:btnItemStr];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _oneScrollAnserBtn = [[NSMutableArray alloc]init];
    for (int i=0; i<65; i++) {
        [_oneScrollAnserBtn addObject:@"NO"];
    }
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
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"心理问卷",@"生活问卷",@"中医问卷",nil];
    
    //初始化UISegmentedControl
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    
    segmentedControl.frame = CGRectMake(-5.0, 0, 330.0, 30.0);
    
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
        titName=@"心理问卷";
        conten=@"医学研究证明，许多个人行为和生活因素会影响个体健康趋势。通过对收集的生活方式信息进行汇总分析后得出以下报告，总结了您目前主要的生活方式情况并给出指导意见，同时根据人群数据估计出相关的健康风险。希望您通过此报告，发现并改善不良健康习惯，有效控制健康风险。";
        [self showOneView];
    }if (con.selectedSegmentIndex==1) {
         titName=@"生活问卷";
        conten=@"<<症状自评量表-SCL90>>是世界上最著名的心理健康测试量表之一,是当前使用最为广泛的精神障碍和心理疾病门诊检查量表,将协助您从十个方面来了解自己的心理健康程度.本测试适用对象为16岁以上的用户.适用于测查某人群中那些人可能有心理障碍,某人可能有何种心理障碍及其严重程度如何.不适合于躁狂症和精神分裂症.";

    }if (con.selectedSegmentIndex==2) {
         titName=@"中医问卷";
        conten=@"中华中医药学会根据中医理论和现代相关科学知识体系将人体体质分为平和质,气虚质,阳虚质,阴虚质,痰湿质,湿热质,气郁质,七个基本类型.处理平和质,其他都属于亚健康性质.中医养生应该根据自身的体质类型来进行.本问卷来源于中华中医药学会<<中医体质分类与判定>>(ZYYXH/T157-2009).";

    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titName
                                                    message:conten
                                                   delegate:nil
                                          cancelButtonTitle:@"我知道了"
                                          otherButtonTitles:nil];
    [alert show];
    
    
}

@end
