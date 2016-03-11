//
//  ODStorePlaceListModel.h
//  ODApp
//
//  Created by 刘培壮 on 16/3/8.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODStorePlaceListModel : NSObject

@property (nonatomic, assign) int id;

@property (nonatomic, copy) NSString *name;

@end

ODRequestResultIsArrayProperty(ODStorePlaceListModel)