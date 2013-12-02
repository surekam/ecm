//
//  SKSearchCell.h
//  NewZhongYan
//
//  Created by lilin on 13-10-29.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKLabel.h"

@interface SKSearchCell : UITableViewCell
{
    __weak IBOutlet SKLabel *titleLabel;
    __weak IBOutlet UIImageView *stateView;
    __weak IBOutlet UIImageView *attachView;
    __weak IBOutlet UILabel *crtmLabel;
}

-(void)setDataDictionary:(NSDictionary*)dictionary;
-(void)setKeyWord:(NSString*)key;
-(void)setKeyWordArray:(NSMutableArray*)keyArray;
-(void)setCMSInfo:(NSDictionary*)info;
-(void)resizeCellHeight;
@end
