//
//  MiUtils.m
//  MiiCaa
//
//  Created by chen neng on 14-4-3.
//  Copyright (c) 2014年 kmyhy. All rights reserved.
//

#import "MiUtils.h"
#import "sys/utsname.h"

#define UIColorFromRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@implementation MiUtils


NSString* deviceString()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}
NSString* ms2datestr(long long ms){
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:ms/1000];
    return date2datestr(date);
}
NSString* date2datestr(NSDate* date){
    NSDateFormatter* df=[NSDateFormatter new];
    df.dateFormat=@"yyyy-MM-dd HH:mm";
    return [df stringFromDate:date];
}
NSString* id2datestr(id obj){
    if (obj==nil || obj==NULL || [obj isKindOfClass:[NSNull class]]) {
        return @"";
    }
    NSString* datestr=@"";
    if([obj isKindOfClass:[NSString class]]){
        datestr=(NSString*)obj;
        if ([datestr isEqualToString:@"<null>"]) {
            datestr=@"";
        }
    }else if([obj isKindOfClass:[NSNumber class]]){
        datestr=ms2datestr(((NSNumber*)obj).longLongValue);
    }
    return datestr;
}
NSString* datestr2ymd(NSString* datestr){
    return [datestr componentsSeparatedByString:@" "][0];
}
BOOL dateIsNil(id date){
    NSString* dateStr=id2datestr(date);
    return stringIsEmpty(dateStr);
}
NSString* removeHtmlTag(NSString* html,NSString* exclusiveTag){
    // exclusiveTag: can includes multiple tag,such as 'img|span'
    // Case insensitive.
    NSRange r;
    NSString* s=html;
    NSString *regStr=[NSString stringWithFormat:@"<(?!%@)[^>]*>",exclusiveTag];//@"<[^>]+>"
    while ((r = [s rangeOfString:regStr options:NSRegularExpressionSearch|NSCaseInsensitiveSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}
NSArray* splitByTag(NSString* html){
    NSString* string=html;// 过滤除 tag 之外的所有 html 标签
    NSMutableArray* mArr =[NSMutableArray new];
    
    NSRegularExpression* regex = [[NSRegularExpression alloc]
                                  initWithPattern:@"(.*?)(<[^>]+>|\\Z)"
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil]; //2
    NSArray* chunks = [regex matchesInString:string
                                     options:0
                                       range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult* b in chunks) {
        NSString* parts=[string substringWithRange:[b rangeAtIndex:0]];
//        DLog(@"parts=%@",parts);
        if ([parts rangeOfString:@"<"].location!=NSNotFound) {
            NSString* leftStr=[parts substringToIndex:[parts rangeOfString:@"<"].location];
            NSString* rightStr=[parts substringFromIndex:[parts rangeOfString:@"<" ].location];
            [mArr addObject:leftStr];
            [mArr addObject:rightStr];
            
        }else{
            [mArr addObject:parts];
        }
        
    }
    return mArr;
}


int id2int(id obj){
    if(obj==nil || obj==NULL)return 0;
    int i=0;
    if([obj isKindOfClass:[NSString class]]){
        if ([(NSString*)obj isEqualToString:@"<null>"]) {
            return 0;
        }else{
            i=[obj intValue];
        }
    }else if([obj isKindOfClass:[NSNumber class]]){
        i=[(NSNumber*)obj intValue];
    }
    return i;
}
NSString* id2str(id obj){
    if (obj==nil || obj==NULL) {
        return @"";
    }
    NSString* str=@"";
    if([obj isKindOfClass:[NSString class]]){
        str=(NSString*)obj;
        if ([str isEqualToString:@"<null>"]) {
            str=@"";
        }
    }else if([obj isKindOfClass:[NSNumber class]]){
        str=[NSString stringWithFormat:@"%d",[obj intValue]];
    }
    return str;
}


NSDictionary* headers(){
    NSMutableDictionary* headers=[NSMutableDictionary new];
    [headers setValue:@"XMLHttpRequest" forKey:@"x-requested-with"];
    NSString* cookie=[[NSUserDefaults standardUserDefaults]objectForKey:@"login_cookie_string"];
    if (cookie)
        [headers setValue:cookie forKey:@"Cookie"];
    return headers;
}
NSDate* GMT2LocalDate(NSDate *date){// iOS 使用 GMT 时间，提交时需要转换成北京时间
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}
NSDate* setTime(NSDate* fromDate,NSString* timeStr){
    if (timeStr==nil) {
        return fromDate;
    }
    NSDate* result;
    NSArray* parts=[timeStr componentsSeparatedByString:@":"];
    if (parts.count>1) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [gregorian components: NSUIntegerMax fromDate: fromDate];
        int hour=[(NSString*)parts[0] intValue];
        int minute=[(NSString*)parts[1] intValue];
        [comps setMinute:minute];
        [comps setHour:hour];
        
        result = [gregorian dateFromComponents:comps];
//        result=GMT2LocalDate(result);
        return result;
    }else
        return fromDate;
}
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
NSString* base64Enc(NSData *data)
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}
NSDate* datestr2date(NSString* datestr){
    return str2date(datestr, @"yyyy-MM-dd HH:mm");
}
NSDate* str2date(NSString* datestr,NSString *format){
    NSDateFormatter* df=[NSDateFormatter new];
    df.dateFormat=format;
    return [df dateFromString:datestr];
}
BOOL stringIsEmpty(NSString* string){
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }else if (string && string.length>0) {
        return NO;
    }else
        return YES;
}
NSInteger daysDiffNow(NSDate* date){
    //    DLog(@"%s:date=%@",__func__,date);
    if (date) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [calendar components:(NSDayCalendarUnit)
                                        
                                                   fromDate:date
                                        
                                                     toDate:[NSDate date]
                                        
                                                    options:0];
        
        return [components day];
    }
    return 0;
}

