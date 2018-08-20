
import UIKit
import SideMenu
import KeychainAccess

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var router: ApplicationRouter!
  let tokenService = AssemblyFactory.shared.tokenServiceAssembly.service()
  let settingsService = AssemblyFactory.shared.settingsServiceAssembly.service()
  let keychainService = KeychainAccessKeychainService()
  let loggedInUserService = AssemblyFactory.shared.loggedInUserServiceAssembly.service()
  let feedDataService = AssemblyFactory.shared.feedDataServiceAssembly.service()
  let feedIdService = AssemblyFactory.shared.feedIdServiceAssebmly.service()

  // MARK: - UIApplicationDelegate

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    configureSlideMenu()
    setupBaseURL()
    refreshToken()
    initWindow()
    router?.routeToInitialViewController()
    clearKeychainIfFirstLaunch()
    settingsService.finishFirstLaunch()
    uploadFeedData()
    return true
  }

  // MARK: - Private Helpers

  private func configureSlideMenu() {
    SideMenuManager.default.menuWidth = UIScreen.main.bounds.width * 0.85
    SideMenuManager.default.menuPresentMode = .menuSlideIn
    SideMenuManager.default.menuFadeStatusBar = false
  }

  private func clearKeychainIfFirstLaunch() {
    if settingsService.isFirstLaunch() {
      let result = keychainService.clear()
      if case .failure(let error) = result {
        Log.error("Error when clearing keychain data: ", error)
      }
    }
  }

  private func initWindow() {
    let window = UIWindow()
    self.window = window
    let loggedInUserService = AssemblyFactory.shared.loggedInUserServiceAssembly.service()
    router = ApplicationRouterImpl(
      window: window,
      loggedInUserService: loggedInUserService,
      settingsService: settingsService
    )
  }

  private func setupBaseURL() {
    let settingsResult = settingsService.settings()
    switch settingsResult {
    case .success(let settings):
      URLBuilder.c2mBase1 = settings.baseURL
      Log.info("Base URL: \(URLBuilder.c2mBase1)")
    case .failure(let error):
      Log.error("Error when reading base URL from settings.", error)
    }
  }

  private func refreshToken() {
    tokenService.refreshToken { result in
      switch result {
      case .success:
        Log.info("Access token refreshed successfully.")
      case .failure(let error):
        Log.error("Error when requesting access token.", error)
      }
    }
  }

  private func uploadFeedData() {
    guard loggedInUserService.isLoggedIn() else {
      return
    }
    feedIdService.feedId(policy: .network) { [weak self] feedIdResult in
      switch feedIdResult {
      case .success:
        self?.feedDataService.uploadAssets { result in
          Log.info("uploadAssets:\(result)")
        }
        self?.feedDataService.uploadEvents { result in
          Log.info("uploadEvents:\(result)")
        }
        self?.feedDataService.uploadContacts { result in
          Log.info("uploadContacts:\(result)")
        }
        self?.feedDataService.uploadReminders { result in
          Log.info("uploadReminders:\(result)")
        }
      case .failure(let error):
        Log.info("Error when fetching feedIds. \(error)")
      }
    }
  }
}

extension AppDelegate {
  static var shared: AppDelegate {
    // swiftlint:disable:next force_cast
    return UIApplication.shared.delegate as! AppDelegate
  }
}
