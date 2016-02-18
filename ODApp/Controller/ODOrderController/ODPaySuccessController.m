//
//  ODPaySuccessController.m
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPaySuccessController.h"
#import "ODPaySuccessView.h"
@interface ODPaySuccessController ()

@property (nonatomic , strong) ODPaySuccessView *paySuccessView;


@end

@implementation ODPaySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"支付订单";
    [self.view addSubview:self.paySuccessView];

    
}


#pragma mark - 懒加载
- (ODPaySuccessView *)paySuccessView
{
    if (_paySuccessView == nil) {
              
        self.paySuccessView = [[ODPaySuccessView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
        
        
    }
    return _paySuccessView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
