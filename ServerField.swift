

import Foundation

/// Enum for storing field names used when communicating with server.
/// For example, when specifying parameter names and parsing responses.
enum ServerField {

  // MARK: Common

  static let response = "response"
  static let icedata = "icedata"
  static let status = "status"
  static let code = "code"
  static let message = "message"
  static let result = "result"

  // MARK: Access Token

  static let Tokens = "Tokens"
  static let AuthCode = "AuthCode"
  static let AccessToken = "AccessToken"
  static let RefreshToken = "RefreshToken"

  // MARK: Login

  static let Login = "Login"
  static let APIKey = "APIKey"

  // MARK: Country

  static let Countries = "Countries"
  static let CountryId = "CountryId"
  static let CountryName = "CountryName"

  // MARK: User

  static let User = "User"
  static let FirstName = "FirstName"
  static let MiddleName = "MiddleName"
  static let LastName = "LastName"
  static let EmailAddress = "EmailAddress"
  static let PhoneCountryCode = "PhoneCountryCode"
  static let PhoneNumber = "PhoneNumber"
  static let Country = "Country"
  static let TemperatureFormat = "TemperatureFormat"
  static let TimeFormat = "TimeFormat"

  // MARK: - Feed Data

  static let FeedId = "FeedId"

  // MARK: - EntityInstance

  static let entityInstanceId = "entityInstanceId"
  static let entityInstanceName = "entityInstanceName"

  // MARK: - EntityType

  static let entityTypeId = "entityTypeId"
  static let entityTypeName = "entityTypeName"
  static let entityTypeIconPath = "entityTypeIconPath"

  // MARK: - Device Category

  static let channelCategoryId = "channelCategoryId"
  static let category = "category"
  static let iconPath = "iconPath"

  // MARK: - Device

  static let entityTypeChannelDefinitionLinkId = "entityTypeChannelDefinitionLinkId"
  static let channelDefinitionId = "channelDefinitionId"
  static let channelDefinitionName = "channelDefinitionName"
  static let channelType = "channelType"
  static let userParam = "userParam"
  static let isPersonalDefault = "isPersonalDefault"
  static let personalDefaultName = "personalDefaultName"
  static let channelDefinitionIconPath = "channelDefinitionIconPath"
  static let entityInstanceChannelInstanceLinkId = "entityInstanceChannelInstanceLinkId"
  static let channelInstanceName = "channelInstanceName"
  static let channel = "channel"
  static let publishChannelId = "publishChannelId"
  static let remotecommand = "remotecommand"
  static let isremoterequired = "isremoterequired"
  static let root = "root"
  static let deviceidentification = "deviceidentification"
  static let schema = "schema"

  // MARK: - CommandGroup

  static let commandGroup = "commandGroup"
  static let commands = "commands"
  static let initAI = "initAI"
  static let cgInfo = "cgInfo"
  static let cgName = "cgName"
  static let cgMode = "cgMode"
  static let cgMobile = "cgMobile"

  // MARK: - Command

  static let cmdName = "cmdName"
  static let cmdParams = "cmdParams"

  // MARK: Column

  static let column = "column"
  static let name = "name"
  static let type = "type"
}
