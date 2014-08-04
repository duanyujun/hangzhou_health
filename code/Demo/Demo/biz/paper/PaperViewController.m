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
    NSMutableArray *_oneScrollAnserImageVewi;
    NSMutableArray *_oneScrollAnserImageVewiThree;
    NSMutableArray *_oneScrollAnserBtnThree;
    NSMutableArray *_oneScrollAnserImageVewiFour;
    NSMutableArray *_oneScrollAnserImageVewiLastAll;
    NSMutableArray *_oneScrollAnserImageVewiLastOnlyTwo;
    NSMutableArray *_oneScrollAnserImageVewiLastOnlyTwoFive;
    NSMutableArray *_oneScrollAnserBtnThreeLastOne;

    UIScrollView *_twoScrollo;
    NSMutableArray *_twoScrollAnserBtn;

    UIScrollView *_threeScrollo;
    NSMutableArray *_threeScrollAnserBtn;

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
        _oneScrollAnserImageVewi = [[NSMutableArray alloc]initWithCapacity:2];
        _oneScrollAnserImageVewiThree = [[NSMutableArray alloc]initWithCapacity:2];
        
        _oneScrollo = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, 320, kScreenHeight-30-120)];
        _oneScrollo.backgroundColor =[UIColor clearColor];
        [self.view addSubview:_oneScrollo];
        //youy_yes@2x  gouy_no.png
        
        
        NSArray *oneLabeQuertin = @[@"1.本人患病情况 (多选题)",@"2.父亲患病情况 (多选题)",@"3.母亲患病情况 (多选题)",@"4.祖父母患病情况 (多选题)",@"5.(外)祖父母患病情况 (多选题)",
            @"1.米、面、薯类平均日摄入量： (一碗指2两)",@"2.肉类及肉制品平均日摄入量：",@"3.鱼类及水产品平均日摄入量：",@"4.蛋类及蛋制品平均日摄入量：(一个是指约50克)",@"5.奶类及奶制品平均日摄入量：(一杯是指约200ml)",@"6.大豆及豆制品平均日摄入量：",@"7.新鲜蔬菜平均日摄入量：",@"8.新鲜水果平均日摄入量：",@"9.平均日饮水摄入量：(一杯是指约200ml)",
            @"1.您平均每周吃早餐的天数：",@"2.您平均每周吃夜宵的天数：",@"3.您目前饮食方面的喜好： (多选题)",@"4.您目前饮食的不良习惯： (多选题)",@"1.您平均每天的工作时间",@"2.平均每天坐姿(静止)时间:",@"3.您平均每周运动锻炼的时间:",@"4.您一般锻炼的强度是:",@"1.您当前吸烟情况的描述是：",@"2.平均每天吸香烟的支数是：",@"3.您总共吸烟的年数是：",@"4.平均每周被动吸烟情况：",@"1.您当前饮酒情况的描述是：",@"2.您最常饮酒的类型：",@"3.平均每天饮酒的两数是：（折算成白酒）",@"4.您总共饮酒的年数是：",@"1.您是否受一些重大意外困扰：",@"2.您的情绪对工作或生活的影响：",@"3.您感觉到自己的精神压力：",@"4.您感觉自己的睡眠充足吗：",@"5.您的糖皮质激素服用情况： ",@"6.您经常接触到有害因素："];
        
        _showItemLabel = [[MBLabel alloc]initWithFrame:CGRectMake(10, 35, 310, 30)];
        _showItemLabel.font=kNormalTextFont;
        _showItemLabel.adjustsFontSizeToFitWidth=YES;
        _showItemLabel.text = @"第一部分:患病部分";
        [self.view addSubview:_showItemLabel];
        
        NSArray *allbingArray  = @[@"高血压",@"糖尿病",@"冠心病",@"高脂血糖",@"肥胖",@"中风",@"肺癌",@"牵累腺癌",@"乳腺癌",@"骨质疏松",@"老年痴呆",@"肝癌",@"胃癌",@"肝癌",@"胃癌"];
        
        
        NSArray *allBinTwoArray = @[@"<1碗",@"1-2碗",@"2-4碗",@"4-6碗",@">=6碗",
                                    @"不吃",@"<1两",@"1-2两",@"2-5两",@">=5两",
                                    @"不吃",@"<1两",@"1-2两",@"2-5两",@">=5两",
                                    @"不吃",@"<1个",@"1-2个",@"2-3个",@">=3个",
                                    @"不吃",@"<1杯",@"1-2杯",@"2-3杯",@">=3杯",
                                    @"不吃",@"<0.5两",@"0.5-1两",@"1-2两",@">=2两",
                                    @"<2两",@"2-6两",@"6-10两",@"10-15两",@">=15两",
                                    @"<1两",@"1-4两",@"4-8两",@"8-12两",@">=12两",
                                    @"<3杯",@"3-6杯",@"6-9杯",@"9-12杯",@">=12杯",
                                    
                                    @"没有",@"1-2小时",@"2-5小时",@"5-8小时",@">=8小时",
                                    @"没有",@"1-2小时",@"2-5小时",@"5-8小时",@">=8小时",
                                    @"不锻炼",@"1-2小时",@"2-5小时",@"2-4小时",@">=4小时",
                                    @"不锻炼",@"极轻度运动",@"轻度运动",@"中度运动",@"重度运动",
                                    @"从不",@"偶尔",@"戒烟",@"吸烟",@"",
                                    @"<5支",@"5-15支",@"15-25支",@"25-40支",@">=40支",
                                    @"<5年",@"5-15年",@"15-25年",@"25-40年",@">=40年",
                                    @"没有",@"1-2天",@"3-4天",@"5-6天",@"7天",
                                    @"从不",@"偶尔",@"戒烟",@"吸烟",@"",
                                    @"白酒",@"黄酒",@"红酒",@"啤酒",@"其他",
                                    @"<2两",@"2-4两",@"4-6两",@"6-8两",@">=8两",
                                    @"<5年",@"5-15年",@"15-25年",@"25-40年",@">=40年",
                                    ];
        
        NSArray *allBinThreeArray = @[@"没有",@"1-2天",@"3-4天",@"5-6天",@"7天",
                                      @"没有",@"1-2天",@"3-4天",@"5-6天",@"7天",];
        NSArray *allBinThreeArrayAllSel = @[@"咸",@"酸",@"甜",@"辣",@"生",@"冷",@"硬",@"烫",@"煎炸",@"油腻",@"腌肉"];
        
        NSArray *allBinThreeArrayAllSelT = @[@"吃饭时喝水",@"吃饭过快",@"吃得过饱",@"晚餐过晚",@"生",@"冷",@"硬",@"烫",@"煎炸",@"油腻",@"腌肉"];
        NSArray *allBinThreeArrayLast = @[@"否",@"是",
                                          @"几乎没有",@"有一点",@"较明显",@"很大",
                                          @"几乎没有",@"有一点",@"较明显",@"很大",
                                          @"充足",@"一般",@"不足",@"严重不足",
                                          @"没有",@"<3月",@"3-12月",@"1-3年",@"3年以上"];
        NSArray *allBinThreeArrayFieveLast = @[@"没有",@"<3月",@"3-12月",@"1-3年",@"3年以上"];
        NSArray *allBinThreeArrayFieveLastTreun = @[@"油烟",@"粉烟尘",@"毒物、致癌物",@"高温",@"低温",@"燥音",@"辐射"];

        for (int i=0; i<oneLabeQuertin.count; i++) {
            
            MBBaseScrollView *contenView  =[[MBBaseScrollView alloc]initWithFrame:CGRectMake(320*i, 0, 320, kScreenHeight-30-120)];

            contenView.backgroundColor =[UIColor clearColor];
            MBLabel *label = [[MBLabel alloc]initWithFrame:CGRectMake(10, 10, 310, 30)];
            label.font=kNormalTextFont;
            label.adjustsFontSizeToFitWidth=YES;
            label.text = oneLabeQuertin[i];
            [contenView addSubview:label];
            
            if (i<5) {
                
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
                            [btn addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];

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

                for (int j=0; j<5; j++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame= CGRectMake(5, 60+40*j, 320, 40);
                    [btn addTarget:self action:@selector(btnSelectShowTwo:) forControlEvents:UIControlEventTouchUpInside];
                    btn.tag=5*(i-5)+j;
                    
                    
                    UIImageView *seplectimageVIew =[[UIImageView alloc]initWithFrame:CGRectMake(0, 100+40*j, 320, 1)];
                    seplectimageVIew.backgroundColor=[UIColor grayColor];
                    [contenView addSubview:seplectimageVIew];
                    
                    UIImageView *imageVIew =[[UIImageView alloc]initWithFrame:CGRectMake(250, 65+40*j, 27, 27)];
                    imageVIew.image =[UIImage imageNamed:@"youy_yes.png"];
                    imageVIew.hidden=YES;
                    imageVIew.tag =5*(i-5)+j;
                    [contenView addSubview:imageVIew];
                    [_oneScrollAnserImageVewi addObject:imageVIew];
                    MBLabel *labelShow = [[MBLabel alloc]initWithFrame:CGRectMake(20, 60+40*j, 300, 40)];
                    labelShow.font=[UIFont fontWithName:@"Helvetica Neue" size:18];
                    labelShow.textColor = HEX(@"#007aff");
                    
                    labelShow.text = allBinTwoArray[5*(i-5)+j];
                    
                    [contenView addSubview:labelShow];
                    
                    [contenView addSubview:btn];
                }
                
            }
            if (i>13&&i<=15) {
                
                
                for (int j=0; j<5; j++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame= CGRectMake(5, 60+40*j, 320, 40);
                    [btn addTarget:self action:@selector(btnSelectShowThree:) forControlEvents:UIControlEventTouchUpInside];
                    btn.tag=5*(i-5-9)+j;
                    
                    
                    UIImageView *seplectimageVIew =[[UIImageView alloc]initWithFrame:CGRectMake(0, 100+40*j, 320, 1)];
                    seplectimageVIew.backgroundColor=[UIColor grayColor];
                    [contenView addSubview:seplectimageVIew];
                    
                    UIImageView *imageVIew =[[UIImageView alloc]initWithFrame:CGRectMake(250, 65+40*j, 27, 27)];
                    imageVIew.image =[UIImage imageNamed:@"youy_yes.png"];
                    imageVIew.hidden=YES;
                    imageVIew.tag =5*(i-5-9)+j;
                    [contenView addSubview:imageVIew];
                    [_oneScrollAnserImageVewiThree addObject:imageVIew];
                    MBLabel *labelShow = [[MBLabel alloc]initWithFrame:CGRectMake(20, 60+40*j, 300, 40)];
                    labelShow.font=[UIFont fontWithName:@"Helvetica Neue" size:18];
                    labelShow.textColor = HEX(@"#007aff");
                    
                    labelShow.text = allBinThreeArray[5*(i-5-9)+j];
                    
                    [contenView addSubview:labelShow];
                    
                    [contenView addSubview:btn];
                }

                
            }
            if (i==16) {
                for (int j=0; j<4; j++) {
                    for (int k=0; k<3; k++) {
                        
                        if (j==3) {
                        if(k==0||k==1){
                                
                                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                                [btn addTarget:self action:@selector(btnSelectThreeAbout:) forControlEvents:UIControlEventTouchUpInside];
                                [btn setBackgroundImage:[UIImage imageNamed:@"btn_check_off_normal"] forState:UIControlStateNormal];
                                btn.frame= CGRectMake(5+105*k, 60+50*j, 25, 25);
                                btn.tag=3*j+k;
                                MBLabel *labelShow = [[MBLabel alloc]initWithFrame:CGRectMake(30+105*k, 57+50*j, 80, 30)];
                                labelShow.font=kNormalTextFont;
                                
                                
                                labelShow.text = allBinThreeArrayAllSel[3*j+k];
                                
                                [contenView addSubview:labelShow];
                                
                                [contenView addSubview:btn];
                                
                            }
                        }else
                        {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            [btn setBackgroundImage:[UIImage imageNamed:@"btn_check_off_normal"] forState:UIControlStateNormal];
                            [btn addTarget:self action:@selector(btnSelectThreeAbout:) forControlEvents:UIControlEventTouchUpInside];

                            btn.frame= CGRectMake(5+105*k, 60+50*j, 25, 25);
                            [btn addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
                            btn.tag=3*j+k;
                            
                            MBLabel *labelShow = [[MBLabel alloc]initWithFrame:CGRectMake(30+105*k, 57+50*j, 80, 30)];
                            labelShow.font=kNormalTextFont;
                            
                            
                            labelShow.text = allBinThreeArrayAllSel[3*j+k];
                            
                            [contenView addSubview:labelShow];
                            
                            [contenView addSubview:btn];
                        }
                        
                        
                    }
                }
            }
            if (i==17) {
                for (int j=0; j<2; j++) {
                    for (int k=0; k<2; k++) {
                        
                        
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        [btn addTarget:self action:@selector(btnSelectThreeAbout:) forControlEvents:UIControlEventTouchUpInside];
                        [btn setBackgroundImage:[UIImage imageNamed:@"btn_check_off_normal"] forState:UIControlStateNormal];
                        btn.frame= CGRectMake(5+135*k, 60+50*j, 25, 25);
                        btn.tag=2*j+k+11;
                        MBLabel *labelShow = [[MBLabel alloc]initWithFrame:CGRectMake(30+135*k, 57+50*j, 110, 30)];
                        labelShow.font=kNormalTextFont;
                        
                        
                        labelShow.text = allBinThreeArrayAllSelT[2*j+k];
                        
                        [contenView addSubview:labelShow];
                        
                        [contenView addSubview:btn];
                        
                    }
                }
            }
            if (i>=18&&i<30) {
                
                for (int j=0; j<5; j++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame= CGRectMake(5, 60+40*j, 320, 40);
                    [btn addTarget:self action:@selector(btnSelectShowFour:) forControlEvents:UIControlEventTouchUpInside];
                    btn.tag=5*(i-5-9-4)+j;
                    
                    
                    UIImageView *seplectimageVIew =[[UIImageView alloc]initWithFrame:CGRectMake(0, 100+40*j, 320, 1)];
                    seplectimageVIew.backgroundColor=[UIColor grayColor];
                    [contenView addSubview:seplectimageVIew];
                    
                    UIImageView *imageVIew =[[UIImageView alloc]initWithFrame:CGRectMake(250, 65+40*j, 27, 27)];
                    imageVIew.image =[UIImage imageNamed:@"youy_yes.png"];
                    imageVIew.hidden=YES;
                    imageVIew.tag =5*(i-5-9-4)+j;
                    [contenView addSubview:imageVIew];
                    [_oneScrollAnserImageVewiFour addObject:imageVIew];
                    MBLabel *labelShow = [[MBLabel alloc]initWithFrame:CGRectMake(20, 60+40*j, 300, 40)];
                    labelShow.font=[UIFont fontWithName:@"Helvetica Neue" size:18];
                    labelShow.textColor = HEX(@"#007aff");
 
                    labelShow.text = allBinTwoArray[45+5*(i-18)+j];
                    NSLog(@"sdfsdf====%d",5*i+j-46);
                    [contenView addSubview:labelShow];
                    
                    [contenView addSubview:btn];
                }
                
            }
            if (i==30) {
                
                for (int j=0; j<2; j++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame= CGRectMake(5, 60+40*j, 320, 40);
                    [btn addTarget:self action:@selector(btnSelectShowLastOnleTwo:) forControlEvents:UIControlEventTouchUpInside];
                    btn.tag=j;
                    
                    
                    UIImageView *seplectimageVIew =[[UIImageView alloc]initWithFrame:CGRectMake(0, 100+40*j, 320, 1)];
                    seplectimageVIew.backgroundColor=[UIColor grayColor];
                    [contenView addSubview:seplectimageVIew];
                    
                    UIImageView *imageVIew =[[UIImageView alloc]initWithFrame:CGRectMake(250, 65+40*j, 27, 27)];
                    imageVIew.image =[UIImage imageNamed:@"youy_yes.png"];
                    imageVIew.hidden=YES;
                    [contenView addSubview:imageVIew];
                    [_oneScrollAnserImageVewiLastOnlyTwo addObject:imageVIew];
                    MBLabel *labelShow = [[MBLabel alloc]initWithFrame:CGRectMake(20, 60+40*j, 300, 40)];
                    labelShow.font=[UIFont fontWithName:@"Helvetica Neue" size:18];
                    labelShow.textColor = HEX(@"#007aff");
                    
            
                        
                    labelShow.text = allBinThreeArrayLast[j];
                    
                    [contenView addSubview:labelShow];
                    
                    [contenView addSubview:btn];
                }
                

            }
            
            if (i>30&&i<34) {
                
                for (int j=0; j<4; j++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame= CGRectMake(5, 60+40*j, 320, 40);
                    [btn addTarget:self action:@selector(btnSelectShowSeven:) forControlEvents:UIControlEventTouchUpInside];
                    btn.tag=j+4*(i-31);
                    
                    
                    UIImageView *seplectimageVIew =[[UIImageView alloc]initWithFrame:CGRectMake(0, 100+40*j, 320, 1)];
                    seplectimageVIew.backgroundColor=[UIColor grayColor];
                    [contenView addSubview:seplectimageVIew];
                    
                    UIImageView *imageVIew =[[UIImageView alloc]initWithFrame:CGRectMake(250, 65+40*j, 27, 27)];
                    imageVIew.image =[UIImage imageNamed:@"youy_yes.png"];
                    imageVIew.hidden=YES;
                    [contenView addSubview:imageVIew];
                    [_oneScrollAnserImageVewiLastAll addObject:imageVIew];
                    MBLabel *labelShow = [[MBLabel alloc]initWithFrame:CGRectMake(20, 60+40*j, 300, 40)];
                    labelShow.font=[UIFont fontWithName:@"Helvetica Neue" size:18];
                    labelShow.textColor = HEX(@"#007aff");
                    
                    labelShow.text = allBinThreeArrayLast[j+4*(i-31)+2];
                    
                    [contenView addSubview:labelShow];
                    
                    [contenView addSubview:btn];
                }

            }
            if (i==34) {
                
                for (int j=0; j<5; j++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame= CGRectMake(5, 60+40*j, 320, 40);
                    [btn addTarget:self action:@selector(btnSelectShowLastOnleTwo:) forControlEvents:UIControlEventTouchUpInside];
                    btn.tag=j;
                    
                    
                    UIImageView *seplectimageVIew =[[UIImageView alloc]initWithFrame:CGRectMake(0, 100+40*j, 320, 1)];
                    seplectimageVIew.backgroundColor=[UIColor grayColor];
                    [contenView addSubview:seplectimageVIew];
                    
                    UIImageView *imageVIew =[[UIImageView alloc]initWithFrame:CGRectMake(250, 65+40*j, 27, 27)];
                    imageVIew.image =[UIImage imageNamed:@"youy_yes.png"];
                    imageVIew.hidden=YES;
                    [contenView addSubview:imageVIew];
                    [_oneScrollAnserImageVewiLastOnlyTwoFive addObject:imageVIew];
                    MBLabel *labelShow = [[MBLabel alloc]initWithFrame:CGRectMake(20, 60+40*j, 300, 40)];
                    labelShow.font=[UIFont fontWithName:@"Helvetica Neue" size:18];
                    labelShow.textColor = HEX(@"#007aff");
                    
                    
                    
                    labelShow.text = allBinThreeArrayFieveLast[j];
                    
                    [contenView addSubview:labelShow];
                    
                    [contenView addSubview:btn];
                }

            }
            if (i==35) {
                
                for (int j=0; j<3; j++) {
                    for (int k=0; k<3; k++) {
                        
                        if (j==2) {
                           if(k==0){
                                
                                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                                [btn addTarget:self action:@selector(btnSelectLastOne:) forControlEvents:UIControlEventTouchUpInside];
                                [btn setBackgroundImage:[UIImage imageNamed:@"btn_check_off_normal"] forState:UIControlStateNormal];
                                btn.frame= CGRectMake(5+85*k, 60+50*j, 25, 25);
                                btn.tag=3*j+k;
                                MBLabel *labelShow = [[MBLabel alloc]initWithFrame:CGRectMake(30+85*k, 57+50*j, 80, 30)];
                                labelShow.font=kNormalTextFont;
                                
                                
                                labelShow.text = allBinThreeArrayFieveLastTreun[3*j+k];
                                
                                [contenView addSubview:labelShow];
                                
                                [contenView addSubview:btn];
                                
                            }
                        }else
                        {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            [btn setBackgroundImage:[UIImage imageNamed:@"btn_check_off_normal"] forState:UIControlStateNormal];
                            [btn addTarget:self action:@selector(btnSelectLastOne:) forControlEvents:UIControlEventTouchUpInside];
                            
                            btn.frame= CGRectMake(5+85*k, 60+50*j, 25, 25);
                            [btn addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
                            btn.tag=3*j+k;
                            
                            MBLabel *labelShow = [[MBLabel alloc]initWithFrame:CGRectMake(30+85*k, 57+50*j, 90, 30)];
                            labelShow.font=kNormalTextFont;
                            
                            
                            labelShow.text = allBinThreeArrayFieveLastTreun[3*j+k];
                            
                            [contenView addSubview:labelShow];
                            
                            [contenView addSubview:btn];
                        }
                        
                        
                    }
                }
            }
            [_oneScrollo addSubview:contenView];
            
        }
        _oneScrollo.contentSize = CGSizeMake(320*oneLabeQuertin.count, kScreenHeight-150);
        _oneScrollo.showsHorizontalScrollIndicator = NO;
        _oneScrollo.showsVerticalScrollIndicator = NO;
        _oneScrollo.pagingEnabled=YES;
        _oneScrollo.delegate=self;
        
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _slider.value=scrollView.contentOffset.x/320;
    if (_oneScrollo.hidden==NO) {
        if (_slider.value==35) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitRightBtnPressed)];
            
        }else
        {
            self.navigationItem.rightBarButtonItem=nil;
        }
    }
}
-(void)submitRightBtnPressed
{
    
}
-(void)btnSelectShowTwo:(UIButton *)btn
{
    
    for ( int i=btn.tag/5*5; i<btn.tag/5*5+5; i++) {
        UIImageView*iamgeView = _oneScrollAnserImageVewi[i];
        iamgeView.hidden=YES;
    }
    NSString *stirng = [NSString stringWithFormat:@"%f",_slider.value];
    
    [_oneScrollo scrollRectToVisible:CGRectMake([stirng intValue]*320+320, _oneScrollo.frame.origin.y, _oneScrollo.frame.size.width, _oneScrollo.frame.size.height) animated:YES];
    UIImageView*iamgeView = _oneScrollAnserImageVewi[btn.tag];
    iamgeView.hidden=NO;
    
    
}
-(void)btnSelectShowTwoAboutGood:(UIButton *)btn
{

    for ( int i=btn.tag/5*5; i<btn.tag/5*5+5; i++) {
        UIImageView*iamgeView = _twoScrollAnserBtn[i];
        iamgeView.hidden=YES;
    }
    UIImageView*iamgeView = _twoScrollAnserBtn[btn.tag];
    iamgeView.hidden=NO;
    
    NSString *stirng = [NSString stringWithFormat:@"%f",_slider.value];

    [_twoScrollo scrollRectToVisible:CGRectMake([stirng intValue]*320+320, _oneScrollo.frame.origin.y, _oneScrollo.frame.size.width, _oneScrollo.frame.size.height) animated:YES];
    
}
-(void)btnSelectShowTwoAboutGoodThree:(UIButton *)btn
{
    
    for ( int i=btn.tag/5*5; i<btn.tag/5*5+5; i++) {
        UIImageView*iamgeView = _threeScrollAnserBtn[i];
        iamgeView.hidden=YES;
    }
    UIImageView*iamgeView = _threeScrollAnserBtn[btn.tag];
    iamgeView.hidden=NO;
    
    NSString *stirng = [NSString stringWithFormat:@"%f",_slider.value];
    
    [_threeScrollo scrollRectToVisible:CGRectMake([stirng intValue]*320+320, _threeScrollo.frame.origin.y, _threeScrollo.frame.size.width, _threeScrollo.frame.size.height) animated:YES];
    
}
-(void)btnSelectShowThree:(UIButton *)btn
{
    
    for ( int i=btn.tag/5*5; i<btn.tag/5*5+5; i++) {
        UIImageView*iamgeView = _oneScrollAnserImageVewiThree[i];
        iamgeView.hidden=YES;
    }
    NSString *stirng = [NSString stringWithFormat:@"%f",_slider.value];
    
    [_oneScrollo scrollRectToVisible:CGRectMake([stirng intValue]*320+320, _oneScrollo.frame.origin.y, _oneScrollo.frame.size.width, _oneScrollo.frame.size.height) animated:YES];
    UIImageView*iamgeView = _oneScrollAnserImageVewiThree[btn.tag];
    iamgeView.hidden=NO;
    
    
}
-(void)btnSelectShowFour:(UIButton *)btn
{
    
    for ( int i=btn.tag/5*5; i<btn.tag/5*5+5; i++) {
        UIImageView*iamgeView = _oneScrollAnserImageVewiFour[i];
        iamgeView.hidden=YES;
    }
    NSString *stirng = [NSString stringWithFormat:@"%f",_slider.value];
    
    [_oneScrollo scrollRectToVisible:CGRectMake([stirng intValue]*320+320, _oneScrollo.frame.origin.y, _oneScrollo.frame.size.width, _oneScrollo.frame.size.height) animated:YES];
    UIImageView*iamgeView = _oneScrollAnserImageVewiFour[btn.tag];
    iamgeView.hidden=NO;
    
}
-(void)btnSelectShowLastOnleFive:(UIButton *)btn
{
    
    for ( int i=0; i<5; i++) {
        UIImageView*iamgeView = _oneScrollAnserImageVewiLastOnlyTwoFive[i];
        iamgeView.hidden=YES;
    }
    NSString *stirng = [NSString stringWithFormat:@"%f",_slider.value];
    
    [_oneScrollo scrollRectToVisible:CGRectMake([stirng intValue]*320+320, _oneScrollo.frame.origin.y, _oneScrollo.frame.size.width, _oneScrollo.frame.size.height) animated:YES];
    UIImageView*iamgeView = _oneScrollAnserImageVewiLastOnlyTwoFive[btn.tag];
    iamgeView.hidden=NO;
    
    
}
-(void)btnSelectShowLastOnleTwo:(UIButton *)btn
{
    
    for ( int i=0; i<2; i++) {
        UIImageView*iamgeView = _oneScrollAnserImageVewiLastOnlyTwo[i];
        iamgeView.hidden=YES;
    }
    NSString *stirng = [NSString stringWithFormat:@"%f",_slider.value];
    
    [_oneScrollo scrollRectToVisible:CGRectMake([stirng intValue]*320+320, _oneScrollo.frame.origin.y, _oneScrollo.frame.size.width, _oneScrollo.frame.size.height) animated:YES];
    UIImageView*iamgeView = _oneScrollAnserImageVewiLastOnlyTwo[btn.tag];
    iamgeView.hidden=NO;
    
    
}
-(void)btnSelectShowSeven:(UIButton *)btn
{
    
    for ( int i=btn.tag/4*4; i<btn.tag/4*4+4; i++) {
        UIImageView*iamgeView = _oneScrollAnserImageVewiLastAll[i];
        iamgeView.hidden=YES;
    }
    NSString *stirng = [NSString stringWithFormat:@"%f",_slider.value];
    
    [_oneScrollo scrollRectToVisible:CGRectMake([stirng intValue]*320+320, _oneScrollo.frame.origin.y, _oneScrollo.frame.size.width, _oneScrollo.frame.size.height) animated:YES];
    UIImageView*iamgeView = _oneScrollAnserImageVewiLastAll[btn.tag];
    iamgeView.hidden=NO;
    
    
}

