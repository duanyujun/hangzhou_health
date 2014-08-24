//
//  NewsViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-31.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "NewsAllViewController.h"
#import "SoapHelper.h"
#import "MBIIRequest.h"
#import "XMLDictionary.h"
#import "TiJianReprotCell.h"
#import "ShocCanDetailViewController.h"
#import "AppDelegate.h"
#import "NewsItemViewController.h"
@interface NewsAllViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _startIndex;
    NSMutableArray *_dataArray;
    UITableView *_tableView ;
    BOOL _isShowMore;//yes ==加载更多
    
}
@end

@implementation NewsAllViewController

//返回到上个页面
-(void)backViewUPloadView
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        UIBarButtonItem *leftBarItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backView.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backViewUPloadView)];
        self.navigationItem.leftBarButtonItem=leftBarItem;
    }else
    {
        UIButton *btnLeft =[UIButton buttonWithType:UIButtonTypeCustom];
        btnLeft.frame=CGRectMake(0, 0, 12, 20);
        [btnLeft setBackgroundImage:[UIImage imageNamed:@"backView.png"] forState:UIControlStateNormal];
        [btnLeft addTarget:self action:@selector(backViewUPloadView) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    }
    
    self.view.backgroundColor=HEX(@"#ffffff");
    
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, kScreenHeight)];
    view.backgroundColor=HEX(@"#ffffff");
    

    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kContentViewHeight+49)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [view addSubview:_tableView];
    [self.view addSubview:view];
    
    _dataArray =[[NSMutableArray alloc]init];
    _startIndex =0;
    _isShowMore=NO;
    
    [self getUserData];

    
}

-(void)getUserData
{
    
    NSMutableArray *arr=[NSMutableArray array];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:_typeID,@"typeId", nil]];

    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",_startIndex*10+1],@"startIndex", nil]];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",_startIndex*10+10],@"endIndex", nil]];
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetMissionaryArticle"];
    NSLog(@"%@",soapMsg);
    __block NewsAllViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetMissionaryArticle" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        
        [blockSelf GetNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];

        
    } failure:^(NSError *error, id JSON) {
        
    }];
    
}

-(void)GetNewHealthDataAndResultSuccess:(NSString *)string
{
    NSDictionary *dataDic=[NSDictionary dictionaryWithXMLString:string];
    
    NSArray *resutlArray = dataDic[@"soap:Body"][@"GetMissionaryArticleResponse"][@"GetMissionaryArticleResult"][@"data"][@"style"];
    
    NSMutableArray *reseDataArray =[NSMutableArray arrayWithCapacity:2];
    if ([resutlArray isKindOfClass:[NSArray class]]) {
        for (int i=0; i<resutlArray.count; i++) {
            NSDictionary *dic =resutlArray[i];
            if (!dic[@"isOrNo"]) {
                [reseDataArray addObject:dic];
            }
        }
    }
    
       
    
    if (reseDataArray.count==0) {
        _isShowMore=NO;
    }else
    {
        [_dataArray addObjectsFromArray:reseDataArray];
        _isShowMore=YES;
    }
    [_tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isShowMore) {
        return _dataArray.count+1;
    }else
    {
        return _dataArray.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellStr =@"_isShowMore";
    TiJianReprotCell *cell =[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[TiJianReprotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        cell.delegateAbout=self;
        cell.itemLbl.frame=CGRectMake(cell.itemLbl.frame.origin.x, 0, 160, 70);
        cell.itemLbl.numberOfLines=0;
        cell.rightLabl.frame=CGRectMake(cell.rightLabl.frame.origin.x+40, cell.rightLabl.frame.origin.y, cell.rightLabl.frame.size.width, 50);
        cell.rightLabl.numberOfLines=0;

        UILabel *loadMore=[[UILabel alloc]initWithFrame:cell.frame];
        loadMore.text=@"加载更多";
        loadMore.textAlignment=UITextAlignmentCenter;
        loadMore.tag=100000;
        loadMore.backgroundColor=[UIColor clearColor];
        [cell addSubview:loadMore];

        
    }
    
    UILabel *loadMore=(UILabel*)[cell viewWithTag:100000];
    if (indexPath.row==_dataArray.count) {
        [cell showLoadMoreVIew];
        loadMore.hidden=NO;
    }else
    {
        if (indexPath.row%5==0) {
            cell.bgView.image=[UIImage imageNamed:@"one.png"];
        } if (indexPath.row%5==1) {
            cell.bgView.image=[UIImage imageNamed:@"two.png"];
        } if (indexPath.row%5==2) {
            cell.bgView.image=[UIImage imageNamed:@"three.png"];
        } if (indexPath.row%5==3) {
            cell.bgView.image=[UIImage imageNamed:@"four.png"];
        } if (indexPath.row%5==4) {
            cell.bgView.image=[UIImage imageNamed:@"five.png"];
        }
        
        cell.itemCountLbl.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        cell.itemLbl.text=MBNonEmptyStringNo_(_dataArray[indexPath.row][@"articleTitle"]);

        cell.rightLabl.text = MBNonEmptyStringNo_(_dataArray[indexPath.row][@"createtime"]);

        [cell hiddleLoadMoreView];
        loadMore.hidden=YES;

    }
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)loadMoreAboutdata
{
    _startIndex+=1;
    [self getUserData];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShocCanDetailViewController *xueYa =[[ShocCanDetailViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:xueYa];
    xueYa.dicAboutInfo=_dataArray[indexPath.row];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
