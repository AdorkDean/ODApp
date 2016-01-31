//
//  ODSkillDetailController.m
//  ODApp
//
//  Created by 代征钏 on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODSkillDetailController.h"

@interface ODSkillDetailController ()

@end

static NSString *const ODSkillDetailReusableVIEW = @"ODSkillDetailReusableView";
@implementation ODSkillDetailController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"e6e6e6" alpha:1];
    
    self.navigationItem.title = self.personTitle;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithType:(ODBarButtonImageLeft) target:self action:@selector(backClick:) image:nil highImage:nil textColor:[UIColor colorWithHexString:@"#000000" alpha:1] highColor:nil title:@"返回"];
    
    [self createSkillDetailView];
    [self creatPayView];
}

- (void)backClick:(UIButton *)button
{

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)createSkillDetailView{

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height - 55)];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    
    self.titleLabel = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 150) / 2, 10, 150, 20) text:@"我去＊代买早饭" font:16 alignment:@"center" color:@"#000000" alpha:1];
    self.priceLabel = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 100) / 2, CGRectGetMaxY(self.titleLabel.frame) + 5, 100, 20) text:@"10元 / 次" font:15 alignment:@"center" color:@"#000000" alpha:1];
    
    self.contentLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(10, CGRectGetMaxY(self.priceLabel.frame) + 10, kScreenSize.width - 20,[ODHelp textHeightFromTextString:@"dfsdfsdf" width:kScreenSize.width - 10 miniHeight:20 fontSize:14] ) text:@"dfdfs" font:14 alignment:@"left" color:@"#000000" alpha:1];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.priceLabel];
    [self.scrollView addSubview:self.contentLabel];
    
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height);
    [self.view addSubview:self.scrollView];
    
}

- (void)creatPayView
{
    
    self.payView = [ODClassMethod creatViewWithFrame:CGRectMake(0, kScreenSize.height - 54, kScreenSize.width, 54) tag:0 color:@"#ffffff"];
    self.collectButton = [ODClassMethod creatButtonWithFrame:CGRectMake(0, 0, 80, 54) target:self sel:@selector(collectButtonClick:) tag:0 image:nil title:@"" font:0];
    self.collectImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(15, 20, 15, 15) imageName:@"Skills profile page_icon_Collection" tag:0];
    UILabel *collectLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(35, 20, 30, 15) text:@"收藏" font:15 alignment:@"left" color:@"#000000" alpha:1];
    collectLabel.userInteractionEnabled = NO;
    
    self.payButton = [ODClassMethod creatButtonWithFrame:CGRectMake(80, 0, kScreenSize.width - 80, 54) target:self sel:@selector(payButtonClick:) tag:0 image:@"" title:@"立即购买" font:15];
    [self.payButton setTitleColor:[UIColor colorWithHexString:@"#ffffff" alpha:1] forState:UIControlStateNormal];
    self.payButton.backgroundColor = [UIColor redColor];
    
    [self.payView addSubview:self.collectButton];
    [self.payView addSubview:self.collectImageView];
    [self.payView addSubview:collectLabel];
    [self.payView addSubview:self.payButton];
    [self.view addSubview:self.payView];
}

- (void)collectButtonClick:(UIButton *)button
{

    
}

- (void)payButtonClick:(UIButton *)button
{
    
    ODOrderController *vc = [[ODOrderController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
