#import "FILARSwiftViewController.h"
#import "FilamentArViewController.h"
#import <FilamentGltfViewer/FilamentScene.h>
#import <FilamentGltfViewer/ModelTapHandler.h>

@implementation FILARSwiftViewController {
    // We use FilamentArViewController as the internal implementation
    FilamentArViewController* _impl;
    id _model;
}

- (instancetype)initWithScene:(FilamentScene *)scene {
    self = [super init];
    if (self) {
        // Ensure we always use the AR-capable controller
        _impl = [[FilamentArViewController alloc] init];
        // Note: FilamentArViewController.mm currently doesn't have a custom initWithScene,
        // so we use the default init and can pass scene data if you extend it later.
    }
    return self;
}

- (instancetype)initWithScene:(FilamentScene *)scene
                   onModelTap:(ModelTapHandler)onModelTap {
    self = [self initWithScene:scene];
    if (self) {
        // Placeholder for onModelTap logic if FilamentArViewController is updated
        // to support tap callbacks similar to FILViewController.
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // standard VC containment setup
    [self addChildViewController:_impl];
    _impl.view.frame = self.view.bounds;
    _impl.view.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.view addSubview:_impl.view];
    [_impl didMoveToParentViewController:self];
    
    // Future-proofing: Load model if it was set before view was loaded
    if (_model != nil) {
        [self loadModel:_model];
    }
}

- (bool)loadModel:(id)model {
    _model = model;
    // FilamentArViewController currently lacks loadModel:
    // This check prevents crashes while you work on the implementation.
    if ([_impl respondsToSelector:@selector(loadModel:)]) {
        return [(id)_impl loadModel:model];
    }
    return false;
}

- (void)unloadModel {
    _model = nil;
    // Future-proofing for when you add unload logic to FilamentArViewController
    if ([_impl respondsToSelector:@selector(unloadModel)]) {
        [(id)_impl unloadModel];
    }
}

@end
