//
//  TijianDetialViewController.m
//  Demo
//
//  Created by wang on 14-5-26.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "TijianDetialViewController.h"

@interface TijianDetialViewController ()

@end

@implementation TijianDetialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITextView *webView=[[UITextView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:webView];
    webView.text=_detailStr;
    webView.font=kNormalTextFont;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
