//
//  SKSToolBar.m
//  ZhongYan
//
//  Created by linlin on 10/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKSToolBar.h"
#import "UIImage+rescale.h"
#import "APPUtils.h"
@implementation SKSToolBar
@synthesize homeButton,firstButton,secondButton;
@synthesize firstLabel,secondLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //homeN 
        UIImage * NBgImage = [UIImage imageNamed:@"btn_home_bg.png"];
        UIImage * NInImage = [UIImage imageNamed:@"btn_particular_home.png"];
        UIImage * NImage = [NBgImage splitImageWithImage:NInImage
                                                    Rect:CGRectMake((NBgImage.size.width - NInImage.size.width)/2, 10,
                                                                    NInImage.size.width, NInImage.size.height)];
        
        //homeH 
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
        
        //first
        firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [firstButton setImage:[UIImage imageNamed:@"btn_call"] forState:UIControlStateNormal];
        [self addSubview:firstButton];
        
        //second
        secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [secondButton setImage:[UIImage imageNamed:@"btn_sms"] forState:UIControlStateNormal];
        [self addSubview:secondButton];
    }
    return self;
}

-(void)setFirstItem:(NSString*)imageName Title:(NSString*)title
{
    [firstButton setFrame:CGRectMake(120, 0, 100, 48)];
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(8, 20, 8, 48)];
    [firstButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [firstButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [firstButton setTitle:title forState:UIControlStateNormal];
}

-(void)setSecondItem:(NSString*)imageName Title:(NSString*)title
{
    [secondButton setFrame:CGRectMake(210, 0, 100, 48)];
    [secondButton setImageEdgeInsets:UIEdgeInsetsMake(8, 20, 8, 48)];
    [secondButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [secondButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [secondButton setTitle:title forState:UIControlStateNormal];
}

-(void)setFirstItem:(NSString*)imageName Title:(NSString*)title Target:(id)target action:(SEL)action
{
    [self setFirstItem:imageName Title:title];
    [firstButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

-(void)setSecondItem:(NSString*)imageName Title:(NSString*)title Target:(id)target action:(SEL)action
{
    [self setSecondItem:imageName Title:title];
    [secondButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

-(void)addFirstTarget:(id)target action:(SEL)action
{
    [firstButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

-(void)addSecondTarget:(id)target action:(SEL)action
{
    [secondButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
