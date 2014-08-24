//
//  ChartViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-4-7.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "ChartViewController.h"
#import "MBIIRequest.h"
#import "XMLParser.h"
#import "SoapHelper.h"
#import "ChartTableViewCell.h"
#import "NSDateUtilities.h"
#import "AdminChartTableViewCell.h"
#import "XMLDictionary.h"
#import "EGORefreshTableHeaderView.h"
#import "MBPopMenu.h"
@interface ChartViewController ()<EGORefreshTableHeaderDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView*_tableView;
    NSMutableArray *_dataArray;
    UITextField *_sendText;
    NSDictionary *_userInfo;
    NSTimer*_timer;
    int _start;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    BOOL _isFirsGetData;
    NSMutableArray *_healthUserAllInfo;
    NSString *_healuserID;
    
}
@end

@implementation ChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        
    }
    return self;
}
- (void)dealloc {
    [_timer invalidate];
	_timer=nil;
}
- (void)keyboardWillShow:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
    NSDictionary *info = [notif userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    float height=0;
    if (IOS7_OR_LATER) {
    }else
    {
        height=-60;
    }
    
    self.view.frame = CGRectMake(0, -kbSize.height+49+20+height, 320, self.view.frame.size.height);
    
    
}


//返回到上个页面
-(void)backViewUPloadView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)didTimeBtnAction:(MBPopMenuItem*)item
{
    if (_dataArray.count>0) {
        [_dataArray removeAllObjects];
    }
    [_tableView reloadData];
    _start=0;
    for (int i=0; i<_healthUserAllInfo.count; i++) {
        NSDictionary *dic=_healthUserAllInfo[i];
        if ([MBNonEmptyStringNo_(dic[@"healthname"]) isEqualToString:item.title]) {
            _healuserID=MBNonEmptyStringNo_(dic[@"healthId"]);
            self.title=item.title;
            break;
        }
    }
    _isFirsGetData=YES;

    [self getChartData];
}
-(void)uploadFoodKC:(UIButton*)button
{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:2];
    
    for (int i=0; i<_healthUserAllInfo.count; i++) {
        MBPopMenuItem*item =[MBPopMenuItem menuItem:MBNonEmptyStringNo_(_healthUserAllInfo[i][@"healthname"]) image:nil target:self action:@selector(didTimeBtnAction:)];
        
        [array addObject:item];
    }

    [MBPopMenu showMenuInView:self.view fromRect:[self.view convertRect:button.frame fromView:button.superview] menuItems:array];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _healthUserAllInfo =[[NSMutableArray alloc]initWithCapacity:2];
    
    _isFirsGetData=YES;
    _start=1;
	// Do any additional setup after loading the view.
    _dataArray =[[NSMutableArray alloc]initWithCapacity:2];
    self.view.backgroundColor=HEX(@"#f5f5f5");
    self.title=@"互动咨询";
    
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
    

        UIButton *btnLeft =[UIButton buttonWithType:UIButtonTypeCustom];
        btnLeft.frame=CGRectMake(0, 0, 24, 24);
        [btnLeft setBackgroundImage:[UIImage imageNamed:@"semdMessageBg.png"] forState:UIControlStateNormal];
        [btnLeft addTarget:self action:@selector(uploadFoodKC:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    



    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, kContentViewHeight-10) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView * view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-_tableView.bounds.size.height, _tableView.frame.size.width, _tableView.bounds.size.height)];
        view.delegate = self;
        [_tableView addSubview:view];
        _refreshHeaderView = view;
    }

    
    _sendText=[[UITextField alloc]initWithFrame:CGRectMake(10, kContentViewHeight+8, 250, 49-8-8)];
    _sendText.textColor=kNormalTextColor;
    _sendText.font=kNormalTextFont;
    _sendText.delegate=self;
    _sendText.placeholder=@"请输入您要发送的信息";
    _sendText.borderStyle=UITextBorderStyleRoundedRect;
    [self.view addSubview:_sendText];
    
    
    UIButton *btnOne =[UIButton buttonWithType:UIButtonTypeCustom];
    btnOne.frame = CGRectMake(265, kContentViewHeight+8, 50, 49-8-8);
    [btnOne setTitle:@"发送" forState:UIControlStateNormal];
    [btnOne setBackgroundImage:[UIImage imageNamed:@"sendMessage.png"] forState:UIControlStateNormal];
    btnOne.titleLabel.font=kNormalTextFont;
    [btnOne addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [btnOne setBackgroundColor:HEX(@"5ec4fe")];
    [self.view addSubview:btnOne];
    [btnOne setTitleColor:kNormalTextColor forState:UIControlStateNormal];
    
    [self getHealth];
}
-(void)getHealth
{
    NSMutableArray *arr=[NSMutableArray array];
    
    
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"_userId", nil]];
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetKeFu"];
    __block ChartViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetKeFu" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf GetKeFusultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];

}
-(void)GetKeFusultSuccess:(NSString *)string
{
    NSLog(@"%@",string);
    NSDictionary *xmlDic=[NSDictionary dictionaryWithXMLString:string];
    NSLog(@"%@",xmlDic);
    NSString *result=MBNonEmptyStringNo_(xmlDic[@"soap:Body"][@"GetKeFuResponse"][@"GetKeFuResult"]);
    if (result.length>0) {
        NSArray *headlAllCount=[result componentsSeparatedByString:@","];
        for (int i=0; i<headlAllCount.count; i++) {
            NSString *headONeInfo=headlAllCount[i];
            NSArray *headoNearray=[headONeInfo componentsSeparatedByString:@"|"];
            NSDictionary *dicOnfi=@{@"healthId":headoNearray[1],@"healthname":headoNearray[0]};
            [_healthUserAllInfo addObject:dicOnfi];
            
        }
        if (_healthUserAllInfo.count>0) {
            self.title=MBNonEmptyStringNo_(_healthUserAllInfo[0][@"healthname"]);
        }
        _healuserID=MBNonEmptyStringNo_(_healthUserAllInfo[0][@"healthId"]);
        [_refreshHeaderView refreshLastUpdatedDate];
        [self egoRefreshTableHeaderDidTriggerRefresh:_refreshHeaderView];
    }
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self viewNor];
    [textField resignFirstResponder];
    
    return YES;
}
-(void)viewAboutUpload
{
    float height=0;
    if (IOS7_OR_LATER) {
        height=-150;
    }else
    {
        height=-180;
    }
    [UIView animateWithDuration:0.75 animations:^{
        
        self.view.frame=CGRectMake(0, height, 320, self.view.frame.size.height);
    }];
}
-(void)viewNor{
    float height=0;
    if (IOS7_OR_LATER) {
        height=65;
    }else
    {
        height=0;
    }
    [UIView animateWithDuration:0.75 animations:^{
        
        self.view.frame=CGRectMake(0, height, 320, self.view.frame.size.height);
        
    }];
    
}
-(void)goToLoginViewAbout
{
    MBNotLogViewController *notLogin =[[MBNotLogViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:notLogin];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)sendMessageToServier
{
    
    
//    if (_dataArray.count==0||!_dataArray) {
//        MBAlert(@"未成功建立通话");
//        return;
//    }
    NSDictionary *dic =nil;
    
    if (_dataArray.count>0) {
        dic =_dataArray[_dataArray.count-1];
        
    }
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        [self goToLoginViewAbout];
    }else{
        //_sendUserId
        NSMutableArray *arr=[NSMutableArray array];
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([_userInfo allValues][0][@"UserID"]),@"_sendUserId", nil]];//userId
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(_healuserID),@"_receiveId", nil]];//userId
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:_sendText.text,@"_content", nil]];//userId
        
        
        NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"SendOnLineMessage"];
        NSLog(@"%@",soapMsg);
        __block ChartViewController *blockSelf = self;
        
        MBRequestItem*item =[MBRequestItem itemWithMethod:@"SendOnLineMessage" params:@{@"soapMessag":soapMsg}];
        
        [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
            
            [blockSelf GSendOnLineMessagesultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
            
            
        } failure:^(NSError *error, id JSON) {
            
        }];
    }
    
}
-(void)GSendOnLineMessagesultSuccess:(NSString *)string
{
    
    NSDate *date =[NSDate date];
    NSString *dateStr =[date dateTimeString];
    NSString *userID=MBNonEmptyStringNo_([_userInfo allValues][0][@"UserID"]);
    NSDictionary *dic =@{@"sendDate": dateStr,@"sendUserId":userID,@"content":_sendText.text};
    [_dataArray addObject:dic];
    [_tableView reloadData];
    
    [_tableView scrollToRowAtIndexPath:
     
     [NSIndexPath indexPathForRow:[_dataArray count]-1 inSection:0]
     
                      atScrollPosition: UITableViewScrollPositionBottom
     
                              animated:NO];
    

    _sendText.text=@"";
//    [self getChartData];
}
-(void)sendMessage
{
    [_sendText resignFirstResponder];
    [self viewNor];
    if (_sendText.text.length>0) {
        
        
        _start=0;
        [self sendMessageToServier];
        
        
    }else
    {
        MBAlert(@"请输入要发送的信息");
    }
}

