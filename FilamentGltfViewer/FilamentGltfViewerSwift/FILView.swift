//
//  FILView.swift
//  FilamentGltfViewer
//
//  Created by Alexis ANEAS on 14/01/2026.
//

import UIKit
import SwiftUI
import FilamentGltfViewer

public struct FILView: UIViewControllerRepresentable {
    
    public init() {}
    
    public func makeUIViewController(context: Context) -> UIViewController {
        FILSwiftViewController()
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

    }
    
}
