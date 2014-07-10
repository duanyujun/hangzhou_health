//
//  FoodViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-30.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "SprotsViewController.h"
#import "XMLDictionary.h"
#import "MBIIRequest.h"
#import "SoapHelper.h"
#import "TiJianReprotCell.h"
#import "SportsAllTableViewController.h"
#import "DBHelper.h"
#import "MBTextField.h"
#import "MBLabel.h"
#import "MBSegmentControl.h"
#import "MBAlertView.h"
@interface SprotsViewController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,MBSegmentControlDelegate,MBTextFieldDelegate>
{
    UIScrollView *_fistView;
    NSDictionary *_infoDicAbout;
    UITableView*_tableView;
    UIView *_sendView;
    UILabel *_foodTypeLbl;
    
    UILabel *_foodCountLabl;
    UILabel *_needbuchonLbl;
    UILabel *_lingshiLbl;
    NSMutableArray * _showDic;
    UIButton *_btnFoodType;
    NSDictionary *_curFoodInfo;
    MBTextField *_keWeiAboutFood;
    UILabel *_allShuruLbl;
    UILabel *_keLabl;
    NSInteger _deleIndexAboutArray;
    BOOL _isFirstGetData;
}
@end

@implementation SprotsViewController

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
-(void)getKCResult:(NSNotification*)noc
{
    _isFirstGetData=YES;
    _allShuruLbl.hidden=NO;
    _keWeiAboutFood.hidden=NO;
    _keLabl.hidden=NO;
    
    NSDictionary*dic=(NSDictionary*)[noc object];
    NSLog(@"%@",dic);
    _curFoodInfo = [dic copy];
    CGSize size =[MBNonEmptyStringNo_(dic[@"sportName"]) sizeWithFont:kNormalTextFont];
    NSLog(@"%f",size.width);
    [_btnFoodType setTitle:MBNonEmptyStringNo_(dic[@"sportName"]) forState:UIControlStateNormal];
    
    _btnFoodType.frame=CGRectMake(320-size.width-30, _btnFoodType.frame.origin.y, size.width, _btnFoodType.frame.size.height);
   _foodCountLabl.frame= CGRectMake(_foodCountLabl.frame.origin.x, 75, _foodCountLabl.frame.size.width, _foodCountLabl.frame.size.height);
    _needbuchonLbl.frame= CGRectMake(_needbuchonLbl.frame.origin.x, 100, _needbuchonLbl.frame.size.width, _needbuchonLbl.frame.size.height);
    _lingshiLbl.frame= CGRectMake(_lingshiLbl.frame.origin.x, 125, _lingshiLbl.frame.size.width, _lingshiLbl.frame.size.height);

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
        MBAlert(@"请输入运动种类");
        
    }else{
        if (_keWeiAboutFood.text.length<1) {
            MBAlert(@"请输入运动时间");
        }else
        {
            BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
            if (!isLogin) {
                [self goToLoginViewAbout];
            }else{
            NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
            
            
            NSMutableArray *arr=[NSMutableArray array];
            [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"userID", nil]];
            [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([NSString stringWithFormat:@"%d",[_keWeiAboutFood.text intValue]]),@"min", nil]];
            
            [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([NSString stringWithFormat:@"%@",MBNonEmptyStringNo_(_curFoodInfo[@"sportItemNo"])]),@"sportItemNo", nil]];


            [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(_curFoodInfo[@"sportParamValueID"]),@"sportParamValueID", nil]];
            
            
            NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"AddClientSportRecord"];
            NSLog(@"%@",soapMsg);
            NSLog(@"%@",_curFoodInfo);
            
            __block SprotsViewController *blockSelf = self;
            
            MBRequestItem*item =[MBRequestItem itemWithMethod:@"AddClientSportRecord" params:@{@"soapMessag":soapMsg}];
            
            [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
                
                [blockSelf GetAddClientFoodRecorddResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
                
                
            } failure:^(NSError *error, id JSON) {
                NSLog(@"%@",error);
            }];
            }
        }
    }
}
-(void)GetAddClientFoodRecorddResultSuccess:(NSString*)string
{
    

    NSDictionary *xmlDic =[NSDictionary dictionaryWithXMLString:string];
    NSLog(@"%@",xmlDic);
    if ([MBNonEmptyStringNo_(xmlDic[@"soap:Body"][@"AddClientSportRecordResponse"][@"AddClientSportRecordResult"]) isEqualToString:@"1"]) {
        
        if (_showDic.count>0) {
            [_showDic removeAllObjects];
        }
        [self getAllFoodDetail];
        
    }else
    {
        MBAlert(@"上传失败");
        return;
    }
    _keWeiAboutFood.hidden=YES;
    _keLabl.hidden=YES;
    _allShuruLbl.hidden=YES;
    _keWeiAboutFood.text=@"";
    [_btnFoodType setTitle:@"请选择运动" forState:UIControlStateNormal];
    _btnFoodType.frame=CGRectMake(200, 12, 100, 30);

    _foodCountLabl.frame= CGRectMake(_foodCountLabl.frame.origin.x, 70, _foodCountLabl.frame.size.width, _foodCountLabl.frame.size.height);
    _needbuchonLbl.frame= CGRectMake(_needbuchonLbl.frame.origin.x, 95, _needbuchonLbl.frame.size.width, _needbuchonLbl.frame.size.height);
    _lingshiLbl.frame= CGRectMake(_lingshiLbl.frame.origin.x, 120, _lingshiLbl.frame.size.width, _lingshiLbl.frame.size.height);
    [self getAllFoodDetail];
    
}
-(void)textFieldDidFinsihEditing:(MBTextField *)textField
{
    [self uploadFoodKC];
}
-(void)getAllFoodDetail
{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    NSMutableArray *arr=[NSMutableArray array];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",0],@"startIndex", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",100],@"endIndex", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"userID", nil]];
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetClientSportRecorsList"];
    NSLog(@"%@",soapMsg);

    __block SprotsViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetClientSportRecorsList" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf GetClientFoodRecordListSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];

}

