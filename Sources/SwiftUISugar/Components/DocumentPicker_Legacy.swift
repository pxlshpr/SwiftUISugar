#if canImport(UIKit)
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

public struct DocumentPicker: UIViewControllerRepresentable {
    
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
            //TODO: Replace this remporary workout of always exporting as copy because without it we get a crash due to the url not being found.
            /// We need to:
            /// - [ ] Have a failsafe ensuring that this is only called when the URL actually exists so the crash never happens
            /// - [ ] Make sure we never get to the position of the crash to begin with by finding out why `DocumentPicker` is created multiple times, even after the move is completed (I suspect it has something to do with it now being a struct and not a class
            /// - [ ] Also, make sure the notification is run after the ZIP process acutally completes by using its Progress indicator
            vc = UIDocumentPickerViewController(forExporting: [url], asCopy: true)
//            vc = UIDocumentPickerViewController(forExporting: [url], asCopy: exportAsCopy)
        } else {
            vc = UIDocumentPickerViewController(forOpeningContentTypes: [.data], asCopy: true)
        }
        vc.allowsMultipleSelection = false
        vc.delegate = delegate
        self.viewController = vc
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        viewController.delegate = delegate
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
    }
}

extension URL {
    var exists: Bool {
        FileManager.default.fileExists(atPath: self.absoluteString)
    }
}
#endif