-(void)btnSelectThreeAbout:(UIButton*)btn
{
    NSLog(@"11111======%d",btn.tag);
    
    NSString *btnItemStr = _oneScrollAnserBtnThree[btn.tag];
    if ([btnItemStr isEqualToString:@"YES"]) {
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_check_off_normal.png"] forState:UIControlStateNormal];
        btnItemStr = @"NO";
    }else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_check_on_normal.png"] forState:UIControlStateNormal];
        btnItemStr = @"YES";
        
    }
    [_oneScrollAnserBtnThree replaceObjectAtIndex:btn.tag withObject:btnItemStr];
    
}

-(void)btnSelectLastOne:(UIButton*)btn
{
    NSLog(@"11111======%d",btn.tag);
    
    NSString *btnItemStr = _oneScrollAnserBtnThreeLastOne[btn.tag];
    if ([btnItemStr isEqualToString:@"YES"]) {
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_check_off_normal.png"] forState:UIControlStateNormal];
        btnItemStr = @"NO";
    }else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_check_on_normal.png"] forState:UIControlStateNormal];
        btnItemStr = @"YES";
        
    }
    [_oneScrollAnserBtnThreeLastOne replaceObjectAtIndex:btn.tag withObject:btnItemStr];
    
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
    _oneScrollAnserBtnThree = [[NSMutableArray alloc]initWithCapacity:2];
    _oneScrollAnserImageVewiFour = [[NSMutableArray alloc]initWithCapacity:2];
    _oneScrollAnserImageVewiLastAll = [[NSMutableArray alloc]initWithCapacity:2];
    _oneScrollAnserBtn = [[NSMutableArray alloc]init];
    _oneScrollAnserBtnThreeLastOne = [[NSMutableArray alloc]initWithCapacity:2];
    
    _oneScrollAnserImageVewiLastOnlyTwo = [[NSMutableArray alloc]initWithCapacity:2];
    for (int i=0; i<65; i++) {
        [_oneScrollAnserBtn addObject:@"NO"];
    }
    for (int i=0; i<7; i++) {
        [_oneScrollAnserBtnThreeLastOne addObject:@"NO"];
    }


    for (int i=0; i<15; i++) {
        [_oneScrollAnserBtnThree addObject:@"NO"];
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
 	_slider.maximumValue = 35;
    _slider.value = 0;
    
    [_slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:_slider];
    
    
    
}
-(void)updateValue:(UISlider*)sender{
 
    NSString *stirng = [NSString stringWithFormat:@"%f",sender.value];
    if (_oneScrollo.hidden==NO) {
            [_oneScrollo scrollRectToVisible:CGRectMake([stirng intValue]*320, _oneScrollo.frame.origin.y, _oneScrollo.frame.size.width, _oneScrollo.frame.size.height) animated:YES];
    }

    if (_twoScrollo.hidden==NO) {
        [_twoScrollo scrollRectToVisible:CGRectMake([stirng intValue]*320, _twoScrollo.frame.origin.y, _twoScrollo.frame.size.width, _twoScrollo.frame.size.height) animated:YES];
    }

    if (_threeScrollo.hidden==NO) {
        [_threeScrollo scrollRectToVisible:CGRectMake([stirng intValue]*320, _threeScrollo.frame.origin.y, _threeScrollo.frame.size.width, _threeScrollo.frame.size.height) animated:YES];
    }

}

