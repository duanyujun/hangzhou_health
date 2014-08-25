//
//  ChartTableViewCell.m
//  Demo
//
//  Created by llbt_wgh on 14-4-7.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "ChartTableViewCell.h"
//管理员
@implementation ChartTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 40, 40)];
        _messAgeImageVIew=[[UIImageView alloc]initWithFrame:CGRectMake(50, 0, 200, 40)];
        _messageLbl=[[MBLabel alloc]initWithFrame:CGRectMake(65, 0, 190, 40)];
        _timeLbl=[[UILabel alloc]initWithFrame:CGRectMake(120, 45, 200, 30)];
        
        _messAgeImageVIew.image=[[UIImage imageNamed:@"bubble-flat-incoming-selected.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:14];
        _timeLbl.font=kNormalTextFont;
        _timeLbl.textAlignment=NSTextAlignmentRight;
        
    
        
        _messageLbl.font=kNormalTextFont;
        _messageLbl.textAlignment=NSTextAlignmentLeft;
        
        
     
        
   
        
        _headImageView.backgroundColor=[UIColor clearColor];
        _messAgeImageVIew.backgroundColor=[UIColor clearColor];
        _messageLbl.backgroundColor=[UIColor clearColor];
        _timeLbl.backgroundColor=[UIColor clearColor];

        
        [self addSubview:_headImageView];
        [self addSubview:_messAgeImageVIew];
        [self addSubview:_messageLbl];
        [self addSubview:_timeLbl];

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
