public struct FilamentSupport {
    public static func isDeviceSupported() -> Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        return true
        #endif
    }
}
