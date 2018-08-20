

import UIKit

/// Typealias for dictionaries that describe application models.
/// Used when mapping network request/responses.
/// For example: swift struct -> model dictionary -> JSON data,
/// swift struct -> model dictionary -> XML data
typealias ModelDictionary = [String: Any]

typealias VoidResult = Result<Void>
typealias VoidResultHandler = (VoidResult) -> Void

extension CGFloat {
  static let automaticDimension: CGFloat = UITableViewAutomaticDimension
  static let defaultBottomButtonOffset: CGFloat = 80
  static let bottomButtonKeyboardOffset: CGFloat = 16

  static let commandViewBorderWidth: CGFloat = 1 / UIScreen.main.scale
  static let commandViewCornerRadius: CGFloat = 4
}

extension TimeInterval {
  static let defaultAnimationDuration = 0.3
}

extension String {
  static let keychainService = "com.plasma"
  static let commandGroupModeSMS = "SMS"

  static let userNotificationUserInfoKey = "userNotificationUserInfoKey"

  static let personalEntityTypeName = "Person"
}

enum Header {
  static let contentType = "Content-Type"
  static let applicationJSON = "application/json"
  static let xAPIKey = "x-api-key"
}

enum UserDefaultsKey {
  static let isNotFirstLaunchDefaultsKey = "isNotFirstLaunchDefaultsKey"
}

extension Notification.Name {}