-(void)getChartData
{
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    _userInfo = [[NSDictionary alloc]initWithDictionary:allUserDic];
    //
    
    NSMutableArray *arr=[NSMutableArray array];

    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"_userId", nil]];//userId
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:_healuserID,@"_healthId", nil]];//userId

    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",_start],@"_start", nil]];//userId
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",_start+9],@"_end", nil]];//userId
    _start+=10;
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetOnLineChatRecordNew"];
    NSLog(@"%@",soapMsg);
    __block ChartViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetOnLineChatRecordNew" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf GetNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    
}
-(void)GetNewHealthDataAndResultSuccess:(NSString*)string
{
    NSDictionary*xmlDic =[NSDictionary dictionaryWithXMLString:string];
    
    NSArray *array=xmlDic[@"soap:Body"][@"GetOnLineChatRecordNewResponse"][@"GetOnLineChatRecordNewResult"][@"data"][@"AllRecord"][@"Record"];
    
    NSMutableArray *reseDataArray =[NSMutableArray arrayWithCapacity:2];
    if ([array isKindOfClass:[NSArray class]]) {
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic =array[i];
            if (!dic[@"isOrNo"]) {
                [reseDataArray addObject:dic];
            }
        }
    }
    NSMutableArray *resortArray =[NSMutableArray arrayWithCapacity:0];
    for (int i=reseDataArray.count-1; i>=0; i--) {
        [resortArray addObject:reseDataArray[i]];
    }

    
    if (_isFirsGetData) {
        
        if (reseDataArray.count>0) {
            [_dataArray addObjectsFromArray:resortArray];
        }
        
    }else
    {
        if (reseDataArray.count>0) {
        NSRange range = NSMakeRange(0, [reseDataArray count]);
            
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [_dataArray insertObjects:reseDataArray atIndexes:indexSet];
        }

    }
    
    for (int i=0; i<_dataArray.count; i++) {
        NSDictionary *dicOfI=_dataArray[i];
        NSDate *dataI=[NSDate dateWithString:MBNonEmptyStringNo_(dicOfI[@"sendDate"])];
        for (int j=i+1; j<_dataArray.count; j++) {
            NSDictionary *dicOfJ=_dataArray[j];
            NSDate *dataJ=[NSDate dateWithString:MBNonEmptyStringNo_(dicOfJ[@"sendDate"])];
            if ([dataI isLaterThanDate:dataJ]) {
                [_dataArray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }

        }
    }
    
    [_tableView reloadData];
    
    if (_isFirsGetData) {
        
        if (_dataArray.count>0) {
            [_tableView scrollToRowAtIndexPath:
             
             [NSIndexPath indexPathForRow:[_dataArray count]-1 inSection:0]
             
                              atScrollPosition: UITableViewScrollPositionBottom
             
                                      animated:NO];
        }
   
    }else
    {
        
    }
    _isFirsGetData=NO;
   
    
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:5.0
                                                target:self
                                              selector:@selector(getChartDataAboutTimeer)
                                              userInfo:nil
                                               repeats:YES];
    }
    
    
    NSLog(@"%@",xmlDic);
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer=nil;
}

