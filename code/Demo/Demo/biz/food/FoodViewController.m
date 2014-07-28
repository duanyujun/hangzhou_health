 //
//  FoodViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-30.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "FoodViewController.h"
#import "XMLDictionary.h"
#import "MBIIRequest.h"
#import "SoapHelper.h"
#import "TiJianReprotCell.h"
#import "FoodAllTableViewController.h"
#import "DBHelper.h"
#import "MBTextField.h"
#import "MBSegmentControl.h"
#import "MBAlertView.h"
@interface FoodViewController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,MBSegmentControlDelegate,MBTextFieldDelegate>
{
    UIScrollView *_fistView;
    NSDictionary *_infoDicAbout;
    UITableView*_tableView;
    UIView *_sendView;
    UILabel *_foodTypeLbl;
    
    UILabel *_foodCountLabl;
    UILabel *_needbuchonLbl;
    UILabel *_lingshiLbl;
    NSString *_timeAoubtFood;//早餐，午餐，晚餐，夜宵，零食
    
    NSMutableArray * _showDic;
    NSMutableArray *_curShowArray;
    UIButton *_btnFoodType;
    NSDictionary *_curFoodInfo;
    MBTextField *_keWeiAboutFood;
    UILabel *_allShuruLbl;
    UILabel *_keLabl;
    NSInteger _deleIndexAboutArray;
    BOOL _isGetSeleThing;
}
@end

@implementation FoodViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isGetSeleThing) {
        [_keWeiAboutFood becomeFirstResponder];
        
    }
    _isGetSeleThing=NO;
}
//返回到上个页面
-(void)backViewUPloadView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)textFieldDidFinsihEditing:(MBTextField *)textField
{
    [self uploadFoodKC];
}
-(void)getKCResult:(NSNotification*)noc
{
    _isGetSeleThing=YES;
    _allShuruLbl.hidden=NO;
    _keWeiAboutFood.hidden=NO;
    _keLabl.hidden=NO;
    
    NSDictionary*dic=(NSDictionary*)[noc object];
    _curFoodInfo = [dic copy];
    [_btnFoodType setTitle:MBNonEmptyStringNo_(dic[@"name"]) forState:UIControlStateNormal];
    
   _foodCountLabl.frame= CGRectMake(_foodCountLabl.frame.origin.x, 20+95, _foodCountLabl.frame.size.width, _foodCountLabl.frame.size.height);
    _needbuchonLbl.frame= CGRectMake(_needbuchonLbl.frame.origin.x, 20+120, _needbuchonLbl.frame.size.width, _needbuchonLbl.frame.size.height);
    _lingshiLbl.frame= CGRectMake(_lingshiLbl.frame.origin.x,20+145, _lingshiLbl.frame.size.width, _lingshiLbl.frame.size.height);

    
    
}
-(void)goToLoginViewAbout
{
    MBNotLogViewController *notLogin =[[MBNotLogViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:notLogin];
    [self presentViewController:nav animated:YES completion:nil];
}
//上传菜单
-(void)uploadFoodKC
{
    if (_keWeiAboutFood.hidden==YES) {
        MBAlert(@"请输入食物种类");
        
    }else{
        if (_keWeiAboutFood.text.length<1) {
            MBAlert(@"请输入食物数量");
        }else
        {
            BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
            if (!isLogin) {
                [self goToLoginViewAbout];
            }else{
            NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
            
            NSString *type =nil;
            if ([_timeAoubtFood isEqualToString:@"早餐"]) {
                type=@"1";
            } if ([_timeAoubtFood isEqualToString:@"午餐"]) {
                type=@"2";
                
            } if ([_timeAoubtFood isEqualToString:@"晚餐"]) {
                type=@"3";
                
            } if ([_timeAoubtFood isEqualToString:@"夜宵"]) {
                type=@"4";
                
            } if ([_timeAoubtFood isEqualToString:@"零食"]) {
                type=@"5";
                
            }
            
            
            NSMutableArray *arr=[NSMutableArray array];
            [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(type),@"type", nil]];
            
            [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"userID", nil]];
            [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([NSString stringWithFormat:@"%d",[_keWeiAboutFood.text intValue]]),@"weight", nil]];
            [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(_curFoodInfo[@"code"]),@"nutrientsCode", nil]];
            
            
            NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"AddClientFoodRecord"];
            NSLog(@"%@",soapMsg);
            NSLog(@"%@",_curFoodInfo);
            
            __block FoodViewController *blockSelf = self;
            
            MBRequestItem*item =[MBRequestItem itemWithMethod:@"AddClientFoodRecord" params:@{@"soapMessag":soapMsg}];
            
            [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
                
                [blockSelf GetAddClientFoodRecorddResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
                
                
            } failure:^(NSError *error, id JSON) {
                [blockSelf GetAddClientFoodRecorddResultSuccess:@""];
            }];
            }
        }
    }
}
-(void)GetAddClientFoodRecorddResultSuccess:(NSString*)string
{
    if ([string isEqualToString:@""]) {
        MBAlert(@"上传失败");
        return;
    }

    
    NSDictionary *xmlDic =[NSDictionary dictionaryWithXMLString:string];
    
    if ([MBNonEmptyStringNo_(xmlDic[@"soap:Body"][@"AddClientFoodRecordResponse"][@"AddClientFoodRecordResult"]) isEqualToString:@"1"]) {
        
        if (_curShowArray.count>0) {
            [_curShowArray removeAllObjects];
        }
        [self getAllFoodDetail];
        
    }else
    {
        MBAlert(@"上传失败");
    }
    _keWeiAboutFood.hidden=YES;
    _keLabl.hidden=YES;
    _allShuruLbl.hidden=YES;
    _keWeiAboutFood.text=@"";
    [_btnFoodType setTitle:@"请选择食物" forState:UIControlStateNormal];
    
    _foodCountLabl.frame= CGRectMake(_foodCountLabl.frame.origin.x, 100, _foodCountLabl.frame.size.width, _foodCountLabl.frame.size.height);
    _needbuchonLbl.frame= CGRectMake(_needbuchonLbl.frame.origin.x, 125, _needbuchonLbl.frame.size.width, _needbuchonLbl.frame.size.height);
    _lingshiLbl.frame= CGRectMake(_lingshiLbl.frame.origin.x, 150, _lingshiLbl.frame.size.width, _lingshiLbl.frame.size.height);
    
    
}
//请求服务器数据
-(void)getAllFoodDetail
{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    NSMutableArray *arr=[NSMutableArray array];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",0],@"startIndex", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",100],@"endIndex", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"userID", nil]];
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetClientFoodRecordList"];
    NSLog(@"%@",soapMsg);

    __block FoodViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetClientFoodRecordList" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf GetClientFoodRecordListSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];

}

