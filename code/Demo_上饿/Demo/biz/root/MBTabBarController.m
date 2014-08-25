//
//  MBTabBarController.m
//  BOCMBCI
//
//  Created by Tracy E on 13-3-25.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBTabBarController.h"
#import "PaperViewController.h"
#import "YuyuejiLiuAllController.h"
#import "SoapHelper.h"
#import "UITabBar+TabBarButtons.h"
#import "MBConstant.h"
#import "MBGlobalUICommon.h"
#import "MBPresentView.h"
#import "MBAlertView.h"
#import "MBUserInfo.h"
#import "SprotsViewController.h"
#import "MBIIRequest.h"
#import "MBFileManager.h"
#import "UIDevice+DevicePrint.h"
#import "AppDelegate.h"
#import "MBLabel.h"
#import "SMPageControl.h"
#import "HomeViewController.h"
#import "MBPersonInfoViewController.h"
#import "shoucangViewController.h"
#import "YuyueJiluViewController.h"
#import "ShanShiTuijianViewController.h"
#import "FoodViewController.h"
#import "MoreViewController.h"
#import "NewsViewController.h"
@interface UITabBar (CustomStyle)
@end

@implementation UITabBar (CustomStyle)

- (void)drawRect:(CGRect)rect
{
    //重画TabBar背景
    if (MBOSVersion() < 5.0) {
        UIImage *image;
        image = [UIImage imageNamed:@"tabBarBG.png"];
        [image drawInRect:CGRectMake(0, self.bounds.size.height - image.size.height,
                                     self.bounds.size.width, image.size.height)];
    }
}
@end

//--------------------------------------------------------------------------------------------------

@implementation MBShortcutButton

+ (id)itemWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url{
    return [[MBShortcutButton alloc] initWithTitle:title image:image url:url];
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url{
    self = [super init];
    if (self) {
        self.url = url;
        
        self.userInteractionEnabled = YES;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
        [self addSubview:_imageView];
        
        _imageView.image = image;
        
        _textLabel = [[MBLabel alloc] initWithFrame:CGRectMake(0, 60, 52, 20)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
        _textLabel.textColor = HEX(@"#ffffff");
        _textLabel.text = title;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.isPaoMaDeng = NO;
        [self addSubview:_textLabel];
    }
    return self;
}
@end


//--------------------------------------------------------------------------------------------------
@interface MBTabBarController (){
    UIButton *              _tabBarActionButton;
    UILabel  *              _tabBarActionLabl;
    BOOL                    _isActionAnimating;
    
    NSArray *               _menuList;
    UIButton *              _menuBackButton;
    MBPresentView *         _menuListView;
    UITableView *           _menuTableView;
    MBShortcutButton *      _currentAddedButton;
    UILabel *               _menuTipLabel;
    
    UIImageView *           _defaultView;
    NSString *              _appStoreURL;
    
    SMPageControl    *_showCurPageControl;
    
    UIControl *             _shortcutBackgroundView;
    UIImageView *           _menuBG;
    BOOL                    _isMenuShow;
    NSMutableArray *_allItemArray;
    
}

@end

@implementation MBTabBarController

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
    
    
    _allItemArray=[[NSMutableArray alloc]initWithCapacity:2];
    
	// Do any additional setup after loading the view.
    _homeViewControllerOne = [[HomeViewController alloc] init];
    _homeViewControllerTwo = [[HomeViewController alloc] init];
    _homeViewControllerThree = [[HomeViewController alloc] init];
    _homeViewControllerFour = [[HomeViewController alloc] init];
    _homeViewControllerOne.title=@"掌上健康";
    _homeViewControllerTwo.title=@"掌上健康";
    _homeViewControllerThree.title=@"掌上健康";
    _homeViewControllerFour.title=@"掌上健康";
    
//    Tablebar 背景色设置
    if (MBOSVersion() >= 6.0)
    {
        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
    if (!IOS7_OR_LATER) {
        [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabBarBG.png"]];
        self.tabBar.backgroundColor=[UIColor whiteColor];
    }
    self.tabBar.alpha=0.8;
    
    _mobileBankNavigationController =
    [[UINavigationController alloc] initWithRootViewController:_homeViewControllerOne];
    
    _mobileBankNavigationController.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"饮食"
                                  image:[UIImage imageNamed:@"tabBarItem1.png"]
                                    tag:0];
    _mobileBankNavigationController.tabBarItem.selectedImage =[UIImage imageNamed:@"tabBarItem1_red.png"];
    
    
    _fidgetNavigationController =
    [[UINavigationController alloc] initWithRootViewController:_homeViewControllerTwo];
    _fidgetNavigationController.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"运动"
                                  image:[UIImage imageNamed:@"tabBarItem2.png"]
                                    tag:1];
    
    _fidgetNavigationController.tabBarItem.selectedImage =[UIImage imageNamed:@"tabBarItem2_red.png"];
    
    
    
    _newsNavigationController =
    [[UINavigationController alloc] initWithRootViewController:_homeViewControllerThree];
    _newsNavigationController.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"资讯"
                                  image:[UIImage imageNamed:@"tabBarItem3.png"]
                                    tag:3];
    _newsNavigationController.tabBarItem.selectedImage =[UIImage imageNamed:@"tabBarItem3_red.png"];
    
    
    
    
    _informationNavigationController =
    [[UINavigationController alloc] initWithRootViewController:_homeViewControllerFour];
    _informationNavigationController.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"更多"
                                  image:[UIImage imageNamed:@"tabBarItem4.png"]
                                    tag:4];
    
    _informationNavigationController.tabBarItem.selectedImage =[UIImage imageNamed:@"tabBarItem4_red.png"];
    
    
    UIViewController *cenger=[[UIViewController alloc]init];
    cenger.view.backgroundColor=[UIColor redColor];
    
    self.viewControllers = @[_mobileBankNavigationController,
                             _fidgetNavigationController,
                             cenger,
                             _newsNavigationController,
                             _informationNavigationController];
    
    [self addCustomTabBarButton];
    
    
}

