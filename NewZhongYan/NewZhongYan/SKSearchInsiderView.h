//
//  SKSearchInsiderView.h
//  NewZhongYan
//
//  Created by lilin on 13-10-29.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchInsideViewProtocol <NSObject>
@optional
-(void)onSearchInsideViewConfirm:(NSDictionary *)dic;
-(void)onSearchInsideViewConfirmWith:(NSString*)title Author:(NSString*)author StartTime:(NSString*)bgtm EndTime:(NSString*)edtm;
-(void)onSearchInsideViewCancel;
@end


@interface SKSearchInsiderView : UIView<UITextFieldDelegate>
{
    UITextField *titleTextField;
    UITextField *authorTextField;
    UITextField *startTimeTextField;
    UITextField *endTimeTextField;
    UIDatePicker    *datePicker;
    UIView          *dateChooseView;
    BOOL isStartTime;
    NSDate *startTime;
    NSDate *endTime;
}
@property(nonatomic,weak)id<SearchInsideViewProtocol>delegate;
@property(nonatomic,weak)id target;
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)NSDate *startTime;
@property(nonatomic,strong)NSDate *endTime;
@property(nonatomic,strong)UITextField *titleTextField;
@property(nonatomic,strong)UITextField *authorTextField;
@property(nonatomic,strong)UITextField *startTimeTextField;
@property(nonatomic,strong)UITextField *endTimeTextField;

-(IBAction)clear:(id)sender;
-(IBAction)confirm:(id)sender;
-(IBAction)confirmDateChoose:(id)sender;
-(IBAction)cancelDateChoose:(id)sender;
@end
