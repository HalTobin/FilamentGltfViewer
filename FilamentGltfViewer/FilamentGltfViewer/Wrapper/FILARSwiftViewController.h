#import <UIKit/UIKit.h>
#import <FilamentGltfViewer/FilamentScene.h>
#import <FilamentGltfViewer/FilamentModel.h>
#import <FilamentGltfViewer/ModelTapHandler.h>

NS_ASSUME_NONNULL_BEGIN

@interface FILARSwiftViewController : UIViewController

- (instancetype)initWithScene:(FilamentScene *)scene NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithScene:(FilamentScene *)scene
                   onModelTap:(ModelTapHandler)onModelTap NS_DESIGNATED_INITIALIZER;

- (bool)loadModel:(FilamentModel *)model;

- (void)unloadModel;

- (UIImage * _Nullable)captureSnapshot;

@end

NS_ASSUME_NONNULL_END

