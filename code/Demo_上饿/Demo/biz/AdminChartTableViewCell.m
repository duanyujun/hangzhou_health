//
//  ChartTableViewCell.m
//  Demo
//
//  Created by llbt_wgh on 14-4-7.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "AdminChartTableViewCell.h"

@implementation AdminChartTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        _headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(270, 10, 40, 40)];
        _messAgeImageVIew=[[UIImageView alloc]initWithFrame:CGRectMake(50, 0, 200, 40)];
        
        _messageLbl=[[MBLabel alloc]initWithFrame:CGRectMake(55, 0, 180, 40)];
        _timeLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 45, 200, 30)];
        
        
        _messAgeImageVIew.image=[[UIImage imageNamed:@"bubble-flat-outgoing-selected.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:14];
        _timeLbl.font=kNormalTextFont;
        _timeLbl.textAlignment=NSTextAlignmentLeft;
        
    
        
        
        _messageLbl.textColor=HEX(@"#ffffff");
        _messageLbl.font=kNormalTextFont;
        _messageLbl.textAlignment=NSTextAlignmentRight;
        
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
