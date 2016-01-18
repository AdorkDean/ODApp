//
//  ODEvaluationCell.h
//  ODApp
//
//  Created by zhz on 16/1/18.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODEvaluationModel.h"
#import "ODEvaluationModel.h"
@interface ODEvaluationCell : UICollectionViewCell

@property (nonatomic , strong) UILabel *contentLabel;

@property (nonatomic , strong) ODEvaluationModel *model;

+(CGFloat)returnHight:(ODEvaluationModel *)model;

@end
