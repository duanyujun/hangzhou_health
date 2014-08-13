//
//  PersonInfoOtherCell.m
//  Demo
//
//  Created by llbt_wgh on 14-3-24.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "PersonInfoOtherCell.h"

@implementation PersonInfoOtherCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _leftLbl =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 30)];
        _leftLbl.textColor=kNormalTextColor;
        _leftLbl.font=kNormalTextFont;
        [self addSubview:_leftLbl];
        
        
        _rightLbl =[[UILabel alloc]initWithFrame:CGRectMake(80, 5, 200, 30)];
        _rightLbl.textColor=kNormalTextColor;
        _rightLbl.font=kNormalTextFont;
        _rightLbl.textAlignment=NSTextAlignmentRight;
        [self addSubview:_rightLbl];
        
        
        UIImageView *mg_liebia=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_liebiao_arrow.png"]];
        mg_liebia.frame = CGRectMake(290, 14, 12, 12);
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
