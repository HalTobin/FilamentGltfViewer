import Foundation

enum EnvironmentLight {
    
    static let ibl: URL = Bundle.main.url(
        forResource: "default_env_ibl",
        withExtension: "ktx"
    )!
    
    static let skybox: URL = Bundle.main.url(
        forResource: "default_env_skybox",
        withExtension: "ktx"
    )!
    
}
