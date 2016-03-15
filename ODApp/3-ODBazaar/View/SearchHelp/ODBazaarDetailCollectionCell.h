//
//  ODBazaarDetailCollectionCell.h
//  ODApp
//
//  Created by Odong-YG on 16/1/8.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODBazaarDetailModel.h"
#import "UIImageView+WebCache.h"

@interface ODBazaarDetailCollectionCell : UICollectionViewCell

@property(weak, nonatomic) IBOutlet UIImageView *imageV;
@property(weak, nonatomic) IBOutlet UILabel *nickLabel;
@property(weak, nonatomic) IBOutlet UILabel *signLabel;

@property(nonatomic,strong)ODBazaarDetailApplysModel *model ;

@end
