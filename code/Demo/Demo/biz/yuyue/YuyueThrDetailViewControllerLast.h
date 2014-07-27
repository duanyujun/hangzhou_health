//  Demo
//
//  Created by llbt_wgh on 14-3-29.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YuyueThrDetailViewControllerLast : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,copy)NSString *priceStr;
@property(nonatomic,copy)NSString *nameStr;
@property(nonatomic,strong)NSDictionary *sendDataInfo;
@property(nonatomic,strong)UITableView *tableView;


@end
