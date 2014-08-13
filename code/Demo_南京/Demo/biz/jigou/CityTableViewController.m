//
//  ShengTableViewController.m
//  Demo
//
//  Created by wang on 14-5-17.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "CityTableViewController.h"
#import "SoapHelper.h"
#import "XMLDictionary.h"
#import "MBIIRequest.h"
#import "DBHelper.h"
#import "PartTableViewController.h"
#import "ShengTableViewController.h"
@interface CityTableViewController ()

@end

@implementation CityTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"省份" style:UIBarButtonItemStylePlain target:self action:@selector(uploadData)];
    if (!IOS7_OR_LATER) {
        [self.navigationItem.rightBarButtonItem setTintColor:HEX(@"#5ec4fe")];
        
    }
    UILabel *labl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    labl.text=@" 请选择城市";
    labl.textColor=HEX(@"#8e8e93");

    labl.backgroundColor=HEX(@"#f0f0f6");
    self.tableView.tableHeaderView=labl;
    
    

}

-(void)uploadData
{
    ShengTableViewController *tabl=nil;
    NSArray *array =self.navigationController.viewControllers;
    for (int i=0; i<array.count; i++) {
        if ([array[i] isKindOfClass:[ShengTableViewController class]]) {
            tabl=array[i];
            break;
        }
    }
    if (tabl!=nil) {
        [self.navigationController popToViewController:tabl animated:YES];
        
    }
}
//请求服务器数据
- (void)getData:(NSString*)cityName
{
    // Dispose of any resources that can be recreated.
    NSMutableArray *arr=[NSMutableArray array];

    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(cityName),@"city", nil]];

    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"getAreaInfoList"];
    
    __block CityTableViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"getAreaInfoList" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItemsAboutHost:@[item] success:^(id JSON) {
        
        [blockSelf GetNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];

        
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    

}
//请求服务器数据 返回的结果
-(void)GetNewHealthDataAndResultSuccess:(NSString*)str
{
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:str];
    NSLog(@"%@",xmlDoc);
    NSArray *array=xmlDoc[@"soap:Body"][@"getAreaInfoListResponse"][@"getAreaInfoListResult"][@"data"][@"Area"];
    if ([array isKindOfClass:[NSArray class]]) {
        NSMutableArray *dicObArray =[NSMutableArray arrayWithArray:array];
        NSLog(@"%@",dicObArray);
        PartTableViewController*city=[[PartTableViewController alloc]init];
        city.isFromKuai=_isFromKuai;
        city.dataArray=dicObArray;
        [self.navigationController pushViewController:city animated:YES];
        
    }else
    {
        MBAlert(@"该城市暂无开通机构");
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr =@"cellabout";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    // Configure the cell...
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.textLabel.font=kNormalTextFont;
    cell.textLabel.text=MBNonEmptyStringNo_(_dataArray[indexPath.row][@"regName"]);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicOb=_dataArray[indexPath.row];
    [self getData:MBNonEmptyStringNo_(dicOb[@"regName"])];
}

@end