-(void)GetClientFoodRecordListSuccess:(NSString *)string
{
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:string];
    
    NSArray *array=xmlDoc[@"soap:Body"][@"GetClientFoodRecordListResponse"][@"GetClientFoodRecordListResult"][@"data"][@"style"];
    if ([array isKindOfClass:[NSArray class]]) {
        NSMutableArray *reseDataArray =[NSMutableArray arrayWithCapacity:2];
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic =array[i];
            if (!dic[@"isOrNo"]) {
                [reseDataArray addObject:dic];
            }
        }
     
        NSString *type =nil;
        if ([_timeAoubtFood isEqualToString:@"早餐"]) {
            type=@"1";
        } if ([_timeAoubtFood isEqualToString:@"午餐"]) {
            type=@"2";
            
        } if ([_timeAoubtFood isEqualToString:@"晚餐"]) {
            type=@"3";
            
        } if ([_timeAoubtFood isEqualToString:@"夜宵"]) {
            type=@"4";
            
        } if ([_timeAoubtFood isEqualToString:@"零食"]) {
            type=@"5";
            
        }
        if (_showDic.count>0) {
            [_showDic removeAllObjects];
        }
        [_showDic addObjectsFromArray:reseDataArray];

        
        for (int i=0; i<_showDic.count; i++) {
            NSDictionary *dic =_showDic[i];
            if ([MBNonEmptyStringNo_(dic[@"type"]) isEqualToString:type]) {
                [_curShowArray addObject:dic];
            }
        }
        float flong =0.0;
        for (int i=0; i<_curShowArray.count; i++) {
            NSDictionary *dic =_showDic[i];
            flong+=[dic[@"nutrientsKCALs"] floatValue];
        }
        
        _foodCountLabl.text=[NSString stringWithFormat:@"您今天%@共吃了%d种食物",_timeAoubtFood,_curShowArray.count];
        _lingshiLbl.text=[NSString stringWithFormat:@"%@摄入总量为%0.2f",_timeAoubtFood,flong];
        _lingshiLbl.textColor=[UIColor whiteColor];



        [self getData];
       
    }else
    {
        _foodCountLabl.text=[NSString stringWithFormat:@"您今天%@共吃了%d种食物",_timeAoubtFood,0];
        
        _lingshiLbl.text=[NSString stringWithFormat:@"%@摄入总量为%0.2f",_timeAoubtFood,.0];
    }
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isGetSeleThing=NO;
    _showDic=[[NSMutableArray alloc]initWithCapacity:2];
    _curShowArray=[[NSMutableArray alloc]initWithCapacity:2];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getKCResult:) name:getKCNotific object:nil];
    self.view.backgroundColor=HEX(@"#ffffff");
    
    _fistView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, kContentViewHeight+150)];
    _fistView.backgroundColor=HEX(@"#ffffff");
    _fistView.contentSize=CGSizeMake(320, kContentViewHeight+450);
    [self.view addSubview:_fistView];
    
    _sendView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, kContentViewHeight+150)];
    _sendView.backgroundColor=HEX(@"#ffffff");
    _sendView.hidden=YES;
    [self.view addSubview:_sendView];
    
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

    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"膳食情况",@"膳食记录",nil];
    
    //初始化UISegmentedControl
    
    MBSegmentControl *segmentedControl = [[MBSegmentControl alloc]initWithFrame:CGRectMake(60.0, 25, 200.0, 30.0)];
     segmentedControl.delegate=self;
    segmentedControl.selectIndex=0;

    segmentedControl.itemNameArray=segmentedArray;
    segmentedControl.tag=1;
    
    [self.navigationController.view addSubview:segmentedControl];
    
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    NSString*Sex=MBNonEmptyStringNo_([allUserDic allValues][0][@"Sex"]);
    NSString *boyHeadIMageStr=nil;
    if ([Sex isEqualToString:@"1"]) {
        
        boyHeadIMageStr =@"headman.png";
    }else
    {
        boyHeadIMageStr =@"headwoman.png";
        
    }
    
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 130)];
    imageView.image=[UIImage imageNamed:boyHeadIMageStr];
    [_fistView addSubview:imageView];
    
    UIImageView*lablBG=[[UIImageView alloc]initWithFrame:CGRectMake(10, 140, 100, 30)];
    lablBG.image=[UIImage imageNamed:@"labelBG.png"];
    [_fistView addSubview:lablBG];
    UILabel *leftLabl=[[UILabel alloc]initWithFrame:CGRectMake(10, 140, 100, 30)];
    leftLabl.text=@"体重";
    leftLabl.textColor=kNormalTextColor;
    leftLabl.textAlignment=UITextAlignmentCenter;
    [_fistView addSubview:leftLabl];
    
    UIImageView*labRkglBG=[[UIImageView alloc]initWithFrame:CGRectMake(10+200, 140, 100, 30)];
    labRkglBG.image=[UIImage imageNamed:@"labelBG.png"];
    [_fistView addSubview:labRkglBG];
    
    UILabel *rightLabl=[[UILabel alloc]initWithFrame:CGRectMake(10+200, 140, 100, 30)];
    rightLabl.text=@"每日饮食";
    rightLabl.textAlignment=UITextAlignmentCenter;
    rightLabl.textColor=kNormalTextColor;
    [_fistView addSubview:rightLabl];
    
    
    UIImageView*curTiZhong=[[UIImageView alloc]initWithFrame:CGRectMake(30, 30+140+20+66+20, 66, 66)];
    curTiZhong.image=[UIImage imageNamed:@"tizhong.gif"];
    [_fistView addSubview:curTiZhong];
    UILabel *tizhong=[[UILabel alloc]initWithFrame:CGRectMake(10, 30+130+20+66+70+20, 100, 30)];
    tizhong.text=@"当前体重";
    tizhong.textAlignment=UITextAlignmentCenter;
    tizhong.textColor=[UIColor blueColor];
    [_fistView addSubview:tizhong];
    
    UILabel *tizhongValue=[[UILabel alloc]initWithFrame:CGRectMake(10, 30+120+20+66+70+30+20, 100, 30)];
    tizhongValue.tag=11;
    tizhongValue.textAlignment=UITextAlignmentCenter;
    tizhongValue.textColor=kTipTextColor;
    [_fistView addSubview:tizhongValue];
    
    
    
    
    
    UIImageView*bianzhunimg=[[UIImageView alloc]initWithFrame:CGRectMake(30, 80+120+20+66+70+30+66+20, 66, 66)];
    bianzhunimg.image=[UIImage imageNamed:@"biaozhuntizhong.gif"];
    [_fistView addSubview:bianzhunimg];
    UILabel *bianzhun=[[UILabel alloc]initWithFrame:CGRectMake(10, 80+120+20+66+70+30+66+66+20, 100, 30)];
    bianzhun.text=@"标准体重";
    bianzhun.textAlignment=UITextAlignmentCenter;
    bianzhun.textColor=[UIColor blueColor];
    [_fistView addSubview:bianzhun];
    
    UILabel *bianzhunvalue=[[UILabel alloc]initWithFrame:CGRectMake(10, 80+120+20+66+70+30+66+66+30+20, 120, 30)];
    bianzhunvalue.tag=12;
    bianzhunvalue.textAlignment=UITextAlignmentCenter;
    bianzhunvalue.textColor=kTipTextColor;
    [_fistView addSubview:bianzhunvalue];
    
    
    
    
    
    UIImageView*shuruliang=[[UIImageView alloc]initWithFrame:CGRectMake(230-15, 70+20+96, 66, 66)];
    shuruliang.image=[UIImage imageNamed:@"biaozhungshuru.gif"];
    [_fistView addSubview:shuruliang];
    UILabel *shureuliang=[[UILabel alloc]initWithFrame:CGRectMake(210-15, 70+20+66+100, 100, 30)];
    shureuliang.text=@"标准摄入量";
    shureuliang.textAlignment=UITextAlignmentCenter;
    shureuliang.textColor=[UIColor blueColor];
    [_fistView addSubview:shureuliang];
    UILabel *shurongValue=[[UILabel alloc]initWithFrame:CGRectMake(210-15, 70+20+66+80+50, 120, 30)];
    shurongValue.tag=13;
    shurongValue.textAlignment=UITextAlignmentCenter;
    shurongValue.textColor=kTipTextColor;
    shurongValue.adjustsFontSizeToFitWidth=YES;

    [_fistView addSubview:shurongValue];
    
    
    UIImageView*jinrunimg=[[UIImageView alloc]initWithFrame:CGRectMake(230-15, 40+80+20+66+70+30+66, 66, 66)];
    jinrunimg.image=[UIImage imageNamed:@"jinrisheru.png"];
    [_fistView addSubview:jinrunimg];
    UILabel *jinrus=[[UILabel alloc]initWithFrame:CGRectMake(210-15, 40+80+20+66+70+30+66+66, 100, 30)];
    jinrus.text=@"今日已摄入";
    jinrus.textAlignment=UITextAlignmentCenter;
    jinrus.textColor=[UIColor blueColor];
    [_fistView addSubview:jinrus];
    UILabel *jianruhunvalue=[[UILabel alloc]initWithFrame:CGRectMake(210-15, 40+80+20+66+70+30+66+66+30, 100, 30)];
    jianruhunvalue.tag=14;
    jianruhunvalue.adjustsFontSizeToFitWidth=YES;
    jianruhunvalue.textAlignment=UITextAlignmentCenter;
    jianruhunvalue.textColor=kTipTextColor;
    [_fistView addSubview:jianruhunvalue];
    
    
    UIImageView*buzhuczhong=[[UIImageView alloc]initWithFrame:CGRectMake(230-15, 100+66+80+20+66+70+30+66+66, 66, 66)];
    buzhuczhong.image=[UIImage imageNamed:@"jianrihaixusheru.gif"];
    [_fistView addSubview:buzhuczhong];
    UILabel *buzhulab=[[UILabel alloc]initWithFrame:CGRectMake(210-15-30, 100+66+80+20+66+70+30+66+66+66, 140, 30)];
    buzhulab.text=@"今日还需补充能量";
    buzhulab.textAlignment=UITextAlignmentCenter;
    buzhulab.tag=999;
    buzhulab.textColor=[UIColor blueColor];
    [_fistView addSubview:buzhulab];
    UILabel *buzhuVale=[[UILabel alloc]initWithFrame:CGRectMake(210-15, 100+66+80+20+66+70+30+66+66+30+66, 100, 30)];
    buzhuVale.textAlignment=UITextAlignmentCenter;
    buzhuVale.tag=15;
    buzhuVale.adjustsFontSizeToFitWidth=YES;
    buzhuVale.textColor=kTipTextColor;
    [_fistView addSubview:buzhuVale];
    
    
    NSArray *segmenteLunchArray = [[NSArray alloc]initWithObjects:@"早餐",@"午餐",@"晚餐",@"夜宵",@"零食",nil];
    
    //初始化UISegmentedControl
    
    MBSegmentControl *segmentedLunchControl = [[MBSegmentControl alloc]initWithFrame:CGRectMake(-5.0, 0, 330.0, 30.0)];
    segmentedLunchControl.delegate=self;
    segmentedLunchControl.itemNameArray=segmenteLunchArray;
    segmentedLunchControl.selectIndex=0;
      segmentedLunchControl.tag=2;

    
    _timeAoubtFood=@"早餐";
    
    [_sendView addSubview:segmentedLunchControl];
    
    UIImageView *foodImage =[[UIImageView alloc]initWithFrame:CGRectMake(10, 45, 30, 28)];
    foodImage.backgroundColor=[UIColor clearColor];
    foodImage.image=[UIImage imageNamed:@"fooType.png"];
    [_sendView addSubview:foodImage];
    
    _foodTypeLbl=[[UILabel alloc]initWithFrame:CGRectMake(45, 45, 200, 30)];
    _foodTypeLbl.text=@"食物种类";
    _foodTypeLbl.textColor=kNormalTextColor;
    _foodTypeLbl.font=kNormalTextFont;
    [_sendView addSubview:_foodTypeLbl];
    
    
    _btnFoodType =[UIButton buttonWithType:UIButtonTypeCustom];
    _btnFoodType.frame=CGRectMake(200, 45, 100, 30);
    [_btnFoodType addTarget:self action:@selector(foodTypeSeleBtn) forControlEvents:UIControlEventTouchUpInside];
    [_btnFoodType setTitle:@"请选择食物" forState:UIControlStateNormal];
    [_sendView addSubview:_btnFoodType];
    _btnFoodType.titleLabel.font=kNormalTextFont;
    [_btnFoodType setTitleColor:kNormalTextColor forState:UIControlStateNormal];
    
    UIImageView *jielleftunImage=[[UIImageView alloc]initWithFrame:CGRectMake(295, 50, 15, 15)];
    jielleftunImage.backgroundColor=[UIColor clearColor];
    jielleftunImage.image=[UIImage imageNamed:@"backRight.png"];
    [_sendView addSubview:jielleftunImage];
    
    
    UIImageView *jielunImage=[[UIImageView alloc]initWithFrame:CGRectMake(0,80, 320, 120)];
    jielunImage.backgroundColor=HEX(@"#9370db");
    
    [_sendView addSubview:jielunImage];
    
    UIImageView *footuiji=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 72, 60)];
    footuiji.image=[UIImage imageNamed:@"tujianfood.png"];
    [jielunImage addSubview:footuiji];
    
    _keWeiAboutFood=[[MBTextField alloc]initWithFrame:CGRectMake(205, 82, 65, 25)];
    _keWeiAboutFood.backgroundColor=[UIColor clearColor];
    _keWeiAboutFood.borderStyle=UITextBorderStyleRoundedRect;
    _keWeiAboutFood.keyboardType=UIKeyboardTypeNumberPad;
    _keWeiAboutFood.hidden=YES;
    _keWeiAboutFood.delegate=self;
    [_sendView addSubview:_keWeiAboutFood];
    
    _allShuruLbl=[[UILabel alloc]initWithFrame:CGRectMake(100, 80,120, 25)];
    _allShuruLbl.textColor=kWhiteTextColor;
    _allShuruLbl.font=kNormalTextFont;
    _allShuruLbl.text=@"请输入数量";
    _allShuruLbl.hidden=YES;
    _allShuruLbl.backgroundColor=[UIColor clearColor];

    _allShuruLbl.textAlignment=NSTextAlignmentCenter;
    [_sendView addSubview:_allShuruLbl];
    
    
    _keLabl=[[UILabel alloc]initWithFrame:CGRectMake(270, 80, 30, 25)];
    _keLabl.textColor=kWhiteTextColor;
    _keLabl.font=kNormalTextFont;
    _keLabl.text=@"克";
    _keLabl.backgroundColor=[UIColor clearColor];
    _keLabl.hidden=YES;
    _keLabl.textAlignment=NSTextAlignmentCenter;
    [_sendView addSubview:_keLabl];
    
    
    _foodCountLabl=[[UILabel alloc]initWithFrame:CGRectMake(0, 100, 320, 25)];
    _foodCountLabl.textColor=kWhiteTextColor;
    _foodCountLabl.font=kNormalTextFont;
    _foodCountLabl.backgroundColor=[UIColor clearColor];

    _foodCountLabl.textAlignment=NSTextAlignmentCenter;
    [_sendView addSubview:_foodCountLabl];
    
    
    _needbuchonLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 95+30, 320, 25)];
    _needbuchonLbl.textColor=kWhiteTextColor;
    _needbuchonLbl.font=kNormalTextFont;
    _needbuchonLbl.backgroundColor=[UIColor clearColor];

    _needbuchonLbl.textAlignment=NSTextAlignmentCenter;
    [_sendView addSubview:_needbuchonLbl];
    
    
    _lingshiLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 95+55, 320, 25)];
    _lingshiLbl.textColor=kWhiteTextColor;
    _lingshiLbl.font=kNormalTextFont;
    _lingshiLbl.backgroundColor=[UIColor clearColor];

    _lingshiLbl.textAlignment=NSTextAlignmentCenter;
    [_sendView addSubview:_lingshiLbl];
    
    
    UIView*view =[[UIView alloc]initWithFrame:CGRectMake(0, 190, 320, 40)];
    view.backgroundColor=[UIColor blueColor];
    [_sendView addSubview:view];
    
    
    UILabel*one=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 100, 30)];
    one.textColor=kWhiteTextColor;
    one.font=kNormalTextFont;
    one.text=@"已添加食物";
    one.backgroundColor=[UIColor clearColor];

    one.textAlignment=NSTextAlignmentCenter;
    [view addSubview:one];
    
    UILabel*two=[[UILabel alloc]initWithFrame:CGRectMake(100, 5, 110, 30)];
    two.textColor=kWhiteTextColor;
    two.font=kNormalTextFont;
    two.text=@"份量(克)";
    two.backgroundColor=[UIColor clearColor];

    two.textAlignment=NSTextAlignmentCenter;
    [view addSubview:two];
    
    UILabel*three=[[UILabel alloc]initWithFrame:CGRectMake(210, 5, 110, 30)];
    three.textColor=kWhiteTextColor;
    three.font=kNormalTextFont;
    three.text=@"摄入能量(千卡)";
    three.backgroundColor=[UIColor clearColor];

    three.textAlignment=NSTextAlignmentCenter;
    [view addSubview:three];
    
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 230, 320, kContentViewHeight-200) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_sendView addSubview:_tableView];
    
    
    [self getData];
    
    
    UIImageView *imageVewiMiddle =[[UIImageView alloc]initWithFrame:CGRectMake((320-119)/2, 130, 117, 97)];
    imageVewiMiddle.image=[UIImage imageNamed:@"right.png"];
    [_fistView addSubview:imageVewiMiddle];
    
    UIImageView *imageVewiMiddleTwo =[[UIImageView alloc]initWithFrame:CGRectMake((320-119)/2, 130+97, 119, 97)];
    imageVewiMiddleTwo.image=[UIImage imageNamed:@"left.png"];
    [_fistView addSubview:imageVewiMiddleTwo];
    
    UIImageView *imageVewiMiddleThre =[[UIImageView alloc]initWithFrame:CGRectMake((320-119)/2, 130+97+97, 119, 97)];
    imageVewiMiddleThre.image=[UIImage imageNamed:@"right.png"];
    [_fistView addSubview:imageVewiMiddleThre];
    
    UIImageView *imageVewiMiddleFou =[[UIImageView alloc]initWithFrame:CGRectMake((320-119)/2, 130+97+97+97, 119, 97)];
    imageVewiMiddleFou.image=[UIImage imageNamed:@"left.png"];
    [_fistView addSubview:imageVewiMiddleFou];
    
    UIImageView *imageVewiMiddleFive =[[UIImageView alloc]initWithFrame:CGRectMake((320-119)/2, 130+97+97+97+97, 119, 97)];
    imageVewiMiddleFive.image=[UIImage imageNamed:@"right.png"];
    [_fistView addSubview:imageVewiMiddleFive];
    
}

