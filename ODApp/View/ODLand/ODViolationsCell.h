//
//  ODViolationsCell.h
//  ODApp
//
//  Created by zhz on 16/1/28.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODBazaarModel.h"
@interface ODViolationsCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *reasonTextView;

@property (nonatomic ,strong) ODBazaarModel *model;

@end
