//
//  SKBrowseNewsController.m
//  NewZhongYan
//
//  Created by lilin on 13-10-25.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKBrowseNewsController.h"
#import "DMLazyScrollView.h"
#import "SKNewsAttachController.h"
#import "SKECMAttahController.h"
@interface SKBrowseNewsController ()
{
    //SKNewsAttachController* controller;
}
@end

@implementation SKBrowseNewsController
@synthesize contentList,viewControllers,kNumberOfPages,currentDictionary;

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

- (IBAction)onHelpButtonClick:(UIButton *)sender {
    UIImageView* helpImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [helpImage setImage:[UIImage imageNamed:IS_IPHONE_5? @"iphone5_cms_detailed" : @"iphone4_cms_detailed"]];
    [helpImage setUserInteractionEnabled:YES];
    [helpImage setTag:1111];
    [self.view.window addSubview:helpImage];
    
    UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapForHelpImage:)];
    [helpImage addGestureRecognizer:tapGes];
    [helpImage fallIn:.4 delegate:nil completeBlock:^{
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }];
}

-(void)dataFromDB
{
    NSString* sql = [NSString stringWithFormat:@"select TID,ATTS,TITL,strftime('%%Y-%%m-%%d %%H:%%M',CRTM) CRTM,AUNAME,READED from T_NEWS where ENABLED = 1 ORDER BY CRTM DESC;"];
    self.contentList = [NSMutableArray arrayWithArray:[[DBQueue sharedbQueue] recordFromTableBySQL:sql]];
    self.kNumberOfPages = [self.contentList count];
}

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

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self dataFromDB];
    }
    return self;
}

-(NSInteger)currentPage
{
    for (NSMutableDictionary* dict in self.contentList) {
        if ([[self.currentDictionary objectForKey:@"TID"] isEqualToString:[dict objectForKey:@"TID"]]) {
            if ([self.contentList containsObject:dict]) {
                return [self.contentList  indexOfObject:dict];
            }
        }
    }
    return 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    KinitialPage = [self currentPage];
    viewControllerArray = [[NSMutableArray alloc] initWithCapacity:kNumberOfPages];
    for (NSUInteger k = 0; k < kNumberOfPages; ++k) {
        [viewControllerArray addObject:[NSNull null]];
    }
    __weak SKBrowseNewsController* browser =self;
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
    if (KinitialPage == 0 && index == kNumberOfPages - 1) {
        return nil;
    }
    if (index > viewControllerArray.count || index < 0) return nil;
    id res = [viewControllerArray objectAtIndex:index];
    if (res == [NSNull null])
    {
        SKNewsAttachController *controller = [viewControllerArray objectAtIndex:index];
        if ((NSNull *)controller == [NSNull null])
        {
            controller = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"SKNewsAttachController"];
            controller.news = [self.contentList objectAtIndex:index];
            [viewControllerArray replaceObjectAtIndex:index withObject:controller];
        }
        [viewControllerArray replaceObjectAtIndex:index withObject:controller];
        return controller;
        
//        SKECMAttahController *controller = [viewControllerArray objectAtIndex:index];
//        if ((NSNull *)controller == [NSNull null])
//        {
//            controller = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"SKECMAttahController"];
//            controller.news = [self.contentList objectAtIndex:index];
//            [viewControllerArray replaceObjectAtIndex:index withObject:controller];
//        }
//        [viewControllerArray replaceObjectAtIndex:index withObject:controller];
//        return controller;
    }
    return res;
}


@end
