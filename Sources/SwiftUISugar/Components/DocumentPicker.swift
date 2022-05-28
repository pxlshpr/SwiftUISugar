import SwiftUI
import UniformTypeIdentifiers

public final class DocumentPicker: NSObject, UIViewControllerRepresentable {
    
    //  typealias UIViewControllerType = UIDocumentPickerViewController
    
    var url: URL?
    weak var delegate: UIDocumentPickerDelegate?
    
    init(url: URL? = nil, delegate: UIDocumentPickerDelegate? = nil) {
        self.url = url
        self.delegate = delegate
    }
    
    lazy var viewController: UIDocumentPickerViewController = {
        let vc: UIDocumentPickerViewController
        if let url = url {
//            vc = UIDocumentPickerViewController(url: url, in: .moveToService)
            vc = UIDocumentPickerViewController(forExporting: [url])
        } else {
            vc = UIDocumentPickerViewController(forOpeningContentTypes: [.data], asCopy: true)
//            vc = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
        }
        vc.allowsMultipleSelection = false
        vc.delegate = delegate
        return vc
    }()
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        viewController.delegate = delegate
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
    }
}
