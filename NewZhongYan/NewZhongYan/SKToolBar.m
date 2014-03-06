//
//  SKToolBar.m
//  ZhongYan
//
//  Created by linlin on 8/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKToolBar.h"
#import "APPUtils.h"
#import "SKViewController.h"
@implementation SKToolBar
@synthesize homeButton,searchButton,refreshButton;

-(void)backToRoot:(id)sender
{
    SKViewController* controller = [APPUtils AppRootViewController];
    [controller.navigationController popToRootViewControllerAnimated:YES];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //home 
        UIImage * NBgImage = [UIImage imageNamed:@"btn_home_bg.png"];
        UIImage * NInImage = [UIImage imageNamed:@"btn_particular_home.png"];
        UIImage * NImage = [NBgImage splitImageWithImage:NInImage
                                                   Rect:CGRectMake((NBgImage.size.width - NInImage.size.width)/2, 10,
                                                                   NInImage.size.width, NInImage.size.height)];
        
        //home 
        UIImage * HBgImage = [UIImage imageNamed:@"btn_home_bg_pressed.png"];
        UIImage * HInImage = [UIImage imageNamed:@"btn_particular_home_pressed.png"];
        UIImage * HImage = [HBgImage splitImageWithImage:HInImage
                                                    Rect:CGRectMake((HBgImage.size.width - HInImage.size.width)/2, 10,
                                                                    HInImage.size.width, HInImage.size.height)];
        
        homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [homeButton setFrame:CGRectMake(2, 0, 49, 49)];
        [homeButton setImage:NImage forState:UIControlStateNormal];
        [homeButton setImage:HImage forState:UIControlStateHighlighted];
        [self addSubview:homeButton];
        
        //search text
        UILabel* homeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        homeLabel.text = @"首页";
        homeLabel.textAlignment = UITextAlignmentCenter;
        homeLabel.backgroundColor = [UIColor clearColor];
        homeLabel.textColor = [UIColor colorWithRed:0 green:48.0/255 blue:161.0/255 alpha:1];
        homeLabel.font = [UIFont systemFontOfSize:10];
        CGPoint labelCenter = homeButton.center;
        labelCenter.y += 15;
        [homeLabel setCenter:labelCenter];
        [self addSubview:homeLabel];
        
        //右边的背景图片
        UIImage* image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zoom_bg" ofType:@"png"]];
        UIImageView * bgImageView = [[UIImageView alloc] initWithImage:image];
        [bgImageView setFrame:CGRectMake(320 - 200, 0, 200, 49)];
        [self addSubview:bgImageView];
        
        //search
        searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchButton setFrame:CGRectMake(120, 0, 100, 48)];
        [searchButton setImage:[UIImage imageNamed:@"btn_search.png"]  forState:UIControlStateNormal];
        [searchButton setImageEdgeInsets:UIEdgeInsetsMake(8, 20, 8, 48)];
        [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [searchButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:searchButton];
        
        refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [refreshButton setFrame:CGRectMake(210, 0, 100, 48)];
        [refreshButton setImageEdgeInsets:UIEdgeInsetsMake(8, 20, 8, 48)];
        [refreshButton setImage:[UIImage imageNamed:@"btn_refresh.png"] forState:UIControlStateNormal];
        [refreshButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [refreshButton setTitle:@"同步" forState:UIControlStateNormal];
        [self addSubview:refreshButton];
        
        [homeButton addTarget:self action:@selector(backToRoot:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame Target:(id)target FirstAction:(SEL)firstaction SecondAction:(SEL)secondaction
{
    self = [self initWithFrame:frame];
    if (self) {
        [searchButton addTarget:target action:firstaction forControlEvents:UIControlEventTouchUpInside];
        [refreshButton addTarget:target action:secondaction forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(id)initMaintainWithFrame:(CGRect)frame Target:(id)target Action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //home
        UIImage * NBgImage = [UIImage imageNamed:@"btn_home_bg.png"];
        UIImage * NInImage = [UIImage imageNamed:@"btn_particular_home.png"];
        UIImage * NImage = [NBgImage splitImageWithImage:NInImage
                                                    Rect:CGRectMake((NBgImage.size.width - NInImage.size.width)/2, 10,
                                                                    NInImage.size.width, NInImage.size.height)];
        
        //home
        UIImage * HBgImage = [UIImage imageNamed:@"btn_home_bg_pressed.png"];
        UIImage * HInImage = [UIImage imageNamed:@"btn_particular_home_pressed.png"];
        UIImage * HImage = [HBgImage splitImageWithImage:HInImage
                                                    Rect:CGRectMake((HBgImage.size.width - HInImage.size.width)/2, 10,
                                                                    HInImage.size.width, HInImage.size.height)];
        
        homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [homeButton setFrame:CGRectMake(2, 0, 49, 49)];
        [homeButton setImage:NImage forState:UIControlStateNormal];
        [homeButton setImage:HImage forState:UIControlStateHighlighted];
        [self addSubview:homeButton];
        
        //search text
        UILabel* homeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        homeLabel.text = @"首页";
        homeLabel.textAlignment = UITextAlignmentCenter;
        homeLabel.backgroundColor = [UIColor clearColor];
        homeLabel.textColor = [UIColor colorWithRed:0 green:48.0/255 blue:161.0/255 alpha:1];
        homeLabel.font = [UIFont systemFontOfSize:10];
        CGPoint labelCenter = homeButton.center;
        labelCenter.y += 15;
        [homeLabel setCenter:labelCenter];
        [self addSubview:homeLabel];
        
        //右边的背景图片
        UIImage* image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zoom_bg" ofType:@"png"]];
        UIImageView * bgImageView = [[UIImageView alloc] initWithImage:image];
        [bgImageView setFrame:CGRectMake(320 - 200, 0, 200, 49)];
        [self addSubview:bgImageView];
        
        UIButton* clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearBtn setTitle:@"一键清除" forState:UIControlStateNormal];
        [clearBtn setFrame:bgImageView.frame];
        [clearBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clearBtn];
        [homeButton addTarget:self action:@selector(backToRoot:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame FirstTarget:(id)firsttarget FirstAction:(SEL)firstaction
      SecondTarget:(id)secondtarget SecondAction:(SEL)secondaction
{
    self = [self initWithFrame:frame];
    if (self) {
        [searchButton addTarget:firsttarget action:firstaction forControlEvents:UIControlEventTouchUpInside];
        [refreshButton addTarget:secondtarget action:secondaction forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)addFirstTarget:(id)target action:(SEL)action
{
    if (action && target) {
        [searchButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)addSecondTarget:(id)target action:(SEL)action
{
    if (action && target) {
        [refreshButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)setFirstTarget:(id)target action:(SEL)action
{
    for (id target in [searchButton allTargets]) {
        [searchButton removeTarget:target action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    }
    if (action && target) {
        [searchButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)setSecondTarget:(id)target action:(SEL)action
{
    for (id target in [refreshButton allTargets]) {
        [refreshButton removeTarget:target action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (action && target) {
        [refreshButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
}
@end
