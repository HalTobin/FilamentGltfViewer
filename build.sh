#!/bin/bash
set -e

xcodebuild archive \
    -project FilamentGltfViewer/FilamentGltfViewer.xcodeproj \
    -scheme FilamentGltfViewer \
    -destination "generic/platform=iOS" \
    -archivePath "archives/FilamentGltfViewer-iOS.xcarchive"

#xcodebuild archive \
    #-project FilamentGltfViewer/FilamentGltfViewer.xcodeproj \
    #-scheme FilamentGltfViewer \
    #-destination "generic/platform=iOS Simulator" \
    #-archivePath "archives/FilamentGltfViewer-iOS_Simulator.xcarchive"

xcodebuild -create-xcframework \
    -archive archives/FilamentGltfViewer-iOS.xcarchive \
        -framework FilamentGltfViewer.framework \
    -output out/FilamentGltfViewer.xcframework

    #-archive archives/FilamentGltfViewer-iOS_Simulator.xcarchive \
        #-framework FilamentGltfViewer.framework \