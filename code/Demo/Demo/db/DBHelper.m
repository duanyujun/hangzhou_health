//
//  DBHelper.m
//  Demo
//
//  Created by llbt_wgh on 14-4-3.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "DBHelper.h"
#import "FMDatabase.h"
static FMDatabase *_db;
@implementation DBHelper
-(NSString *)databaseFilePath
{
    
    NSString *filePath= [[NSBundle mainBundle] pathForResource:@"shphone" ofType:@"db"];
    NSLog(@"%@",filePath);
    return filePath;
    
}
-(void)creatDatabase
{
    _db = [FMDatabase databaseWithPath:[self databaseFilePath]];
    
}
-(NSArray*)getAllProvince
{
    [self creatDatabase];
    
    if (![_db open]) {
        return nil;
    }
    
    NSMutableArray *peopleArray = [NSMutableArray arrayWithCapacity:2];
    NSString *seleSql =[NSString stringWithFormat:@"select * from region"];
    FMResultSet *rs = [_db executeQuery:seleSql];
    while ([rs next]) {
        NSString *rid = [rs stringForColumn:@"rid"];
        NSString *pid = [rs stringForColumn:@"pid"];
        NSString *regName = [rs stringForColumn:@"regName"];

        NSDictionary *dic=@{@"rid": rid,@"pid":pid,@"regName":regName};
        
        [peopleArray addObject:dic];
        
    }
    
    return peopleArray;
}
-(NSArray*)getAllFoodType:(NSString*)foodNameCode
{
    
    [self creatDatabase];
   
    if (![_db open]) {
        return nil;
    }
    
    NSMutableArray *peopleArray = [NSMutableArray arrayWithCapacity:2];
    NSString *seleSql =[NSString stringWithFormat:@"select name,code ,desc from food where typeCode in (\"%@\")",foodNameCode];
    FMResultSet *rs = [_db executeQuery:seleSql];
    while ([rs next]) {
        NSString *name = [rs stringForColumn:@"name"];
        NSString *desc = [rs stringForColumn:@"desc"];

        
        if (desc.length>0) {
            name =[name stringByAppendingFormat:@" %@",desc];
        }
        NSString *code = [rs stringForColumn:@"code"];
        NSDictionary *dic=@{@"name": name,@"code":code};

        [peopleArray addObject:dic];

    }
    
    return peopleArray;
                                   
}
-(NSDictionary*)getFoodCode:(NSString*)foodName{

    [self creatDatabase];
    
    if (![_db open]) {
        return nil;
    }
    NSString *seleName=@"";
    NSArray *array=[foodName componentsSeparatedByString:@" "];
    NSLog(@"%@",array);
    NSLog(@"%@",foodName);
    seleName=array[0];
    NSString *desKey=@"";
    NSString *desValue=@"";
    if (array.count==2) {
        desKey=@"desc";
        desValue=array[1];
    }else
    {
        desKey=@"";

    }
    NSString *nameFood=[foodName componentsSeparatedByString:@" "][0];
    if (nameFood.length>0) {
        seleName=nameFood;
    }else
    {
        seleName=[foodName componentsSeparatedByString:@" "][0];
    }
    //select code,kc from food where name="321"
    NSString *seleSql =[NSString stringWithFormat:@"select code,kc,name,desc from food where name like (\"%@\") and %@ like (\"%@\")",seleName,desKey,desValue];
    NSLog(@"%@",seleName);
    
    FMResultSet *rs = [_db executeQuery:seleSql];
    while ([rs next]) {
        NSString *code = [rs stringForColumn:@"code"];
        NSString *name = [rs stringForColumn:@"name"];
        NSString *desc = [rs stringForColumn:@"desc"];
        if (desc.length>0) {
            name=[name stringByAppendingString:desc];
        }
        NSString *kc = [rs stringForColumn:@"kc"];
        NSDictionary *dic=@{@"code": code,@"kc":kc,@"name":name};
        
        return dic;
        
    }

    return nil;
}
-(NSString *)returnSprotNameWithSprotCode:(NSString*)code
{
    //select name from sportitem where sportItemNo like ""
    [self creatDatabase];
    
    if (![_db open]) {
        return nil;
    }
    //select code,kc from food where name="321"
    NSString *seleSql =[NSString stringWithFormat:@"select sportName from sportitem where sportItemNo  = \"%@\"",code];
    FMResultSet *rs = [_db executeQuery:seleSql];
    while ([rs next]) {
        NSString *name = [rs stringForColumn:@"sportName"];
        
        
        return name;
        break;
    }
    
    return nil;
}
-(NSArray*)getAllSprotsName:(NSString*)sprotNameCode
{
    [self creatDatabase];
    
    if (![_db open]) {
        return nil;
    }
    
    NSMutableArray *peopleArray = [NSMutableArray arrayWithCapacity:2];
    NSString *seleSql =[NSString stringWithFormat:@"select sportItemNo,sportName,png from sportitem where sportTypeCode in (\"%@\")",sprotNameCode];
    NSLog(@"%@",seleSql);

    FMResultSet *rs = [_db executeQuery:seleSql];
    while ([rs next]) {
        NSString *sportItemNo = [rs stringForColumn:@"sportItemNo"];
        NSString *sportName = [rs stringForColumn:@"sportName"];

        NSDictionary *dic=@{@"sportItemNo": sportItemNo,@"sportName":sportName};
        
        [peopleArray addObject:dic];
        
    }
    NSLog(@"%@",peopleArray);
    return peopleArray;
}
@end
