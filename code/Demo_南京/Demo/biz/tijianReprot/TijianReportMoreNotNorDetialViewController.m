//
//  TijianReportMoreDetialViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-23.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "TijianReportMoreNotNorDetialViewController.h"

@interface TijianReportMoreNotNorDetialViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation TijianReportMoreNotNorDetialViewController

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
	// Do any additional setup after loading the view.
    self.title=@"体检报告";
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    UITableView*tableVewi =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, kContentViewHeight+49) style:UITableViewStylePlain];
    tableVewi.delegate=self;
    tableVewi.dataSource=self;
    [self.view addSubview:tableVewi];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr =@"table view";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.textLabel.numberOfLines=0;
    cell.textLabel.font=kNormalTextFont;
    if (indexPath.row==0) {
        cell.textLabel.text = MBNonEmptyStringNo_(_resultDic[@"abnoramlName"]);
    }
    if (indexPath.row==1) {
        cell.textLabel.text = MBNonEmptyStringNo_(_resultDic[@"abnoramlNo"]);

    } if (indexPath.row==2) {
        cell.textLabel.text = MBNonEmptyStringNo_(_resultDic[@"advises"]);

    } if (indexPath.row==3) {
        cell.textLabel.text = MBNonEmptyStringNo_(_resultDic[@"commonCauses"]);

    }
    if (indexPath.row==4) {
        cell.textLabel.text = MBNonEmptyStringNo_(_resultDic[@"medicineExplains"]);
        
    }
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        
        return 40;
    } if (indexPath.row==1) {
        return 40;
    }
    if (indexPath.row==2) {
        
        CGSize size = [MBNonEmptyStringNo_(_resultDic[@"advises"]) sizeWithFont:kNormalTextFont constrainedToSize:CGSizeMake(320, 100000) lineBreakMode:NSLineBreakByCharWrapping];
        return size.height+40;
    }
    if (indexPath.row==3) {
        CGSize size = [MBNonEmptyStringNo_(_resultDic[@"commonCauses"]) sizeWithFont:kNormalTextFont constrainedToSize:CGSizeMake(320, 100000) lineBreakMode:NSLineBreakByCharWrapping];
        return size.height+40;
    }
    if (indexPath.row==4) {
        CGSize size = [MBNonEmptyStringNo_(_resultDic[@"medicineExplains"]) sizeWithFont:kNormalTextFont constrainedToSize:CGSizeMake(320, 100000) lineBreakMode:NSLineBreakByCharWrapping];
        return size.height+40;
    }
    return 0;

}
@end
