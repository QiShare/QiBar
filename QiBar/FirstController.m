//
//  ViewController.m
//  QiNavigationBar
//
//  Created by wangdacheng on 2019/3/26.
//  Copyright © 2019 dac_1033. All rights reserved.
//

#import "FirstController.h"
#import "BarStyleViewController.h"
#import "CustomNavBarController.h"
#import "LargeTitleTableViewController.h"

#define Margin        15

@interface FirstController ()

@end

@implementation FirstController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"FirstController"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.prefersLargeTitles = NO;
}

- (void)setupViews {
    
    CGFloat btnHeight = 50;
    CGSize size = self.view.frame.size;
    NSArray *titles = @[@"BarStyle", @"LargeTitle", @"CustomNavBar"];
    CGFloat offset = Margin;
    for (int idx=0; idx<titles.count; idx++) {
        NSString *title = [titles objectAtIndex:idx];
        UIButton *button = [self createCustomButton:title];
        button.frame = CGRectMake(Margin, offset, size.width - Margin * 2, btnHeight);
        button.tag = 100 + idx;
        [self.view addSubview:button];
        offset += btnHeight;
    }
}

- (UIButton *)createCustomButton:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}


#pragma mark - Actions

- (void)buttonClicked:(UIButton *)button {
    
    if (button.tag == 100) {
        BarStyleViewController *barStyle = [[BarStyleViewController alloc] init];
        [self.navigationController pushViewController:barStyle animated:YES];
    } else if (button.tag == 101) {
        LargeTitleTableViewController *largeTitle = [[LargeTitleTableViewController alloc] init];
        [self.navigationController pushViewController:largeTitle animated:YES];
    } else if (button.tag == 102) {
        CustomNavBarController *customNavBar = [[CustomNavBarController alloc] init];
        [self.navigationController pushViewController:customNavBar animated:YES];
    } else if (button.tag == 103) {
        
    }
}




@end