-(void)showTwoView
{
    if (!_twoScrollo) {
        _twoScrollAnserBtn = [[NSMutableArray alloc]initWithCapacity:2];
        
        
        _twoScrollo = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, 320, kScreenHeight-30-120)];
        _twoScrollo.backgroundColor =[UIColor clearColor];
        [self.view addSubview:_twoScrollo];
        NSArray *oneLabeQuertin = @[@"1、 头痛",@"2、 严重神经过敏，心神不定",@"3、 头脑中有不必要的想法或字句盘旋",@"4、 头晕或昏倒",@"5、 对异性的兴趣减退",@"6、 对旁人责备求全",@"7、 感到别人能控制你的思想",@"8、 责怪别人制造麻烦",@"9、 忘记性大",@"10、 担心自己的衣饰整齐及仪态的端庄",
                                    @"11、 容易烦恼和激动",@"12、 胸痛",@"13、 害怕空旷的场所或街道",@"14、 感到自己精力下降，活动减慢",@"15、 想结束自己的生命",@"16、听到旁人听不到声音",@"17、 发抖",@"18、 感到大多数人都不可信任",@"19、胃口不好",@"20、容易哭泣",
                                    @"21、 同异性相处时感到害羞不自在",@"22、 感到受骗，中了圈套或有人想抓你",@"23、 无缘无故的感觉到害怕",@"24、 自己不能控制的大发脾气",@"25、 怕单独出门",@"26、 经常责怪自己",@"27、 腰痛",@"28、 感到难以完成任务",@"29、 感到孤独",@"30、 感到苦闷",
                                    @"31、 过分担忧",@"32、 对事物不感兴趣",@"33、 感到害怕",@"34、 你的感情容易受到伤害",@"35、 旁人能知道你的私下想法",@"36、 感到别人不理解你不同情你",@"37、 感到人们对你不友好，不喜欢你",@"38、 做事情必须做得很慢以保证做正确",@"39、 心跳得厉害",@"40、 恶心或胃不舒服",
                                    @"41、 感到比不上别人",@"42、 肌肉酸痛",@"43、 感到有人在监视你谈论你",@"44、 难以入睡",@"45、 做事必须反复检查",@"46、 难以做出决定",@"47、 怕乘电车、公共汽车、地铁或火车",@"48、 呼吸困难",@"49、 一阵阵发冷或发热",@"50、 因为感到害怕而避开某些东西、场合或活动",
                                    @"51、 脑子变空了",@"52、 身体发麻或刺痛",@"53、 喉咙有梗塞感",@"54、 感到前途没有希望",@"55、 不能集中注意力",@"56、 感到身体的某一部分软弱无力",@"57、 感到紧张或容易紧张",@"58、 感到手或脚发重",@"59、 感到死亡的事",@"60、 吃得太多",
                                    @"61、 当别人看着你或谈论你时感到不自在",@"62、 有一些不属于你自己的看法",@"63、 有想打人或伤害他人的冲动",@"64、 醒得太早",@"65、 必须反复洗手、点数目或触摸某些东西必须反复洗手、点数目或触摸某些东西",@"66、 睡得不稳不深",@"67、 有想摔坏或破坏东西的冲动",@"68、 有一些别人没有的想法或念头",@"69、 感到对别人神经过敏",@"70、 在商场或电影院等人多的地方感到不自在",
                                    @"71、 感到任何事情都很困难",@"72、 一阵阵恐惧或惊恐",@"73、 感到在公共场合吃东西很不舒服",@"74、 经常与人争论",@"75、 单独一个人时神经很紧张",@"76、 别人对你的成绩没有做出恰当的评论",@"77、 即使和别人在一起也感到孤独",@"78、 感到坐立不安心神不定",@"79、 感到自己没有什么价值",@"80、 感到熟悉的东西变陌生或不象真的",
                                    @"81、 大叫或摔东西",@"82、 害怕会在公共场合昏倒",@"83、 感到别人想占你便宜",@"84、 为一些有关“性”的想法而苦恼",@"85、 你认为应该因为自己的过错而受惩罚",@"86、 感到要赶快把事情做完",@"87、 感到自己的身体有严重问题",@"88、 从未感到和其他人亲近",@"89、 感到自己有罪",@"90、 感到自己的脑子有毛病"];
        
        NSArray *ansere = @[@"没有",@"很轻",@"中等",@"偏重",@"严重"];
        
        for (int i=0; i<oneLabeQuertin.count; i++) {
            
            MBBaseScrollView *contenView  =[[MBBaseScrollView alloc]initWithFrame:CGRectMake(320*i, 0, 320, kScreenHeight-30-120)];
            
            contenView.backgroundColor =[UIColor clearColor];
            MBLabel *label = [[MBLabel alloc]initWithFrame:CGRectMake(10, 10, 310, 30)];
            label.font=kNormalTextFont;
            label.adjustsFontSizeToFitWidth=YES;
            label.text = oneLabeQuertin[i];
            [contenView addSubview:label];
            
                for (int j=0; j<5; j++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame= CGRectMake(5, 60+40*j, 320, 40);
                    [btn addTarget:self action:@selector(btnSelectShowTwoAboutGood:) forControlEvents:UIControlEventTouchUpInside];
                    btn.tag=5*(i)+j;
                    
                    
                    UIImageView *seplectimageVIew =[[UIImageView alloc]initWithFrame:CGRectMake(0, 100+40*j, 320, 1)];
                    seplectimageVIew.backgroundColor=[UIColor grayColor];
                    [contenView addSubview:seplectimageVIew];
                    
                    UIImageView *imageVIew =[[UIImageView alloc]initWithFrame:CGRectMake(250, 65+40*j, 27, 27)];
                    imageVIew.image =[UIImage imageNamed:@"youy_yes.png"];
                    imageVIew.hidden=YES;
                    imageVIew.tag =5*(i)+j;
                    [contenView addSubview:imageVIew];
                    [_twoScrollAnserBtn addObject:imageVIew];
                    MBLabel *labelShow = [[MBLabel alloc]initWithFrame:CGRectMake(20, 60+40*j, 300, 40)];
                    labelShow.font=[UIFont fontWithName:@"Helvetica Neue" size:18];
                    labelShow.textColor = HEX(@"#007aff");
                    
                    labelShow.text = ansere[j];
                    
                    [contenView addSubview:labelShow];
                    
                    [contenView addSubview:btn];
                }
            [_twoScrollo addSubview:contenView];
            
        }
        
        _twoScrollo.contentSize = CGSizeMake(320*oneLabeQuertin.count, kScreenHeight-150);
        _twoScrollo.showsHorizontalScrollIndicator = NO;
        _twoScrollo.showsVerticalScrollIndicator = NO;
        _twoScrollo.pagingEnabled=YES;
        _twoScrollo.delegate=self;

    }
    
}

