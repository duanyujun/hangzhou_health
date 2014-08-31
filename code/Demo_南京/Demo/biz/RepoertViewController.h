//
//  RepoertViewController.h
//  Demo
//
//  Created by wang on 14-8-28.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBTextField.h"
@interface RepoertViewController : UIViewController<UITextFieldDelegate>
{
    MBTextField *_bianhaoTF;
    UIView *BgView;
    NSString *_usrlStr;
}
@end
