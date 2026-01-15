#import "FilamentScene.h"

@implementation FilamentScene

- (instancetype)initWithEnvSkyboxPath:(NSURL *)envSkyboxPath
                          envIblPath:(NSURL *)envIblPath
{
    self = [super init];
    if (self) {
        _envSkyboxPath = envSkyboxPath;
        _envIblPath = envIblPath;
    }
    return self;
}

@end
