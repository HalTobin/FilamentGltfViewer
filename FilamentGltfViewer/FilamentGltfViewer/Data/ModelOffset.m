#import "ModelOffset.h"

@implementation ModelOffset

- (instancetype)initWithX:(NSNumber *)x
                        y:(NSNumber *)y
                        z:(NSNumber *)z
{
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
        _z = z;
    }
    return self;
}

@end