#pragma mark - Custom Methods
//配置程序外观（StatusBar | NavigationBar | TabBar）

-(void)addCustomTabBarButton
{
    UIImage *buttonImage = [UIImage imageNamed:@"tabBarMenu.png"];
    _tabBarActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _tabBarActionButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    _tabBarActionButton.frame = CGRectMake(0.0, 0, 30, 30);
    [_tabBarActionButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_tabBarActionButton addTarget:self action:@selector(showPopMenu) forControlEvents:UIControlEventTouchUpInside];
    _tabBarActionButton.center = CGPointMake(self.tabBar.center.x, _tabBarActionButton.center.y);
    _tabBarActionLabl =[[UILabel alloc]initWithFrame:CGRectMake(_tabBarActionButton.frame.origin.x+2, _tabBarActionButton.frame.origin.y+33, 40, 20)];
    _tabBarActionLabl.text=@"个人";
    _tabBarActionLabl.font=[UIFont fontWithName:@"Helvetica Neue" size:11];
    _tabBarActionLabl.textColor=kTipTextColor;
    _tabBarActionLabl.backgroundColor=[UIColor clearColor];
    [self.tabBar addSubview:_tabBarActionLabl];
    _tabBarActionLabl.userInteractionEnabled=NO;
    [self.tabBar addSubview:_tabBarActionButton];
}



