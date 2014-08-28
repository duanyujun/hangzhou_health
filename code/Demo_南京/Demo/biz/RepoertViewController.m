//
//  RepoertViewController.m
//  Demo
//
//  Created by wang on 14-8-28.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "RepoertViewController.h"
#import "MBLabel.h"
#import "MBTextField.h"
#import "SoapHelper.h"
#import "MBIIRequest.h"
#import "XMLDictionary.h"
@implementation RepoertViewController
//返回到上个页面
-(void)backViewUPloadView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
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
    UIView *BgView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, kScreenHeight)];
    BgView.backgroundColor=HEX(@"#ffffff");
    [self.view addSubview:BgView];
    self.title = @"评估报告";
    MBLabel *showLabel =[[MBLabel alloc]initWithFrame:CGRectMake(10, 0, 320, 30)];
    showLabel.font = kNormalTextFont;
    showLabel.text = @"请输入体检编号";
    [BgView addSubview:showLabel];
    
    _bianhaoTF=[[MBTextField alloc]initWithFrame:CGRectMake(10, 40, 220, 30)];
    _bianhaoTF.backgroundColor=[UIColor clearColor];
    _bianhaoTF.borderStyle=UITextBorderStyleRoundedRect;
    _bianhaoTF.delegate=self;
    [BgView addSubview:_bianhaoTF];
    
    UIButton * searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(240, 40, 60, 30);
    [searchBtn addTarget:self action:@selector(searchBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.backgroundColor = HEX(@"#5ec4fe");
    [BgView addSubview:searchBtn];
    
}
-(void)searchBtnPressed{

    if (_bianhaoTF.text.length==0) {
        MBAlert(@"请输入体检编号");
        return;
    }
    
    NSMutableArray *arr=[NSMutableArray array];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:_bianhaoTF.text,@"reportNO", nil]];
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetPersonReportVirtualPath"];
    
    __block RepoertViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetPersonReportVirtualPath" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf GetNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];

}
-(void)GetNewHealthDataAndResultSuccess:(NSString*)string
{
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:string];
    NSLog(@"%@",xmlDoc);
}
@end