-(void)GetClientFoodRecordListSuccess:(NSString *)string
{
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:string];
    NSLog(@"%@",xmlDoc);
    NSLog(@"%@",_infoDicAbout);
    NSArray *array=xmlDoc[@"soap:Body"][@"GetClientSportRecorsListResponse"][@"GetClientSportRecorsListResult"][@"data"][@"style"];
    if ([array isKindOfClass:[NSArray class]]) {
        NSMutableArray *reseDataArray =[NSMutableArray arrayWithCapacity:2];
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic =array[i];
            if (!dic[@"isOrNo"]) {
                [reseDataArray addObject:dic];
            }
        }
     
        
        if (_showDic.count>0) {
            [_showDic removeAllObjects];
        }
        [_showDic addObjectsFromArray:reseDataArray];

        
        
        float flong =0.0;
        for (int i=0; i<_showDic.count; i++) {
            NSDictionary *dic =_showDic[i];
            flong+=[dic[@"nutrientsKCALs"] floatValue];
        }
        
        _foodCountLabl.text=[NSString stringWithFormat:@"您今天共做了%d项运动",_showDic.count];
        if ([MBNonEmptyStringNo_(_infoDicAbout[@"sportLiang"]) floatValue]>flong) {
            
            NSLog(@"%f=====%f",[MBNonEmptyStringNo_(_infoDicAbout[@"sportLiang"]) floatValue],flong);
            _needbuchonLbl.text=[NSString stringWithFormat:@"还需消耗%0.2f千卡",-flong+[MBNonEmptyStringNo_(_infoDicAbout[@"sportLiang"]) floatValue]];
            _foodCountLabl.text=[NSString stringWithFormat:@"您今天共做了%d项运动",_showDic.count];


        }else
        {
            NSLog(@"1111111==========%f=====%f",[MBNonEmptyStringNo_(_infoDicAbout[@"sportLiang"]) floatValue],flong);
            _needbuchonLbl.text=[NSString stringWithFormat:@"超标消耗%0.2f千卡",-[MBNonEmptyStringNo_(_infoDicAbout[@"sportLiang"]) floatValue]+flong];

        }
        _lingshiLbl.text=[NSString stringWithFormat:@"消耗总量为%0.2f千卡",flong];
        _lingshiLbl.textColor=[UIColor whiteColor];

        //还需消耗

        [self getData];
       
    }else
    {
        _foodCountLabl.text=[NSString stringWithFormat:@"您今天共做了%d项运动",0];
        _needbuchonLbl.text=[NSString stringWithFormat:@"还需消耗%0.2f千卡",[MBNonEmptyStringNo_(_infoDicAbout[@"sportLiang"]) floatValue]];

        _lingshiLbl.text=[NSString stringWithFormat:@"消耗总量为%0.2f千卡",.0];
    }
    [_tableView reloadData];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:getKCFoodNotific object:nil];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (_isFirstGetData) {
        [_keWeiAboutFood becomeFirstResponder];
        
    }
    _isFirstGetData=NO;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isFirstGetData=NO;
    
    _showDic=[[NSMutableArray alloc]initWithCapacity:2];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getKCResult:) name:getKCFoodNotific object:nil];
    self.view.backgroundColor=HEX(@"#ffffff");
    
    _fistView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, kContentViewHeight+180)];
    _fistView.backgroundColor=HEX(@"#ffffff");
    _fistView.contentSize=CGSizeMake(320, kContentViewHeight+650);
    [self.view addSubview:_fistView];
    
    _sendView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, kContentViewHeight+150)];
    _sendView.backgroundColor=HEX(@"#ffffff");
    _sendView.hidden=YES;
    [self.view addSubview:_sendView];
    
   
    
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
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"运动情况",@"运动记录",nil];
    
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
    leftLabl.text=@"体重指数";
    leftLabl.textColor=kNormalTextColor;
    leftLabl.textAlignment=UITextAlignmentCenter;
    [_fistView addSubview:leftLabl];
    
    UIImageView*labRkglBG=[[UIImageView alloc]initWithFrame:CGRectMake(10+200, 140, 100, 30)];
    labRkglBG.image=[UIImage imageNamed:@"labelBG.png"];
    [_fistView addSubview:labRkglBG];
    
    UILabel *rightLabl=[[UILabel alloc]initWithFrame:CGRectMake(10+200, 140, 100, 30)];
    rightLabl.text=@"每日运动";
    rightLabl.textAlignment=UITextAlignmentCenter;
    rightLabl.textColor=kNormalTextColor;
    [_fistView addSubview:rightLabl];
    
    
    UIImageView*curTiZhong=[[UIImageView alloc]initWithFrame:CGRectMake(30, 35+140+20+66+20, 66, 66)];
    curTiZhong.image=[UIImage imageNamed:@"tizhong.gif"];
    [_fistView addSubview:curTiZhong];
    UILabel *tizhong=[[UILabel alloc]initWithFrame:CGRectMake(10, 35+130+20+66+70+20, 100, 30)];
    tizhong.text=@"体重指数";
    tizhong.textAlignment=UITextAlignmentCenter;
    tizhong.textColor=[UIColor blueColor];
    [_fistView addSubview:tizhong];
    
    UILabel *tizhongValue=[[UILabel alloc]initWithFrame:CGRectMake(10, 35+120+20+66+70+30+20, 100, 30)];
    tizhongValue.tag=11;
    tizhongValue.textAlignment=UITextAlignmentCenter;
    tizhongValue.textColor=kTipTextColor;
    [_fistView addSubview:tizhongValue];
    
    
    
    
    
    UIImageView*bianzhunimg=[[UIImageView alloc]initWithFrame:CGRectMake(30, 80+140+66+70+30+66+20, 66, 66)];
    bianzhunimg.image=[UIImage imageNamed:@"biaozhuntizhong.gif"];
    [_fistView addSubview:bianzhunimg];
    UILabel *bianzhun=[[UILabel alloc]initWithFrame:CGRectMake(10, 80+120+20+66+70+30+66+66+20, 100, 30)];
    bianzhun.text=@"当前体重";
    bianzhun.textAlignment=UITextAlignmentCenter;
    bianzhun.textColor=[UIColor blueColor];
    [_fistView addSubview:bianzhun];
    
    UILabel *bianzhunvalue=[[UILabel alloc]initWithFrame:CGRectMake(10, 80+120+20+66+70+30+66+66+30+20, 120, 30)];
    bianzhunvalue.tag=32;
    bianzhunvalue.textAlignment=UITextAlignmentCenter;
    bianzhunvalue.textColor=kTipTextColor;
    [_fistView addSubview:bianzhunvalue];
    
    
    UIImageView*bianzhunimgTow=[[UIImageView alloc]initWithFrame:CGRectMake(30, 50+80+66+120+20+66+70+30+66+20+77, 66, 66)];
    bianzhunimgTow.image=[UIImage imageNamed:@"curweight.png"];
    [_fistView addSubview:bianzhunimgTow];
    UILabel *bianzhunTizhong=[[UILabel alloc]initWithFrame:CGRectMake(10, 50+80+66+120+20+66+70+30+66+66+20+77, 100, 30)];
    bianzhunTizhong.text=@"标准体重";
    bianzhunTizhong.textAlignment=UITextAlignmentCenter;
    bianzhunTizhong.textColor=[UIColor blueColor];
    [_fistView addSubview:bianzhunTizhong];
    
    UILabel *bianzhunTizhongvalue=[[UILabel alloc]initWithFrame:CGRectMake(10, 50+80+66+77+120+20+66+70+30+66+66+30+20, 150, 30)];
    bianzhunTizhongvalue.tag=42;
    bianzhunTizhongvalue.textAlignment=UITextAlignmentCenter;
    bianzhunTizhongvalue.textColor=kTipTextColor;
    bianzhunTizhongvalue.text=@"79kg";
    bianzhunTizhongvalue.adjustsFontSizeToFitWidth=YES;
    [_fistView addSubview:bianzhunTizhongvalue];
    
    
    UIImageView*shuruliang=[[UIImageView alloc]initWithFrame:CGRectMake(230-15, 70+20+96, 66, 66)];
    shuruliang.image=[UIImage imageNamed:@"sportone.png"];
    [_fistView addSubview:shuruliang];
    UILabel *shureuliang=[[UILabel alloc]initWithFrame:CGRectMake(210-15, 70+20+55+100, 120, 55)];
