//
//  ODShopCartView.m
//  ODApp
//
//  Created by 王振航 on 16/3/31.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODShopCartView.h"
#import "ODTakeOutModel.h"

#import "ODShopCartListCell.h"

#import <MJExtension.h>

@interface ODShopCartView() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *leftView;

@property (nonatomic, strong) NSArray *datasArray;

@end

static NSString * const shopCartListCell = @"ODShopCartListCell";

@implementation ODShopCartView

- (UITableView *)shopCartView
{
    if (!_shopCartView)
    {
        _shopCartView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, CGFLOAT_MIN) style:UITableViewStylePlain];
        _shopCartView.dataSource = self;
        _shopCartView.delegate = self;
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self.shopCartView];
        
        // 取消分割线
        _shopCartView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 注册cell
        [_shopCartView registerNib:[UINib nibWithNibName:NSStringFromClass([ODShopCartListCell class]) bundle:nil] forCellReuseIdentifier:shopCartListCell];
    }
    return _shopCartView;
}

- (void)awakeFromNib
{
    UITapGestureRecognizer *gas =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickShopCart)];
    [self.leftView addGestureRecognizer:gas];
    
    self.numberLabel.layer.cornerRadius = 7.5;
    self.numberLabel.layer.masksToBounds = YES;
}

+ (instancetype)shopCart
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)setShops:(NSMutableDictionary *)shops
{
    _shops = shops;
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in shops)
    {
        NSDictionary *userDict = shops[dict];
        
        self.datasArray = [NSMutableArray array];
        
        [arrayM addObject:userDict];
    }
    
    self.datasArray = [ODTakeOutModel mj_objectArrayWithKeyValuesArray:arrayM];
    // 逆序
    self.datasArray = [[self.datasArray reverseObjectEnumerator] allObjects];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODShopCartListCell *cell = [tableView dequeueReusableCellWithIdentifier:shopCartListCell];
    cell.takeOut = self.datasArray[indexPath.row];
    return cell;
}


- (void)clickShopCart
{
    self.isOpened = !self.isOpened;
    
    if (self.isOpened) {
        CGFloat height = self.shops.count * 44;
        self.shopCartView.frame = CGRectMake(0, KScreenHeight - height - 55, KScreenWidth, height);
    } else {
        self.shopCartView.od_height = 0;
    }
    [self.shopCartView reloadData];
}

@end
