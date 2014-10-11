//
//  MBTabBarController.h
//  BOCMBCI
//
//  Created by Tracy E on 13-3-25.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBLabel.h"
@class HomeViewController;

@interface MBTabBarController : UITabBarController

{
    UINavigationController *_mobileBankNavigationController;//
    UINavigationController *_fidgetNavigationController;//
    UINavigationController *_newsNavigationController;//
    UINavigationController *_informationNavigationController;
    UINavigationController *_aboutRootViewController;
}
@property (nonatomic, strong) HomeViewController *homeViewControllerOne;//饮食控制器
@property (nonatomic, strong) HomeViewController *homeViewControllerTwo;//运动控制器
@property (nonatomic, strong) HomeViewController *homeViewControllerThree;//资讯控制器
@property (nonatomic, strong) HomeViewController *homeViewControllerFour;//更多控制器


//@property (nonatomic, strong)UINavigationController *mobileBankNavigationController;
//@property (nonatomic, strong)UINavigationController *fidgetNavigationController;
//@property (nonatomic, strong)UINavigationController *newsNavigationController;
//@property (nonatomic, strong)UINavigationController *informationNavigationController;

@end

//TabBar上的快捷菜单Item
@interface MBShortcutButton : UIImageView
@property (nonatomic, strong) MBLabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) NSString *url;
+ (id)itemWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url;
@end
