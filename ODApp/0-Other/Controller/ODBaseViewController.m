//
//  ODBaseViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODBaseViewController ()

@end

@implementation ODBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];
    self.noResultLabel = [[ODNoResultLabel alloc] init];
}

- (void)dealloc
{
    NSLogFunc
}

@end
