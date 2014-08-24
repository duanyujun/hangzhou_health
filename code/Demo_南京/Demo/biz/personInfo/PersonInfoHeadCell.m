//
//  PersonInfoHeadCell.m
//  Demo
//
//  Created by llbt_wgh on 14-3-24.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "PersonInfoHeadCell.h"

@implementation PersonInfoHeadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _leftLbl =[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 40, 50)];
        _leftLbl.textColor=kNormalTextColor;
        _leftLbl.font=kNormalTextFont;
        [self addSubview:_leftLbl];
        
        _rightView=[[UIImageView alloc]initWithFrame:CGRectMake(220, 10, 60, 60)];
        [self addSubview:_rightView];
        
        
        UIImageView *mg_liebia=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_liebiao_arrow.png"]];
        mg_liebia.frame = CGRectMake(290, 34, 12, 12);
        [self addSubview:mg_liebia];

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
