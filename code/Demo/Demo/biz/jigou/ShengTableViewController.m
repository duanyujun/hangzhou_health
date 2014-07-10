//
//  ShengTableViewController.m
//  Demo
//
//  Created by wang on 14-5-17.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "ShengTableViewController.h"
#import "SoapHelper.h"
#import "XMLDictionary.h"
#import "MBIIRequest.h"
#import "DBHelper.h"
#import "CityTableViewController.h"
#import "PartTableViewController.h"
#import "BOCProgressHUD.h"
#import "MBLoadingView.h"
@interface ShengTableViewController ()
{
    NSArray *_allProvicArray;
    NSArray *_allData;
    MBLoadingView *_HUD;
}
@end

@implementation ShengTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_mapView==nil) {
        _mapView =[[BMKMapView alloc]init];
        _search = [[BMKSearch alloc]init];
    }

    _allData=[[[DBHelper alloc]init] getAllProvince];
    
    NSMutableArray *provinceArray =[NSMutableArray arrayWithCapacity:2];
    for (int i=0; i<_allData.count; i++) {
        if ([_allData[i][@"pid"] isEqualToString:@"0"]) {
            [provinceArray addObject:_allData[i]];
        }
    }
    _allProvicArray =[[NSArray alloc]initWithArray:provinceArray];
      self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"定位" style:UIBarButtonItemStylePlain target:self action:@selector(uploadData)];
    if (!IOS7_OR_LATER) {
        [self.navigationItem.rightBarButtonItem setTintColor:HEX(@"#5ec4fe")];

    }
    
    
    UILabel *labl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    labl.text=@" 请选择省份";
    labl.backgroundColor=HEX(@"#f0f0f6");
    labl.textColor=HEX(@"#8e8e93");
    self.tableView.tableHeaderView=labl;
    
    [self uploadData];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _search.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放


    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewDidAppear:animated];
    _mapView.delegate = nil; // 不用时，置nil
    _search.delegate=nil;
}
-(void)uploadData
{
    if (!_HUD) {
        _HUD = [[MBLoadingView alloc] init];
        _HUD.canCancel = NO;
    }
    [_HUD show];
    [_mapView setShowsUserLocation:YES];

}
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}

/**
 *用户位置更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 新的用户位置
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    [_HUD hide];
}
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil) {
		NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        [_mapView setShowsUserLocation:NO];
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
        pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
        [self showCity:pt];
        	}
	
}
-(void)showCity:(CLLocationCoordinate2D)pt
{
    BOOL flag = [_search reverseGeocode:pt];
    if (flag) {
        NSLog(@"ReverseGeocode search success.");
        
    }
    else{
        NSLog(@"ReverseGeocode search failed!");
    }
    [_HUD hide];

}
//地图地位返回的结果
- (void)onGetAddrResult:(BMKSearch*)searcher result:(BMKAddrInfo*)result errorCode:(int)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
	if (error == 0) {
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.coordinate = result.geoPt;
		item.title = result.strAddr;
		[_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.geoPt;
        NSString* showmeg;
        

        showmeg = [NSString stringWithFormat:@"%@",result.addressComponent.city];
        NSRange range=[showmeg rangeOfString:@"市"];
        if (range.location!=NSNotFound) {
            NSString *rangstr=[showmeg substringToIndex:range.location];
            [self getData:rangstr];
        }else
        {
            [self getData:showmeg];
        }
        
	}
}
//请求服务器数据
- (void)getData:(NSString*)cityName
{
    // Dispose of any resources that can be recreated.

    NSMutableArray *arr=[NSMutableArray array];
    
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(cityName),@"city", nil]];
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"getAreaInfoList"];
    
    __block ShengTableViewController *blockSelf = self;
    [_HUD hide];

    MBRequestItem*item =[MBRequestItem itemWithMethod:@"getAreaInfoList" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItemsAboutHost:@[item] success:^(id JSON) {
        

        [blockSelf GetNewHealthDataAndResultSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];

    
}
-(void)GetNewHealthDataAndResultSuccess:(NSString*)str
{
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:str];
    NSLog(@"%@",xmlDoc);
    NSArray *array=xmlDoc[@"soap:Body"][@"getAreaInfoListResponse"][@"getAreaInfoListResult"][@"data"][@"Area"];
    if ([array isKindOfClass:[NSArray class]]) {
        NSMutableArray *dicObArray =[NSMutableArray arrayWithArray:array];
        NSLog(@"%@",dicObArray);

        PartTableViewController*city=[[PartTableViewController alloc]init];
        city.dataArray=dicObArray;
        city.isFromKuai=_isFromKuai;
        [self.navigationController pushViewController:city animated:YES];
        
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _allProvicArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr =@"cellabout";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    // Configure the cell...
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.textLabel.font=kNormalTextFont;
    cell.textLabel.text=MBNonEmptyStringNo_(_allProvicArray[indexPath.row][@"regName"]);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicOb=_allProvicArray[indexPath.row];
    NSLog(@"%@",dicOb);
    NSMutableArray *dicObArray =[NSMutableArray arrayWithCapacity:2];
    for (int i=0;i<_allData.count; i++) {
        if ([dicOb[@"rid"] isEqualToString:_allData[i][@"pid"] ]) {
            [dicObArray addObject:_allData[i]];
        }
    }
    NSLog(@"%@",dicObArray);
    CityTableViewController*city=[[CityTableViewController alloc]init];
    city.dataArray=dicObArray;
    city.isFromKuai=_isFromKuai;
    [self.navigationController pushViewController:city animated:YES];
}

@end