//    shureuliang.text=@"舞蹈";
    shureuliang.tag=33;
    shureuliang.numberOfLines=2;
    
    shureuliang.textAlignment=UITextAlignmentCenter;
    shureuliang.textColor=[UIColor blueColor];
    [_fistView addSubview:shureuliang];
    
    UILabel *shurongValue=[[UILabel alloc]initWithFrame:CGRectMake(210-15, 70+20+66+80+50, 120, 30)];
    shurongValue.tag=13;
    shurongValue.textAlignment=UITextAlignmentCenter;
    shurongValue.textColor=kTipTextColor;

    [_fistView addSubview:shurongValue];
    
    
    UIImageView*jinrunimg=[[UIImageView alloc]initWithFrame:CGRectMake(230-15, 50+80+20+66+70+30+66, 66, 66)];
    jinrunimg.image=[UIImage imageNamed:@"sporttwo.png"];
    [_fistView addSubview:jinrunimg];
    UILabel *jinrus=[[UILabel alloc]initWithFrame:CGRectMake(210-15, 50+80+20+66+70+30+66+66-11, 120, 55)];
//    jinrus.text=@"慢跑";
    jinrus.numberOfLines=2;

    jinrus.tag=34;
    jinrus.numberOfLines=2;

    jinrus.textAlignment=UITextAlignmentCenter;
    jinrus.textColor=[UIColor blueColor];
    [_fistView addSubview:jinrus];
    UILabel *jianruhunvalue=[[UILabel alloc]initWithFrame:CGRectMake(210-15, 50+80+20+66+70+30+66+66+30, 100, 30)];
    jianruhunvalue.tag=14;

    jianruhunvalue.textAlignment=UITextAlignmentCenter;
    jianruhunvalue.textColor=kTipTextColor;
    [_fistView addSubview:jianruhunvalue];
    
    
    UIImageView*buzhuczhong=[[UIImageView alloc]initWithFrame:CGRectMake(230-15, 110+66+80+20+66+70+30+66+66, 66, 66)];
    buzhuczhong.image=[UIImage imageNamed:@"sportthree.png"];
    [_fistView addSubview:buzhuczhong];
    UILabel *buzhulab=[[UILabel alloc]initWithFrame:CGRectMake(210-15, 110+66+80+20+66+70+30+66+66+66-11, 120, 55)];
