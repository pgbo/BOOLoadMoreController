//
//  ViewController.m
//  Sample
//
//  Created by guangbool on 2017/4/24.
//  Copyright © 2017年 bool. All rights reserved.
//

#import "ViewController.h"
#import "BOOLoadMoreController.h"
#import "SimpleLoadMoreView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) BOOLoadMoreController *loadMoreController;
@property (nonatomic) SimpleLoadMoreView *loadMoreView;
@property (nonatomic) UITableView *tableView;

@property (nonatomic) NSMutableArray<NSString *> *titles;

@end

@implementation ViewController

- (NSMutableArray<NSString *> *)titles {
    if (!_titles) {
        _titles = [NSMutableArray<NSString *> array];
    }
    return _titles;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

- (SimpleLoadMoreView *)loadMoreView {
    if (!_loadMoreView) {
        _loadMoreView = [[SimpleLoadMoreView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        _loadMoreView.textForIdle = @"pull up to load more";
        _loadMoreView.textForPulling = @"release to load right now";
    }
    return _loadMoreView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView addSubview:({
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, CGRectGetWidth([UIScreen mainScreen].bounds), 30)];
        tipLabel.font = [UIFont systemFontOfSize:20];
        tipLabel.textColor = [UIColor grayColor];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"Try to pull up right now! ";
        tipLabel;
    })];
    
    [self.tableView addSubview:self.loadMoreView];
    self.loadMoreView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    CGFloat loadMoreHeight = [self.loadMoreView intrinsicContentSize].height;
    
    self.loadMoreController = [[BOOLoadMoreController alloc] initWithObservable:self.tableView];
//    self.loadMoreController.loadThreshold = loadMoreHeight;
    
    // auto load more, set loadThreshold = 0
    self.loadMoreController.loadThreshold = 0;
    
    self.loadMoreController.extraBottomInsetWhenLoading = loadMoreHeight;
    __weak typeof(self)weakSelf = self;
    self.loadMoreController.stateWillChangeBlock = ^(BOOLoadMoreController *controller, BOOLoadMoreControlState current, BOOLoadMoreControlState willState) {
        if ([weakSelf.loadMoreView respondsToSelector:@selector(loadMoreStateWillChangeFromCurrent:toState:)]) {
            [weakSelf.loadMoreView loadMoreStateWillChangeFromCurrent:current toState:willState];
        }
    };
    
    self.loadMoreController.stateDidChangedBlock = ^(BOOLoadMoreController *controller, BOOLoadMoreControlState old, BOOLoadMoreControlState currentState) {
        
        if ([weakSelf.loadMoreView respondsToSelector:@selector(loadMoreStateDidChangedFromOld:toCurrentState:)]) {
            [weakSelf.loadMoreView loadMoreStateDidChangedFromOld:old toCurrentState:currentState];
        }
        if (controller.state == BOOLoadMoreControlStateIdle) {
            weakSelf.loadMoreView.frame = CGRectMake(0, controller.scrollViewVisiableAreaMaxY, CGRectGetWidth([UIScreen mainScreen].bounds), loadMoreHeight);
        }
    };
    
    self.loadMoreController.pullingPercentChangeBlock = ^(BOOLoadMoreController *refreshController, CGFloat pullingPercent){
        if ([weakSelf.loadMoreView respondsToSelector:@selector(loadMorePullingPercentChangeTo:)]) {
            [weakSelf.loadMoreView loadMorePullingPercentChangeTo:pullingPercent];
        }
    };
    
    self.loadMoreController.finishLoadAnimationBlock = ^(BOOLoadMoreController *controller){
        if ([weakSelf.loadMoreView respondsToSelector:@selector(loadMoreAnimateWhenFinishRefresh)]) {
            [weakSelf.loadMoreView loadMoreAnimateWhenFinishRefresh];
        }
    };
    
    self.loadMoreController.loadMoreExecuteBlock = ^(BOOLoadMoreController *controller){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!weakSelf) return;
            NSUInteger currentCount = weakSelf.titles.count;
            NSMutableArray<NSString *> *newInserts = [NSMutableArray<NSString *> array];
            for (NSInteger i = 0; i < 15; i ++) {
                [newInserts addObject:@(i+currentCount).stringValue];
            }
            [weakSelf.titles addObjectsFromArray:newInserts];
            [weakSelf.tableView reloadData];
            [weakSelf.loadMoreController finishLoadingWithDelay:0];
        });
    };
    
    self.loadMoreController.scrollContentSizeChangedBlock = ^(BOOLoadMoreController *controller){
        if (controller.state == BOOLoadMoreControlStateIdle) {
            weakSelf.loadMoreView.frame = CGRectMake(0, controller.scrollViewVisiableAreaMaxY, CGRectGetWidth([UIScreen mainScreen].bounds), loadMoreHeight);
        }
    };
    
    self.loadMoreView.frame = CGRectMake(0, self.loadMoreController.scrollViewVisiableAreaMaxY, CGRectGetWidth([UIScreen mainScreen].bounds), loadMoreHeight);
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.textLabel.text = self.titles[indexPath.row];
    
    return cell;
}


@end
