A customized UIPickerView to choose date and time
=================================================

Features
--------
* YmdAndHmPicker allow you choose a datetime.In style,it was like 'YYYY-MM-dd HH:mm' :

![screenshot](https://github.com/kmyhy/YmdAndHmPicker/raw/master/Screenshot.png)

How to use
----------
* Copy below files to your project:
 MiUtils.h, MiUtils.m,YmdAndHmPicker.h,YmdAndHmPicker.m,YmdAndHmPicker.xib
* Import YmdAndHmPicker.h
* Create a YmdAndHmPicker instance and setup it's properties
```objective-c
	customePicker=[YmdAndHmPicker new];
	customePicker.delegate=self;
	customePicker.minDate=[NSDate date];
	customePicker.maxDate=addDays([NSDate date],3);
	[customePicker show];
```
* Implement YmdAndHmPickerDelegate protocol
```objective-c
	-(void)ymdAndHmPicker:(YmdAndHmPicker *)picker accepted:(BOOL)b{
    	if (b) {
        	textField.text=picker.acceptedString;
    	}
	}
```

Demo / Example App
------------------
See Demo project for details.

Contact
-------
Email:[kmyhy@126.com](mailto://kmyhy@126.com/ "Email")	Blog:[http://blog.csdn.net/kmyhy](http://blog.csdn.net/kmyhy "Blog") 
