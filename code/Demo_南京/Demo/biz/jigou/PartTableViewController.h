//
//  ShengTableViewController.h
//  Demo
//
//  Created by wang on 14-5-17.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartTableViewController : UITableViewController
@property(nonatomic,strong)NSArray*dataArray;//存储数据字典
@property(nonatomic,assign)BOOL isFromKuai;//是否是从快捷方式进入的
@end
