//
//  SKGridController.m
//  NewZhongYan
//
//  Created by lilin on 13-12-13.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKGridController.h"
#import "DDXMLDocument.h"
#import "DDXMLElementAdditions.h"
#import "DDXMLElement.h"
#import "UIButton+WebCache.h"

@interface SKGridController ()
{
    NSMutableArray *upButtons;
}
@end

@implementation SKGridController
-(void)initView
{
    upButtons = [[NSMutableArray alloc] init];
    NSArray* array = [[DBQueue sharedbQueue] recordFromTableBySQL:@"select * from T_CHANNEL WHERE OWNERAPP = 'company';"];
    for (int i=0;i<array.count;i++)
    {
        NSDictionary *dict=[array objectAtIndex:i];
        UIDragButton *dragbtn=[[UIDragButton alloc] initWithFrame:CGRectZero inView:self.view];
        [dragbtn setTitle:dict[@"NAME"]];
        [dragbtn.tapButton setImageWithURL:[NSURL URLWithString:dict[@"LOGO"]] forState:UIControlStateNormal];
        [dragbtn setNormalImage:dict[@"NAME"]];
        [dragbtn setLocation:up];
        [dragbtn setDelegate:self];
        [dragbtn setTag:i];
        //[dragbtn.tapButton addTarget:self action:@selector(jumpToController:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:dragbtn];
        [upButtons addObject:dragbtn];
    }

    [self setUpButtonsFrameWithAnimate:NO withoutShakingButton:nil];
}

- (void)setUpButtonsFrameWithAnimate:(BOOL)_bool withoutShakingButton:(UIDragButton *)shakingButton
{
    int count = [upButtons count];
    if (shakingButton != nil) {
        [UIView animateWithDuration:_bool ? 0.4 : 0 animations:^{
            for (int y = 0; y <= count / 3; y++) {
                for (int x = 0; x < 3; x++) {
                    int i = 3 * y + x;
                    if (i < count) {
                        UIDragButton *button = (UIDragButton *)[upButtons objectAtIndex:i];
                        if (button.tag != shakingButton.tag){
                            [button setFrame:CGRectMake(40 + x * 90,  40 + y * 96.6, 60, 60)];
                        }
                        //[button setLastCenter:CGPointMake(CGRectGetMidX(button.frame),CGRectGetMidY(button.frame))];
                        [button setLastCenter:CGPointMake(40 + x * 90 + 30,  40 + y * 96.6 + 30)];
                    }
                }
            }
        }];
    }else{
        [UIView animateWithDuration:_bool ? 0.4 : 0 animations:^{
            for (int y = 0; y <= count / 3; y++) {
                for (int x = 0; x < 3; x++) {
                    int i = 3 * y + x;
                    if (i < count) {
                        UIDragButton *button = (UIDragButton *)[upButtons objectAtIndex:i];
                        [button setFrame:CGRectMake(40 + x * 90, 40 + y * 96.6, 60, 60)];
                        [button setLastCenter:CGPointMake(40 + x * 90 + 30,  40 + y * 96.6 + 30)];
                    }
                }
            }
        }];
    }
}

- (void)checkLocationOfOthersWithButton:(UIDragButton *)shakingButton
{
    if (shakingButton.location == up)
    {
        for (int i = 0; i < [upButtons count]; i++)
        {
            UIDragButton *button = (UIDragButton *)[upButtons objectAtIndex:i];
            if (button.tag != shakingButton.tag)
            {
                CGRect intersectionRect=CGRectIntersection(shakingButton.frame, button.frame);//两个按钮接触的大小
                if (intersectionRect.size.width>15&&intersectionRect.size.height>25)
                {
                    [upButtons exchangeObjectAtIndex:i withObjectAtIndex:[upButtons indexOfObject:shakingButton]];
                    [self setUpButtonsFrameWithAnimate:YES withoutShakingButton:shakingButton];
                    //[self writeDataToXml];
                    break;
                }
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

@end
