import SwiftUI
import UIKit
import PhotosUI

public struct ImagePickerView: UIViewControllerRepresentable {
    
    public typealias UIViewControllerType = PHPickerViewController
    
    public init(filter: PHPickerFilter = .images, selectionLimit: Int = 1, delegate: PHPickerViewControllerDelegate) {
        self.filter = filter
        self.selectionLimit = selectionLimit
        self.delegate = delegate
    }
    
    private let filter: PHPickerFilter
    private let selectionLimit: Int
    private let delegate: PHPickerViewControllerDelegate
    
    public func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = filter
        configuration.selectionLimit = selectionLimit
        
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = delegate
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
}

extension ImagePickerView {
    public class Delegate: NSObject, PHPickerViewControllerDelegate {
        
        public init(isPresented: Binding<Bool>, didCancel: @escaping (PHPickerViewController) -> (), didSelect: @escaping (ImagePickerResult) -> (), didFail: @escaping (ImagePickerError) -> ()) {
            self._isPresented = isPresented
            self.didCancel = didCancel
            self.didSelect = didSelect
            self.didFail = didFail
        }
        
        @Binding var isPresented: Bool
        private let didCancel: (PHPickerViewController) -> ()
        private let didSelect: (ImagePickerResult) -> ()
        private let didFail: (ImagePickerError) -> ()
        
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if results.count == 0 {
                self.isPresented = false
                self.didCancel(picker)
                return
            }
            var images = [UIImage]()
            var processedImagesCount = 0
            for i in 0..<results.count {
                let result = results[i]
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { newImage, error in
                        if let _ = error {
//                            self.isPresented = false
//                            self.didFail(ImagePickerError(picker: picker, error: error))
//                            continue
                            processedImagesCount += 1
                        } else if let image = newImage as? UIImage {
                            processedImagesCount += 1
                            images.append(image)
                        }
                        if processedImagesCount == results.count {
                            DispatchQueue.main.async {
                                self.isPresented = false
                                if images.count != 0 {
                                    self.didSelect(ImagePickerResult(picker: picker, images: images))
                                } else {
                                    self.didCancel(picker)
                                }
                            }
                        }
                    }
                } else {
                    /// We've removed these lines (from the original source), since it resulted in the entire group of selected photos to fail when only one of them was not loadable (which happened when it was an unsupported file format such as .webp)
//                    self.isPresented = false
//                    self.didFail(ImagePickerError(picker: picker, error: ImagePickerViewError.cannotLoadObject))
                    processedImagesCount += 1
                    continue
                }
            }            
        }
    }
}

public struct ImagePickerResult {
    public let picker: PHPickerViewController
    public let images: [UIImage]
}

public struct ImagePickerError {
    public let picker: PHPickerViewController
    public let error: Error
}

public enum ImagePickerViewError: Error {
    case cannotLoadObject
    case failedToLoadObject
}
