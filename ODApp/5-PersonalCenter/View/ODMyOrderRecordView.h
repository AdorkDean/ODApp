//
//  ODMyOrderRecordView.h
//  ODApp
//
//  Created by Bracelet on 16/3/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ODMyOrderrecordModel.h"


@interface ODMyOrderRecordView : UITableViewCell


- (void)showDatawithModel:(ODMyOrderRecordModel *)model;



@property(weak, nonatomic) IBOutlet UILabel *centerPurposeDetailLabel;


@property(weak, nonatomic) IBOutlet UILabel *centerNameDetailLabel;


@property(weak, nonatomic) IBOutlet UILabel *timeDetailLabel;

@property(weak, nonatomic) IBOutlet UILabel *checkStateLabel;



@end
