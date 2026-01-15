#import "FilamentModel.h"

@implementation FilamentModel

- (instancetype) initWithUrl:(NSURL *)url
                        name:(NSString *)name
                       scale:(NSNumber *)scale
                      offset:(ModelOffset *)offset
{
    self = [super init];
    if (self) {
        _url = url;
        _name = [name copy];
        _scale = scale;
        _offset = offset;
    }
    return self;
}

- (instancetype) initWithUrl:(NSURL *)url
                        name:(NSString *)name
                      offset:(ModelOffset *)offset
{
    self = [super init];
    if (self) {
        _url = url;
        _name = [name copy];
        _offset = offset;
    }
    return self;
}

- (instancetype) initWithUrl:(NSURL *)url
                        name:(NSString *)name
                       scale:(NSNumber *)scale
{
    self = [super init];
    if (self) {
        _url = url;
        _name = [name copy];
        _scale = scale;
    }
    return self;
}

- (instancetype) initWithUrl:(NSURL *)url
                        name:(NSString *)name
{
    self = [super init];
    if (self) {
        _url = url;
        _name = [name copy];
        _scale = nil;
        _offset = nil;
    }
    return self;
}

@end
