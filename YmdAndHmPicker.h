//
//  DateAndTimePicker.h
//  BKDateAndTimePickerView
//
//  Created by chen neng on 14-4-10.
//  Copyright (c) 2014年 Bhavya Kothari. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YmdAndHmPicker;
@protocol YmdAndHmPickerDelegate <NSObject>
@required
-(void)ymdAndHmPicker:(YmdAndHmPicker*)picker accepted:(BOOL)b;
@optional
-(void)ymdAndHmPickerWillShow:(YmdAndHmPicker *)picker;
-(void)ymdAndHmPickerWillHide:(YmdAndHmPicker *)picker;
@end
@interface YmdAndHmPicker : UIView{
    
}
@property(assign,readonly)CGSize kPickerViewSize;//CGSizeMake(320, 206)
@property (strong,nonatomic)NSString* acceptedString;
@property(assign,nonatomic)int tag;
@property(weak,nonatomic)id miscellaneous;
@property(nonatomic,assign) id <YmdAndHmPickerDelegate>
delegate;
@property(nonatomic,retain)NSDate *maxDate,*minDate;
-(void)setDateTime:(NSDate*)date;
-(void)show;
-(void)hide;
-(void)close;
@end
