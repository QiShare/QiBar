//
//  QiTabBarController.m
//  QiBar
//
//  Created by wangdacheng on 2019/4/8.
//  Copyright © 2019 dac_1033. All rights reserved.
//

#import "QiTabBarController.h"
#import "QiNavigationController.h"
#import "FirstController.h"
#import "SecondController.h"

@interface QiTabBarController () <UITabBarControllerDelegate>

@property (strong, nonatomic) NSMutableArray<UIImage *> *imgArr;

@end

@implementation QiTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildControllers];
    [self setTabBarStyle];
    [self initImages];
}

- (void)setupChildControllers {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    
    FirstController *first = [[FirstController alloc] init];
    QiNavigationController *firstNav = [[QiNavigationController alloc] initWithRootViewController:first];
    firstNav.tabBarItem.title = @"FirTab";
    firstNav.tabBarItem.image = [[UIImage imageNamed:@"tab_team_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    firstNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_team_50"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    SecondController *second = [[SecondController alloc] init];
    QiNavigationController *secondNav = [[QiNavigationController alloc] initWithRootViewController:second];
    secondNav.tabBarItem.title = @"SecTab";
    secondNav.tabBarItem.image = [[UIImage imageNamed:@"tab_mine_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    secondNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_mine_50"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.viewControllers = @[firstNav, secondNav];
}

- (void)setTabBarStyle {
    
    //去掉TabBar顶部的线
    UITabBar *tabBar = self.tabBar;
    [tabBar setShadowImage:[UIImage new]];
    [tabBar setBackgroundImage:[UIImage new]];
    tabBar.translucent = NO;

    for (UITabBarItem *item in self.tabBar.items) {
        // 设置UITabBarItem中title样式
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]} forState:UIControlStateSelected];

        // 设置UITabBarItem中按钮大小，及img与title间距
        [item setImageInsets:UIEdgeInsetsMake(-3, 0, 3, 0)];
    }
}

- (void)initImages {
    
    _imgArr = [NSMutableArray array];
    for (int i=0; i<51; i++) {
        NSString *name = [NSString stringWithFormat:@"tab_team_%02d", i];
        UIImage *image = [UIImage imageNamed:name];
        [_imgArr addObject:image];
    }
}

- (CAAnimation *)getCustomAnimation {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //速度控制函数，控制动画运行的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.2;
    animation.repeatCount = 1;
    animation.autoreverses = YES;
    animation.fromValue = [NSNumber numberWithFloat:0.7];
    animation.toValue = [NSNumber numberWithFloat:1.2];
    
    return animation;
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    NSInteger index = [tabBarController.childViewControllers indexOfObject:viewController];
    
    UIButton *tabBarBtn = tabBarController.tabBar.subviews[index+1];
    UIImageView *imageView = tabBarBtn.subviews.firstObject;
    
    if (index == 0) {
        [imageView stopAnimating];
        imageView.animationImages = _imgArr;
        imageView.animationRepeatCount = 1;
        imageView.animationDuration = 0.7;
        [imageView startAnimating];
    } else {
        static NSString *tabBarBtnAnimationKey = @"tabBarBtnAnimationKey";
        [imageView.layer removeAnimationForKey:tabBarBtnAnimationKey];
        [imageView.layer addAnimation:[self getCustomAnimation] forKey:tabBarBtnAnimationKey];
    }
    
    return YES;
}



@end
