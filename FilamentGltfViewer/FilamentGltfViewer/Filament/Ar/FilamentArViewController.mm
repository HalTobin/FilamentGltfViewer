/*
 * Copyright (C) 2019 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FilamentArViewController.h"
#import "FilamentApp.h"
#import "FilamentView.h"

#import "MathHelpers.h"

#import <FilamentGltfViewer/FilamentScene.h>
#import <FilamentGltfViewer/FilamentModel.h>
#import <FilamentGltfViewer/ModelTapHandler.h>

#import <ARKit/ARKit.h>

#define METAL_AVAILABLE __has_include(<QuartzCore/CAMetalLayer.h>)

#if !METAL_AVAILABLE
#error The iOS simulator does not support Metal.
#endif

@interface FilamentArViewController () <ARSessionDelegate> {
    FilamentApp* app;
}

@property (nonatomic, strong) ARSession* session;

// The most recent anchor placed via a tap on the screen.
@property (nonatomic, strong) ARAnchor* anchor;

@end

@implementation FilamentArViewController {
    FilamentScene* _scene;
    FilamentModel* _model;
    ModelTapHandler _onModelTapCallback;
}

- (instancetype)initWithScene:(FilamentScene *)scene {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _scene = scene;
    }
    return self;
}

- (instancetype)initWithScene:(FilamentScene *)scene
                   onModelTap:(ModelTapHandler)onModelTap {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _scene = scene;
        _onModelTapCallback = [onModelTap copy];
    }
    return self;
}

- (void)loadView {
    self.view = [[FilamentView alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.contentScaleFactor = [UIScreen mainScreen].nativeScale;

    CAMetalLayer *metalLayer = (CAMetalLayer *)self.view.layer;
    CGRect nativeBounds = [[UIScreen mainScreen] nativeBounds];
    metalLayer.drawableSize = nativeBounds.size;

    uint32_t nativeWidth = (uint32_t) nativeBounds.size.width;
    uint32_t nativeHeight = (uint32_t) nativeBounds.size.height;
    app = new FilamentApp((__bridge void*) metalLayer, nativeWidth, nativeHeight);

    // Not a beautiful fix, but it should do it for now
    app->setObjectTransform(mat4f::translation(float3{0.f, -1000.f, 0.f}));
    
    self.session = [ARSession new];
    self.session.delegate = self;

    UITapGestureRecognizer* tapRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(handleTap:)];

    tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

// MARK: - Orientation Transitions
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Quickly fade out the AR camera feed right before the rotation begins
    [UIView animateWithDuration:0.1 animations:^{
        self.view.alpha = 0.0;
    }];
    
    // Wait for the system's rotation animation to finish
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {

        // Fade the camera feed back in.
        [UIView animateWithDuration:0.2 animations:^{
            self.view.alpha = 1.0;
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    ARWorldTrackingConfiguration* configuration = [ARWorldTrackingConfiguration new];
    configuration.planeDetection = ARPlaneDetectionHorizontal;
    [self.session runWithConfiguration:configuration];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.session pause];
}

- (void)dealloc
{
    delete app;
}

- (bool)loadModel:(FilamentModel *)model {
    if (app == nullptr) {
        NSLog(@"Filament engine not initialized yet. Deferring model load.");
        _model = model; // Store it to load once viewDidLoad finishes
        return true;
    }

    if (model == nil || model.url == nil) return false;

    @try {
        NSData* data = [NSData dataWithContentsOfFile:model.url.path];
        if (!data) return false;

        app->loadModel((const uint8_t*)data.bytes, (uint32_t)data.length);
        return true;
    }
    @catch (NSException *exception) {
        return false;
    }
}

- (void)unloadModel {
    app->unloadModel();
}

- (UIImage *)captureSnapshot {
    UIGraphicsImageRendererFormat *format = [UIGraphicsImageRendererFormat new];
    format.opaque = YES;
    
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:self.view.bounds.size format:format];
    
    UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
        // drawViewHierarchyInRect safely captures the Metal layer and SwiftUI overlays
        [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    }];
    
    return image;
}

#pragma mark ARSessionDelegate

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
    UIInterfaceOrientation orientation = UIInterfaceOrientationUnknown;
    UIWindowScene *windowScene = (UIWindowScene *)self.view.window.windowScene;
    if (windowScene) {
        orientation = windowScene.interfaceOrientation;
    }
    
    // Fallback if unknown
    if (orientation == UIInterfaceOrientationUnknown) {
        orientation = UIInterfaceOrientationPortrait;
    }

    CGSize viewport = self.view.bounds.size;

    CGAffineTransform displayTransform =
            [frame displayTransformForOrientation:orientation
                                     viewportSize:viewport];
    CGAffineTransform transformInv = CGAffineTransformInvert(displayTransform);
    mat3f textureTransform(transformInv.a, transformInv.b, 0,
                           transformInv.c, transformInv.d, 0,
                           transformInv.tx, transformInv.ty, 1);

    const auto& projection =
            [frame.camera projectionMatrixForOrientation:orientation
                                            viewportSize:viewport
                                                   zNear: 0.01f
                                                    zFar:10.00f];

    auto viewMatrix = [frame.camera viewMatrixForOrientation:orientation];
    auto cameraTransformMatrix = simd_inverse(viewMatrix);
    
    app->render(FilamentApp::FilamentArFrame {
        .cameraImage = (void*) frame.capturedImage,
        .cameraTextureTransform = textureTransform,
        .projection = FILAMENT_MAT4_FROM_SIMD(projection),
        .view = FILAMENT_MAT4F_FROM_SIMD(cameraTransformMatrix)
    });
}

- (void)handleTap:(UITapGestureRecognizer*)sender
{
    ARFrame* currentFrame = self.session.currentFrame;
    if (!currentFrame) {
        return;
    }
    
    UIInterfaceOrientation orientation = UIInterfaceOrientationUnknown;
    UIWindowScene *windowScene = (UIWindowScene *)self.view.window.windowScene;
    if (windowScene) {
        orientation = windowScene.interfaceOrientation;
    }
    if (orientation == UIInterfaceOrientationUnknown) {
        orientation = UIInterfaceOrientationPortrait;
    }

    CGPoint tapLocation = [sender locationInView:self.view];
    CGSize viewSize = self.view.bounds.size;

    // Check if the user's tapped on an already displayed object
    if (self.anchor) {
        simd_float3 modelPosition = self.anchor.transform.columns[3].xyz;
        CGPoint projectedPoint = [currentFrame.camera projectPoint:modelPosition
                                                               orientation:orientation
                                                              viewportSize:viewSize];
        
        CGFloat distance = hypot(tapLocation.x - projectedPoint.x, tapLocation.y - projectedPoint.y);
        if (distance < 80.0) {
            if (_onModelTapCallback != nil && _model != nil) {
                _onModelTapCallback(_model);
            }
            return;
        }
    }
    
    CGPoint normalizedPoint = CGPointMake(tapLocation.x / viewSize.width,
                                          tapLocation.y / viewSize.height);

    // Convert the normalized screen point to the camera's image coordinate space
    CGAffineTransform displayTransform =
            [currentFrame displayTransformForOrientation:orientation
                                            viewportSize:viewSize];
    CGPoint imagePoint = CGPointApplyAffineTransform(normalizedPoint, CGAffineTransformInvert(displayTransform));

    // Perform a hit test against detected planes (like tables) and estimated planes
    NSArray<ARHitTestResult *> *results = [currentFrame hitTest:imagePoint
                                                          types:ARHitTestResultTypeExistingPlaneUsingExtent |
                                                                ARHitTestResultTypeEstimatedHorizontalPlane];

    if (results.count > 0) {
        // Remove the previous anchor if it exists
        if (self.anchor) {
            [self.session removeAnchor:self.anchor];
        }

        ARHitTestResult *result = results.firstObject;
        mat4f hitTransform = FILAMENT_MAT4F_FROM_SIMD(result.worldTransform);
        
        // Extract ONLY the translation to keep the model perfectly upright, avoiding ground slopes
        mat4f uprightTransform = mat4f::translation(hitTransform[3].xyz);

        app->setObjectTransform(uprightTransform);

        simd_float4x4 simd_transform = SIMD_FLOAT4X4_FROM_FILAMENT(uprightTransform);
        self.anchor = [[ARAnchor alloc] initWithName:@"object" transform:simd_transform];
        [self.session addAnchor:self.anchor];
    }
}

- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<ARAnchor*>*)anchors
{
    for (ARAnchor* anchor : anchors) {
        if ([anchor isKindOfClass:[ARPlaneAnchor class]]) {
            ARPlaneAnchor* planeAnchor = (ARPlaneAnchor*) anchor;
            const auto& geometry = planeAnchor.geometry;
            app->updatePlaneGeometry(FilamentApp::FilamentArPlaneGeometry {
                .transform = FILAMENT_MAT4F_FROM_SIMD(planeAnchor.transform),
                // geometry.vertices is an array of simd_float3's, but they're padded to be the
                // same length as a float4.
                .vertices = (float4*) geometry.vertices,
                .indices = (uint16_t*) geometry.triangleIndices,
                .vertexCount = geometry.vertexCount,
                .indexCount = geometry.triangleCount * 3
            });
            continue;
        }

        filament::math::mat4f transform = FILAMENT_MAT4F_FROM_SIMD(anchor.transform);
        app->setObjectTransform(transform);
    }
}

@end
