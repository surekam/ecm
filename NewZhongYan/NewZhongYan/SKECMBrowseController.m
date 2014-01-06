//
//  SKECMBrowseController.m
//  NewZhongYan
//
//  Created by lilin on 14-1-3.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKECMBrowseController.h"
#import "SKECMAttahController.h"

@implementation SKECMBrowseController
@synthesize contentList,viewControllers,kNumberOfPages,currentDictionary;

#pragma mark -DMLazyScrollView delegate
- (void)lazyScrollViewDidEndDecelerating:(DMLazyScrollView *)pagingView atPageIndex:(NSInteger)pageIndex
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[DBQueue sharedbQueue] updateDataTotableWithSQL:[NSString stringWithFormat:
                                                          @"update T_NEWS set READED = 1 where TID  = '%@'",
                                                          [[self.contentList objectAtIndex:pageIndex] objectForKey:@"TID"]]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newsStateChanged"
                                                            object:0
                                                          userInfo:
         [NSDictionary dictionaryWithObjectsAndKeys:[[self.contentList objectAtIndex:pageIndex] objectForKey:@"TID"],@"TID", nil]];
    });
}


-(NSInteger)currentPage
{
    for (NSMutableDictionary* dict in self.contentList) {
        NSLog(@"%@  %@",[self.currentDictionary objectForKey:@"AID"],[dict objectForKey:@"AID"]);
        if ([[self.currentDictionary objectForKey:@"AID"] isEqualToString:[dict objectForKey:@"AID"]]) {
            if ([self.contentList containsObject:dict]) {
                return [self.contentList  indexOfObject:dict];
            }
        }
    }
    return 0;
}

-(void)dataFromDB
{
    NSString* sql = [NSString stringWithFormat:@"select (case when(strftime('%%s','now','start of day','-8 hour','-1 day') >= strftime('%%s',crtm)) then 1 else 0 end ) as bz,AID,TITL, ATTRLABLE,PMS,URL,strftime('%%Y-%%m-%%d %%H:%%M',CRTM) CRTM,strftime('%%s000',UPTM) UPTM from T_DOCUMENTS where CHANNELID in (%@) and ENABLED = 1  ORDER BY CRTM DESC;",self.channel.FIDLIST];
    self.contentList = [NSMutableArray arrayWithArray:[[DBQueue sharedbQueue] recordFromTableBySQL:sql]];
    self.kNumberOfPages = [self.contentList count];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self dataFromDB];
    KinitialPage = [self currentPage];
    viewControllerArray = [[NSMutableArray alloc] initWithCapacity:kNumberOfPages];
    for (NSUInteger k = 0; k < kNumberOfPages; ++k) {
        [viewControllerArray addObject:[NSNull null]];
    }
    __weak SKECMBrowseController* browser =self;
    _lazyScrollView.dataSource = ^(NSUInteger index) {
        return [browser controllerAtIndex:index];
    };
    
    _lazyScrollView.numberOfPages = kNumberOfPages;
    _lazyScrollView.controlDelegate = self;
    [_lazyScrollView setCurrentPage:KinitialPage];
    [_lazyScrollView setPage:KinitialPage animated:NO];
    
}

- (UIViewController *) controllerAtIndex:(NSInteger) index
{
    if (index > viewControllerArray.count || index < 0) return nil;
    id res = [viewControllerArray objectAtIndex:index];
    if (res == [NSNull null])
    {
        SKECMAttahController *controller = [viewControllerArray objectAtIndex:index];
        if ((NSNull *)controller == [NSNull null])
        {
            controller = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"SKECMAttahController"];
            controller.news = [self.contentList objectAtIndex:index];
            [viewControllerArray replaceObjectAtIndex:index withObject:controller];
        }
        [viewControllerArray replaceObjectAtIndex:index withObject:controller];
        return controller;
    }
    return res;
}
@end
