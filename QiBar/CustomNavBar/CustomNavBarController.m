//
//  MenuTableViewController.m
//  QiNavigationBar
//
//  Created by wangdacheng on 2019/3/26.
//  Copyright © 2019 dac_1033. All rights reserved.
//

#import "CustomNavBarController.h"

@interface CustomNavBarController ()

@property(nonatomic, strong) UIView *navBarView;

@end

@implementation CustomNavBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CustomNavBar";
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setPrefersLargeTitles:YES];
    }
    
    [self setupNavBarView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setPrefersLargeTitles:NO];
    }
    
    [_navBarView removeFromSuperview];
    [self.navigationController.navigationBar removeObserver:self forKeyPath:@"frame"];
}

- (void)setupNavBarView {
    
    CGFloat margin = 100;
    CGSize size = self.navigationController.navigationBar.bounds.size;
    _navBarView = [[UIView alloc] initWithFrame:CGRectMake(margin, 0, size.width - margin * 2, size.height)];
    [_navBarView setBackgroundColor:[UIColor cyanColor]];
    [self.navigationController.navigationBar addSubview:_navBarView];

    // KVO监听
    [self.navigationController.navigationBar addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}


#pragma mark - 监听navBar的frame

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"frame"]) {
        [self navBarFrameChanged];
    }
}

- (void) navBarFrameChanged {
    
    CGRect frame = _navBarView.frame;
    frame.size.height = self.navigationController.navigationBar.frame.size.height;
    _navBarView.frame = frame;
    [_navBarView layoutIfNeeded];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"MenuTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"菜单行";
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

@end
