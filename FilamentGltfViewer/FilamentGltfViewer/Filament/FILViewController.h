#import <UIKit/UIKit.h>

#import <FILModelView.h>
#import <FilamentGltfViewer/FilamentScene.h>
#import <FilamentGltfViewer/FilamentModel.h>
#import <FilamentGltfViewer/ModelTapHandler.h>

@interface FILViewController : UIViewController

- (instancetype _Nonnull )initWithScene:(nonnull FilamentScene *)scene NS_DESIGNATED_INITIALIZER;

- (instancetype _Nonnull )initWithScene:(nonnull FilamentScene *)scene
                             onModelTap:(nullable ModelTapHandler)onModelTap NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)bundle NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

- (bool)loadModel:(FilamentModel *)model;

- (void)unloadModel;

@property(nonatomic, strong) FILModelView* modelView;

@end
