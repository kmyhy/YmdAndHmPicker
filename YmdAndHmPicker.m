//
//  DateAndTimePicker.m
//  BKDateAndTimePickerView
//
//  Created by chen neng on 14-4-10.
//  Copyright (c) 2014年 Bhavya Kothari. All rights reserved.
//

#import "YmdAndHmPicker.h"
#import "MiUtils.h"

@interface YmdAndHmPicker ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    NSMutableArray *yearArray;
    NSArray *monthArray;
    NSMutableArray *DaysArray;
    NSMutableArray *hoursArray;
    NSMutableArray *minutesArray;
    
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    NSInteger selectedHourRow;
    NSInteger selectedMinuteRow;
    
    BOOL firstTimeLoad;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *aPicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)cancelAction:(id)sender;
- (IBAction)okAction:(id)sender;

@end

@implementation YmdAndHmPicker
-(id)init{
    self=[YmdAndHmPicker instance];
    _kPickerViewSize=CGSizeMake(320, 206);
    [self initModel];
    [self setDateTime:[NSDate date]];
    
    self.hidden=YES;
    return self;
}
+(YmdAndHmPicker*)instance{
    YmdAndHmPicker* picker=nil;
    NSArray* obj=[[NSBundle mainBundle]loadNibNamed:@"YmdAndHmPicker"
                                              owner:self options:nil];
    for(id each in obj){
        if([each isKindOfClass:[YmdAndHmPicker class]]){
            picker=(YmdAndHmPicker*)each;
            break;
        }
    }
    return picker;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initModel
{
    firstTimeLoad = YES;

    // PickerView -  Years data
    
    yearArray = [[NSMutableArray alloc]init];
    
    
    for (int i = 1970; i <= 2050 ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    
    // PickerView -  Months data
    
    
    monthArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    
    // PickerView -  Hours data
    
    
    hoursArray = [NSMutableArray new];
    for (int i = 0; i < 24; i++)
    {
        [hoursArray addObject:[NSString stringWithFormat:@"%02d",i+1]];
    }
    
    
    // PickerView -  Hours data
    
    minutesArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 60; i++)
    {
        
        [minutesArray addObject:[NSString stringWithFormat:@"%02d",i]];
        
    }
    
    
    
    // PickerView -  days data
    
    DaysArray = [[NSMutableArray alloc]init];
    
    for (int i = 1; i <= 31; i++)
    {
        [DaysArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }

}
-(void)setDateTime:(NSDate*)date{
    // Get Current Year
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    
    NSString *currentyearString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    // Get Current  Month
    
    [formatter setDateFormat:@"MM"];
    
    NSString* currentMonthString = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    
    
    // Get Current  Date
    
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%d",[[formatter stringFromDate:date]integerValue]];
    
    
    // Get Current  Hour
    [formatter setDateFormat:@"hh"];
    NSString *currentHourString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  Minutes
    [formatter setDateFormat:@"mm"];
    NSString *currentMinutesString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    
    // Synchronize select row #
    selectedYearRow=[yearArray indexOfObject:currentyearString];
    selectedMonthRow=[monthArray indexOfObject:currentMonthString];
    selectedDayRow=[DaysArray indexOfObject:currentDateString];
    selectedHourRow=[hoursArray indexOfObject:currentHourString];
    selectedMinuteRow=[minutesArray indexOfObject:currentMinutesString];
    
    // PickerView - Default Selection as per current Date
    
    [_aPicker selectRow:selectedYearRow inComponent:0 animated:YES];
    
    [_aPicker selectRow:selectedMonthRow inComponent:1 animated:YES];
    
    [_aPicker selectRow:selectedDayRow inComponent:2 animated:YES];
    
    [_aPicker selectRow:selectedHourRow inComponent:3 animated:YES];
    
    [_aPicker selectRow:selectedMinuteRow inComponent:4 animated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)cancelAction:(id)sender {
    [self close];
    if (_delegate) {
        [_delegate ymdAndHmPicker:self accepted:NO];
    }
}

- (IBAction)okAction:(id)sender {
    [self close];
    _acceptedString =[NSString stringWithFormat:@"%@-%@-%@ %@:%@",yearArray[selectedYearRow],monthArray[selectedMonthRow],DaysArray[selectedDayRow],hoursArray[selectedHourRow],minutesArray[selectedMinuteRow]];
    if (_delegate) {
        [_delegate ymdAndHmPicker:self accepted:YES];
    }
}
-(BOOL)validate{
    BOOL b1=YES;
    BOOL b2=YES;
    NSString* newValue =[NSString stringWithFormat:@"%@-%@-%@ %@:%@",
                         yearArray[[_aPicker selectedRowInComponent:0]],
                         monthArray[[_aPicker selectedRowInComponent:1]],
                         DaysArray[[_aPicker selectedRowInComponent:2]],
                         hoursArray[[_aPicker selectedRowInComponent:3]],
                         minutesArray[[_aPicker selectedRowInComponent:4]]];
    NSDate *newDate=datestr2date(newValue);
    if (self.minDate) {
        // If newDate is earlier than minDate
        b1=[newDate compare:self.minDate]==NSOrderedDescending;
    }
    if (self.maxDate) {
        // If newDate is later than maxDate
        b2=[newDate compare:self.maxDate]==NSOrderedAscending;
    }
    return  b1 && b2;
}
#pragma mark - UIPickerViewDelegate & UIPickerViewDataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([self validate]){
        switch (component) {
            case 0:
                selectedYearRow = row;
                [_aPicker reloadAllComponents];
                break;
            case 1:
                selectedMonthRow = row;
                [_aPicker reloadAllComponents];
                break;
            case 2:
                selectedDayRow = row;
                [_aPicker reloadAllComponents];
                break;
            case 3:
                selectedHourRow = row;
                [_aPicker reloadAllComponents];
                break;
            default:
                selectedMinuteRow = row;
                [_aPicker reloadAllComponents];
                break;
        }
    }else{
        [_aPicker selectRow:selectedYearRow inComponent:0 animated:YES];
        
        [_aPicker selectRow:selectedMonthRow inComponent:1 animated:YES];
        
        [_aPicker selectRow:selectedDayRow inComponent:2 animated:YES];
        
        [_aPicker selectRow:selectedHourRow inComponent:3 animated:YES];
        
        [_aPicker selectRow:selectedMinuteRow inComponent:4 animated:YES];
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 60, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    
    switch (component) {
        case 0:
            pickerLabel.text =  yearArray[row];
            break;
        case 1:
            pickerLabel.text =  monthArray[row];
            break;
        case 2:
            pickerLabel.text =  DaysArray[row];
            break;
        case 3:
            pickerLabel.text =  hoursArray[row];
            break;
        default:
            pickerLabel.text =  minutesArray[row];
    }
    return pickerLabel;
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
    switch (component) {
        case 0:
            return [yearArray count];
        case 1:
            return [monthArray count];
        case 2:
            switch (selectedMonthRow+1) {
                case 1:
                case 3:
                case 5:
                case 7:
                case 8:
                case 10:
                case 12:
                    return 31;
                case 2:
                    return ((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)?29:28;
                default:
                    return 30;
            }
        case 3:// hour
            return [hoursArray count];
        default:// min
            return [minutesArray count];
    }
}
#pragma mark -
- (void)show
{
    if (self.superview) {
        self.frame=(CGRect){CGPointZero,self.superview.frame.size};
        self.contentView.frame=self.frame;
        _contentView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.2];
        _pickerView.frame=(CGRect){{0,self.frame.size.height-_kPickerViewSize.height},_kPickerViewSize};
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [self.superview bringSubviewToFront:self];
                             self.hidden = NO;
                         }
                         completion:^(BOOL finished){
                             SEL sel=NSSelectorFromString(@"ymdAndHmPickerWillShow:");
                             if ([_delegate respondsToSelector:sel]) {
                                 SuppressPerformSelectorLeakWarning(
                                                                    [_delegate performSelector:sel withObject:self]
                                                                    );
                             }

                         }];

    }
}
-(IBAction)hide{
    if (self.superview) {
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             self.hidden = YES;
                         }
                         completion:^(BOOL finished){
                             SEL sel=NSSelectorFromString(@"ymdAndHmPickerWillHide:");
                             if ([_delegate respondsToSelector:sel]) {
                                 SuppressPerformSelectorLeakWarning(
                                                                    [_delegate performSelector:sel withObject:self]
                                                                    );
                             }
                         }];
    }
}
-(void)close{
    if (self.superview) {
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             self.hidden = YES;
                         }
                         completion:nil];
    }
}
@end