//食物种类选择
-(void)foodTypeSeleBtn
{
    
    FoodAllTableViewController*foodView=[[FoodAllTableViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:foodView];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)getData
{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"userID", nil]];
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetFoodDetail"];
    
    __block FoodViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetFoodDetail" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf GetNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    
}
-(void)GetNewHealthDataAndResultSuccess:(NSString*)string
{
    NSDictionary*xmlDic =[NSDictionary dictionaryWithXMLString:string];
    NSArray *array=xmlDic[@"soap:Body"][@"GetFoodDetailResponse"][@"GetFoodDetailResult"][@"data"][@"style"];
    
    NSMutableArray *reseDataArray =[NSMutableArray arrayWithCapacity:2];
    if ([array isKindOfClass:[NSArray class]]) {
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic =array[i];
            if (!dic[@"isOrNo"]) {
                [reseDataArray addObject:dic];
            }
        }
    }
    if (reseDataArray.count==1) {
        _infoDicAbout = reseDataArray[0];
    }
    
    
    UILabel *lbl11=(UILabel*)[self.view viewWithTag:11];
    UILabel *lbl12=(UILabel*)[self.view viewWithTag:12];
    UILabel *lbl13=(UILabel*)[self.view viewWithTag:13];
    UILabel *lbl14=(UILabel*)[self.view viewWithTag:14];
    UILabel *lbl15=(UILabel*)[self.view viewWithTag:15];
    UILabel *lbl156=(UILabel*)[self.view viewWithTag:999];

    lbl11.text=[MBNonEmptyString(_infoDicAbout[@"weight"]) stringByAppendingString:@"kg"];
    
    lbl12.text=[MBNonEmptyString(_infoDicAbout[@"bzWeight"]) stringByAppendingString:@"kg"];
    lbl13.text=[MBNonEmptyString(_infoDicAbout[@"totalNutrients"]) stringByAppendingString:@"千卡/天"];
    lbl14.text=[MBNonEmptyString(_infoDicAbout[@"todayNutrients"]) stringByAppendingString:@"千卡"];
    lbl15.text=[MBNonEmptyString(_infoDicAbout[@"remainNutrients"]) stringByAppendingString:@"千卡"];
    NSLog(@"%@",_infoDicAbout);
    
    float remainNutrients=[MBNonEmptyString(_infoDicAbout[@"totalNutrients"]) floatValue] - [MBNonEmptyString(_infoDicAbout[@"todayNutrients"]) floatValue];
    
    if (remainNutrients<0) {
        _needbuchonLbl.text=[NSString stringWithFormat:@"今日能量超标%.2f千卡",-remainNutrients];
        lbl156.text=@"今日能量已超标";
        lbl15.text=[NSString stringWithFormat:@"%.2f千卡",-remainNutrients];
    }else
    {
        _needbuchonLbl.text=[NSString stringWithFormat:@"今日能量还需补充%.2f千卡",remainNutrients];
        lbl156.text=@"今日能量还需补充";

        lbl15.text=[NSString stringWithFormat:@"%.2f千卡",remainNutrients];

    }
    _needbuchonLbl.textColor=[UIColor whiteColor];


}
-(void)MBSegment:(MBSegmentControl *)segment selectAtIndex:(NSInteger)index
{
    if (segment.tag==1) {
        
        
        if (index==0) {
            _fistView.hidden=NO;
            _sendView.hidden=YES;
            self.navigationItem.rightBarButtonItem=nil;
            
            [self getData];
        }if (index==1) {
            _fistView.hidden=YES;
            _sendView.hidden=NO;
            
            if (IOS7_OR_LATER) {
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStyleBordered target:self action:@selector(uploadFoodKC)];
            }else
            {
                UIButton *btnLeft =[UIButton buttonWithType:UIButtonTypeCustom];
                btnLeft.frame=CGRectMake(0, 0, 40, 40);
                [btnLeft setTitle:@"上传" forState:UIControlStateNormal];
                [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnLeft addTarget:self action:@selector(uploadFoodKC) forControlEvents:UIControlEventTouchUpInside];
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
            }
            
            
            if (_curShowArray.count>0) {
                [_curShowArray removeAllObjects];
            }
            [self getAllFoodDetail];
        }
        
        
    }if (segment.tag==2) {
        if (index==0) {
            _timeAoubtFood = @"早餐";
        }if (index==1) {
            _timeAoubtFood = @"午餐";
        }if (index==2) {
            _timeAoubtFood = @"晚餐";
        }if (index==3) {
            _timeAoubtFood = @"夜宵";
        }if (index==4) {
            _timeAoubtFood = @"零食";
        }
        if (_curShowArray.count>0) {
            [_curShowArray removeAllObjects];
        }
        [self getAllFoodDetail];
    }

}
-(void)segmentedCOntrollerPressed:(UISegmentedControl*)con
{
   }

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _curShowArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellSr=@"TiJianReprotCell";
    UITableViewCell*cell =[tableView dequeueReusableCellWithIdentifier:cellSr];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellSr];
        for (int i=0; i<3; i++) {
            UILabel *labl =[[UILabel alloc]initWithFrame:CGRectMake(110*i, 5, 110, 30)];
            labl.tag=10000+i;
            labl.textAlignment=NSTextAlignmentCenter;
            labl.font=kNormalTextFont;
            labl.textColor=kNormalTextColor;
            [cell addSubview:labl];
        }
        
    }
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [longPressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [longPressGestureRecognizer setMinimumPressDuration:1.0f];
    [longPressGestureRecognizer setAllowableMovement:50.0];
    [cell addGestureRecognizer:longPressGestureRecognizer];
    
    NSDictionary *arrayDic =_showDic[indexPath.row];
    NSLog(@"%@",arrayDic);
    NSLog(@"%@",_curShowArray);

    UILabel *one =(UILabel*)[cell viewWithTag:10000];
    UILabel *two =(UILabel*)[cell viewWithTag:10001];
    UILabel *thr =(UILabel*)[cell viewWithTag:10002];
    
    one.text=MBNonEmptyStringNo_(_curShowArray[indexPath.row][@"nutrientName"]);
    two.text=MBNonEmptyStringNo_(_curShowArray[indexPath.row][@"weight"]);
    thr.text=MBNonEmptyStringNo_(_curShowArray[indexPath.row][@"nutrientsKCALs"]);
    cell.tag=indexPath.row;

    return cell;
}

