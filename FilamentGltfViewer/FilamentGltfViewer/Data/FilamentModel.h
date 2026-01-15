#import <Foundation/Foundation.h>

@class ModelOffset;

NS_ASSUME_NONNULL_BEGIN

@interface FilamentModel : NSObject

@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly, nullable) NSNumber *scale;
@property (nonatomic, strong, readonly, nullable) ModelOffset *offset;

- (instancetype)initWithUrl:(NSURL *)url
                       name:(NSString *)name NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithUrl:(NSURL *)url
                       name:(NSString *)name
                      scale:(nullable NSNumber *)scale NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithUrl:(NSURL *)url
                       name:(NSString *)name
                     offset:(nullable ModelOffset *)offset NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithUrl:(NSURL *)url
                       name:(NSString *)name
                      scale:(nullable NSNumber *)scale
                     offset:(nullable ModelOffset *)offset NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
