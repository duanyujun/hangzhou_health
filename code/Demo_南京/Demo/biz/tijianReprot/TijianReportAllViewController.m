//
//  HomeViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-20.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "TijianReportAllViewController.h"
#import "MBConstant.h"
#import "MBNotLogViewController.h"
#import "AppDelegate.h"
#import "MBUserTransViewController.h"
#import "MBIIRequest.h"
#import "SoapHelper.h"
//#import <GHUnitIOS/GHUnit.h>
#import "NSDateUtilities.h"
#import "XMLParser.h"
#import "MBGlobalUICommon.h"
#import "TiJianReprotCell.h"
#import "TijianReportMoreDetialViewController.h"
#import "TijianReportMoreNotNorDetialViewController.h"
#import "RATreeView.h"
#import "RADataObject.h"
#import "MBLabel.h"
#import "MBAlertView.h"
#import "TijianDetialViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TijianReportAllViewController ()<RATreeViewDataSource,RATreeViewDelegate>
{
    
    UITableView *_tableView ;
    NSMutableArray *_dataArray;

}
@end

@implementation TijianReportAllViewController
//返回到上个页面
-(void)backViewUPloadView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
    NSLog(@"%@",[_dataArray description]);
   self.title=@"体检报告";
   self.view.backgroundColor= HEX(@"#ffffff");
    _dataArray =[[NSMutableArray alloc]initWithCapacity:2];

    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    NSMutableArray *allData =[NSMutableArray arrayWithCapacity:2];



    NSLog(@"%@",_healthAbnoramlsDic[@"abnoraml"]);
    NSArray *hearNorArray =_healthAbnoramlsDic[@"abnoraml"];
    if ([hearNorArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *hearNorArrayItem=[NSMutableArray arrayWithCapacity:2];

        for (int i=0; i<hearNorArray.count;i++ ) {
                RADataObject *phone1 = [RADataObject dataObjectWithName:hearNorArray[i][@"abnoramlName"] children:nil];
                [hearNorArrayItem addObject:phone1];
            if (i==0) {
                self.expanded=phone1;
            }
            }

        RADataObject *phone = [RADataObject dataObjectWithName:@"本次体检异常" children:hearNorArrayItem];
        [allData addObject:phone];
    }else
    {
        RADataObject *phone1 = [RADataObject dataObjectWithName:_healthAbnoramlsDic[@"abnoraml"][@"abnoramlName"] children:nil];

        RADataObject *phone = [RADataObject dataObjectWithName:@"本次体检异常" children:@[phone1]];
        
        NSLog(@"%@",_healthAbnoramlsDic);
        [allData addObject:phone];
    }
    NSLog(@"%@",_resultArray);

    
    for (int i=0; i<_resultArray.count; i++) {
        NSMutableArray *nameONe=[[NSMutableArray alloc]initWithCapacity:2];

        for (int j=0; j<[_resultArray[i][@"items"][@"item"] count]; j++) {
            if ([_resultArray[i][@"items"][@"item"] isKindOfClass:[NSArray class]]) {
                RADataObject *phone1 = [RADataObject dataObjectWithName:_resultArray[i][@"items"][@"item"][j][@"itemName"] children:nil];
                    [nameONe addObject:phone1];
               
            }
            if ([_resultArray[i][@"items"][@"item"] isKindOfClass:[NSDictionary class]]) {
                RADataObject *phone1 = [RADataObject dataObjectWithName:_resultArray[i][@"items"][@"item"][@"itemName"] children:nil];
                [nameONe addObject:phone1];
                NSLog(@"%@",_resultArray[i][@"items"][@"item"]);
                
                RADataObject *phone2 = [RADataObject dataObjectWithName:@"小结" children:nil];
                phone1.nameForValue=MBNonEmptyStringNo_(_resultArray[i][@"conclusion"]);
                [nameONe addObject:phone2];
                
                break;
                
            }
            if ([_resultArray[i][@"items"][@"item"] count]-1==j) {
                RADataObject *phone1 = [RADataObject dataObjectWithName:@"小结" children:nil];
                phone1.nameForValue=MBNonEmptyStringNo_(_resultArray[i][@"conclusion"]);
                [nameONe addObject:phone1];
                
            }
            
     
        }
      
        RADataObject *phone = [RADataObject dataObjectWithName:_resultArray[i][@"departMentName"] children:nameONe];
        
        [allData addObject:phone];
        
    }
    
    RADataObject *phoneZhongItem = [RADataObject dataObjectWithName:@"点击查看 " children:nil];
    RADataObject *zhong = [RADataObject dataObjectWithName:@"综述" children:@[phoneZhongItem]];
    [allData addObject:zhong];

    
    RADataObject *jianyiZhong = [RADataObject dataObjectWithName:@"点击查看" children:nil];
    RADataObject *jianyi = [RADataObject dataObjectWithName:@"建议" children:@[jianyiZhong]];
    [allData addObject:jianyi];

    
    _dataArray=[[NSMutableArray alloc]initWithArray:allData];

    RATreeView *treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0, 0, 320, kContentViewHeight+49)];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;

    [treeView reloadData];
    [self.view addSubview:treeView];
    

    [self CheckReportExists];
}

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 40;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 2 * treeNodeInfo.treeDepthLevel;
}

- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return YES;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    if ([item isEqual:self.expanded]) {
        return YES;
    }
    return NO;
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
    } else if (treeNodeInfo.treeDepthLevel == 1) {
        cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
    }
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

    MBLabel *cellText=(MBLabel*)[cell viewWithTag:3000];
    if (!cellText) {
        cellText =[[MBLabel alloc]initWithFrame:CGRectMake(50, 5, 200, 30)];
        cellText.font =kNormalTextFont;
        cellText.textColor = [UIColor blackColor];
        cellText.numberOfLines=0;
        cellText.backgroundColor=[UIColor clearColor];
        cellText.tag=3000;
        [cell addSubview:cellText];
    }
    cellText.text = ((RADataObject *)item).name;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *bgView =(UIImageView*)[cell viewWithTag:1000];
    if (!bgView) {
        bgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        bgView.tag=1000;
        bgView.backgroundColor=[UIColor clearColor];
        [cell addSubview:bgView];
    }
    MBLabel *bgText=(MBLabel*)[cell viewWithTag:2000];
    if (!bgText) {
        bgText =[[MBLabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        bgText.font =[UIFont fontWithName:@"Helvetica Neue" size:15];
        bgText.textColor = [UIColor whiteColor];
        bgText.numberOfLines=0;
        bgText.backgroundColor=[UIColor clearColor];
        bgText.tag=2000;
        [cell addSubview:bgText];
    }
    if (treeNodeInfo.treeDepthLevel == 0) {
        static NSInteger itemINter=-1;
        for (int i=0; i<_resultArray.count; i++) {
            if ([_resultArray[i][@"departMentName"] isEqualToString:cellText.text]) {
                itemINter=i;
                break;
            }
        }
        itemINter=treeNodeInfo.positionInSiblings;
        bgText.text = [NSString stringWithFormat:@"%d",treeNodeInfo.positionInSiblings+1];

        if (itemINter%5==0) {
            bgView.image=[UIImage imageNamed:@"one.png"];
        } if (itemINter%5==1) {
            bgView.image=[UIImage imageNamed:@"two.png"];
        } if (itemINter%5==2) {
            bgView.image=[UIImage imageNamed:@"three.png"];
        } if (itemINter%5==3) {
            bgView.image=[UIImage imageNamed:@"four.png"];
        } if (itemINter%5==4) {
            bgView.image=[UIImage imageNamed:@"five.png"];
        }
        
        cellText.frame=CGRectMake(40, cellText.frame.origin.y, 250, cellText.frame.size.height);
        cellText.font=[UIFont boldSystemFontOfSize:15];
        
    }else
    {
    
        cellText.frame=CGRectMake(cellText.frame.origin.x, cellText.frame.origin.y, 130, cellText.frame.size.height);
        
        MBLabel *cellTextAbout=(MBLabel*)[cell viewWithTag:4000];
        if (!cellTextAbout) {
            cellTextAbout =[[MBLabel alloc]initWithFrame:CGRectMake(170, 5, 140, 30)];
            cellTextAbout.font =kNormalTextFont;
            cellTextAbout.textColor = [UIColor blackColor];
            cellTextAbout.numberOfLines=0;
            cellTextAbout.backgroundColor=[UIColor clearColor];
            cellTextAbout.tag=4000;
            cellTextAbout.textAlignment=UITextAlignmentRight;
            [cell addSubview:cellTextAbout];
            
        }
        UIImageView *imageViewUpOrLos=(UIImageView *)[cell viewWithTag:5000];
        if (!imageViewUpOrLos) {
            imageViewUpOrLos  =[[UIImageView alloc]initWithFrame:CGRectMake(200, 15, 10, 10)];
            imageViewUpOrLos.tag=5000;
            imageViewUpOrLos.image=[UIImage imageNamed:@"low.png"];
            [cell addSubview:imageViewUpOrLos];
        }
        cellTextAbout.text = ((RADataObject *)item).name;
        bgText.frame=CGRectMake(50, 5, 120, 30);
        NSArray *hearNorArray =_healthAbnoramlsDic[@"abnoraml"];
        if ([hearNorArray isKindOfClass:[NSArray class]]) {
            
            for (int i=0; i<hearNorArray.count; i++) {
                if ([cellTextAbout.text isEqualToString:hearNorArray[i][@"abnoramlName"] ]) {
                    cellTextAbout.text=@"";
                    imageViewUpOrLos.hidden=YES;
                    cellText.frame=CGRectMake(cellText.frame.origin.x, cellText.frame.origin.y, 170, cellText.frame.size.height);
                    break;
                }
            }
        }else
        {
            imageViewUpOrLos.hidden=YES;

        }
       
        for (int i=0; i<_resultArray.count; i++) {
            for (int j=0; j<[_resultArray[i][@"items"][@"item"] count]; j++) {
                
                NSLog(@"%@",_resultArray[i][@"departMentName"]);
                RATreeNodeInfo*pare=treeNodeInfo.parent;
                NSLog(@"%@",((RADataObject*)(pare.item)).name);
                
                if ([_resultArray[i][@"items"][@"item"] isKindOfClass:[NSArray class]]) {
                    
                    if ([_resultArray[i][@"items"][@"item"][j][@"itemName"] isEqualToString:cellTextAbout.text]&&[((RADataObject*)(pare.item)).name isEqualToString:_resultArray[i][@"departMentName"] ]) {
                        NSDictionary *infoDic =_resultArray[i][@"items"][@"item"][j];
                        NSLog(@"%@",infoDic);
                        
                        cellTextAbout.text=[NSString stringWithFormat:@"%@ %@",MBNonEmptyStringNo_(infoDic[@"itemValue"]),MBNonEmptyStringNo_(infoDic[@"unit"])];
                        if ([MBNonEmptyStringNo_(infoDic[@"isNormal"]) integerValue]>0) {
                            NSLog(@"MBNonEmptyStringNo_(infoDic");
                            CGSize size =[cellTextAbout.text sizeWithFont:cellTextAbout.font constrainedToSize:CGSizeMake(cellTextAbout.frame.size.width, 1000000)];
                            imageViewUpOrLos.hidden=NO;
                            imageViewUpOrLos.frame=CGRectMake(320-size.width-30, imageViewUpOrLos.frame.origin.y, 10, 10);
                            if ([MBNonEmptyStringNo_(infoDic[@"isNormal"]) isEqualToString:@"1"]) {
                                imageViewUpOrLos.image=[UIImage imageNamed:@"upl.png"];
                                cellTextAbout.textColor=[UIColor redColor];
                            }else
                            {
                                imageViewUpOrLos.image=[UIImage imageNamed:@"low.png"];
                                cellTextAbout.textColor=[UIColor blueColor];


                            }
                        }else
                        {
                            imageViewUpOrLos.hidden=YES;
                            cellTextAbout.textColor=[UIColor blackColor];

                        }

                        if (MBNonEmptyStringNo_(((RADataObject *)item).nameForValue).length>0 ) {
                            cellTextAbout.text=MBNonEmptyStringNo_(((RADataObject *)item).nameForValue);
                        }
                        break;
                    }

                }
                if ([_resultArray[i][@"items"][@"item"] isKindOfClass:[NSDictionary class]]) {
                    if ([_resultArray[i][@"items"][@"item"][@"itemName"] isEqualToString:cellTextAbout.text]&&[((RADataObject*)(pare.item)).name isEqualToString:_resultArray[i][@"departMentName"] ]) {
                        NSDictionary *infoDic =_resultArray[i][@"items"][@"item"];
                        
                        cellTextAbout.text=[NSString stringWithFormat:@"%@ %@",MBNonEmptyStringNo_(infoDic[@"itemValue"]),MBNonEmptyStringNo_(infoDic[@"unit"])];
                        
                        if ([MBNonEmptyStringNo_(infoDic[@"isNormal"]) integerValue]>0) {
                            CGSize size =[cellTextAbout.text sizeWithFont:cellTextAbout.font constrainedToSize:CGSizeMake(cellTextAbout.frame.size.width, 1000000)];
                            imageViewUpOrLos.hidden=NO;
                            imageViewUpOrLos.frame=CGRectMake(320-size.width-30, imageViewUpOrLos.frame.origin.y, 10, 10);
                            if ([MBNonEmptyStringNo_(infoDic[@"isNormal"]) isEqualToString:@"1"]) {
                                imageViewUpOrLos.image=[UIImage imageNamed:@"upl.png"];
                                cellTextAbout.textColor=[UIColor redColor];
                            }else
                            {
                                imageViewUpOrLos.image=[UIImage imageNamed:@"low.png"];
                                cellTextAbout.textColor=[UIColor blueColor];
                                
                                
                            }
                            
                            
                        }else
                        {
                            imageViewUpOrLos.hidden=YES;
                            cellTextAbout.textColor=[UIColor blackColor];

                        }
                        if (MBNonEmptyStringNo_(((RADataObject *)item).nameForValue).length>0 ) {
                            cellTextAbout.text=MBNonEmptyStringNo_(((RADataObject *)item).nameForValue);
                        }
                        break;
                    }
                    
                }
            }
            
        }
        if ([cellText.text isEqualToString:cellTextAbout.text]) {
            cellTextAbout.text=@"";
            imageViewUpOrLos.hidden=YES;

        }
        if ([cellTextAbout.text isEqualToString:@""]) {
            cellTextAbout.text=MBNonEmptyStringNo_(((RADataObject *)item).nameForValue);

        }
        if ([cellText.text isEqualToString:@"身高"]||[cellText.text isEqualToString:@"体重"]) {
            imageViewUpOrLos.hidden=YES;
            cellTextAbout.textColor=kNormalTextColor;
        }
        
       
    }
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [_resultArray count]+3;
    }
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [_dataArray objectAtIndex:index];
    }
    return [data.children objectAtIndex:index];
}
-(BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return NO;
}
-(void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if ([((RADataObject *)item).name isEqualToString:@"点击查看 "]) {
        NSLog(@"11111111111");//综述
        TijianDetialViewController *detial=[[TijianDetialViewController alloc]init];
        detial.detailStr=_summarize;
        detial.title=@"综述详情";
        [self.navigationController pushViewController:detial animated:YES];
    }
    if ([((RADataObject *)item).name isEqualToString:@"点击查看"]) {
        
        TijianDetialViewController *detial=[[TijianDetialViewController alloc]init];
        detial.detailStr=_advice;
        detial.title=@"建议详情";
        [self.navigationController pushViewController:detial animated:YES];
        NSLog(@"22222222222");//建议

    }
    if ([((RADataObject *)item).name isEqualToString:@"本次体检异常"]) {
        
        [self CheckReportExists];
        
    }
}



