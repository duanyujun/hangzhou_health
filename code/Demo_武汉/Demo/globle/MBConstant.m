//
//  NSDictionary+DataSource.m
//  BOCMBCI
//
//  Created by Tracy E on 13-4-8.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

//  File convert from BOCiPadX Project constants_zh_CN.js file.

#import "MBConstant.h"
#import "JSONKit.h"
#import "MBRegExpCheck.h"
#import "RegexKitLite.h"
#import "NSDateUtilities.h"
@implementation MBConstant
NSString* MMStringWithStringAndLength (NSString * string , NSInteger length)
{
    NSString * tmpStr = @"";
    if ([string isKindOfClass:[NSString class]])
    {
        tmpStr = string;
        NSInteger tmpLength = [string length] + [[string componentsMatchedByRegex:@"[\u4e00-\u9fa5]"] count];
        
        for (int i =0; i <length - tmpLength; i ++) {
            tmpStr = [NSString stringWithFormat:@"%@%@",tmpStr,@" "];
        }
    }
    
    return tmpStr;
}

NSString* MMStringWithArray (NSArray * array)
{
    NSString * tmpStr = @"";
    if (MBIsArrayWithItems(array)) {
        
        for (int i =0; i < [array count]; i ++) {
            
            if ([array[i] isKindOfClass:[NSString class]]) {
                
                tmpStr = [NSString stringWithFormat:@"%@%@",tmpStr,array[i]];
                
            }else if (MBIsArrayWithItems(array[i])){
                
                NSString * tmpStr1 = [array[i][0] length]?array[i][0]:@"";
                NSInteger tmpLength = [array[i][1] integerValue];
                
                tmpStr = [NSString stringWithFormat:@"%@%@",tmpStr,MMStringWithStringAndLength(tmpStr1, tmpLength)];
            }
        }
    }
    return tmpStr;
}
NSString* MMRequestHeaderString (NSString * trancode)
{
    NSString * tmpStr = @"";
    NSString * date = [[[NSDate date]dateString]
                       stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    tmpStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",
              MMStringWithStringAndLength(@"DSMB", 4),      // 渠道代码
              MMStringWithStringAndLength(trancode, 6),     // 交易码
              MMStringWithStringAndLength(date, 8),         // 当前日期
              MMStringWithStringAndLength(@" ", 20),        // 客户电话
              MMStringWithStringAndLength(@" ", 90),        // 空格
              MMStringWithStringAndLength(@" ", 4),         // 返回码
              MMStringWithStringAndLength(@" ", 60),        // 返回信息
              MMStringWithStringAndLength(@" ", 8)          // 数据长度
              ];
    return tmpStr;
}

NSString* MMRequestBodyString (NSString * string)
{
    return MBIsStringWithAnyText(string)?string:@"";
}
NSString* MMRequestString (NSString * header,NSString * body)
{
    return [NSString stringWithFormat:@"%@%@",header,body];
}

NSDictionary* MMHTTPHeaderDictionary (NSString * userid,NSString *acton)
{
    NSString * tran_date = [[[NSDate date]dateString] stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString * tran_time = [[[NSDate date]timeString] stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithCapacity:6];
    [dic setObject:@"03" forKey:@"type"];
    [dic setObject:userid forKey:@"userid"];
    [dic setObject:@"393" forKey:@"clentid"];
    [dic setObject:acton forKey:@"acton"];
    [dic setObject:tran_date forKey:@"tran_date"];
    [dic setObject:tran_time forKey:@"tran_time"];
    return dic;
}


NSString* MMGetTargetString (NSString * string,int startPosition,int targetStrlength)
{
    NSString * tmpStr = @"";
    if ([string isKindOfClass:[NSString class]]) {
        tmpStr = [string substringWithRange:NSMakeRange(startPosition, targetStrlength)];
    }
    return tmpStr;
}



NSData* MMTmpPath (NSString * trancode)
{
    NSString *path = [[NSBundle mainBundle] pathForResource:trancode ofType:@"txt"];
    
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSRange  start = [string rangeOfString:@"<DATA1>"];
    NSRange  end = [string rangeOfString:@"</DATA1>"];
    NSLog(@"a:%d,%d",start.location,start.length);
    NSLog(@"b:%d,%d",end.location,end.length);
    NSString * data1= [string substringWithRange:NSMakeRange(start.location + start.length, end.location-start.location-start.length)];
    
    //    data1 = [data1 substringFromIndex:[data1 rangeOfString:kSYSID].location];
    //    NSLog(@"data1 = [%@]",data1);
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString * result = [[NSString alloc]initWithData:[[data1 dataUsingEncoding:encode] subdataWithRange:NSMakeRange(0, 200)] encoding:encode];
    
    data1 = [data1 substringFromIndex:[data1 rangeOfString:result].location + [data1 rangeOfString:result].length];
    NSLog(@"data1 = [%@]",data1);
    NSData * data = [data1 dataUsingEncoding:encode];
    
    //    NSString * results = [[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(0, 102)] encoding:encode];
    
    //    NSLog(@"{%@]%d %d",results,[results length],[[data subdataWithRange:NSMakeRange(0, 102)] length]);
    return data;
}

NSString * MMTmpString (NSData * targetData,  int startPosition,int targetStrlength)
{
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString * results = [[NSString alloc]initWithData:[targetData subdataWithRange:NSMakeRange(startPosition, targetStrlength)] encoding:encode];
    if ([results rangeOfString:@" "].location !=NSNotFound) {
        results = [results stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return results;
}

NSString* MMChangeMoneyShow (NSString * string)
{
    NSString * value = @"";
    if (MBIsStringWithAnyText(string)) {
        if ([string rangeOfString:@"."].location != NSNotFound) {
            NSString * tmpStr = [string substringFromIndex:[string rangeOfString:@"."].location+1];
            NSLog(@"tmpstr = %@",tmpStr);
            if ([tmpStr length] == 1) {
                value = [string stringByAppendingString:@"0%"];
            }else if ([tmpStr length]==2){
                value = [string stringByAppendingString:@"%"];
            }else{
                value = [string substringToIndex:[string rangeOfString:@"."].location+2];
            }
        }else{
            value = [string stringByAppendingString:@".00%"];
        }
    }
    return value;
}

@end
