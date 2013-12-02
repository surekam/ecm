//
//  SKEDetailController.m
//  NewZhongYan
//
//  Created by lilin on 13-10-31.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKEDetailController.h"
#import "SKLToolBar.h"
#import "SKNewMailController.h"
@interface SKEDetailController ()
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *storeButton;
@property (weak, nonatomic) IBOutlet UILabel *ENAMELabel;
@property (weak, nonatomic) IBOutlet UIButton *MobileButton;
@property (weak, nonatomic) IBOutlet UIButton *ShortButton;
@property (weak, nonatomic) IBOutlet UIButton *OfficeButton;
@property (weak, nonatomic) IBOutlet UIButton *EmailButton;
@property (weak, nonatomic) IBOutlet UILabel *DepartLabel;
@property (weak, nonatomic) IBOutlet UILabel *OfficeAddrLabel;
@end

@implementation SKEDetailController
@synthesize employeeInfo;

-(void)handleTapForHelpImage:(UIGestureRecognizer*)recognizer
{
    if (recognizer.state==UIGestureRecognizerStateEnded)
    {
        UIImageView* helpImage = (UIImageView*)[self.view.window viewWithTag:1111];
        [helpImage fallOut:.4 delegate:nil completeBlock:^{
            [helpImage performSelector:@selector(removeFromSuperview) withObject:0 afterDelay:0.4];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
        }] ;
    }
}

- (IBAction)help:(id)sender {
    UIImageView* helpImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [helpImage setImage:[UIImage imageNamed:IS_IPHONE_5? @"iphone5_help_addressbook_detailed" : @"iphone4_help_addressbook_detailed"]];
    [helpImage setUserInteractionEnabled:YES];
    [helpImage setTag:1111];
    [self.view.window addSubview:helpImage];
    
    UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapForHelpImage:)];
    [helpImage addGestureRecognizer:tapGes];
    [helpImage fallIn:.4 delegate:nil completeBlock:^{
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }];
}


- (IBAction)stored:(UIButton*)storeBtn {
    DBQueue* queue = [DBQueue sharedbQueue];
    NSString* idx = [self.employeeInfo objectForKey:@"id"];
    if ([[self.employeeInfo objectForKey:@"STORED"] intValue]) {
        [storeBtn setBackgroundImage:[UIImage imageNamed:@"star_off"] forState:UIControlStateNormal];
        [storeBtn setBackgroundImage:[UIImage imageNamed:@"star_on"] forState:UIControlStateHighlighted];
        NSString* updatesql =
        [NSString stringWithFormat:@"UPDATE T_EMPLOYEE SET STORED = %d where id  = %@;",![[self.employeeInfo objectForKey:@"STORED"] intValue],idx];
        [queue updateDataTotableWithSQL:updatesql];
        [self.employeeInfo setObject:@"0" forKey:@"STORED"];
    }else{
        [storeBtn setBackgroundImage:[UIImage imageNamed:@"star_on"] forState:UIControlStateNormal];
        [storeBtn setBackgroundImage:[UIImage imageNamed:@"star_off"] forState:UIControlStateHighlighted];
        NSString* updatesql =
        [NSString stringWithFormat:@"UPDATE T_EMPLOYEE SET STORED = %d where id  = %@;",![[self.employeeInfo objectForKey:@"STORED"] intValue],idx];
        [queue updateDataTotableWithSQL:updatesql];
        [self.employeeInfo setObject:@"1" forKey:@"STORED"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"storeChanged" object:0];
}
- (IBAction)mobile:(UIButton *)sender {
    NSString* phone = [sender titleForState:UIControlStateNormal];
    if (phone && phone.length > 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",phone]]];
    }
}
- (IBAction)shortMobile:(UIButton *)sender {
    NSString* phone = [sender titleForState:UIControlStateNormal];
    if (phone && phone.length > 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",phone]]];
    }
}
- (IBAction)officeCall:(UIButton *)sender {
    NSString* phone = [sender titleForState:UIControlStateNormal];
    if (phone && phone.length > 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",phone]]];
    }
}

- (IBAction)email:(UIButton *)sender {
    SKNewMailController* aEmail = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"SKNewMailController"];
    NSString* name = [[DBQueue sharedbQueue] stringFromSQL:
                      [NSString stringWithFormat:@"select CNAME from T_EMPLOYEE WHERE EMAIL = '%@';",[self.employeeInfo objectForKey:@"EMAIL"]]];
    if (!name) name = sender.titleLabel.text;
    SKToken* token = [[SKToken alloc] initWithTitle:name
                                  representedObject:[self.employeeInfo objectForKey:@"EMAIL"]];
    [aEmail.toTokenField addToken:token];
    [aEmail setStatus:NewMailStatusWrite];
    [[APPUtils visibleViewController].navigationController pushViewController:aEmail animated:YES];
}