-(void)CheckReportExists
{
    

    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(_reportID),@"ReportNO", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:ORGANIZATIONNAME,@"OrganName", nil]];
    
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"CheckReportExists"];
    
    NSLog(@"%@",soapMsg);
    
    __block TijianReportAllViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"CheckReportExists" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestSendLogWinXinXMLWithItems:@[item] success:^(id JSON) {
        
        
        [blockSelf GetNewHealthDataAndResultSuccessphone:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    
    
}
-(void)GetNewHealthDataAndResultSuccessphone:(NSString*)string
{
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:string];
    NSLog(@"%@",xmlDoc);
    NSString *array=MBNonEmptyStringNo_(xmlDoc[@"soap:Body"][@"CheckReportExistsResponse"][@"CheckReportExistsResult"]);
    if (![array isEqualToString:@""]) {
        if ([array isEqualToString:@"2"]) {
            MBAlertView *show=[[MBAlertView alloc]initWithTitle:nil message:@"是否要备份这份体检报告" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [show show];
            
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self AddOrganReport];
    }
}
-(void)AddOrganReport
{
    
    
    
    NSMutableArray *arr=[NSMutableArray array];
    
    
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    NSString *report = [NSString stringWithFormat:@"<ORGAN_NAME>%@</ORGAN_NAME><CLIENT_NO>%@</CLIENT_NO><CLIENT_NAME>%@</CLIENT_NAME><MOBILE>%@</MOBILE><SEX>%@</SEX><REPORT_NO>%@</REPORT_NO><REPORT_TIME>%@</REPORT_TIME><REPORT_SUMMARY>%@</REPORT_SUMMARY><REPORT_ADVICE>%@</REPORT_ADVICE><DATA_SOURCE>%@</DATA_SOURCE>",ORGANIZATIONNAME,[allUserDic allValues][0][@"UserName"],[allUserDic allValues][0][@"Name"],[allUserDic allValues][0][@"MobileNO"],[allUserDic allValues][0][@"Sex"],_reportID,[[NSDate date]dateString],_summarize,_advice,@""]
    ;
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:report,@"report", nil]];
    
    NSString *AbnormalList;
    NSArray *hearNorArray =_healthAbnoramlsDic[@"abnoraml"];
    for (int i=0; i<hearNorArray.count; i++) {
        NSDictionary *dicInfo = hearNorArray[i];
        if (!AbnormalList) {
            AbnormalList = [NSString stringWithFormat:@"<ReportAbnormal><ABNORMAL_NO>%@</ABNORMAL_NO><ABNORMAL_NAME>%@</ABNORMAL_NAME></ReportAbnormal>",MBNonEmptyStringNo_(dicInfo[@"abnoramlNo"]),MBNonEmptyStringNo_(dicInfo[@"abnoramlName"])];
        }else
        {
            AbnormalList =[NSString stringWithFormat:@"%@<ReportAbnormal><ABNORMAL_NO>%@</ABNORMAL_NO><ABNORMAL_NAME>%@</ABNORMAL_NAME></ReportAbnormal>",AbnormalList,MBNonEmptyStringNo_(dicInfo[@"abnoramlNo"]),MBNonEmptyStringNo_(dicInfo[@"abnoramlName"])];
        }
    }
    
    NSLog(@"%@",AbnormalList);
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:AbnormalList,@"AbnormalList", nil]];

    NSString *ConclustionList;
    NSArray *ConclustionListArray =_allDataInfo[@"data"][@"departments"][@"department"];
    
    for (int i=0; i<ConclustionListArray.count; i++) {
        NSDictionary *dicInfo = ConclustionListArray[i];
        if (!ConclustionList) {
            ConclustionList = [NSString stringWithFormat:@"<ReportConclustion><DEPARMENT_NAME>%@</DEPARMENT_NAME><CONTENTS>%@</CONTENTS><CHECK_USER>%@</CHECK_USER><CHECK_DATE>%@</CHECK_DATE></ReportConclustion>",MBNonEmptyStringNo_(dicInfo[@"departMentName"]),MBNonEmptyStringNo_(dicInfo[@"conclusion"]),MBNonEmptyStringNo_([allUserDic allValues][0][@"UserName"]),[[NSDate date]dateString]];
            
        }else
        {
             ConclustionList = [NSString stringWithFormat:@"%@<ReportConclustion><DEPARMENT_NAME>%@</DEPARMENT_NAME><CONTENTS>%@</CONTENTS><CHECK_USER>%@</CHECK_USER><CHECK_DATE>%@</CHECK_DATE></ReportConclustion>",ConclustionList,MBNonEmptyStringNo_(dicInfo[@"departMentName"]),MBNonEmptyStringNo_(dicInfo[@"conclusion"]),MBNonEmptyStringNo_([allUserDic allValues][0][@"UserName"]),[[NSDate date]dateString]];
        }
    }
    
    NSLog(@"%@",ConclustionList);
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:ConclustionList,@"ConclustionList", nil]];

    NSString *ItemList;
    NSArray *ItemListListArray =_allDataInfo[@"data"][@"departments"][@"department"];
    
    for (int i=0; i<ItemListListArray.count; i++) {
        NSDictionary *dicInfo = ItemListListArray[i];
        NSArray *arrayOf = dicInfo[@"items"][@"item"];
        for (int i=0; i<arrayOf.count; i++) {
            NSDictionary *dicInfoAbout = arrayOf[i];
            if (!ItemList) {
                
                ItemList = [NSString stringWithFormat:@"<ReportItem><DEPARMENT_NAME>%@</DEPARMENT_NAME><ITEM_NAME>%@</ITEM_NAME><ITEM_VALUE>%@</ITEM_VALUE><ITEM_UNIT>%@</ITEM_UNIT><ITEM_SIGN>%@</ITEM_SIGN><ITEM_REFERENCE>%@</ITEM_REFERENCE></ReportItem>",MBNonEmptyStringNo_(dicInfo[@"departMentName"]),MBNonEmptyStringNo_(dicInfoAbout[@"itemName"]),MBNonEmptyStringNo_(dicInfoAbout[@"itemValue"]),MBNonEmptyStringNo_(dicInfoAbout[@"unit"]),MBNonEmptyStringNo_(dicInfoAbout[@"sign"]),MBNonEmptyStringNo_(dicInfoAbout[@"reference"])];
                
            }else
            {
                ItemList = [NSString stringWithFormat:@"%@<ReportItem><DEPARMENT_NAME>%@</DEPARMENT_NAME><ITEM_NAME>%@</ITEM_NAME><ITEM_VALUE>%@</ITEM_VALUE><ITEM_UNIT>%@</ITEM_UNIT><ITEM_SIGN>%@</ITEM_SIGN><ITEM_REFERENCE>%@</ITEM_REFERENCE></ReportItem>",ItemList,MBNonEmptyStringNo_(dicInfo[@"departMentName"]),MBNonEmptyStringNo_(dicInfoAbout[@"itemName"]),MBNonEmptyStringNo_(dicInfoAbout[@"itemValue"]),MBNonEmptyStringNo_(dicInfoAbout[@"unit"]),MBNonEmptyStringNo_(dicInfoAbout[@"sign"]),MBNonEmptyStringNo_(dicInfoAbout[@"reference"])];

            }
        }
       
    }
    
    NSLog(@"%@",ItemList);
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:ItemList,@"ItemList", nil]];
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"AddOrganReport"];
    
    NSLog(@"%@",soapMsg);
    
    __block TijianReportAllViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"AddOrganReport" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestSendLogWinXinXMLWithItems:@[item] success:^(id JSON) {
        
        
        [blockSelf AddOrganReportGetNewHealthDataAndResultSuccessphone:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    
    
}
-(void)AddOrganReportGetNewHealthDataAndResultSuccessphone:(NSString*)string
{
}
@end