#pragma mark - UITabBarDelegate Method
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    if (_isMenuShow) {
        [_shortcutBackgroundView removeFromSuperview];
        _shortcutBackgroundView = nil;
        
        _tabBarActionButton.transform = CGAffineTransformMakeRotation(0);
        _isMenuShow = NO;
        [_tabBarActionButton setBackgroundImage:[UIImage imageNamed:@"tabBarMenu.png"] forState:UIControlStateNormal];
        _tabBarActionLabl.textColor=kTipTextColor;
        _isActionAnimating = NO;
        
    }
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        [self goToLoginViewAbout];
    }else{
        NSInteger index = [tabBar.items indexOfObject:item];
        
        if (index==0) {
            [self getSendLogAboutFood];
            
           
        }if (index==1) {
            [self getSendLogAboutsprots];

        }if (index==4) {
            
            MoreViewController *food =[[MoreViewController alloc]init];
            UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:food];
            [self presentViewController:nav animated:YES completion:nil];
        }
        if (index==3) {
            
            NewsViewController *food =[[NewsViewController alloc]init];
            UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:food];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
    
}
-(void)getSendLogAboutsprots
{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    NSMutableArray *arr=[NSMutableArray array];
    
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:ORGANIZATIONNAME,@"OrganName", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"UserName"],@"ClientNo", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"Name"],@"ClientName", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"MobileNO"],@"Mobile", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"健康运动",@"ActExplain", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"Remark", nil]];
    
    
    NSString *soapMsg=[SoapHelper arraySendLogToDefaultSoapMessage:arr methodName:@"AddWenXinOperateLog"];
    NSLog(@"111111111111===========%@",soapMsg);
    __block MBTabBarController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"AddWenXinOperateLog" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestSendLogXMLWithItems:@[item] success:^(id JSON) {
        
        NSLog(@"444444=====%@",[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]);
        [blockSelf goToSprotsView];
        
    } failure:^(NSError *error, id JSON) {
        [blockSelf goToSprotsView];
        
    }];
}

-(void)goToSprotsView
{
    SprotsViewController *food =[[SprotsViewController alloc]init];
    UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:food];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)getSendLogAboutFood
{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    NSMutableArray *arr=[NSMutableArray array];
    
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:ORGANIZATIONNAME,@"OrganName", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"UserName"],@"ClientNo", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"Name"],@"ClientName", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allUserDic allValues][0][@"MobileNO"],@"Mobile", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"健康饮食",@"ActExplain", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"Remark", nil]];
    
    
    NSString *soapMsg=[SoapHelper arraySendLogToDefaultSoapMessage:arr methodName:@"AddWenXinOperateLog"];
    NSLog(@"111111111111===========%@",soapMsg);
    __block MBTabBarController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"AddWenXinOperateLog" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestSendLogXMLWithItems:@[item] success:^(id JSON) {
        
        NSLog(@"444444=====%@",[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]);
        [blockSelf goToFoodView];
        
    } failure:^(NSError *error, id JSON) {
        [blockSelf goToFoodView];
        
    }];
}

