//
//  ODEvaluationView.m
//  ODApp
//
//  Created by Bracelet on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODEvaluationView.h"

#import "ODHelp.h"

@implementation ODEvaluationView

- (void)awakeFromNib {
    self.layer.borderColor = [UIColor lineColor].CGColor;
    self.layer.borderWidth = 0.5f;
}

- (void)setTaskModel:(ODEvaluationModel *)taskModel {
    self.contentLabel.text = [NSString stringWithFormat:@"%@", taskModel.comment];
}

- (void)setSkillModel:(ODSecondEvaluationModel *)skillModel {
    if ([skillModel.reason isEqualToString:@""]) {
        float reason_num = [skillModel.reason_num floatValue];
        NSArray *array = @[ @"非常不满意", @"不满意", @"一般", @"满意", @"非常满意" ];
        for (int i = 0; i < array.count; i++) {
            if (reason_num == i) {
            }
        }
    }
    else {
        self.contentLabel.text = skillModel.reason;
    }
}


@end