//    buzhulab.text=@"上下楼";
    buzhulab.numberOfLines=2;

    buzhulab.tag=35;

    
    buzhulab.textAlignment=UITextAlignmentCenter;
    buzhulab.textColor=[UIColor blueColor];
    [_fistView addSubview:buzhulab];
    UILabel *buzhuVale=[[UILabel alloc]initWithFrame:CGRectMake(210-15, 110+66+80+20+66+70+30+66+66+30+66, 100, 30)];
    buzhuVale.textAlignment=UITextAlignmentCenter;
    buzhuVale.tag=15;
    buzhuVale.textColor=kTipTextColor;
    [_fistView addSubview:buzhuVale];
    
    UIImageView*buzhuczhongFout=[[UIImageView alloc]initWithFrame:CGRectMake(230-15, 170+130+66+80+20+66+70+30+66+66, 66, 66)];
    buzhuczhongFout.image=[UIImage imageNamed:@"sprotfour.png"];
    [_fistView addSubview:buzhuczhongFout];
    UILabel *buzhulabFout=[[UILabel alloc]initWithFrame:CGRectMake(210-15, 170+130+66+80+20+66+70+30+66+66+66-11, 120, 55)];
//    buzhulabFout.text=@"上下";
    buzhulabFout.numberOfLines=2;

    buzhulabFout.tag=36;
    buzhulabFout.textAlignment=UITextAlignmentCenter;
    buzhulabFout.textColor=[UIColor blueColor];
    [_fistView addSubview:buzhulabFout];
    UILabel *buzhuValeFour=[[UILabel alloc]initWithFrame:CGRectMake(210-15, 170+130+66+80+20+66+70+30+66+66+30+66, 100, 30)];
    buzhuValeFour.textAlignment=UITextAlignmentCenter;
    buzhuValeFour.tag=16;
    buzhuValeFour.textColor=kTipTextColor;
    [_fistView addSubview:buzhuValeFour];
    
    
    
    
    UIImageView *foodImage =[[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 30, 28)];
    foodImage.backgroundColor=[UIColor clearColor];
    foodImage.image=[UIImage imageNamed:@"yundongType.png"];
    [_sendView addSubview:foodImage];
    
    _foodTypeLbl=[[UILabel alloc]initWithFrame:CGRectMake(45, 12, 200, 30)];
    _foodTypeLbl.text=@"运动类型";
    _foodTypeLbl.textColor=kNormalTextColor;
    _foodTypeLbl.font=kNormalTextFont;
    _foodCountLabl.backgroundColor=[UIColor clearColor];
    [_sendView addSubview:_foodTypeLbl];
    
    
    _btnFoodType =[UIButton buttonWithType:UIButtonTypeCustom];
    _btnFoodType.frame=CGRectMake(200, 12, 100, 30);
    [_btnFoodType addTarget:self action:@selector(foodTypeSeleBtn) forControlEvents:UIControlEventTouchUpInside];
    _btnFoodType.titleLabel.font=kNormalTextFont;
    [_btnFoodType setTitle:@"请选择运动" forState:UIControlStateNormal];
    [_btnFoodType setTitleColor:kTipTextColor forState:UIControlStateNormal];
    [_sendView addSubview:_btnFoodType];
    
    UIImageView *jielleftunImage=[[UIImageView alloc]initWithFrame:CGRectMake(295, 40-20, 15, 15)];
    jielleftunImage.backgroundColor=[UIColor clearColor];
    jielleftunImage.image=[UIImage imageNamed:@"backRight.png"];
    [_sendView addSubview:jielleftunImage];
    
    
    UIImageView *jielunImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 45, 320, 120)];
    jielunImage.backgroundColor=HEX(@"#9370db");
    [_sendView addSubview:jielunImage];
    
    UIImageView *footuiji=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 72, 60)];
    footuiji.image=[UIImage imageNamed:@"yundong.png"];
    [jielunImage addSubview:footuiji];
    
    _keWeiAboutFood=[[MBTextField alloc]initWithFrame:CGRectMake(203, 52, 65, 25)];
    _keWeiAboutFood.backgroundColor=[UIColor clearColor];
    _keWeiAboutFood.borderStyle=UITextBorderStyleRoundedRect;
    _keWeiAboutFood.keyboardType=UIKeyboardTypeNumberPad;
    _keWeiAboutFood.hidden=YES;
    _keWeiAboutFood.delegate=self;
    [_sendView addSubview:_keWeiAboutFood];
    
    _allShuruLbl=[[UILabel alloc]initWithFrame:CGRectMake(100, 50,120, 25)];
    _allShuruLbl.textColor=kWhiteTextColor;
    _allShuruLbl.font=kNormalTextFont;
    _allShuruLbl.text=@"请输入时间：";
    _allShuruLbl.hidden=YES;
    _allShuruLbl.backgroundColor=[UIColor clearColor];

    _allShuruLbl.textAlignment=NSTextAlignmentCenter;
    [_sendView addSubview:_allShuruLbl];
    
    
    _keLabl=[[UILabel alloc]initWithFrame:CGRectMake(270, 50, 30, 25)];
    _keLabl.textColor=kWhiteTextColor;
    _keLabl.font=kNormalTextFont;
    _keLabl.text=@"分钟";
    _keLabl.backgroundColor=[UIColor clearColor];

    _keLabl.hidden=YES;
    _keLabl.textAlignment=NSTextAlignmentCenter;
    [_sendView addSubview:_keLabl];
    
    
    _foodCountLabl=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 320, 25)];
    _foodCountLabl.textColor=kWhiteTextColor;
    _foodCountLabl.font=kNormalTextFont;
    _foodCountLabl.backgroundColor=[UIColor clearColor];

    _foodCountLabl.textAlignment=NSTextAlignmentCenter;
    [_sendView addSubview:_foodCountLabl];
    
    
    _needbuchonLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 95+0, 320, 25)];
    _needbuchonLbl.textColor=kWhiteTextColor;
    _needbuchonLbl.font=kNormalTextFont;
    _needbuchonLbl.textAlignment=NSTextAlignmentCenter;
    _needbuchonLbl.backgroundColor=[UIColor clearColor];

    [_sendView addSubview:_needbuchonLbl];
    
    
    _lingshiLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 95+25, 320, 25)];
    _lingshiLbl.textColor=kWhiteTextColor;
    _lingshiLbl.font=kNormalTextFont;
    _lingshiLbl.backgroundColor=[UIColor clearColor];

    _lingshiLbl.textAlignment=NSTextAlignmentCenter;
    [_sendView addSubview:_lingshiLbl];
    
    
    UIView*view =[[UIView alloc]initWithFrame:CGRectMake(0, 150, 320, 40)];
    view.backgroundColor=[UIColor blueColor];
    [_sendView addSubview:view];
    
    
    UILabel*one=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 100, 30)];
    one.textColor=kWhiteTextColor;
    one.font=kNormalTextFont;
    one.text=@"已添加项目";
    one.backgroundColor=[UIColor clearColor];

    one.textAlignment=NSTextAlignmentCenter;
    [view addSubview:one];
    
    UILabel*two=[[UILabel alloc]initWithFrame:CGRectMake(100, 5, 110, 30)];
    two.textColor=kWhiteTextColor;
    two.font=kNormalTextFont;
    two.text=@"时间(分钟)";
    two.backgroundColor=[UIColor clearColor];

    two.textAlignment=NSTextAlignmentCenter;
    [view addSubview:two];
    
    UILabel*three=[[UILabel alloc]initWithFrame:CGRectMake(210, 5, 110, 30)];
    three.textColor=kWhiteTextColor;
    three.font=kNormalTextFont;
    three.text=@"消耗能量(千卡)";
    three.backgroundColor=[UIColor clearColor];

    three.textAlignment=NSTextAlignmentCenter;
    [view addSubview:three];
    
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 190, 320, kContentViewHeight-200+49) style:UITableViewStylePlain];
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
    
    
    UIImageView *imageVewiMiddleswx =[[UIImageView alloc]initWithFrame:CGRectMake((320-119)/2, 130+97+97+97+97*2, 119, 97)];
    imageVewiMiddleswx.image=[UIImage imageNamed:@"left.png"];
    [_fistView addSubview:imageVewiMiddleswx];
    
    UIImageView *imageVewiMiddleeigh =[[UIImageView alloc]initWithFrame:CGRectMake((320-119)/2, 130+97+97+97+97*3, 119, 97)];
    imageVewiMiddleeigh.image=[UIImage imageNamed:@"right.png"];
    [_fistView addSubview:imageVewiMiddleeigh];
    
    
    _needbuchonLbl.text=[NSString stringWithFormat:@"还需消耗%0.2f千卡",0.0];
    _foodCountLabl.text=[NSString stringWithFormat:@"您今天共做了%d项运动",0];
    _lingshiLbl.text=[NSString stringWithFormat:@"消耗总量为%0.2f千卡",0.0];


}

