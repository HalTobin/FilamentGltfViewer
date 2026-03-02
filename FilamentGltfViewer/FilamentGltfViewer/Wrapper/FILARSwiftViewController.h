#import <UIKit/UIKit.h>
#import <FilamentGltfViewer/FilamentScene.h>
#import <FilamentGltfViewer/FilamentModel.h>
#import <FilamentGltfViewer/ModelTapHandler.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ModelVisibilityHandler)(BOOL visible);

@interface FILARSwiftViewController : UIViewController

- (instancetype)initWithScene:(FilamentScene *)scene NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithScene:(FilamentScene *)scene
                   onModelTap:(ModelTapHandler)onModelTap NS_DESIGNATED_INITIALIZER;

- (bool)loadModel:(FilamentModel *)model;

- (void)unloadModel;

- (UIImage * _Nullable)captureSnapshot;

@property (nonatomic, copy) ModelVisibilityHandler onModelVisibilityUpdate;

@end

NS_ASSUME_NONNULL_END

