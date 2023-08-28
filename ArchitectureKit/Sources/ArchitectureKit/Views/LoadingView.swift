import SwiftUI

@available(iOS, deprecated: 14.0, message: "use ProgressView")
public struct LoadingView: UIViewRepresentable {
    public init() {}
    
    public func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicatorView = UIActivityIndicatorView(style: .large)
        
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        
        return indicatorView
    }

    public func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}
