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
#import "MBBaseScrollView.h"
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
    self.view.backgroundColor = HEX(@"#ffffff");
    [self getAllPdf];
    
}
-(void)getAllPdf{

    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"_userId", nil]];
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetPDFCount"];
    NSLog(@"%@",soapMsg);
    __block RepoertViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetPDFCount" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf GeGetPDFCounttNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        NSLog(@"%@",error);
    }];

    
}
-(void)GeGetPDFCounttNewHealthDataAndResultSuccess:(NSString *)string
{
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:string];
    NSLog(@"%@",xmlDoc);
    NSArray *arrayof = xmlDoc[@"soap:Body"][@"GetPDFCountResponse"][@"GetPDFCountResult"][@"ArrayOfString"][@"string"];
    if ([arrayof isKindOfClass:[NSArray class]]) {
        _allPdf = arrayof;
        
        
        UIScrollView *baseViewHel = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, kScreenHeight)];
        [self.view addSubview:baseViewHel];
        
        baseViewHel.contentSize= CGSizeMake(arrayof.count/3*320, kScreenHeight);
        baseViewHel.pagingEnabled= YES;
        
        for (int i=0; i<arrayof.count; i+=3) {
            
            MBBaseScrollView *baseView = [[MBBaseScrollView alloc]initWithFrame:CGRectMake(320*(i/3), 0, 320, kScreenHeight)];
            [baseViewHel addSubview:baseView];
            
            UIImageView *showiMageView =[[UIImageView alloc]initWithFrame:CGRectMake(30, 20, 260, kScreenHeight-240)];
            showiMageView.image = [UIImage imageNamed:@"fengmian.jpg"];
            [baseView addSubview:showiMageView];
            
            UIButton * searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            [searchBtn setTitle:@"点击查看" forState:UIControlStateNormal];
            searchBtn.titleLabel.font=kNormalTextFont;
            searchBtn.frame = CGRectMake(210, kScreenHeight-200-80, 90, 30);
            [searchBtn addTarget:self action:@selector(searchBtnPressedseeDtail:) forControlEvents:UIControlEventTouchUpInside];
            searchBtn.tag=100+i;
            searchBtn.titleLabel.textColor = kNormalTextColor;
            [searchBtn setTitleColor:kNormalTextColor forState:UIControlStateNormal];
            [searchBtn setTitleColor:kNormalTextColor forState:UIControlStateHighlighted];
            
            [showiMageView addSubview:searchBtn];
            [baseView addSubview:searchBtn];
            
                UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(60, kScreenHeight-50-100-80+20, 260, 30)];
                name.text = [NSString stringWithFormat:@"姓      名:%@",arrayof[i]];
                name.textColor =HEX(@"#5ec4fe");
                name.font = kNormalTextFont;
                [baseView addSubview:name];
                
                UILabel *nametime = [[UILabel alloc]initWithFrame:CGRectMake(60, kScreenHeight-50-100+30-80+20, 260, 30)];
                nametime.text = [NSString stringWithFormat:@"体检时间:%@",arrayof[i+1]];
                nametime.textColor =HEX(@"#5ec4fe");
                nametime.font = kNormalTextFont;
                [baseView addSubview:nametime];
                UILabel *nameCode = [[UILabel alloc]initWithFrame:CGRectMake(60, kScreenHeight-50-100+60-80+20, 260, 30)];
                nameCode.text = [NSString stringWithFormat:@"体检编号:%@",arrayof[i+2]];
                nameCode.textColor =HEX(@"#5ec4fe");
                nameCode.font = kNormalTextFont;
                [baseView addSubview:nameCode];

            
        }
        
    }
    
    
}
-(void)getBtnPdf:(NSString*)string{


    
    NSMutableArray *arr=[NSMutableArray array];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:string,@"_reportNO", nil]];
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
        MBSafetyIntroViewController *detail = [[MBSafetyIntroViewController alloc] init];
        detail.urlStr = [NSString stringWithFormat:@"%@",getPdf];
        //NSLog(@"detail.urlStr = %@",detail.urlStr);
        [self.navigationController pushViewController:detail animated:YES];
        
    }else
    {
        MBAlert(@"不存在次体检报告");


    }
}
-(void)searchBtnPressedseeDtail:(UIButton*)btn{
    int indexAbout = (btn.tag-100)/3;
    NSLog(@"%d",indexAbout);
    NSLog(@"%@",_allPdf[indexAbout*3+2]);
    [self getBtnPdf:_allPdf[indexAbout*3+2]];
    

    
}
@end
