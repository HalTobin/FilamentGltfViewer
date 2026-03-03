import Foundation

enum EnvironmentLight {
    
    static let classicalIbl: URL = Bundle.main.url(
        forResource: "default_env_ibl",
        withExtension: "ktx"
    )!
    
    static let classicalSkybox: URL = Bundle.main.url(
        forResource: "default_env_skybox",
        withExtension: "ktx"
    )!
    
    static let arIbl: URL = Bundle.main.url(
        forResource: "venetian_crossroads_2k_ibl",
        withExtension: "ktx"
    )!
    
    static let arSkybox: URL = Bundle.main.url(
        forResource: "venetian_crossroads_2k_skybox",
        withExtension: "ktx"
    )!
    
}
