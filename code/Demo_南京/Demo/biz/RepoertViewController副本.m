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
#import "MBSafetyIntroViewController.h"
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
    BgView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, kScreenHeight)];
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
//    _bianhaoTF.text = @"099958133";
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
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:_bianhaoTF.text,@"_reportNO", nil]];
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetPersonReportVirtualPath"];
    NSLog(@"%@",soapMsg);
    __block RepoertViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetPersonReportVirtualPath" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf GetNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        NSLog(@"%@",error);
    }];

}
-(void)GetNewHealthDataAndResultSuccess:(NSString*)string
{
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:string];
    NSLog(@"%@",xmlDoc);
    NSString *getPdf = MBNonEmptyStringNo_(xmlDoc[@"soap:Body"][@"GetPersonReportVirtualPathResponse"][@"GetPersonReportVirtualPathResult"]);
    if (getPdf.length>0) {
        
        UIImageView *showiMageView =[[UIImageView alloc]initWithFrame:CGRectMake(30, 80, 260, kScreenHeight-240)];
        showiMageView.image = [UIImage imageNamed:@"fengmian.jpg"];
        [BgView addSubview:showiMageView];
        
        UIButton * searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [searchBtn setTitle:@"点击查看" forState:UIControlStateNormal];
        searchBtn.titleLabel.font=kNormalTextFont;
        searchBtn.frame = CGRectMake(210, kScreenHeight-200, 90, 30);
        [searchBtn addTarget:self action:@selector(searchBtnPressedseeDtail) forControlEvents:UIControlEventTouchUpInside];
        searchBtn.titleLabel.textColor = kNormalTextColor;
        [searchBtn setTitleColor:kNormalTextColor forState:UIControlStateNormal];
        [searchBtn setTitleColor:kNormalTextColor forState:UIControlStateHighlighted];
        
        [showiMageView addSubview:searchBtn];
        [BgView addSubview:searchBtn];
        
        NSLog(@"%@",getPdf);
        NSArray *getAindof = [[[getPdf componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"_"];
        if (getAindof.count>=3) {
            UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(60, kScreenHeight-50-100, 260, 30)];
            name.text = [NSString stringWithFormat:@"姓      名:%@",getAindof[0]];
            name.textColor =HEX(@"#5ec4fe");
            name.font = kNormalTextFont;
            [BgView addSubview:name];
            
            UILabel *nametime = [[UILabel alloc]initWithFrame:CGRectMake(60, kScreenHeight-50-100+30, 260, 30)];
            nametime.text = [NSString stringWithFormat:@"体检时间:%@",getAindof[1]];
            nametime.textColor =HEX(@"#5ec4fe");
            nametime.font = kNormalTextFont;
            [BgView addSubview:nametime];
            _usrlStr = getPdf;
            UILabel *nameCode = [[UILabel alloc]initWithFrame:CGRectMake(60, kScreenHeight-50-100+60, 260, 30)];
            nameCode.text = [NSString stringWithFormat:@"体检编号:%@",_bianhaoTF.text];
            nameCode.textColor =HEX(@"#5ec4fe");
            nameCode.font = kNormalTextFont;
            [BgView addSubview:nameCode];
            name.tag=100;
            nametime.tag=101;
            nameCode.tag=102;

        }
        
        
    }else
    {
        MBAlert(@"不存在次体检报告");
        UILabel *one1 =(UILabel*)[BgView viewWithTag:100];
        UILabel *one2=(UILabel*)[BgView viewWithTag:101];
        UILabel *on3 =(UILabel*)[BgView viewWithTag:102];
        one2.text=@"";
        one1.text=@"";
        on3.text=@"";

    }
}
-(void)searchBtnPressedseeDtail{
    MBSafetyIntroViewController *detail = [[MBSafetyIntroViewController alloc] init];
    detail.urlStr = [NSString stringWithFormat:@"%@",_usrlStr];
    //NSLog(@"detail.urlStr = %@",detail.urlStr);
    [self.navigationController pushViewController:detail animated:YES];
    
}
@end