-(void)gestureRecognizerHandle:(UILongPressGestureRecognizer*)longgest
{
    UITableViewCell *cell=(UITableViewCell*)[longgest view];
    _deleIndexAboutArray=cell.tag;
    MBAlertView *alterView =[[MBAlertView alloc]initWithTitle:Nil message:@"确定删除此膳食记录！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alterView.tag=10004;
    [alterView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10004) {
        if (buttonIndex==1) {
            
            NSLog(@"%@",_curShowArray[_deleIndexAboutArray]);
            [self deleteAboutNews];
            
            
        }
    }
}
-(void)deleteAboutNews
{
    //NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    NSDictionary *deleInfo =_curShowArray[_deleIndexAboutArray];
    NSLog(@"%@",deleInfo);
    NSMutableArray *arr=[NSMutableArray array];
    
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(deleInfo[@"foodRecordID"]),@"footID", nil]];
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"DeleteClientFoodRecord"];
    NSLog(@"%@",soapMsg);
    
    __block FoodViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"DeleteClientFoodRecord" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        
        [blockSelf deleNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];

}
-(void)deleNewHealthDataAndResultSuccess:(NSString*)str
{
    NSLog(@"%@",str);
    NSDictionary *dic=[NSDictionary dictionaryWithXMLString:str];
    NSLog(@"%@",dic);
    if ([MBNonEmptyStringNo_(dic[@"soap:Body"][@"DeleteClientFoodRecordResponse"][@"DeleteClientFoodRecordResult"]) isEqualToString:@"1"]) {
        if (_curShowArray.count>0) {
            [_curShowArray removeAllObjects];
        }
        if (_showDic.count>0) {
            [_showDic removeAllObjects];
        }
        [self getAllFoodDetail];

    }
}
@end