//运动种类选择
-(void)foodTypeSeleBtn
{
    
    SportsAllTableViewController*foodView=[[SportsAllTableViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:foodView];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)getData
{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"userID", nil]];
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetSportDetail"];
    
    __block SprotsViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetSportDetail" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf GetNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    
}
-(void)GetNewHealthDataAndResultSuccess:(NSString*)string
{
    NSDictionary*xmlDic =[NSDictionary dictionaryWithXMLString:string];
    NSLog(@"%@",xmlDic);
    _infoDicAbout=xmlDic[@"soap:Body"][@"GetSportDetailResponse"][@"GetSportDetailResult"][@"data"][@"sportDetail"];
    
    UILabel *lbl11=(UILabel*)[self.view viewWithTag:11];
    UILabel *lbl12=(UILabel*)[self.view viewWithTag:32];
    UILabel *lbl13=(UILabel*)[self.view viewWithTag:42];
    
    lbl11.text=[NSString stringWithFormat:@"%@kg/m²",MBNonEmptyStringNo_(_infoDicAbout[@"BMI"])];
    lbl12.text=[NSString stringWithFormat:@"%@kg",MBNonEmptyStringNo_(_infoDicAbout[@"weight"])];
    lbl13.text=[NSString stringWithFormat:@"%@kg之间",MBNonEmptyStringNo_(_infoDicAbout[@"bzWeight"])];

    NSArray *sports =[MBNonEmptyStringNo_(_infoDicAbout[@"recommendedSports"]) componentsSeparatedByString:@"&"];
    
    NSLog(@"%@",sports);
    UILabel *lbl15=(UILabel*)[self.view viewWithTag:33];
    UILabel *lbl16=(UILabel*)[self.view viewWithTag:34];
    UILabel *lbl17=(UILabel*)[self.view viewWithTag:35];
    UILabel *lbl18=(UILabel*)[self.view viewWithTag:36];
    UILabel *lbl25=(UILabel*)[self.view viewWithTag:13];
    UILabel *lbl26=(UILabel*)[self.view viewWithTag:14];
    UILabel *lbl37=(UILabel*)[self.view viewWithTag:15];
    UILabel *lbl38=(UILabel*)[self.view viewWithTag:16];
    
    DBHelper *helo=[[DBHelper alloc]init];
    if (sports.count>=1&&((NSString*)sports[0]).length>1) {
        NSString *oneName =[MBNonEmptyStringNo_(sports[0]) componentsSeparatedByString:@"$"][0];
        lbl15.text=[helo returnSprotNameWithSprotCode:oneName];
        lbl25.text=[NSString stringWithFormat:@"%@分",MBNonEmptyStringNo_([sports[0] componentsSeparatedByString:@"$"][1])];
    }if (sports.count>=2) {
        NSString *twoName =[MBNonEmptyStringNo_(sports[1]) componentsSeparatedByString:@"$"][0];
         lbl16.text=[helo returnSprotNameWithSprotCode:twoName];
        lbl26.text=[NSString stringWithFormat:@"%@分",MBNonEmptyStringNo_([sports[1] componentsSeparatedByString:@"$"][1])];

    }if (sports.count>=3) {
        NSString *threeName =[MBNonEmptyStringNo_(sports[2]) componentsSeparatedByString:@"$"][0];
         lbl17.text=[helo returnSprotNameWithSprotCode:threeName];
        lbl37.text=[NSString stringWithFormat:@"%@分",MBNonEmptyStringNo_([sports[2] componentsSeparatedByString:@"$"][1])];

    }if (sports.count>=4) {
        NSString *fourName =[MBNonEmptyStringNo_(sports[3]) componentsSeparatedByString:@"$"][0];
         lbl18.text=[helo returnSprotNameWithSprotCode:fourName];
        lbl38.text=[NSString stringWithFormat:@"%@分",MBNonEmptyStringNo_([sports[3] componentsSeparatedByString:@"$"][1])];

    }
    

    
    
    


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
            
            if (_showDic.count>0) {
                [_showDic removeAllObjects];
            }
            [self getAllFoodDetail];
            
        }
        
        
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _showDic.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellSr=@"TiJianReprotCell";
    UITableViewCell*cell =[tableView dequeueReusableCellWithIdentifier:cellSr];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellSr];
        for (int i=0; i<3; i++) {
            MBLabel *labl =[[MBLabel alloc]initWithFrame:CGRectMake(110*i, 5, 110, 30)];
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
    cell.tag=indexPath.row;
    NSDictionary *arrayDic =_showDic[indexPath.row];
    NSLog(@"%@",arrayDic);

    UILabel *one =(UILabel*)[cell viewWithTag:10000];
    UILabel *two =(UILabel*)[cell viewWithTag:10001];
    UILabel *thr =(UILabel*)[cell viewWithTag:10002];
    
    one.text=MBNonEmptyStringNo_(arrayDic[@"sportName"]);
    two.text=MBNonEmptyStringNo_(arrayDic[@"min"]);
    thr.text=MBNonEmptyStringNo_(arrayDic[@"nutrientsKCALs"]);


    return cell;
}

