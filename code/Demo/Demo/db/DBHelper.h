//  Demo
//
//  Created by llbt_wgh on 14-4-3.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBHelper : NSObject
-(NSString *)databaseFilePath;
-(NSArray*)getAllFoodType:(NSString*)foodNameCode;
-(NSDictionary*)getFoodCode:(NSString*)foodName;
-(NSString *)returnSprotNameWithSprotCode:(NSString*)code;
-(NSArray*)getAllSprotsName:(NSString*)sprotNameCode;
-(NSArray*)getAllProvince;

@end
