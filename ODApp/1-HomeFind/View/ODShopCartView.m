//
//  ODShopCartView.m
//  ODApp
//
//  Created by 王振航 on 16/3/31.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODShopCartView.h"

@interface ODShopCartView()

@property (weak, nonatomic) IBOutlet UIView *leftView;

@end

@implementation ODShopCartView

- (void)awakeFromNib
{
    UITapGestureRecognizer *gas =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickShopCart)];
    [self.leftView addGestureRecognizer:gas];
}

+ (instancetype)shopCart
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)clickShopCart
{
    NSLogFunc;
}

@end
