# Warning
This is a Work In Progress:
- The project currently only support loading a .glb embedded in the project
- Using the library is tedious

# Presentation
FilamentGLTFViewer is a simple project to load and display .glb and .gltf on ios.
It can currently be exported as an .xcframework and then imported in your Xcode project.

Only compatible with physical iOS devices (no Simulator).

### Export the framework
1. Open your terminal at the parent's folder of the Xcode project FilamentGltfViewer, this folder will be referenced as the *workspace*
2. Clone filament's repository: `git clone https://github.com/google/filament.git`
3. Make sure you have the following folders: *filament* and *FilamentGltfViewer* in your workspace (root folder).
4. Open *filament* and run the following commands: 
    `sh ./build.sh -p ios -i debug` and `sh ./build.sh -p ios -i release`
    Note, that the building process will take a few minutes.
5. Return to the workspace's folder and run:
    `sh build.sh`
6. An usable .xcframework will be generated at *{WORKSPACE}/out/FilamentGltfViewer.xcframework*