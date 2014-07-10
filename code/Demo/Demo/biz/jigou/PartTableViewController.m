//
//  ShengTableViewController.m
//  Demo
//
//  Created by wang on 14-5-17.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "PartTableViewController.h"
#import "SoapHelper.h"
#import "XMLDictionary.h"
#import "MBIIRequest.h"
#import "DBHelper.h"
#import "MBNotLogViewController.h"
#import "YuyueViewController.h"
#import "ShengTableViewController.h"
@interface PartTableViewController ()

@end

@implementation PartTableViewController

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
    
    //省份选择
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"省份" style:UIBarButtonItemStylePlain target:self action:@selector(uploadData)];
    
    if (!IOS7_OR_LATER) {
        [self.navigationItem.rightBarButtonItem setTintColor:HEX(@"#5ec4fe")];
        
    }


    UILabel *labl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    labl.text=@" 请选择机构";
    labl.textColor=HEX(@"#8e8e93");

    labl.backgroundColor=HEX(@"#f0f0f6");
    self.tableView.tableHeaderView=labl;
    
}

//请求服务器数据
-(void)uploadData
{
    NSLog(@"%@",self.navigationController.viewControllers);
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
    cell.textLabel.text=MBNonEmptyStringNo_(_dataArray[indexPath.row][@"organName"]);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicOb=_dataArray[indexPath.row];
    if ([MBNonEmptyStringNo_(dicOb[@"webAddress"])isEqualToString:@"1"]||[MBNonEmptyStringNo_(dicOb[@"webAddress"])isEqualToString:@""]) {
        MBAlert(@"请确认您选择的机构是否开通此项服务!");
        return;
    }
    NSLog(@"%@",dicOb);
    [[NSNotificationCenter defaultCenter]postNotificationName:MBGETJIGOUINFO object:dicOb];
    NSArray *array =self.navigationController.viewControllers;
    MBNotLogViewController *login=nil;
    for (int i=0; i<array.count; i++) {
        if ([array[i] isKindOfClass:[MBNotLogViewController class]]) {
            login=array[i];
            break;
        }
    }


    if (_isFromKuai) {

        if (array.count>=2&&[array[1] isKindOfClass:[YuyueViewController class]]) {
                [self.navigationController popToViewController:array[1] animated:YES];
        }else{
            [self.navigationController popToViewController:array[0] animated:YES];
        }
        NSLog(@"%@",array);
    }else
    {
        [self.navigationController popToViewController:login animated:YES];


    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MBGETJIGOUINFO object:nil];
}
@end
