import Flutter
import UIKit
#if canImport(ProximityReader)
import ProximityReader
#endif

/// Presents Apple's Tap to Pay on iPhone merchant education
/// (ProximityReaderDiscovery, iOS 18+).
public class FpsTapToPayIosPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "fps_tap_to_pay_ios", binaryMessenger: registrar.messenger())
    let instance = FpsTapToPayIosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isEducationAvailable":
      result(Self.educationAvailable())
    case "showEducation":
      showEducation(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private static func educationAvailable() -> Bool {
    #if canImport(ProximityReader)
    if #available(iOS 18.0, *) {
      return true
    }
    #endif
    return false
  }

  private func showEducation(result: @escaping FlutterResult) {
    #if canImport(ProximityReader)
    if #available(iOS 18.0, *) {
      Task { @MainActor in
        guard let presenter = Self.topViewController() else {
          result(FlutterError(code: "no_view_controller", message: "No view controller to present from.", details: nil))
          return
        }
        do {
          let discovery = ProximityReaderDiscovery()
          let content = try await discovery.content(for: ProximityReaderDiscovery.Topic.payment(.howToTap))
          try await discovery.presentContent(content, from: presenter)
          // Only report back once the education sheet is closed, so the caller
          // can safely continue (for example with the payment screen).
          var waited = 0
          while presenter.presentedViewController != nil && waited < 1200 {
            try? await Task.sleep(nanoseconds: 250_000_000)
            waited += 1
          }
          result(true)
        } catch {
          result(FlutterError(code: "education_failed", message: error.localizedDescription, details: nil))
        }
      }
      return
    }
    #endif
    result(false)
  }

  @MainActor
  private static func topViewController() -> UIViewController? {
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    let windows = scenes.flatMap { $0.windows }
    let window = windows.first { $0.isKeyWindow } ?? windows.first
    var top = window?.rootViewController
    while let presented = top?.presentedViewController {
      top = presented
    }
    return top
  }
}
