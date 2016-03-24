
/** .m 不包含数组的模型的内部实现 */
#define ODRequestModelImplementation(className) \
@implementation className  \
@end

/** .h  请求回来的result是数组的情况 */
#define ODRequestResultIsArrayProperty(className) \
@interface className##Response : NSObject\
@property (nonatomic, strong) NSArray *result;\
@property (nonatomic, copy)NSString *status;\
@end

/** .m  请求回来的result数组的内部元素转化成模型实现 */
#define ODRequestResultIsArrayImplementation(className) \
@implementation className##Response \
+ (void)initialize \
{ \
[className##Response mj_setupObjectClassInArray:^NSDictionary *{ \
return @{ \
@"result" : [className class] \
}; \
}]; \
} \
@end

/**  .m 综合实现请求回来的result是数组的情况 */
#define ODRequestResultIsArrayAll(className) \
ODRequestResultIsArrayProperty(className) \
ODRequestResultIsArrayImplementation(className)

/**  .h  请求回来的result是字典的情况 */
#define ODRequestResultIsDictionaryProperty(className) \
@interface className##Response : NSObject\
@property (nonatomic, strong) className *result;\
@property (nonatomic, copy)NSString *status;\
@end


/**  .m  请求回来的result字典的内部元素转化成模型实现 */
#define ODRequestResultIsDictionaryImplementation(className) \
@implementation className##Response\
@end


/**  .m 综合实现请求回来的result是字典的情况 */
#define ODRequestResultIsDictionaryAll(className) \
ODRequestResultIsDictionaryProperty(className) \
ODRequestResultIsDictionaryImplementation(className)
