//
//  SKCMeetCell.m
//  NewZhongYan
//
//  Created by lilin on 13-11-7.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKCMeetCell.h"

@implementation SKCMeetCell
{
    UILabel* _TITLLabel;
    UILabel* _STIMELabel;//start
    UILabel* _ETIMELabel;//end
    UILabel* _MeetAddrLabel;//addition
    UIImageView *_RStateView;
    UIImageView *_ATTACHView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _RStateView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_read.png"]];
        [self addSubview:_RStateView];
        
        _TITLLabel = [[UILabel alloc] init];
        [_TITLLabel setFont: [UIFont fontWithName:@"Helvetica" size:16.]];
        [_TITLLabel setNumberOfLines:0];
        [_TITLLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [self addSubview:_TITLLabel];
        
        _STIMELabel = [[UILabel alloc] init];
        //[_STIMELabel setBackgroundColor:COLOR(17, 168, 171)];
        [_STIMELabel setFont:[UIFont systemFontOfSize:12]];
        [_STIMELabel setTextAlignment:NSTextAlignmentRight];
        [_STIMELabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_STIMELabel];
        
        _ETIMELabel = [[UILabel alloc] init];
        //[_ETIMELabel setBackgroundColor:COLOR(17, 168, 171)];
        [_ETIMELabel setFont:[UIFont systemFontOfSize:12]];
        [_ETIMELabel setTextAlignment:NSTextAlignmentRight];
        [_ETIMELabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_ETIMELabel];
        
        _MeetAddrLabel = [[UILabel alloc] init];
        //[_MeetAddrLabel setBackgroundColor:COLOR(17, 168, 171)];
        [_MeetAddrLabel setFont:[UIFont systemFontOfSize:12]];
        [_MeetAddrLabel setTextAlignment:NSTextAlignmentRight];
        [_MeetAddrLabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_MeetAddrLabel];
        
        _ATTACHView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cms_attachment.png"]];
        [self addSubview:_ATTACHView];
    }
    return self;
}

-(void)resizeCellHeight
{
    CGFloat contentWidth = 280;
    CGFloat height = [_TITLLabel.text sizeWithFont:_TITLLabel.font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:NSLineBreakByCharWrapping].height;
    [_TITLLabel  setFrame:CGRectMake(25, 10, 280, height)];
    [_RStateView setFrame:CGRectMake(5,CGRectGetMidY(_TITLLabel.frame) - 7.5, 15, 15)];
    [_STIMELabel setFrame:CGRectMake(180, height + 12, 128, 20)];
    [_ETIMELabel setFrame:CGRectMake(180, height + 32, 128, 20)];
    [_MeetAddrLabel setFrame:CGRectMake(20, height + 32, 128, 20)];
    [_ATTACHView setFrame:CGRectMake(25, height + 32, 30, 15)];
}

-(void)setCMSInfo:(NSDictionary*)info Section:(NSInteger)section
{
    if ([info.allKeys containsObject:@"TITL"]) {
        _TITLLabel.text = [info objectForKey:@"TITL"];
    }
    
    _STIMELabel.text = [NSString stringWithFormat:@"开始: %@",[[[info objectForKey:@"BGTM"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:16]];
    _ETIMELabel.text = [NSString stringWithFormat:@"结束: %@",[[[info objectForKey:@"EDTM"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:16]];
    
    [_ATTACHView setHidden:![self containAttachement:info]];
    if (info[@"ADDITION"] == [NSNull null]) {
        NSLog(@"info[@ADDITION] %@",info[@"ADDITION"]);
    }
    
    if (    [info[@"ADDITION"] isEqual:[NSNull null]]) {
        NSLog(@"info[@ADDITION]111 %@",info[@"ADDITION"]);
    }
    if (!section) {
        [_RStateView  setImage:[UIImage imageNamed:@"icon_unread"]];
    }else{
        [_RStateView  setImage:[UIImage imageNamed:@"icon_read"]];
    }
}

//重新布局
-(void)resizeTheHeight
{
    CGFloat height = [_TITLLabel.text sizeWithFont:_TITLLabel.font constrainedToSize:CGSizeMake(280, 220) lineBreakMode:NSLineBreakByCharWrapping].height;
    [_TITLLabel  setFrame:CGRectMake(25, 10, 280, height)];
    [_RStateView setFrame:CGRectMake(5,CGRectGetMidY(_TITLLabel.frame) - 7.5, 15, 15)];
    [_STIMELabel setFrame:CGRectMake(67, height + 12, 241, 20)];
    [_ETIMELabel setFrame:CGRectMake(67, height + 32, 241, 20)];
    [_ATTACHView setFrame:CGRectMake(25, height + 32, 30, 15)];
}

-(BOOL)containAttachement:(NSDictionary*)dict
{
    return [[[dict objectForKey:@"ATTS"] componentsSeparatedByString:@","] count] > 1;
}
@end
