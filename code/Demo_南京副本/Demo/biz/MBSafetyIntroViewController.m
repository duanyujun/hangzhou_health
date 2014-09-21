

#import "MBSafetyIntroViewController.h"

@implementation MBSafetyIntroViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.infoDict = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton=YES;
    self.title = @"体检报告详情";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(closeSelf)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self createWebView];
}

- (void)createWebView
{
    //背景图
    //    UIImageView *infoBackGroundImageView = [[UIImageView alloc]
    //                                            initWithFrame:CGRectMake(10, 10, kScreenWidth-10-10,self.view.height-20 - 50)];
    //    infoBackGroundImageView.backgroundColor = [UIColor whiteColor];
    //    infoBackGroundImageView.image = MBImageNamed(@"whitebg.png");
    //    [infoBackGroundImageView addStanderdShadow];
    //    [self.view addSubview:infoBackGroundImageView];
    
    //_webView = [[UIWebView alloc] initWithFrame:(CGRect){infoBackGroundImageView.x + 10,infoBackGroundImageView.y + 10,infoBackGroundImageView.width - 20,infoBackGroundImageView.height -20,}];
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [_webView setBackgroundColor:[UIColor clearColor]];
    [_webView setDelegate:self];
    [_webView setScalesPageToFit:YES];
    CGAffineTransformMakeScale(100, 100);
    [self.view addSubview:_webView];
    
    //self.urlStr = @"http://22.188.20.119:9083/BocnetClient/";//临时测试
    NSLog(@"_urlStr ---%@",_urlStr);
    NSString* encodedString = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
}

//webViewdelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    UILabel *introLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    introLabel.center = self.view.center;
    introLabel.numberOfLines = 0;
    introLabel.textAlignment = NSTextAlignmentCenter;
    introLabel.font = kNormalTextFont;
    introLabel.text = @"正在努力加载...";
    introLabel.tag = 400;
    introLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:introLabel];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    UILabel *label = (UILabel *)[self.view viewWithTag:400];
    [label removeFromSuperview];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UILabel *label = (UILabel *)[self.view viewWithTag:400];
    [label setText:@"加载失败请重试"];
    
    //    [label removeFromSuperview];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)closeSelf{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end