//
//  JCImagePickerSheet.swift
//  JCSwiftUIWedgets
//
//  Created by James Chen on 2023/1/12.
//

import AVFoundation
import SwiftUI

let SAFE_AREA_INSETS = UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets()

public extension View {
  func showImagePickerSheet(_ isPresented: Binding<Bool>, onImageSelected: @escaping (UIImage) -> Void) -> some View {
    modifier(JCImagePickerSheetModifier(isPresented: isPresented, onImageSelected: onImageSelected))
  }
}

struct JCImagePickerSheetModifier: ViewModifier {
  @Binding var isPresented: Bool
  var onImageSelected: (UIImage) -> Void

  @ViewBuilder
  func body(content: Content) -> some View {
    ZStack {
      content.disabled(isPresented)
      if isPresented {
        JCImagePickerSheet(isPresented: $isPresented) { image in
          self.onImageSelected(image)
        }
      }
    }
  }
}

// Editing config.shared ensures that this component looks the same wherever it is used.
// Or have a new Config() to make it special.
public struct JCImagePickerSheetConfig {
  static let shared = JCImagePickerSheetConfig()

  var grantCameraPermissionString = "Grant camera permission"
  var takePhotoString = "Take a Photo"
  var takePhotoIcon = Image(systemName: "camera")
  var chooseFromAlbumString = "Choose From Album"
  var chooseFromAlbumIcon = Image(systemName: "photo.on.rectangle.angled")

  var overlayColor = Color.gray.opacity(0.5)
  var sheetHeight: CGFloat = 178
  var backgroundColor = Color(withHex: "F0F0F0")
  var foregroundColor = Color(withHex: "#333333")

  var leftMargin: CGFloat = 32
  var buttonHeight: CGFloat = 64
  var buttonStyle = JCButtonStyle.HighlightStyle(backgroundColor: JCColorPair(normal: Color.clear, highlight: Color(withHex: "#CCCCCC")))
}

public struct JCImagePickerSheet: View {
  @Binding var isPresented: Bool

  var didSelectImage: (UIImage) -> Void

  var config = JCImagePickerSheetConfig.shared

  @State private var isStarted = false
  @State private var showImagePicker = false
  @State private var sourceType: UIImagePickerController.SourceType = .camera

  public var body: some View {
    ZStack(alignment: .bottom) {
      config.overlayColor.opacity(isStarted ? 1 : 0)
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
          isPresented = false
        }
      VStack {
        Spacer()
        VStack(spacing: 0) {
          Capsule()
            .foregroundColor(config.foregroundColor)
            .frame(width: 32, height: 2)
            .padding(12)
          Button {
            if IsCameraDenied() {
              GoToSystemSettingScreen()
              return
            }
            sourceType = .camera
            showImagePicker = true
          } label: {
            HStack {
              config.takePhotoIcon
                .mask(color: config.foregroundColor)
                .padding([.leading], config.leftMargin)
              Text(IsCameraDenied() ? config.grantCameraPermissionString : config.takePhotoString)
                .foregroundColor(config.foregroundColor)
                .font(JCThemeFont.shared.M)
              Spacer()
            }
            .frame(height: config.buttonHeight)
          }
          .buttonStyle(config.buttonStyle)
          Button {
            sourceType = .photoLibrary
            showImagePicker = true
          } label: {
            HStack {
              config.chooseFromAlbumIcon
                .mask(color: config.foregroundColor)
                .padding([.leading], config.leftMargin)
              Text(config.chooseFromAlbumString)
                .foregroundColor(config.foregroundColor)
                .font(JCThemeFont.shared.M)
              Spacer()
            }
            .frame(height: config.buttonHeight)
          }
          .buttonStyle(config.buttonStyle)
          Spacer()
        }
        .frame(height: config.sheetHeight + SAFE_AREA_INSETS.bottom)
        .background(config.backgroundColor)
        .cornerRadius(8, corners: [.topLeft, .topRight])
      }.offset(y: isStarted ? 0 : config.sheetHeight + SAFE_AREA_INSETS.bottom)
    }.edgesIgnoringSafeArea(.all)
      .onAppear {
        withAnimation {
          isStarted = true
        }
      }.sheet(isPresented: $showImagePicker) {
        JCImagePicker(sourceType: $sourceType) { image in
          didSelectImage(image)
          isPresented = false
        }
        .edgesIgnoringSafeArea(.all)
      }
  }

  func IsCameraDenied() -> Bool {
    let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
    return authStatus == .denied
  }

  func GoToSystemSettingScreen() {
    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
  }
}

#Preview {
  JCImagePickerSheet(isPresented: .constant(true)) { _ in
  }
}
