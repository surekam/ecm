//
//  SKSearchInsiderView.m
//  NewZhongYan
//
//  Created by lilin on 13-10-29.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKSearchInsiderView.h"
#import "DateUtils.h"
@implementation SKSearchInsiderView
@synthesize target,delegate;
@synthesize contentView;
@synthesize titleTextField,authorTextField,startTimeTextField,endTimeTextField;
@synthesize startTime,endTime;

-(IBAction)clear:(id)sender
{
    titleTextField.text=@"";
    authorTextField.text=@"";
    startTimeTextField.text=@"";
    endTimeTextField.text=@"";
}

-(IBAction)confirm:(id)sender
{
    [delegate onSearchInsideViewConfirmWith:titleTextField.text ? titleTextField.text :@""
                                     Author:authorTextField.text ? authorTextField.text :@""
                                  StartTime:startTimeTextField.text
                                    EndTime:endTimeTextField.text];
}

-(IBAction)confirmDateChoose:(id)sender
{
    if (isStartTime)
    {
        startTimeTextField.text=[DateUtils dateToString:datePicker.date DateFormat:@"yyyy-MM-dd"];
        self.startTime=datePicker.date;
    }
    else
    {
        endTimeTextField.text=[DateUtils dateToString:datePicker.date DateFormat:@"yyyy-MM-dd"];
        self.endTime=datePicker.date;
    }
    
    CGRect moreRect=dateChooseView.frame;
    moreRect.origin.y=self.frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        dateChooseView.frame=moreRect;
    }];
}

-(void)cancelDateChoose:(id)sender
{
    CGRect moreRect=dateChooseView.frame;
    moreRect.origin.y=self.frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        dateChooseView.frame=moreRect;
    }];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:184/255 green:184/255 blue:184/255 alpha:0.6]];
        contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, 300, 320)];
        [contentView setFrame:CGRectMake(10, 15, 0, 0)];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        contentView.layer.borderColor = UIColor.grayColor.CGColor;
        contentView.layer.borderWidth = 1;
        contentView.layer.cornerRadius = 10.0;
        contentView.layer.masksToBounds = YES;
        contentView.clipsToBounds = YES;
        [self addSubview:contentView];
        
        UILabel* indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, 320, 21)];
        [indexLabel setTextAlignment:NSTextAlignmentCenter];
        [indexLabel setText:@"多条件输入"];
        [contentView addSubview:indexLabel];
        
        
        UILabel* titltLabel =[[UILabel alloc] initWithFrame:CGRectMake(15, 72, 72, 21)];
        [titltLabel setText:@"标      题:"];
        [contentView addSubview:titltLabel];
        
        UILabel* authorLabel =[[UILabel alloc] initWithFrame:CGRectMake(15, 113, 72, 21)];
        [authorLabel setText:@"发 布 者:"];
        [contentView addSubview:authorLabel];
        
        UILabel* startLabel =[[UILabel alloc] initWithFrame:CGRectMake(11, 159, 74, 21)];
        [startLabel setText:@"开始时间:"];
        [contentView addSubview:startLabel];
        
        
        UILabel* endLabel =[[UILabel alloc] initWithFrame:CGRectMake(11, 206, 74, 21)];
        [endLabel setText:@"结束时间:"];
        [contentView addSubview:endLabel];
        
        titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, 69, 195, 30)];
        titleTextField.delegate = self;
        [titleTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [titleTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [titleTextField setBorderStyle:UITextBorderStyleLine];
        [contentView addSubview:titleTextField];
        
        authorTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, 111, 195, 30)];
        authorTextField.delegate = self;
        [authorTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [authorTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [authorTextField setBorderStyle:UITextBorderStyleLine];
        [contentView addSubview:authorTextField];
        
        startTimeTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, 157, 195, 30)];
        startTimeTextField.delegate = self;
        [startTimeTextField setBorderStyle:UITextBorderStyleLine];
        [contentView addSubview:startTimeTextField];
        
        endTimeTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, 204, 195, 30)];
        endTimeTextField.delegate = self;
        [endTimeTextField setBorderStyle:UITextBorderStyleLine];
        [contentView addSubview:endTimeTextField];
        
        UIButton* clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearBtn addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
        [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
        [clearBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [clearBtn setBackgroundImage:[UIImage imageNamed:@"btn_home_bg.png"] forState:UIControlStateNormal];
        [clearBtn setFrame:CGRectMake(85, 263, 57, 38)];
        [contentView addSubview:clearBtn];
        
        UIButton* doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneBtn addTarget:target action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
        [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doneBtn setBackgroundImage:[UIImage imageNamed:@"btn_home_bg.png"] forState:UIControlStateNormal];
        [doneBtn setFrame:CGRectMake(154, 263, 57, 38)];
        [contentView addSubview:doneBtn];
        
        UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn addTarget:target action:@selector(moreConditionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_home_bg.png"] forState:UIControlStateNormal];
        [cancelBtn setFrame:CGRectMake(223, 263, 57, 38)];
        [contentView addSubview:cancelBtn];
        
        dateChooseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, 320, 240)];
        [self addSubview:dateChooseView];
        
        //创建工具栏
        UIBarButtonItem *confirmbtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(confirmDateChoose:)];
        
        UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *cancelbtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelDateChoose:)];
        
        UIToolbar* toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,320, 44)];
        toolBar.barStyle = UIBarStyleBlackTranslucent;
        toolBar.items = [NSArray arrayWithObjects:cancelbtn,flexibleSpaceItem,confirmbtn,nil];
        [dateChooseView addSubview:toolBar];
        
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,40, 320, 200)];
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [dateChooseView addSubview:datePicker];
        
        
        startTimeTextField.text=[DateUtils dateToString:[[NSDate date] dateBySubtractingDays:30] DateFormat:@"yyyy-MM-dd"];
        self.startTime = [[NSDate date] dateBySubtractingDays:30];
        endTimeTextField.text=[DateUtils dateToString:[NSDate date] DateFormat:@"yyyy-MM-dd"];
        self.endTime = [NSDate date];
    }
    return self;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField==startTimeTextField)
    {
        [titleTextField resignFirstResponder];
        [authorTextField resignFirstResponder];
        
        CGRect moreRect=dateChooseView.frame;
        moreRect.origin.y=self.frame.size.height - dateChooseView.frame.size.height - 44;
        [UIView animateWithDuration:0.3 animations:^{
            dateChooseView.frame=moreRect;
        }];
        isStartTime=YES;
        return NO;
    }
    else if(textField==endTimeTextField)
    {
        [titleTextField resignFirstResponder];
        [authorTextField resignFirstResponder];
        CGRect moreRect=dateChooseView.frame;
        moreRect.origin.y=self.frame.size.height - dateChooseView.frame.size.height - 44;
        [UIView animateWithDuration:0.3 animations:^{
            dateChooseView.frame=moreRect;
        }];
        isStartTime=NO;
        return NO;
    }else{
        CGRect moreRect=dateChooseView.frame;
        moreRect.origin.y=self.frame.size.height;
        [UIView animateWithDuration:0.3 animations:^{
            dateChooseView.frame=moreRect;
        }];
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
