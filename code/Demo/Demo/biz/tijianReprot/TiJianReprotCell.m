//
//  TiJianReprotCell.m
//  Demo
//
//  Created by llbt_wgh on 14-3-23.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "TiJianReprotCell.h"

@implementation TiJianReprotCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _bgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        [self addSubview:_bgView];
        
        _itemLbl =[[UILabel alloc]initWithFrame:CGRectMake(40, 10, 290, 30)];
        _itemLbl.font =[UIFont fontWithName:@"Helvetica Neue" size:14];
        _itemLbl.backgroundColor=[UIColor clearColor];
        [self addSubview:_itemLbl];
        
        
        _itemCountLbl =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _itemCountLbl.font =[UIFont fontWithName:@"Helvetica Neue" size:14];
        _itemCountLbl.textColor = [UIColor whiteColor];
        _itemCountLbl.numberOfLines=0;
        _itemCountLbl.backgroundColor=[UIColor clearColor];

        [self addSubview:_itemCountLbl];
        
        
        _rightLabl =[[UILabel alloc]initWithFrame:CGRectMake(170, 10, 100, 30)];
        _rightLabl.font =[UIFont fontWithName:@"Helvetica Neue" size:14];
        _rightLabl.textColor = kRedTextColor;
        _rightLabl.numberOfLines=0;
        _rightLabl.backgroundColor=[UIColor clearColor];

        [self addSubview:_rightLabl];
        
        _moreLoad =[UIButton buttonWithType:UIButtonTypeCustom];
        _moreLoad.frame=CGRectMake(0, 0, 320, self.frame.size.height);
        _moreLoad.titleLabel.textColor=kNormalTextColor;
        [_moreLoad addTarget:self action:@selector(btnPresedn) forControlEvents:UIControlEventTouchUpInside];
        _moreLoad.hidden=YES;
        [_moreLoad setTitle:@"更多" forState:UIControlStateNormal];
        [self addSubview:_moreLoad];
        
        _yuyueBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _yuyueBtn.frame=CGRectMake(270, 0, self.frame.size.height+10, self.frame.size.height);
        [_yuyueBtn setBackgroundImage:[UIImage imageNamed:@"gouy_no.png"] forState:UIControlStateNormal];
        _yuyueBtn.titleLabel.textColor=kNormalTextColor;
        [_yuyueBtn addTarget:self action:@selector(btnPresednBtn) forControlEvents:UIControlEventTouchUpInside];
        _yuyueBtn.hidden=YES;
        [self addSubview:_yuyueBtn];
        
        _yuyueBtnAbout =[UIButton buttonWithType:UIButtonTypeCustom];
        _yuyueBtnAbout.frame=CGRectMake(250, 0, self.frame.size.height+10+50, self.frame.size.height);
        [_yuyueBtnAbout setBackgroundImage:[UIImage imageNamed:@"gouy_no.png"] forState:UIControlStateNormal];
        _yuyueBtnAbout.titleLabel.textColor=kNormalTextColor;
        [_yuyueBtnAbout addTarget:self action:@selector(btnPresednBtn) forControlEvents:UIControlEventTouchUpInside];
        _yuyueBtnAbout.hidden=YES;
        [self addSubview:_yuyueBtnAbout];
        
    }
    return self;
}
//预约
-(void)btnPresednBtn
{
    if (_delegateAbout&&[_delegateAbout respondsToSelector:@selector(yuyueBtnPressed:)]) {
        [_delegateAbout yuyueBtnPressed:_yuyueBtn];
    }
}
-(void)showLoadMoreVIew
{
    _moreLoad.hidden=NO;
    _itemCountLbl.hidden=YES;
    _itemLbl.hidden=YES;
    _bgView.hidden=YES;
    _rightLabl.hidden=YES;
}
-(void)hiddleLoadMoreView
{
    _moreLoad.hidden=YES;
    _itemCountLbl.hidden=NO;
    _itemLbl.hidden=NO;
    _bgView.hidden=NO;
    _rightLabl.hidden=NO;

}

-(void)btnPresedn
{
    if (_delegateAbout&&[_delegateAbout respondsToSelector:@selector(loadMoreAboutdata)]) {
        [_delegateAbout loadMoreAboutdata];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
