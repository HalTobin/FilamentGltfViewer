import UIKit
import SwiftUI

public struct FILView: UIViewControllerRepresentable {
    
    public init() {}
    
    public func makeUIViewController(context: Context) -> UIViewController {
        FILSwiftViewController()
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

    }
    
}
