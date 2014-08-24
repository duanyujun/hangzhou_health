//
//  YuyueTeleViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-29.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "YuyueJiluDetialViewController.h"
#import "MBSelectView.h"
#import "XMLDictionary.h"
#import "MBIIRequest.h"
#import "SoapHelper.h"
#import "NSDateUtilities.h"
#import "YuyuejiLiuAllController.h"
#import "XMLDictionary.h"
@interface YuyueJiluDetialViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

@end

@implementation YuyueJiluDetialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)backViewUPloadView{
[self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"预约信息";
    self.view.backgroundColor=HEX(@"#ffffff");
   
    
    
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

    
    UIView *bgView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, kScreenHeight)];
    bgView.backgroundColor=HEX(@"#ffffff");
    [self.view addSubview:bgView];
    
    
    NSArray *itemArray =@[@"套餐名称：",@"套餐价格：",@"处理状态：",@"预约时间：",@"姓  名：",@"联系电话：",@"备  注："];
    NSArray *iteVal =@[
                       MBNonEmptyStringNo_(_dicInfoAbout[@"templateName"]),
                       [MBNonEmptyStringNo_(_dicInfoAbout[@"price"])stringByAppendingString:@"元"],[MBNonEmptyStringNo_(_dicInfoAbout[@"nowState"]) isEqualToString:@"1"]?@"未处理":@"处理",
                       MBNonEmptyStringNo_(_dicInfoAbout[@"reservationDate"]),
                MBNonEmptyStringNo_(_dicInfoAbout[@"name"]),
                       MBNonEmptyStringNo_(_dicInfoAbout[@"mobile"]),
                       MBNonEmptyStringNo_(_dicInfoAbout[@"reservationExplain"])];
    for (int i=0; i<itemArray.count; i++) {
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10+i*40, 80, 35)];
        label.textAlignment=NSTextAlignmentLeft;
        label.text=itemArray[i];
        label.font=kNormalTextFont;
        label.backgroundColor=[UIColor clearColor];
        [self.view addSubview:label];
        
        UILabel *towolab=[[UILabel alloc]initWithFrame:CGRectMake(120, 10+i*40, 180, 35)];
        towolab.textAlignment=NSTextAlignmentLeft;
        towolab.text=itemArray[i];
        towolab.font=kNormalTextFont;
        towolab.textAlignment=NSTextAlignmentRight;
        towolab.text=iteVal[i];
        towolab.backgroundColor=[UIColor clearColor];
        if (i==3) {
            towolab.text=MBNonEmptyStringNo_([iteVal[i] componentsSeparatedByString:@" "][0]);
        }
        if (i==6) {
            towolab.text=MBNonEmptyStringNo_([iteVal[i] componentsSeparatedByString:@" "][0]);
        }
        NSLog(@"%@",_dicInfoAbout);
        
        [self.view addSubview:towolab];
        
    }
 
    for (int i=1; i<itemArray.count+1; i++) {
        UIImageView *iameg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10+i*38, 300, 1)];
        iameg.backgroundColor=kTipTextColor;
        [bgView addSubview:iameg];
    }
    

    
}




@end