NSDate* addDays(NSDate* fromDate,int numOfDay){
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:numOfDay];
    NSDate *daysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:fromDate options:0];
    return daysAgo;
}
NSString* timeRelativeToNow(NSString* datestr){
    NSDate* date=datestr2date(datestr);
    NSDate* now=[NSDate new];
    if (date) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components;
        components= [calendar components:(NSYearCalendarUnit) fromDate:date toDate:now options:0];
        if([components year]!=0){
            if([components year]>0)
                return [NSString stringWithFormat:@"%lld年前",(long long)[components year]];
            else
                return [NSString stringWithFormat:@"%lld年后",(long long)-1*[components year]];
        }
        components= [calendar components:(NSMonthCalendarUnit) fromDate:date toDate:now options:0];
        if ([components month]!=0){
            if([components month]>0)
                return [NSString stringWithFormat:@"%lld个月前",(long long)[components month]];
            else
                return [NSString stringWithFormat:@"%lld个月后",(long long)-1*[components month]];
        }
        components= [calendar components:(NSDayCalendarUnit) fromDate:date toDate:now options:0];
        if([components day]!=0){
            if([components day]>0)
                return [NSString stringWithFormat:@"%lld天前",(long long)[components day]];
            else
                return [NSString stringWithFormat:@"%lld天后",(long long)-1*[components day]];
        }
        components= [calendar components:(NSHourCalendarUnit) fromDate:date toDate:now options:0];
        if([components hour]!=0){
            if([components hour]>0)
                return [NSString stringWithFormat:@"%lld小时前",(long long)[components hour]];
            else
                return [NSString stringWithFormat:@"%lld小时后",(long long)-1*[components hour]];
        }
        components= [calendar components:(NSMinuteCalendarUnit) fromDate:date toDate:now options:0];
        if([components minute]!=0){
            if([components minute]>0)
                return [NSString stringWithFormat:@"%lld分钟前",(long long)[components minute]];
            else
                return [NSString stringWithFormat:@"%lld分钟后",(long long)-1*[components minute]];
        }
        components= [calendar components:(NSSecondCalendarUnit) fromDate:date toDate:now options:0];
        if([components second]!=0){
            if([components second]>0)
                return [NSString stringWithFormat:@"%lld秒前",(long long)[components second]];
            else
                return [NSString stringWithFormat:@"%lld秒后",(long long)-1*[components second]];
        }else
            return @"刚刚";
    }else
        return datestr;
}
BOOL isTelNum(NSString *num){
    //一个判断是否是移动号码的正则表达式
    NSString *regex = @"^[0-9]{5,12}$";
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:regex
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    //无符号整型数据接受匹配的数据的数目
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:num
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, num.length)];
    return(numberofMatch > 0);
}
BOOL isMobilePhone(NSString *num){
    //一个判断是否是移动号码的正则表达式
    NSString *regex = @"^(1)[0-9]{10}$";
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:regex
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    //无符号整型数据接受匹配的数据的数目
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:num
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, num.length)];
    return(numberofMatch > 0);
}
void printRect(CGRect r){
    DLog(@"%.f,%.f,%.f,%.f",r.origin.x,r.origin.y,r.size.width,r.size.height);
}
BOOL dateIsToday(NSDate* date){
    
    NSInteger days=daysDiffNow(date);
    DLog(@"days diff now:%d",(int)days);
    return days==0;
}
@end