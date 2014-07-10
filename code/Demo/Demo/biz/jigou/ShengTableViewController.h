//
//  ShengTableViewController.h
//  Demo
//
//  Created by wang on 14-5-17.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
@interface ShengTableViewController : UITableViewController<BMKSearchDelegate,BMKMapViewDelegate>
{
    BMKMapView* _mapView;//地图定位
    BMKSearch* _search;//地图反编码

}
@property(nonatomic,assign)BOOL isFromKuai;//是否是从快捷方式进入的

@end
