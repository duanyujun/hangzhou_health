//
//  HomeViewController.h
//  Demo
//
//  Created by llbt_wgh on 14-3-20.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TijianReportAllViewController : UIViewController
@property(nonatomic,strong)NSMutableArray *resultArray;
@property(nonatomic,strong)NSDictionary *healthAbnoramlsDic;
@property(nonatomic,strong)NSArray *itemArray;
@property (strong, nonatomic) id expanded;
@property(nonatomic,copy)NSString *summarize;//综述
@property(nonatomic,copy)NSString *advice;//建议


@end
