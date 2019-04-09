//
//  SecViewController.m
//  QiNavigationBar
//
//  Created by wangdacheng on 2019/3/26.
//  Copyright © 2019 dac_1033. All rights reserved.
//

#import "BarStyleViewController.h"


#define Margin      15

@interface BarStyleViewController ()

@end

@implementation BarStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"BarStyle"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

- (void)setupNavBarStyle {
    
    // 设置导航栏属性
    NSDictionary  *textAttributes=@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:30]};
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
    
    // 设置导航栏背景图
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_handscene_timing"] forBarMetrics:UIBarMetricsDefault];
    
    // 允许大标题
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}


- (void)setupViews {
    
    CGFloat btnHeight = 60;
    CGSize size = self.view.frame.size;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(Margin, 50, size.width - Margin * 2, btnHeight);
    [button1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitle:@"修改状态栏颜色" forState:UIControlStateNormal];
    button1.tag = 100;
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(Margin, 150, size.width - Margin * 2, btnHeight);
    [button2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitle:@"是否显示大标题" forState:UIControlStateNormal];
    button2.tag = 101;
    [self.view addSubview:button2];
}


#pragma mark - Actions

static bool flag = YES;
- (void)buttonClicked:(UIButton *)button {
    
    flag = !flag;
    if (button.tag == 100) {
        
        UIStatusBarStyle style = flag ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
        [UIApplication sharedApplication].statusBarStyle = style;
        
    } else if (button.tag == 101) {
        
        NSString *title = flag ? @"点击收起" : @"点击展开";
        [button setTitle:title forState:UIControlStateNormal];
        self.navigationController.navigationBar.prefersLargeTitles = flag;
    }
}




@end

