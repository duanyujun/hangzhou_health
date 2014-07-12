//
//  YuYueDtailTableViewCell.m
//  Demo
//
//  Created by IBM on 14-7-12.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "YuYueDtailTableViewCell.h"

@implementation YuYueDtailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)seleBtnPressed:(id)sender {
    if (_delegateAbout&&[_delegateAbout respondsToSelector:@selector(seleThisCell:)]) {
        [_delegateAbout seleThisCell:self];
    }
}
@end
