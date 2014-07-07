//
//  MiUtils.h
//  MiiCaa
//
//  Created by chen neng on 14-4-3.
//  Copyright (c) 2014年 kmyhy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MiUtils : NSObject

NSString* deviceString();
NSString* id2datestr(id obj);
int id2int(id obj);
NSString* date2datestr(NSDate* date);
NSString* ms2datestr(long long ms);
NSString* id2str(id obj);

NSDictionary* headers();
NSDate* GMT2LocalDate(NSDate *date);
NSDate* setTime(NSDate* fromDate,NSString* timeStr);
BOOL dateIsNil(id date);
NSString* base64Enc(NSData *data);
NSString* removeHtmlTag(NSString* html,NSString* exclusiveTag);
NSArray* splitByTag(NSString* html);

NSDate* datestr2date(NSString* datestr);
NSDate* str2date(NSString* datestr,NSString *format);
NSAttributedString* disposeEndTime(NSString* endTime);
BOOL stringIsEmpty(NSString* string);
NSInteger daysDiffNow(NSDate* date);
NSString* nameOfDate(NSDate* date);
NSDate* addDays(NSDate* fromDate,int numOfDay);
NSString* timeRelativeToNow(NSString* datestr);
NSString* datestr2ymd(NSString* datestr);
BOOL isTelNum(NSString *num);
BOOL isMobilePhone(NSString *num);
void printRect(CGRect r);
BOOL dateIsToday(NSDate* date);

@end
