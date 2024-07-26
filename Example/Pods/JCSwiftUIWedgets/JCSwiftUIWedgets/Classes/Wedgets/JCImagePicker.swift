//
//  JCImagePicker.swift
//  JCSwiftUIWedgets
//
//  Created by James Chen on 2023/1/12.
//

import SwiftUI
import UIKit

// PhotosPicker only support iOS 16+, so I wrote this instead.
public struct JCImagePicker: UIViewControllerRepresentable {
  @Environment(\.presentationMode) private var presentationMode
  @Binding var sourceType: UIImagePickerController.SourceType
  var didSelectedImage: (UIImage) -> Void

  public func makeUIViewController(context: UIViewControllerRepresentableContext<JCImagePicker>) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.allowsEditing = false
    imagePicker.sourceType = sourceType
    imagePicker.delegate = context.coordinator

    return imagePicker
  }

  public func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<JCImagePicker>) {
  }

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  public final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var parent: JCImagePicker

    init(_ parent: JCImagePicker) {
      self.parent = parent
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
      let key = UIImagePickerController.InfoKey.originalImage
      if let image = info[key] as? UIImage {
        parent.didSelectedImage(image)
      }
      parent.presentationMode.wrappedValue.dismiss()
    }
  }
}

#Preview {
  JCImagePicker(sourceType: .constant(.photoLibrary)) { _ in }
}
