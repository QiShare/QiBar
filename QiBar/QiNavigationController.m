//
//  QiNavigationController.m
//  QiNavigationBar
//
//  Created by wangdacheng on 2019/3/26.
//  Copyright © 2019 dac_1033. All rights reserved.
//

#import "QiNavigationController.h"


@interface QiNavigationController ()

@end

@implementation QiNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    
    return self.topViewController;
}


- (UIViewController *)childViewControllerForStatusBarHidden {
    
    return self.topViewController;
}



@end
