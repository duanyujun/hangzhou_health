//
//  ChartTableViewCell.h
//  Demo
//
//  Created by llbt_wgh on 14-4-7.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBLabel.h"
@interface AdminChartTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UIImageView *messAgeImageVIew;
@property(nonatomic,strong)MBLabel *messageLbl;
@property(nonatomic,strong)UILabel *timeLbl;


@end