-(void)gestureRecognizerHandle:(UILongPressGestureRecognizer*)longgest
{
    UITableViewCell *cell=(UITableViewCell*)[longgest view];
    _deleIndexAboutArray=cell.tag;
    MBAlertView *alterView =[[MBAlertView alloc]initWithTitle:Nil message:@"确定删除此运动记录！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alterView.tag=10004;
    [alterView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10004) {
        if (buttonIndex==1) {
            
            NSLog(@"%@",_showDic[_deleIndexAboutArray]);
            [self deleteAboutNews];
            
            
        }
    }
}
-(void)deleteAboutNews
{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    NSDictionary *deleInfo =_showDic[_deleIndexAboutArray];
    NSLog(@"%@",deleInfo);
    NSMutableArray *arr=[NSMutableArray array];
    
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(deleInfo[@"sportRecordID"]),@"sportID", nil]];
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"DeleteClientSportRecord"];
    NSLog(@"%@",soapMsg);
    
    __block SprotsViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"DeleteClientSportRecord" params:@{@"soapMessag":soapMsg}];
    
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
    if ([MBNonEmptyStringNo_(dic[@"soap:Body"][@"DeleteClientSportRecordResponse"][@"DeleteClientSportRecordResult"]) isEqualToString:@"1"]) {
        [_showDic removeObjectAtIndex:_deleIndexAboutArray];
        if (_showDic.count>0) {
            [_showDic removeAllObjects];
        }
       
        [self getAllFoodDetail];
        
    }
}

@end
