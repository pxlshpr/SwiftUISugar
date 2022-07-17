import SwiftUI
import UniformTypeIdentifiers

//TODO: Clean this up and make the syntax more understable
public final class DocumentPicker_Legacy: NSObject, UIViewControllerRepresentable {
    
    //  typealias UIViewControllerType = UIDocumentPickerViewController
    
    var url: URL?
    var exportAsCopy: Bool
    weak var delegate: UIDocumentPickerDelegate?
    
    public init(url: URL? = nil, exportAsCopy: Bool = false, delegate: UIDocumentPickerDelegate? = nil) {
        self.url = url
        self.exportAsCopy = exportAsCopy
        self.delegate = delegate
    }
    
    lazy var viewController: UIDocumentPickerViewController = {
        let vc: UIDocumentPickerViewController
        if let url = url {
//            vc = UIDocumentPickerViewController(url: url, in: .moveToService)
            vc = UIDocumentPickerViewController(forExporting: [url], asCopy: exportAsCopy)
        } else {
            vc = UIDocumentPickerViewController(forOpeningContentTypes: [.data], asCopy: true)
//            vc = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
        }
        vc.allowsMultipleSelection = false
        vc.delegate = delegate
        return vc
    }()
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker_Legacy>) -> UIDocumentPickerViewController {
        viewController.delegate = delegate
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker_Legacy>) {
    }
}

public struct DocumentPicker_Legacy_AsAStruct: UIViewControllerRepresentable {
    
    var url: URL?
    var exportAsCopy: Bool
    weak var delegate: UIDocumentPickerDelegate?
    
    var viewController: UIDocumentPickerViewController
    
    public init(url: URL? = nil, exportAsCopy: Bool = false, delegate: UIDocumentPickerDelegate? = nil) {
        self.url = url
        self.exportAsCopy = exportAsCopy
        self.delegate = delegate
        
        let vc: UIDocumentPickerViewController
        if let url = url {
            vc = UIDocumentPickerViewController(forExporting: [url], asCopy: exportAsCopy)
        } else {
            vc = UIDocumentPickerViewController(forOpeningContentTypes: [.data], asCopy: true)
        }
        vc.allowsMultipleSelection = false
        vc.delegate = delegate
        self.viewController = vc
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker_Legacy_AsAStruct>) -> UIDocumentPickerViewController {
        viewController.delegate = delegate
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker_Legacy_AsAStruct>) {
    }
}
