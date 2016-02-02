/** 定义模型 */
#define ODModelResult @"result"

#define ODRequestClassName(className)       NSClassFromString([NSStringFromClass(className)stringByAppendingString:@"Response"])

#define ODRequestModelProperty(className) \
@interface className##Response : NSObject\
@property (nonatomic, strong) NSArray *result;\
@property (nonatomic, copy)NSString *status;\
@end


#define ODRequestArrayToModel(className) \
@implementation className##Response \
+ (void)initialize \
{ \
[className##Response mj_setupObjectClassInArray:^NSDictionary *{ \
return @{ \
ODModelResult : [className class] \
}; \
}]; \
} \
@end

