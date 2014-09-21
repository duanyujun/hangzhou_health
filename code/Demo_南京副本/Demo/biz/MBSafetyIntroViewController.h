//
//  MBSafetyIntroViewController.h
//  BOCMBCI
//
//  Created by llbt on 13-11-20.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBSafetyIntroViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView   *_webView;
}
@property (nonatomic,strong) NSDictionary   *infoDict;
@property (nonatomic,strong) NSString       *urlStr;

@end