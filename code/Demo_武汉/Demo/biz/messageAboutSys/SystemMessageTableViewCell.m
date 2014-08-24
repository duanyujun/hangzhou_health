//
//  SystemMessageTableViewCell.m
//  Demo
//
//  Created by llbt_wgh on 14-5-11.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "SystemMessageTableViewCell.h"

@implementation SystemMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _nameLabl=[[MBLabel alloc]initWithFrame:CGRectMake(15, 0, 90, 40)];
        
//        _nameLabl.textColor=HEX(@"#ffffff");
        _nameLabl.font=kNormalTextFont;
        _nameLabl.backgroundColor=[UIColor clearColor];
        _nameLabl.textAlignment=NSTextAlignmentLeft;
        [self addSubview:_nameLabl];
        
        
        _timeLabl=[[MBLabel alloc]initWithFrame:CGRectMake(90, 0,200, 40)];
        
//        _timeLabl.textColor=HEX(@"#ffffff");
        _timeLabl.font=kNormalTextFont;
        _timeLabl.backgroundColor=[UIColor clearColor];
        _timeLabl.textAlignment=NSTextAlignmentRight;
        [self addSubview:_timeLabl];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, 320, 1)];
        imageView.backgroundColor=[UIColor grayColor];
        [self addSubview:imageView];
        
        _meaageImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 50, 60, 60)];
        _meaageImageView.image=[UIImage imageNamed:@"manager_app_icon.png"];
        [self addSubview:_meaageImageView];
        
        _messageNameLabl=[[MBLabel alloc]initWithFrame:CGRectMake(80, 45,200, 40)];
        
//        _messageNameLabl.textColor=HEX(@"#ffffff");
        _messageNameLabl.font=kNormalTextFont;
        _messageNameLabl.backgroundColor=[UIColor clearColor];
        _messageNameLabl.textAlignment=NSTextAlignmentLeft;
        [self addSubview:_messageNameLabl];
        
        _messageContLabl=[[MBLabel alloc]initWithFrame:CGRectMake(80, 80,200, 40)];
        
//        _messageContLabl.textColor=HEX(@"#ffffff");
        _messageContLabl.font=kNormalTextFont;
        _messageContLabl.backgroundColor=[UIColor clearColor];
        _messageContLabl.textAlignment=NSTextAlignmentLeft;
        [self addSubview:_messageContLabl];
        
    }
    return self;
}
-(void)setLablVaule:(NSDictionary*)dic
{
    _timeLabl.text=MBNonEmptyStringNo_(dic[@"pushTime"]);
    _messageContLabl.text=MBNonEmptyStringNo_(dic[@"pushContent"]);
    _messageNameLabl.text=MBNonEmptyStringNo_(dic[@"customerName"]);
    _nameLabl.text=MBNonEmptyStringNo_(dic[@"userName"]);

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
