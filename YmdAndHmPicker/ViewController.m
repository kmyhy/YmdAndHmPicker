//
//  ViewController.m
//  YmdAndHmPicker
//
//  Created by chen neng on 14-7-2.
//  Copyright (c) 2014年 kmyhy. All rights reserved.
//

#import "ViewController.h"
#import "YmdAndHmPicker.h"
#import "MiUtils.h"

@interface ViewController ()<YmdAndHmPickerDelegate>{
YmdAndHmPicker* customePicker;
    __weak IBOutlet UITextField *textField;
}
@end

@implementation ViewController
- (IBAction)buttonAction:(id)sender {
    [customePicker show];
}
- (IBAction)freeKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	customePicker=[YmdAndHmPicker new];
    customePicker.delegate=self;
    customePicker.minDate=[NSDate date];
    customePicker.maxDate=addDays([NSDate date],3);
    [self.view addSubview:customePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -DateAndTimePickerDelegate
-(void)ymdAndHmPicker:(YmdAndHmPicker *)picker accepted:(BOOL)b{
    if (b) {
        textField.text=picker.acceptedString;
    }
}
@end
