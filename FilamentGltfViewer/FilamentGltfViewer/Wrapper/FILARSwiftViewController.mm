#import "FILARSwiftViewController.h"
#import "FilamentArViewController.h"
#import <FilamentGltfViewer/FilamentScene.h>
#import <FilamentGltfViewer/ModelTapHandler.h>

#if !TARGET_OS_SIMULATOR

@implementation FILARSwiftViewController {
    FilamentArViewController* _impl;
    FilamentModel* _model;
}

- (instancetype)initWithScene:(FilamentScene *)scene {
    self = [super init];
    if (self) {
        _impl = [[FilamentArViewController alloc] initWithScene:scene];
    }
    return self;
}

- (instancetype)initWithScene:(FilamentScene *)scene
                   onModelTap:(ModelTapHandler)onModelTap {
    self = [super init];
    if (self) {
        _impl = [[FilamentArViewController alloc] initWithScene:scene onModelTap:onModelTap];
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
    
    if (_model != nil) {
        [_impl loadModel:_model];
    }
}

- (bool)loadModel:(FilamentModel *)model {
    _model = model;
    return [_impl loadModel:model];
}

- (void)unloadModel {
    _model = nil;
    [_impl unloadModel];
}

- (UIImage *)captureSnapshot {
    if (_impl) {
        return [_impl captureSnapshot];
    }
    return nil;
}

- (void)setOnModelVisibilityUpdate:(ModelVisibilityHandler)onModelVisibilityUpdate {
    _onModelVisibilityUpdate = onModelVisibilityUpdate;
    if (_impl) {
        _impl.onModelVisibilityUpdate = onModelVisibilityUpdate;
    }
}

@end

#else

@implementation FILARSwiftViewController

- (instancetype)initWithScene:(FilamentScene *)scene {
    return [super init];
}

- (instancetype)initWithScene:(FilamentScene *)scene
                   onModelTap:(ModelTapHandler)onModelTap {
    return [super init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (bool)loadModel:(id)model {
    return false;
}

- (void)unloadModel {
}

- (UIImage *)captureSnapshot {
    return nil;
}

- (void)setOnModelVisibilityUpdate:(ModelVisibilityHandler)onModelVisibilityUpdate {
}

@end

#endif
