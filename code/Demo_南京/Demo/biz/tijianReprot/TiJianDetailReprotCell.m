//
//  TiJianReprotCell.m
//  Demo
//
//  Created by llbt_wgh on 14-3-23.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "TiJianDetailReprotCell.h"
@implementation TiJianDetailReprotCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        
        _itemLbl =[[MBLabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
        _itemLbl.font =[UIFont fontWithName:@"Helvetica Neue" size:15];
        _itemLbl.textAlignment=NSTextAlignmentLeft;
        _itemLbl.numberOfLines=0;

        [self addSubview:_itemLbl];
        
        
        _itemCountLbl =[[MBLabel alloc]initWithFrame:CGRectMake(100, 0, 210, 40)];
        _itemCountLbl.font =[UIFont fontWithName:@"Helvetica Neue" size:15];
        _itemCountLbl.textAlignment=NSTextAlignmentRight;
        _itemCountLbl.numberOfLines=0;
        _itemCountLbl.backgroundColor=[UIColor clearColor];
        [self addSubview:_itemCountLbl];
        
        
    }
    return self;
}

@end
