//
//  YuYueDtailTableViewCell.h
//  Demo
//
//  Created by IBM on 14-7-12.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBLabel.h"
@interface YuYueDtailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet MBLabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property(strong,nonatomic) NSDictionary *infoDic;
@property(assign,nonatomic)id delegateAbout;
@property(assign,nonatomic)BOOL isSelectAbout;
@property(copy,nonatomic)NSString* TJ_Code;
@property (weak, nonatomic) IBOutlet UIImageView *showMoreITem;

- (IBAction)showMoreDetail:(id)sender;


- (IBAction)seleBtnPressed:(id)sender;
@end

@protocol YuYueDtailTableViewCellDelegate <NSObject>

-(void)seleThisCell:(YuYueDtailTableViewCell*)cell;
-(void)showMoreDetail:(YuYueDtailTableViewCell*)cell;

@end