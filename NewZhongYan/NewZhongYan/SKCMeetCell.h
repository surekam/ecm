//
//  SKCMeetCell.h
//  NewZhongYan
//
//  Created by lilin on 13-11-7.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKCMeetCell : UITableViewCell
{
    __weak IBOutlet UILabel* TITLLabel;
    __weak IBOutlet UILabel* STIMELabel;//start
    __weak IBOutlet UILabel* ETIMELabel;//end
    __weak IBOutlet UIImageView *RStateView;
    __weak IBOutlet UIImageView *ATTACHView;
}


-(void)resizeTheHeight;
-(void)setDataDictionary:(NSDictionary*)dictionary Section:(NSInteger)section;
-(void)resizeCellHeight;
-(void)setCMSInfo:(NSDictionary*)info Section:(NSInteger)section;
@end
