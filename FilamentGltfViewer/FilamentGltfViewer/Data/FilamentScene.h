#import <Foundation/Foundation.h>

@class FilamentScene;

NS_ASSUME_NONNULL_BEGIN

@interface FilamentScene : NSObject

@property (nonatomic, strong, readonly, nullable) NSURL *envSkyboxPath;
@property (nonatomic, strong, readonly, nullable) NSURL *envIblPath;

- (instancetype)initWithEnvSkyboxPath:(nullable NSURL *)envSkyboxPath
                          envIblPath:(nullable NSURL *)envIblPath NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
