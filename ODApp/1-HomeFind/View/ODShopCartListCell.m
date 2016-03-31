//
//  ODShopCartListCell.m
//  ODApp
//
//  Created by 王振航 on 16/3/31.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODShopCartListCell.h"
#import "ODTakeOutModel.h"

@interface ODShopCartListCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation ODShopCartListCell

- (void)awakeFromNib {
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTakeOut:(ODTakeOutModel *)takeOut
{
    _takeOut = takeOut;
    self.titleLabel.text = takeOut.title;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", takeOut.shopNumber];
    self.priceLabel.text = [NSString stringWithFormat:@"%@", takeOut.price_show];
}

- (IBAction)plusButtonClick:(id)sender {
    NSInteger number = [self.numberLabel.text integerValue];
    if (number < 0) return;
//    if (number >= 0)
//    {
        number += 1;
//    }
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", number];
}

- (IBAction)minusButtonClick:(id)sender {
    NSInteger number = [self.numberLabel.text integerValue];
    if (number <= 0) return;
//    if (number > 0)
//    {
        number -= 1;
        
        if (number == 0)
        {
            
//            UITableView *tableView = (UITableView *)self.superview;
////            NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
////            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self.datas removeObject:self.takeOut];
//            [tableView reloadData];
            if ([self.delegate respondsToSelector:@selector(shopCartListcell:RemoveCurrentRow:)])
            {
                [self.delegate shopCartListcell:self RemoveCurrentRow:self.takeOut];
            }
        }
//    }
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", number];
}

@end