-(void)goToFoodView
{
    FoodViewController *food =[[FoodViewController alloc]init];
    UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:food];
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)showPopMenu{
    
    if (_isActionAnimating) {
        
        NSLog(@"111====%@",_allItemArray);
        
        for (int i=0; i<_allItemArray.count; i++) {
            MBShortcutButton*btn =(MBShortcutButton*)_allItemArray[i];
            NSLog(@"%@",btn);
            [UIView animateWithDuration:0.5 animations:^{
                
                btn.frame=CGRectMake(135, kScreenHeight, 55, 80);
                
                
            } completion:^(BOOL finished) {
                
                
                if (finished) {
                    if (i==4) {
                        [_shortcutBackgroundView removeFromSuperview];
                        _isActionAnimating = NO;
                    }
                }
            }];
        }
        
    }
    _isActionAnimating = YES;
    [_tabBarActionButton setBackgroundImage:[UIImage imageNamed:@"tabBarMenu_hight.png"] forState:UIControlStateNormal];
    _tabBarActionLabl.textColor=[UIColor blueColor];
    
    if (!_shortcutBackgroundView) {
        _shortcutBackgroundView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _shortcutBackgroundView.backgroundColor=[UIColor blackColor];
        UIImageView *bageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        bageView.backgroundColor=[UIColor blackColor];
        bageView.alpha=0.5f;
        //        bageView.image =[UIImage imageNamed:@"menuBg.png"];
        [_shortcutBackgroundView addSubview:bageView];
        
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(146, kScreenHeight-264+5, 37, 16);
        [btn addTarget:self action:@selector(uploadView) forControlEvents:UIControlEventTouchUpInside];
        //        [btn setBackgroundImage:[UIImage imageNamed:@"menbgBtn.png"] forState:UIControlStateNormal];
        [_shortcutBackgroundView addSubview:btn];
        
    }
    
    NSArray *itemArray = @[@"资料",@"收藏",@"预约记录",@"问卷",@"膳食推荐"];
    NSArray *itemAImagerray = @[@"information_normal.png",@"star_pressed.png",@"disease_gif_normal.png",@"disease_icon.png",@"risk_normal.png"];
    
    if (!_isMenuShow) {
        
        if (_allItemArray.count>0) {
            [_allItemArray removeAllObjects];
        }
        for (int i = 0; i < 5; i++) {
            NSInteger tag = 100 + i;
            
            MBShortcutButton *item = [MBShortcutButton itemWithTitle:itemArray[i] image:[UIImage imageNamed:itemAImagerray[i]] url:itemAImagerray[i]];
            
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCurmenu:)];
            [item addGestureRecognizer:tapGesture];
            
            item.frame=CGRectMake(135, kScreenHeight, 55, 80);
            
            [UIView animateWithDuration:0.5 animations:^{
                if (i<4) {
                    item.frame = CGRectMake(20*(i+1)+55*i, kScreenHeight-160-70, 55, 80);
                    
                }else
                {
                    item.frame = CGRectMake(20, kScreenHeight-160+10+10, 55, 80);
                    
                }
                
            } completion:^(BOOL finished) {
                
                
                
            }];
            item.tag = tag;
            [_allItemArray addObject:item];
            [_shortcutBackgroundView addSubview:item];
        }
        
        [_shortcutBackgroundView addTarget:self action:@selector(showPopMenu) forControlEvents:UIControlEventTouchUpInside];
        _shortcutBackgroundView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:_shortcutBackgroundView belowSubview:self.tabBar];
        
        
        
    } else {
        
        NSLog(@"22222====%@",_allItemArray);
        
        for (int i=0; i<_allItemArray.count; i++) {
            MBShortcutButton*btn =(MBShortcutButton*)_allItemArray[i];
            NSLog(@"%@",btn);
            [UIView animateWithDuration:0.5 animations:^{
                
                btn.frame=CGRectMake(135, kScreenHeight, 55, 80);
                
                
            } completion:^(BOOL finished) {
                
                
                if (finished) {
                    if (i==4) {
                        //                        [_shortcutBackgroundView removeFromSuperview];
                        _isActionAnimating = NO;
                    }
                }
            }];
        }
    }
    _isMenuShow = !_isMenuShow;
}
//进入登陆页面
-(void)goToLoginViewAbout
{
    MBNotLogViewController *notLogin =[[MBNotLogViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:notLogin];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)showCurmenu:(UIGestureRecognizer*)gesture
{
    
    if (_isMenuShow) {
        [_shortcutBackgroundView removeFromSuperview];
        _shortcutBackgroundView = nil;
        
        _tabBarActionButton.transform = CGAffineTransformMakeRotation(0);
        _isMenuShow = NO;
        [_tabBarActionButton setBackgroundImage:[UIImage imageNamed:@"tabBarMenu.png"] forState:UIControlStateNormal];
        _tabBarActionLabl.textColor=kTipTextColor;
        _isActionAnimating = NO;
        
    }
    NSArray *itemAImagerray = @[@"information_normal.png",@"star_pressed.png",@"disease_gif_normal.png",@"disease_icon.png",@"risk_normal.png"];
    
    _aboutRootViewController=nil;
    UINavigationController *rootViewController=nil;
    if (self.selectedIndex==0) {
        rootViewController=_mobileBankNavigationController;
    } if (self.selectedIndex==1) {
        rootViewController=_fidgetNavigationController;
    }  if (self.selectedIndex==3) {
        rootViewController=_newsNavigationController;
    } if (self.selectedIndex==4) {
        rootViewController=_informationNavigationController;
    }
    _aboutRootViewController=rootViewController;
    
    MBShortcutButton*currentAddedButton = (MBShortcutButton *)[gesture view];
    BOOL isLoginOK =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if ([currentAddedButton.url isEqualToString:itemAImagerray[2]])  {
    if (!isLoginOK) {
        if ([currentAddedButton.url isEqualToString:itemAImagerray[2]])  {
            //预约记录
            YuyueJiluViewController*person=[[YuyueJiluViewController alloc]init];
            [rootViewController pushViewController:person animated:YES];
            return;
        }
    }else
    {
        [self yueyuBtnPressed];
        return;
        
    }
    }
    
    
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        [self goToLoginViewAbout];
    }else{
        
        if ([currentAddedButton.url isEqualToString:itemAImagerray[0]])  {
            //资料
            MBPersonInfoViewController*person=[[MBPersonInfoViewController alloc]init];
            [rootViewController pushViewController:person animated:YES];
        }
        if ([currentAddedButton.url isEqualToString:itemAImagerray[1]])  {
            //收藏
            shoucangViewController*person=[[shoucangViewController alloc]init];
            [rootViewController pushViewController:person animated:YES];
        }
        if ([currentAddedButton.url isEqualToString:itemAImagerray[3]])  {
            //问卷
//            MBAlert(@"此功能暂未开通");
//            return;
            PaperViewController*person=[[PaperViewController alloc]init];
            UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:person];
            [rootViewController presentViewController:nav animated:YES completion:^{
            
                    }];
            
        }
        
        if ([currentAddedButton.url isEqualToString:itemAImagerray[4]])  {
            //膳食推荐
            ShanShiTuijianViewController*person=[[ShanShiTuijianViewController  alloc]init];
            [rootViewController pushViewController:person animated:YES];
        }
    }
    
}
//预约查询
-(void)yueyuBtnPressed
{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    NSLog(@"%@",allUserDic);
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"Name"]),@"name", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"MobileNO"]),@"mobile", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",0],@"startIndex", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",10000000],@"endIndex", nil]];
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetReservationBodycheckList"];
    
    __block MBTabBarController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetReservationBodycheckList" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf AddReservationBodycheckSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
        
    }];
    
}
//预约查询
-(void)AddReservationBodycheckSuccess:(NSString *)string
{
    
    NSDictionary *resutlDic =[NSDictionary dictionaryWithXMLString:string][@"soap:Body"][@"GetReservationBodycheckListResponse"][@"GetReservationBodycheckListResult"];
    
    NSArray *array =resutlDic[@"data"][@"style"];
    
    NSMutableArray *itemArray =[NSMutableArray arrayWithCapacity:2];
    if ([array isKindOfClass:[NSArray class]]) {
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic =array[i];
            if (!dic[@"isOrNo"]) {
                [itemArray addObject:dic];
            }
        }
    }
    
    
    
    
    YuyuejiLiuAllController *allview =[[YuyuejiLiuAllController alloc]init];
    allview.resultArray=itemArray;
    [_aboutRootViewController pushViewController:allview animated:YES];
}
-(void)uploadView
{
    if (_isMenuShow) {
        
        [_shortcutBackgroundView removeFromSuperview];
        _shortcutBackgroundView = nil;
        
        _tabBarActionButton.transform = CGAffineTransformMakeRotation(0);
        _isMenuShow = NO;
        [_tabBarActionButton setBackgroundImage:[UIImage imageNamed:@"tabBarMenu.png"] forState:UIControlStateNormal];
        _tabBarActionLabl.textColor=kTipTextColor;
        _isActionAnimating = NO;
        
    }
    
}
@end
