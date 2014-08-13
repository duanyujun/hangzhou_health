//  Demo
//
//  Created by llbt_wgh on 14-5-11.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBLabel.h"
@interface SystemMessageTableViewCell : UITableViewCell
{
    MBLabel *_nameLabl;
    MBLabel *_timeLabl;
    MBLabel *_messageNameLabl;
    MBLabel *_messageContLabl;
    UIImageView *_meaageImageView;
}
-(void)setLablVaule:(NSDictionary*)dic;
@end
