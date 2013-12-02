//
//  SKSearchCell.m
//  NewZhongYan
//
//  Created by lilin on 13-10-29.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKSearchCell.h"

@implementation SKSearchCell
{
    SKLabel *_titleLabel;
    UIImageView *_stateView;
    UIImageView *_attachView;
    UILabel *_crtmLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[SKLabel alloc] init];
        [_titleLabel setFrame:CGRectMake(25, 10, 280, 40)];
        [_titleLabel setFont: [UIFont fontWithName:@"Helvetica" size:16.]];
        [_titleLabel setNumberOfLines:0];
        [_titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [self addSubview:_titleLabel];
        
        _crtmLabel = [[UILabel alloc]init];
        [_crtmLabel setBackgroundColor:[UIColor clearColor]];
        [_crtmLabel setFont:[UIFont systemFontOfSize:12]];
        [_crtmLabel setTextAlignment:NSTextAlignmentRight];
        [_crtmLabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_crtmLabel];
        
        _attachView = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"cms_attachment.png"]];
        [self addSubview:_attachView];
        
        _stateView = [[UIImageView alloc]init];
        [self addSubview:_stateView];
    }
    return self;
}

-(void)resizeCellHeight
{
    CGFloat contentWidth = 280;
    CGFloat height = [_titleLabel.text sizeWithFont:[UIFont systemFontOfSize:16]
                                  constrainedToSize:CGSizeMake(contentWidth, 220)
                                      lineBreakMode:NSLineBreakByCharWrapping].height;
    [_titleLabel  setFrame:CGRectMake(25, 8, 280, height)];
    [_stateView   setFrame:CGRectMake(5, CGRectGetMidY(_titleLabel.frame) - 7.5, 15, 15)];
    [_attachView  setFrame:CGRectMake(25,CGRectGetMaxY(_titleLabel.frame)+5, 30, 15)];
    [_crtmLabel   setFrame:CGRectMake(205,CGRectGetMaxY(_titleLabel.frame)+5, 100, 21)];
}

-(void)setCMSInfo:(NSDictionary*)info
{
    if ([info.allKeys containsObject:@"TITL"]) {
        _titleLabel.text =  [info objectForKey:@"TITL"];
    }
    
    if ([info.allKeys containsObject:@"CRTM"]) {
        NSString* crtm = [info objectForKey:@"CRTM"];
        if (crtm.length > 16) {//这种情况可能出现在远程查询
            NSDate   *notifyDate = [DateUtils stringToDate:crtm DateFormat:dateTimeFormat];
            NSString *notifyTime = [DateUtils dateToString:notifyDate DateFormat:displayDateTimeFormat];
            crtm = [notifyTime substringToIndex:16];
        }
        [_crtmLabel setText:crtm];
    }
    
    [_attachView setHidden:![self containAttachement:info]];
    if (![[info objectForKey:@"READED"] intValue]) {
        [_stateView  setImage:
         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_unread" ofType:@"png"]]];
    }else{
        [_stateView setImage:
         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_read" ofType:@"png"]]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


-(BOOL)containAttachement:(NSDictionary*)dict
{
    if ([[dict allKeys] containsObject:@"ATTS"]) {
        return  [[[dict objectForKey:@"ATTS"] componentsSeparatedByString:@","] count] > 1;
    }else{
        return NO;
    }
}

//渲染该cell
-(void)setDataDictionary:(NSDictionary*)dictionary
{
    if ([dictionary.allKeys containsObject:@"TITL"]) {
        titleLabel.text =  [dictionary objectForKey:@"TITL"];
    }
    if ([dictionary.allKeys containsObject:@"CRTM"]) {
        NSString* crtm = [dictionary objectForKey:@"CRTM"];
        if (crtm.length > 16 ) {
            [crtmLabel setText: [[crtm stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:16]];
        }else{
            [crtmLabel setText:[dictionary objectForKey:@"CRTM"]];
        }
    }
    
    [attachView setHidden:![self containAttachement:dictionary]];
    if (![[dictionary objectForKey:@"READED"] intValue]) {
        [stateView  setImage:
         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_unread" ofType:@"png"]]];
    }else{
        [stateView setImage:
         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_read" ofType:@"png"]]];
    }
}

-(void)setKeyWord:(NSString*)key
{
    //[titleLabel addKeyWord:key];
    [_titleLabel addKeyWord:key];
}

-(void)setKeyWordArray:(NSMutableArray*)keyArray
{
    //[titleLabel setKeyWordArray:keyArray];
    [_titleLabel setKeyWordArray:keyArray];

}
@end
