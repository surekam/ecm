//
//  SKEdetailInfoController.m
//  NewZhongYan
//
//  Created by lilin on 13-11-27.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKEdetailInfoController.h"
#import "SKLToolBar.h"
#import "UIColor+FlatUI.h"
@interface SKEdetailInfoController ()
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation SKEdetailInfoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    SKLToolBar* myToolBar = [[SKLToolBar alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
    [myToolBar setFirstItem:@"btn_call" Title:@"电话"];
    [myToolBar setSecondItem:@"btn_sms" Title:@"短信"];
    [myToolBar setThirdItem:@"btn_email" Title:@"邮件"];
//    [myToolBar.firstButton  addTarget:self action:@selector(phoneOnToolBar)  forControlEvents:UIControlEventTouchUpInside];
//    [myToolBar.secondButton addTarget:self action:@selector(sendSMS)   forControlEvents:UIControlEventTouchUpInside];
//    [myToolBar.thirdButton  addTarget:self action:@selector(email:) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:myToolBar];
    
    if (System_Version_Small_Than_(7)) {
        _tableview.backgroundColor = [UIColor cloudsColor];
        _tableview.opaque = NO;
        _tableview.backgroundView = nil;
    }

}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 1;
    }else if (section == 2) {
        return 3;
    }else {
        return 2;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    if (indexPath.section == 0) {
        CellIdentifier = @"baseinfo";
    }else if (indexPath.section == 1){
        CellIdentifier = @"mail";
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            CellIdentifier = @"mobile";
        }else if (indexPath.row == 1){
            CellIdentifier = @"shortno";
        }else if (indexPath.row == 2){
            CellIdentifier = @"officeno";
        }
    }else if(indexPath.section == 3){
        if (indexPath.row == 0) {
            CellIdentifier = @"department";
        }else if (indexPath.row == 1){
            CellIdentifier = @"officeplace";
        }
    }

    UITableViewCell *cell;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    if (System_Version_Small_Than_(7)) {
        UIView* bgView = [[UIView alloc] initWithFrame:cell.bounds];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        cell.backgroundView = bgView;
        
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cell.contentView.bounds), CGRectGetWidth(cell.contentView.bounds), 0.5)];
        [v setBackgroundColor:[UIColor lightGrayColor]];
        if (indexPath.section == 2){
            if (indexPath.row != 2) {
                [cell.contentView addSubview:v];
            }
        }else if(indexPath.section == 3){
            if (indexPath.row == 0) {
                [cell.contentView addSubview:v];
            }
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }else if (indexPath.section == 1){
        return 60;
    }else{
        return 44;
    }
}

/**
 *  Reducing the space between sections of the UITableView
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return
 */
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 15;
    return 10.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}
@end
