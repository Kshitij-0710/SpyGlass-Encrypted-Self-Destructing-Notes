import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  
  private var secureTextField: UITextField?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let securityChannel = FlutterMethodChannel(name: "security/screenshot",
                                              binaryMessenger: controller.binaryMessenger)
    
    securityChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      
      switch call.method {
      case "enableSecureMode":
        self.enableScreenshotPrevention()
        result(true)
        
      case "disableSecureMode":
        self.disableScreenshotPrevention()
        result(true)
        
      default:
        result(FlutterMethodNotImplemented)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Method from CHI Software research - most reliable
  private func enableScreenshotPrevention() {
    guard let window = self.window else { return }
    
    DispatchQueue.main.async {
      // Create secure text field
      let field = UITextField()
      field.isSecureTextEntry = true
      
      // Add to window
      window.addSubview(field)
      
      // Key part: Layer manipulation that prevents screenshots
      window.layer.superlayer?.addSublayer(field.layer)
      field.layer.sublayers?.first?.addSublayer(window.layer)
      
      // Store reference
      self.secureTextField = field
      
      // Make invisible and non-interactive
      field.alpha = 0.01
      field.isUserInteractionEnabled = false
      field.frame = CGRect(x: -1000, y: -1000, width: 1, height: 1)
      
      print("✅ Screenshot prevention enabled")
    }
  }
  
  private func disableScreenshotPrevention() {
    DispatchQueue.main.async {
      // Remove secure field
      self.secureTextField?.removeFromSuperview()
      self.secureTextField = nil
      
      print("❌ Screenshot prevention disabled")
    }
  }
  
  // Alternative method for iOS 17+ if above doesn't work
  private func enableScreenshotPreventionAlternative() {
    guard let window = self.window else { return }
    
    let field = UITextField()
    let view = UIView(frame: CGRect(x: 0, y: 0, width: field.frame.width, height: field.frame.height))
    
    // Create white overlay image (replace with your app logo)
    let image = UIImageView()
    if let whiteImage = UIImage(systemName: "lock.fill") {
      image.image = whiteImage
      image.tintColor = .white
    }
    image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    image.contentMode = .center
    image.backgroundColor = .black
    
    field.isSecureTextEntry = true
    window.addSubview(field)
    view.addSubview(image)
    
    window.layer.superlayer?.addSublayer(field.layer)
    
    // Use last sublayer instead of first for iOS 17+
    field.layer.sublayers?.last?.addSublayer(window.layer)
    
    field.leftView = view
    field.leftViewMode = .always
    
    self.secureTextField = field
  }
}