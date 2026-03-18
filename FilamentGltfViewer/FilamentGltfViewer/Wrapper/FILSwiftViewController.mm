#import "FILSwiftViewController.h"
#import "FILViewController.h"
#import <FilamentGltfViewer/FilamentScene.h>
#import <FilamentGltfViewer/ModelTapHandler.h>

#if !TARGET_OS_SIMULATOR

@implementation FILSwiftViewController {
    FILViewController* _impl;
    FilamentModel* _model;
}

- (instancetype)initWithScene:(FilamentScene *)scene {
    self = [super init];
    if (self) {
        _impl = [[FILViewController alloc] initWithScene:scene];
    }
    return self;
}

- (instancetype)initWithScene:(FilamentScene *)scene
                   onModelTap:(ModelTapHandler)onModelTap {
    self = [super init];
    if (self) {
        _impl = [[FILViewController alloc] initWithScene:scene onModelTap:onModelTap];
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

- (bool)loadModel:(id)model {
    _model = model;
    return [_impl loadModel:model];
}

- (void)unloadModel {
    [_impl unloadModel];
}

@end

#else

@implementation FILSwiftViewController

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

@end

#endif
