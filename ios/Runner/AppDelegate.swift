import UIKit
import Flutter
import Photos

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private let CHANNEL = "com.example.my_wallpaper/setWallpaper"
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let wallpaperChannel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)
        
        wallpaperChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "setWallpaper" {
                guard let args = call.arguments else {
                    result(FlutterError(code: "ERROR", message: "Image not found", details: nil))
                    return
                }
                if let imageData = (args as? FlutterStandardTypedData)?.data {
                    self.saveImageToPhotos(imageData: imageData, result: result)
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func saveImageToPhotos(imageData: Data, result: @escaping FlutterResult) {
        if let image = UIImage(data: imageData) {
            // Save image to Photos
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            // Request photo library access if needed
            let photoLibraryAuthorization = PHPhotoLibrary.authorizationStatus()
            if photoLibraryAuthorization == .authorized {
                result(true)
                self.showWallpaperInstructions()
            } else {
                PHPhotoLibrary.requestAuthorization { (status) in
                    if status == .authorized {
                        result(true)
                        self.showWallpaperInstructions()
                    } else {
                        result(FlutterError(code: "PERMISSION_DENIED", message: "Permission denied to access photos", details: nil))
                    }
                }
            }
        } else {
            result(FlutterError(code: "ERROR", message: "Unable to decode image", details: nil))
        }
    }
    
    // Notify user to set the wallpaper manually
    private func showWallpaperInstructions() {
        let alert = UIAlertController(title: "Wallpaper Saved", message: "Go to the Photos app and set the saved image as your wallpaper.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                rootViewController.present(alert, animated: true, completion: nil)
            }
        }
    }
}
