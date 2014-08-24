//
//  TiJianReprotCell.h
//  Demo
//
//  Created by llbt_wgh on 14-3-23.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TiJianReprotCell : UITableViewCell
{
//    UIButton *_moreLoad;
    UIButton *_yuyueBtn;
    UIButton*_yuyueBtnAbout;
}
@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)UILabel *itemLbl;
@property(nonatomic,strong)UILabel *itemCountLbl;
@property(nonatomic,assign)id delegateAbout;
@property(nonatomic,strong)UIButton *yuyueBtn;
@property(nonatomic,strong)UILabel *rightLabl;
@property(nonatomic,strong)UIButton *moreLoad;


-(void)showLoadMoreVIew;
-(void)hiddleLoadMoreView;
@end

@protocol TijianReproTcellDelegate <NSObject>
@optional
-(void)loadMoreAboutdata;
-(void)yuyueBtnPressed:(UIButton*)btn;

@end