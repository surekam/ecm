//
//  SKECMSearchController.m
//  NewZhongYan
//
//  Created by lilin on 14-1-8.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKECMSearchController.h"
#import "DDXMLNode.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "Paper.h"
#import "SKTableViewCell.h"
@interface UIButton(network)
- (void)startLoadData:(BOOL)show;
@end

@implementation UIButton(network)

- (void)startLoadData:(BOOL)show {
	if(show) {
		UIActivityIndicatorView *progress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		UIView *progressView = [[UIView alloc] initWithFrame: self.bounds];
        [self addSubview:progressView];
        [self setTitle:@"正在加载..." forState:UIControlStateNormal];
        [progressView setTag:1001];
        [self setEnabled:NO];
        [progressView addSubview: progress];
        CGPoint p =  progressView.center;
        p.x -= 90;
		progress.center = p;
		[progress startAnimating];
	} else {
		[self setEnabled:YES];
        [[self viewWithTag:1001] removeFromSuperview];
	}
}
@end

@implementation SKECMSearchController
@synthesize moreBtn = _moreBtn;
-(void)initNavBar
{
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    UIImage* navbgImage;
    if (System_Version_Small_Than_(7)) {
        navbgImage = [UIImage imageNamed:@"navbar44"] ;
        self.navigationController.navigationBar.tintColor = COLOR(0, 97, 194);
    }else{
        [self setNeedsStatusBarAppearanceUpdate];
        self.navigationController.navigationBar.translucent = YES;
        navbgImage = [UIImage imageNamed:@"navbar64"] ;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    [self.navigationController.navigationBar setBackgroundImage:navbgImage  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
}

-(void)initData
{
    
    _dataArray = [[NSMutableArray alloc] init];
    pageindex = 1;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setFrame:CGRectMake(15, 4.5, 290, 41)];
    [_moreBtn setTitle:@"远程查询" forState:UIControlStateNormal];
    [_moreBtn setHidden:YES];
    [_moreBtn setBackgroundImage:Image(@"contentview_graylongbutton") forState:UIControlStateNormal];
    [_moreBtn setBackgroundImage:Image(@"contentview_graylongbutton_highlighted") forState:UIControlStateHighlighted];
    [_moreBtn setBackgroundImage:Image(@"contentview_graylongbutton_highlighted") forState:UIControlStateSelected];
    [_moreBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_moreBtn];
    [self.tableView setTableFooterView:view];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (object == _dataArray && [keyPath isEqualToString:@"count"]) {
        NSLog(@"%@",change);
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSURL* queryurl = [SKECMURLManager queryTitleWith:pageindex ECMContent:@"中烟" ChannelID:@""];
    SKHTTPRequest* request = [SKHTTPRequest requestWithURL:queryurl];
    __weak SKHTTPRequest* req = request;
    [request setCompletionBlock:^{
        DDXMLDocument* mainDoc = [[DDXMLDocument alloc] initWithData:req.responseData options:0 error:0];
        NSArray* array = [mainDoc nodesForXPath:@"//paper" error:nil];
        for (DDXMLElement* e in array) {
            Paper* p = [Paper new];
            p.paperid = [[e nodesForXPath:@"paperid" error:0][0] stringValue];
            p.channelid = [[e nodesForXPath:@"channelid" error:0][0] stringValue];
            p.title = [[e nodesForXPath:@"title" error:0][0] stringValue];
            p.content = [[e nodesForXPath:@"content" error:0][0] stringValue];
            p.time = [[e nodesForXPath:@"time" error:0][0] stringValue];
            p.author = [[e nodesForXPath:@"author" error:0][0] stringValue];
            p.url = [[e nodesForXPath:@"url" error:0][0] stringValue];
            [_dataArray addObject:p];
        }
        [self.tableView reloadData];
        if (_dataArray.count < 20 ) {
            [_moreBtn setHidden:YES];
        }else{
            [_moreBtn setHidden:NO];
            [_moreBtn setTitle:array.count < 20 ? @"没有更多了" :@"下一页" forState:UIControlStateNormal];
            pageindex ++;
        }
        
    }];
    
    [request setFailedBlock:^{
        NSLog(@"%@",req.error);
        [_moreBtn setHidden:YES];
    }];
    [request startAsynchronous];
    [searchBar resignFirstResponder];
}

-(void)nextPage
{
    NSURL* queryurl = [SKECMURLManager queryTitleWith:pageindex ECMContent:@"中烟" ChannelID:@""];
    NSLog(@"%@",queryurl);
    SKHTTPRequest* request = [SKHTTPRequest requestWithURL:queryurl];
    __weak SKHTTPRequest* req = request;
    [request setCompletionBlock:^{
        DDXMLDocument* mainDoc = [[DDXMLDocument alloc] initWithData:req.responseData options:0 error:0];
        NSArray* array = [mainDoc nodesForXPath:@"//paper" error:nil];
        for (DDXMLElement* e in array) {
            Paper* p = [Paper new];
            p.paperid = [[e nodesForXPath:@"paperid" error:0][0] stringValue];
            p.channelid = [[e nodesForXPath:@"channelid" error:0][0] stringValue];
            p.title = [[e nodesForXPath:@"title" error:0][0] stringValue];
            p.content = [[e nodesForXPath:@"content" error:0][0] stringValue];
            p.time = [[e nodesForXPath:@"time" error:0][0] stringValue];
            p.author = [[e nodesForXPath:@"author" error:0][0] stringValue];
            p.url = [[e nodesForXPath:@"url" error:0][0] stringValue];
            [_dataArray addObject:p];
        }
        [self.tableView reloadData];
        if (_dataArray.count < 20 ) {
            [_moreBtn setHidden:YES];
        }else{
            [_moreBtn setHidden:NO];
            [_moreBtn setTitle:array.count < 20 ? @"没有更多了" :@"下一页" forState:UIControlStateNormal];
            [_moreBtn startLoadData:NO];
            pageindex ++;
        }
        
    }];
    
    [request setFailedBlock:^{
        NSLog(@"%@",req.error);
        [_moreBtn setHidden:YES];
        [_moreBtn startLoadData:NO];
    }];
    [request startAsynchronous];
    [_moreBtn startLoadData:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initNavBar];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* identify = @"newscell";
    SKTableViewCell*  cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[SKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    [cell setECMPaperInfo:_dataArray[indexPath.row]];
    [cell resizeCellHeight];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Paper* paper = _dataArray[indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize size = [paper.title sizeWithFont:font constrainedToSize:CGSizeMake(270, 220) lineBreakMode:NSLineBreakByTruncatingTail];
    return size.height + 30;
}
@end
