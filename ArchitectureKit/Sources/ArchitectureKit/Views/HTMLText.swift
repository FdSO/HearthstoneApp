import SwiftUI

public struct HTMLText: UIViewRepresentable {
    private let alignment: NSTextAlignment
    private let string: String
    
    public init(_ alignment: NSTextAlignment = .natural, string: String) {
        self.string = string.replacingOccurrences(of: "\n", with: "<br>")
        self.alignment = alignment
    }
    
    public func makeUIView(context: Context) -> UILabel {
        .init()
    }

    public func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.numberOfLines = 0
        
        let attributedString = try? NSAttributedString(
            data: .init(string.utf8), options: [
                .documentType: NSAttributedString.DocumentType.html
            ], documentAttributes: nil
        )

        if let attributedString {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = alignment

            let attributedText = NSMutableAttributedString(
                attributedString: attributedString
            )

            attributedText.addAttributes([
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.label,
            ], range: .init(location: 0, length: attributedText.length))

            uiView.attributedText = attributedText
        } else {
            uiView.text = string
        }
    }
}
