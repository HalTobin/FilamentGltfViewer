//
//  FILSwiftViewController.mm
//  FilamentGltfViewer
//
//  Created by Alexis ANEAS on 14/01/2026.
//

#import "FILSwiftViewController.h"
#import "FILViewController.h"

@implementation FILSwiftViewController {
    FILViewController* _impl;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _impl = [[FILViewController alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addChildViewController:_impl];
    _impl.view.frame = self.view.bounds;
    _impl.view.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.view addSubview:_impl.view];
    [_impl didMoveToParentViewController:self];
}

@end
