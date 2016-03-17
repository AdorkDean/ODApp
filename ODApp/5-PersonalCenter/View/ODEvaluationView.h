//
//  ODEvaluationView.h
//  ODApp
//
//  Created by Bracelet on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ODEvaluationModel.h"
#import "ODSecondEvaluationModel.h"

@interface ODEvaluationView : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) ODEvaluationModel *taskModel;
@property (nonatomic, strong) ODSecondEvaluationModel *skillModel;


@end
