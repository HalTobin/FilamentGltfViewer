#import <Foundation/Foundation.h>

@class ModelOffset;

NS_ASSUME_NONNULL_BEGIN

@interface ModelOffset : NSObject

@property (nonatomic, strong, readonly) NSNumber *x;
@property (nonatomic, strong, readonly) NSNumber *y;
@property (nonatomic, strong, readonly) NSNumber *z;

- (instancetype)initWithX:(NSNumber *)x
                        y:(NSNumber *)y
                        z:(NSNumber *)z NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
