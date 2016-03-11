//
//  ODAddressCell.h
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODOrderAddressModel.h"

@interface ODAddressCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property(weak, nonatomic) IBOutlet UILabel *addressLabel;
@property(weak, nonatomic) IBOutlet UILabel *lineLabel;
@property(nonatomic, strong) ODOrderAddressDefModel *model;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineonstraint;



@property(nonatomic, copy) NSString *isDefault;

@end