-(void)getChartDataAboutTimeer
{
    
    NSMutableDictionary *allUserDic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE];
    _userInfo = [[NSDictionary alloc]initWithDictionary:allUserDic];
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([allUserDic allValues][0][@"UserID"]),@"userId", nil]];//userId
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(_healuserID),@"_healthId", nil]];//userId
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetIsOnLineChatingNew"];
    NSLog(@"%@",soapMsg);
    __block ChartViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"GetIsOnLineChatingNew" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf GetTimerNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    
}
-(void)GetTimerNewHealthDataAndResultSuccess:(NSString*)string
{
    
    NSLog(@"1111=====%@",string);
    
    NSDictionary*xmlDic =[NSDictionary dictionaryWithXMLString:string];
    NSLog(@"%@",xmlDic);
    NSArray *array=xmlDic[@"soap:Body"][@"GetIsOnLineChatingNewResponse"][@"GetIsOnLineChatingNewResult"][@"data"][@"AllRecord"][@"Record"];
    
    NSMutableArray *reseDataArray =[NSMutableArray arrayWithCapacity:2];
    if ([array isKindOfClass:[NSArray class]]) {
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic =array[i];
            if (!dic[@"isOrNo"]) {
                [reseDataArray addObject:dic];
            }
        }
    }
    if ([array isKindOfClass:[NSDictionary class]]) {
        [reseDataArray addObject:array];
        
    }
    if (reseDataArray.count>0) {
        NSMutableArray *getRsult=[NSMutableArray arrayWithCapacity:2];
        for (int i=reseDataArray.count-1; i>=0; i--) {
            [getRsult addObject:reseDataArray[i]];
        }
        [_dataArray addObjectsFromArray:getRsult];
        
        for (int i=0; i<_dataArray.count; i++) {
            NSDictionary *dicOfI=_dataArray[i];
            NSDate *dataI=[NSDate dateWithString:MBNonEmptyStringNo_(dicOfI[@"sendDate"])];
            for (int j=i+1; j<_dataArray.count; j++) {
                NSDictionary *dicOfJ=_dataArray[j];
                NSDate *dataJ=[NSDate dateWithString:MBNonEmptyStringNo_(dicOfJ[@"sendDate"])];
                if ([dataI isEqualToDate:dataJ]) {
                    [_dataArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
                
            }
        }
        
        [_tableView reloadData];
        [_tableView scrollToRowAtIndexPath:
         
         [NSIndexPath indexPathForRow:[_dataArray count]-1 inSection:0]
         
                          atScrollPosition: UITableViewScrollPositionBottom
         
                                  animated:NO];
        
        [self getNewMessagAndNoticeSerVier:getRsult];
        
        
    }
    
    
    NSLog(@"%@",xmlDic);
}
-(void)getNewMessagAndNoticeSerVier:(NSArray*)reseDataArray
{
    //UpDateChatRecordState
    NSString *recordIds=nil;
    for (int i=0; i<reseDataArray.count; i++) {
        if (!recordIds) {
            recordIds =MBNonEmptyStringNo_(reseDataArray[i][@"recordId"]);
        }else
        {
            recordIds =[recordIds stringByAppendingFormat:@",%@",MBNonEmptyStringNo_(reseDataArray[i][@"recordId"])];
        }
    }
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(recordIds),@"recordIds", nil]];//userId
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"UpDateChatRecordState"];
    
    __block ChartViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"UpDateChatRecordState" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf UpDateChatRecordStateAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    
    
}
-(void)UpDateChatRecordStateAndResultSuccess:(NSString*)string
{
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([MBNonEmptyStringNo_(_dataArray[indexPath.row][@"sendUserId"]) isEqualToString:MBNonEmptyStringNo_([_userInfo allValues][0][@"UserID"])]) {
        
        static NSString *cellStr =@"_isShowMoreSlef";
        AdminChartTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell = [[AdminChartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.messageLbl.text=MBNonEmptyStringNo_(_dataArray[indexPath.row][@"content"]);
        cell.timeLbl.text=MBNonEmptyStringNo_(_dataArray[indexPath.row][@"sendDate"]);
        
        [MBIIRequest getValidationImageForView:cell.headImageView withUrlStr:MBNonEmptyStringNo_([_userInfo allValues][0][@"HeadImg"])];
        
        
        return cell;
    }else{
        static NSString *cellStr =@"_isShowMore";
        ChartTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell = [[ChartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.messageLbl.text=MBNonEmptyStringNo_(_dataArray[indexPath.row][@"content"]);
        cell.timeLbl.text=MBNonEmptyStringNo_(_dataArray[indexPath.row][@"sendDate"]);
        
        
        cell.headImageView.image=[UIImage imageNamed:@"manager_app_icon.png"];
        
        return cell;
        
    }
    
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 78;
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    [self getChartData];
    
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


@end
