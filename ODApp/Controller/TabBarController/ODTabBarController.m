//
//  ODTabBarController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODTabBarController.h"
#import "ODPersonalCenterViewController.H"
@interface ODTabBarController ()

@end

@implementation ODTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createViewControllers];
    [self setTabBar];
}

- (void)createViewControllers
{
    NSArray *controllerArray = @[@"HomeFoundViewController",@"CenterActivityViewController",@"BazaarViewController",@"CommumityViewController",@"LandMainController"];
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < controllerArray.count; i++) {
        
        NSString * str = [NSString stringWithFormat:@"OD%@",controllerArray[i]];
        Class vcClass = NSClassFromString(str);
        UIViewController *controller = [[vcClass alloc]init];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:controller];
        navController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
        [mArray addObject:navController];
    }
    self.viewControllers = mArray;
}

-(void)setTabBar
{
    self.tabBar.hidden = YES;
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,kScreenSize.height - 55,kScreenSize.width, 55)];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    [self.view addSubview:self.imageView];
    
    NSArray *titleArray = @[@"首页发现",@"中心活动",@"欧动集市",@"欧动社区",@"个人中心"];
    NSArray *imageArray = @[@"icon_home-find",@"icon_Center - activity",@"icon_market",@"icon_community",@"icon_Personal Center"];
    
    for (NSInteger i = 0 ; i < titleArray.count; i++) {
        
        //此处必须用UIButtonTypeCustom
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //        button.frame = CGRectMake(0.5 * space + (30+space)*i, 5, 30, 30);
        button.frame = CGRectMake((kScreenSize.width/5)*i, 0, kScreenSize.width/5, 55);
        button.tag = i+1;
        //        [button setBackgroundImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@默认态",imageArray[i]]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        //        [button setBackgroundImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@点击态",imageArray[i]]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.imageView addSubview:button];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenSize.width/5-25)/2, 7.5, 25, 25)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_default",imageArray[i]]];
        if (i==0) {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Selected",imageArray[i]]];
        }
        imageView.tag = i+6;
        [button addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((kScreenSize.width/5)*i,37 , kScreenSize.width/5, 18)];
        label.text = titleArray[i];
        label.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
        label.font = [UIFont systemFontOfSize:11];
        label.textAlignment = NSTextAlignmentCenter;
        [self.imageView addSubview:label];
    }
    UIButton *button= (UIButton *)[self.imageView viewWithTag:1];
    button.selected = YES;
}

-(void)buttonClick:(UIButton *)button
{
    
    NSArray *imageArray = @[@"icon_home-find",@"icon_Center - activity",@"icon_market",@"icon_community",@"icon_Personal Center"];
    NSInteger index = button.tag-1;
    if (index == 4 && [[ODUserInformation getData].openID isEqualToString:@""])
    {
        ODPersonalCenterViewController *vc = [[ODPersonalCenterViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        self.selectedIndex = index;
        if (index != 4)
        {
            self.currentIndex = self.selectedIndex;
        }
    }
    
    
    
    
    
    for (NSInteger i = 0; i<5; i++) {
        UIButton *newButton= (UIButton *)[self.imageView viewWithTag:1+i];
        UIImageView *imageView = (UIImageView *)[newButton viewWithTag:6+i];
        
        
        
        
        if (i!=index) {
            newButton.selected =NO;
            button.selected = YES;
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_default",imageArray[i]]];
            
        }else{
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Selected",imageArray[i]]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