-(void)showThreeView
{
    if (!_threeScrollo) {
        _threeScrollAnserBtn = [[NSMutableArray alloc]initWithCapacity:2];
        
        
        _threeScrollo = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, 320, kScreenHeight-30-120)];
        _threeScrollo.backgroundColor =[UIColor clearColor];
        [self.view addSubview:_threeScrollo];
        NSArray *oneLabeQuertin = @[@"1、 您精力充沛吗？",@"2、 您容易疲乏吗？",@"3、 您容易气短（呼吸短促，接不上气）吗？",@"4、 您容易心慌吗？",@"5、 您容易头晕或站起时晕眩吗？",@"6、 您喜欢安静、懒得说话吗？",@"7、 您说话声音低弱无力吗？",@"8、 您容易忘事（健忘）吗？",@"9、 您感到闷闷不乐、情绪低沉吗？",@"10、 您多愁善感、感情脆弱吗？",
                                    @"11、 您容易精神紧张、焦虑不安吗？",@"12、 您容易感到害怕或受到惊吓吗？",@"13、 您两肋部或乳房胀痛吗？",@"14、 您感到胸闷或腹部胀满吗？",@"15、 您无缘无故叹气吗？",@"16、 您感到身体沉重不轻松或不爽快吗？",@"17、 您感到手脚心发热吗？",@"18、 您手脚发凉吗？",@"19、 您胃脘部、背部或腰膝部怕冷吗？",@"20、 您感到怕冷、衣服比别人穿得多吗？",
                                    @"21、 您感觉身体、脸上发热吗？",@"22、 您比一般人耐受不了寒冷（冬天的寒冷或夏天的冷空调、电扇等）吗？",@"23、 您比别人容易患感冒吗？",@"24、 您不感冒时也会打喷嚏吗？",@"25、 您不感冒时也会鼻塞、流鼻涕吗？",@"26、 您有因季节变化、温度变化或异味等原因而咳喘的现象吗？",@"27、 您活动量稍大就容易出虚汗吗？",@"28、 您有额部油脂分泌多的现象吗？",@"29、 您皮肤或口唇干吗？",@"30、 您容易过敏（对药物、食物、气味、花粉或在季节交替、气候变化时）吗？",
                                    @"31、 您的皮肤容易起荨麻疹（风团、风疹块、风疙瘩）吗？",@"32、 您的皮肤因过敏出现过紫癜（紫红色瘀点、瘀斑）吗？",@"33、 您的皮肤在不知不觉中会出现乌青或青紫瘀斑（皮下出血）吗？",@"34、 您的皮肤一抓就红，并出现抓痕吗？",@"35、 您口唇的颜色比一般人红吗？",@"36、 您两颧部有细微红丝吗？",@"37、 您身体上有哪里疼痛吗？",@"38、 您面部两颧潮红或偏红吗？",@"39、 您面部或鼻部有油腻感或者油亮发光吗？",@"40、 您面色晦暗或容易出现褐斑吗？",
                                    @"41、 您容易生痤疮或疮疖吗？",@"42、 您上眼睑比别人肿（上眼睑有轻微隆起的现象）吗？",@"43、 您会出现黑眼圈吗？",@"44、 您感到眼睛干涩吗？",@"45、 您口唇颜色偏黯吗？",@"46、 您感到口干咽燥、总想喝水吗？",@"47、 您咽喉部有异物感，且吐之不出、咽之不下吗？",@"48、 您感到口苦或嘴里有异味吗？",@"49、 您嘴里有黏黏的感觉吗？",@"50、 您舌苔厚腻或有舌苔厚厚的感觉吗？",
                                    @"51、 您平时痰多，特别是咽喉部总感到有痰堵着吗？",@"52、 您吃（喝）凉的东西会感到不舒服或者怕吃（喝）凉东西吗？",@"53、 您能适应外界自然和社会环境的变化吗？",@"54、 您容易失眠吗？",@"55、 您受凉或吃（喝）凉的东西后，容易腹泻（拉肚子）吗？",@"56、 您大便黏滞不爽、有解不尽的感觉吗？",@"57、 您容易便秘或大便干燥吗？",@"58、 您腹部肥满松软吗？",@"59、 您小便时尿道有发热感、尿色浓（深）吗？",@"60、 您带下色黄（白带颜色发黄）吗？（限女性回答）",
                                    @"60、 您的阴囊部位潮湿吗？（限男性回答）"];
        
        NSArray *ansere = @[@"没有 （根本不）",@"很少 （有一点）",@"有时 （有    些）",@"经常 （相    当）",@"总是 （非    常）"];
        
        for (int i=0; i<oneLabeQuertin.count; i++) {
            
            MBBaseScrollView *contenView  =[[MBBaseScrollView alloc]initWithFrame:CGRectMake(320*i, 0, 320, kScreenHeight-30-120)];
            
            contenView.backgroundColor =[UIColor clearColor];
            MBLabel *label = [[MBLabel alloc]initWithFrame:CGRectMake(10, 10, 310, 30)];
            label.font=kNormalTextFont;
            label.adjustsFontSizeToFitWidth=YES;
            label.text = oneLabeQuertin[i];
            [contenView addSubview:label];
            
            for (int j=0; j<5; j++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame= CGRectMake(5, 60+40*j, 320, 40);
                [btn addTarget:self action:@selector(btnSelectShowTwoAboutGoodThree:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag=5*(i)+j;
                
                
                UIImageView *seplectimageVIew =[[UIImageView alloc]initWithFrame:CGRectMake(0, 100+40*j, 320, 1)];
                seplectimageVIew.backgroundColor=[UIColor grayColor];
                [contenView addSubview:seplectimageVIew];
                
                UIImageView *imageVIew =[[UIImageView alloc]initWithFrame:CGRectMake(250, 65+40*j, 27, 27)];
                imageVIew.image =[UIImage imageNamed:@"youy_yes.png"];
                imageVIew.hidden=YES;
                imageVIew.tag =5*(i)+j;
                [contenView addSubview:imageVIew];
                [_threeScrollAnserBtn addObject:imageVIew];
                MBLabel *labelShow = [[MBLabel alloc]initWithFrame:CGRectMake(20, 60+40*j, 300, 40)];
                labelShow.font=[UIFont fontWithName:@"Helvetica Neue" size:18];
                labelShow.textColor = HEX(@"#007aff");
                
                labelShow.text = ansere[j];
                
                [contenView addSubview:labelShow];
                
                [contenView addSubview:btn];
            }
            [_threeScrollo addSubview:contenView];
            
        }
        
        _threeScrollo.contentSize = CGSizeMake(320*oneLabeQuertin.count, kScreenHeight-150);
        _threeScrollo.showsHorizontalScrollIndicator = NO;
        _threeScrollo.showsVerticalScrollIndicator = NO;
        _threeScrollo.pagingEnabled=YES;
        _threeScrollo.delegate=self;
        
    }
    
}
-(void)segmentedCOntrollerPressed:(UISegmentedControl*)con
{
    NSString *titName=nil;
    NSString *conten=nil;
    if (con.selectedSegmentIndex==0) {
        titName=@"心理问卷";
        _slider.minimumValue = 0;
        _slider.maximumValue = 35;
        _slider.value = 0;
        _oneScrollo.hidden=NO;
        _twoScrollo.hidden=YES;
        _threeScrollo.hidden=YES;

        conten=@"《症状自评量表-SCL90》是世界上最著名的心理健康测试量表之一，是当前使用最为广泛的精神障碍和心理疾病门诊检查量表，将协助您从十个方面来了解自己的心理健康程度。 本测验适用对象为16岁以上的用户。适用于测查某人群中那些人可能有心理障碍、某人可能有何种心理障碍及其严重程度如何。不适合于躁狂症和精神分裂症。";
        [self showOneView];
    }if (con.selectedSegmentIndex==1) {
         titName=@"生活问卷";
        _slider.minimumValue = 0;
        _slider.maximumValue = 90;
        _slider.value = 0;
        _oneScrollo.hidden=YES;
        _twoScrollo.hidden=NO;
        _threeScrollo.hidden=YES;

        conten=@"医学研究证实，许多个人行为和生活因素会影响个体健康趋势。通过对收集的生活方式信息进行汇总分析后得出以下报告，总结了您目前主要的生活方式情况并给出指导意见，同时根据人群数据估算出相关的健康风险。希望您通过此报告，发现并改善不良健康习惯，有效控制健康风险。";
        [self showTwoView];

    }if (con.selectedSegmentIndex==2) {
         titName=@"中医问卷";
        conten=@"中华中医药学会根据中医理论和现代相关科学知识体系将人体体质分为平和质、气虚质、阳虚质、阴虚质、痰湿质、湿热质、血瘀质、气郁质、特禀质九个基本类型。除了平和质，其它八种都属于亚健康性质。中医养生应该根据自身的体质类型来进行。本问卷来源于中华中医药学会《中医体质分类与判定》(ZYYXH/T157-2009)。";
        _oneScrollo.hidden=YES;
        _twoScrollo.hidden=YES;
        _threeScrollo.hidden=NO;
        _slider.minimumValue = 0;
        _slider.maximumValue = 60;
        _slider.value = 0;
        [self showThreeView];

    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titName
                                                    message:conten
                                                   delegate:nil
                                          cancelButtonTitle:@"我知道了"
                                          otherButtonTitles:nil];
    [alert show];
    
    
}

@end
