

import Foundation

class ProfileServiceAssemblyImpl: ProfileServiceAssembly {

  // MARK: - Private Properties

  private let countryServiceAssembly: CountryServiceAssembly
  private let userServiceAssembly: UserServiceAssembly
  private let settingsServiceAssembly: SettingsServiceAssembly

  // MARK: - Initialization

  init(
    countryServiceAssembly: CountryServiceAssembly,
    userServiceAssembly: UserServiceAssembly,
    settingsServiceAssembly: SettingsServiceAssembly
  ) {
    self.countryServiceAssembly = countryServiceAssembly
    self.userServiceAssembly = userServiceAssembly
    self.settingsServiceAssembly = settingsServiceAssembly
  }

  // MARK: - ProfileServiceAssembly

  func service() -> ProfileService {
    return ProfileServiceImpl(
      countryService: countryServiceAssembly.service(),
      userService: userServiceAssembly.service(),
      settingsService: settingsServiceAssembly.service()
    )
  }
}