-(void)phoneOnToolBar
{
    NSString* phone = [self.employeeInfo objectForKey:@"MOBILE"];
    if (phone && phone.length > 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",phone]]];
    }
}

- (void)sendSMS
{
	if ([MFMessageComposeViewController canSendText]) {
		MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
		picker.messageComposeDelegate = self;
		picker.recipients = [NSArray arrayWithObject:[self.employeeInfo objectForKey:@"MOBILE"]];
		[self presentModalViewController:picker animated:YES];
	}
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString* msg = [NSString string];
    if(result==MessageComposeResultSent)
    {
        msg = @"发短信成功";
    }
    else if(result==MessageComposeResultCancelled)
    {
        msg = @"发短信取消";
    }
    else if(result==MessageComposeResultFailed)
    {
        msg = @"发短信失败";
    }
    [BWStatusBarOverlay showSuccessWithMessage:msg duration:1 animated:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.employeeInfo objectForKey:@"TNAME"] && [[self.employeeInfo objectForKey:@"TNAME"] length] > 0) {
        _ENAMELabel.text = [NSString stringWithFormat:@"%@(%@)",[self.employeeInfo objectForKey:@"CNAME"],[self.employeeInfo objectForKey:@"TNAME"]];
    }else{
        _ENAMELabel.text = [NSString stringWithFormat:@"%@",[self.employeeInfo objectForKey:@"CNAME"]];
    }
    _DepartLabel.text = [self.employeeInfo objectForKey:@"UCNAME"];
    _OfficeAddrLabel.text = [self.employeeInfo objectForKey:@"OFFICEADDRESS"];
    
    if ([[self.employeeInfo objectForKey:@"STORED"] intValue] == 1) {
        [_storeButton  setBackgroundImage:[UIImage imageNamed:@"star_on"] forState:UIControlStateNormal];
    }
    
    [_MobileButton setTitle:[self.employeeInfo objectForKey:@"MOBILE"] forState:UIControlStateNormal];
    [_EmailButton  setTitle:[self.employeeInfo objectForKey:@"EMAIL"] forState:UIControlStateNormal];
    [_ShortButton  setTitle:[self.employeeInfo objectForKey:@"SHORTPHONE"] forState:UIControlStateNormal];
    [_OfficeButton setTitle:[self.employeeInfo objectForKey:@"TELEPHONE"] forState:UIControlStateNormal];
    
    SKLToolBar* myToolBar = [[SKLToolBar alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
    [myToolBar setFirstItem:@"btn_call" Title:@"电话"];
    [myToolBar setSecondItem:@"btn_sms" Title:@"短信"];
    [myToolBar setThirdItem:@"btn_email" Title:@"邮件"];
    [myToolBar.firstButton  addTarget:self action:@selector(phoneOnToolBar)  forControlEvents:UIControlEventTouchUpInside];
    [myToolBar.secondButton addTarget:self action:@selector(sendSMS)   forControlEvents:UIControlEventTouchUpInside];
    [myToolBar.thirdButton  addTarget:self action:@selector(email:) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:myToolBar];
}
@end
