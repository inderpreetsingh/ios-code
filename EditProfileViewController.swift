

import UIKit
import InputMask

final class EditProfileViewController: ViewController, LoginFlowValidatable {

  // MARK: - IBOutlets

  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var firstNameTextField: UITextField!
  @IBOutlet var lastNameTextField: UITextField!
  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var countryCodeTextField: UITextField!
  @IBOutlet var phoneNumberTextField: UITextField!
  @IBOutlet var saveChangesButton: UIButton!

  // MARK: - IBActions

  @IBAction func formChanged() { validateForm() }
  @IBAction func saveChangesAction() { saveChanges() }

  // MARK: - Private Properties

  private let settingsService = AssemblyFactory.shared.settingsServiceAssembly.service()
  private let loggedInUserService = AssemblyFactory.shared.loggedInUserServiceAssembly.service()
  private let userService = AssemblyFactory.shared.userServiceAssembly.service()

  private let emailValidator = ValidatorFactory.shared.emailValidator

  private var countryCodePickerView = UIPickerView()
  private var countryCodeAdapter = PickerViewAdapter<CountryCode>(items: [])

  // swiftlint:disable:next weak_delegate
  private var maskedDelegate: MaskedTextFieldDelegate?
  private var didFillMandatoryPhoneCharacters = false

  private var user: User?

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    setupPhoneTextField()
    setupCountryCodeTextField()
    loadUser(loggedInUserService: loggedInUserService, userService: userService)
  }

  // MARK: - ViewController

  override func keyboardWillShow(keyboardHeight: CGFloat) {
    super.keyboardWillShow(keyboardHeight: keyboardHeight)
    scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
  }

  override func keyboardWillHide(keyboardHeight: CGFloat) {
    super.keyboardWillHide(keyboardHeight: keyboardHeight)
    scrollView.contentInset = .zero
  }

  // MARK: - Internal Helpers

  @objc func countryCodeTextFieldNextAction() {
    phoneNumberTextField.becomeFirstResponder()
  }

  @objc func phoneNumberTextFieldDoneAction() {
    phoneNumberTextField.resignFirstResponder()
  }

  // MARK: - Private Helpers

  private func setupCountryCodeTextField() {
    let selector = #selector(countryCodeTextFieldNextAction)
    let inputAccessoryView = UIToolbar.nextAccessoryView(target: self, action: selector)
    countryCodeTextField.inputAccessoryView = inputAccessoryView
    countryCodeTextField.inputView = countryCodePickerView
    countryCodeTextField.tintColor = .clear
    setupAdapter()
  }

  private func setupAdapter() {
    let countryCodes = settingsService.settings().value?.countryCodes ?? []
    countryCodeAdapter = PickerViewAdapter(items: countryCodes)
    countryCodePickerView.dataSource = countryCodeAdapter
    countryCodePickerView.delegate = countryCodeAdapter
    countryCodeAdapter.didSelectRowBlock = { [weak self] _, item in self?.didSelectPhoneCountryCode(countryCode: item) }
    countryCodeAdapter.titleForRowBlock = { _, item in return item.title }
  }

  private func didSelectPhoneCountryCode(countryCode: CountryCode) {
    guard let user = user else { return }
    self.user?.phoneCountryCode = countryCode.code
    countryCodeTextField.text = "+\(countryCode.code)"
    setupMaskedDelegate(countryCode: user.phoneCountryCode)
    maskedDelegate?.put(text: user.phone, into: phoneNumberTextField)
  }

  private func setupMaskedDelegate(countryCode: String) {
    let maskedDelegate = MaskedTextFieldDelegate(countryCode: CountryCode(code: countryCode))
    maskedDelegate.listener = self
    phoneNumberTextField.delegate = maskedDelegate
    self.maskedDelegate = maskedDelegate
  }

  private func setupPhoneTextField() {
    let accessoryView = UIToolbar.doneAccessoryView(target: self, action: #selector(phoneNumberTextFieldDoneAction))
    phoneNumberTextField.inputAccessoryView = accessoryView
  }

  private func validateForm() {
    saveChangesButton.isEnabled = isFormValid()
  }

  private func isFormValid() -> Bool {
    let isFirstNameValid = !firstNameTextField.string.isEmpty
    let isLastNameValid = !lastNameTextField.string.isEmpty
    let isEmailValid = isValid(email: emailTextField.string, using: emailValidator)
    let isPhoneValid = didFillMandatoryPhoneCharacters
    return isFirstNameValid && isLastNameValid && isEmailValid && isPhoneValid
  }

  // MARK: - Request Helpers

  private func saveChanges() {
    guard var user = user else {
      assertionFailure("User should be passed from previous screens.")
      return
    }
    user.firstName = firstNameTextField.string
    user.lastName = lastNameTextField.string
    user.email = emailTextField.string
    user.phone = phoneNumberTextField.string
    showLoadingDialog(message: Strings.shared.loading.updateUserProfile)
    userService.update(user) { [weak self] result in
      self?.handle(updateUserResult: result, user: user)
    }
  }

  private func handle(updateUserResult: Result<Void>, user: User) {
    hideLoadingDialog()
    switch updateUserResult {
    case .success:
      handleUpdateUserSuccess(user: user)
    case .failure(let error):
      display(error: error) { [weak self] in
        self?.saveChanges()
      }
    }
  }

  private func handleUpdateUserSuccess(user: User) {
    displaySuccessAlert()
  }

  private func displaySuccessAlert() {
    let title = Strings.shared.general.dialogTitle
    let message = Strings.shared.success.editProfile
    let controller = UIAlertController.okAlert(title: title, message: message) { [weak self] _ in
      self?.navigationController?.popViewController(animated: true)
    }
    present(controller, animated: true, completion: nil)
  }
}

extension EditProfileViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case emailTextField: firstNameTextField.becomeFirstResponder()
    case firstNameTextField: lastNameTextField.becomeFirstResponder()
    case lastNameTextField: countryCodeTextField.becomeFirstResponder()
    case countryCodeTextField: phoneNumberTextField.becomeFirstResponder()
    default: textField.resignFirstResponder()
    }
    return true
  }

  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    // Disable text input for country code text field. Input picker view should be used to change its text.
    if textField == countryCodeTextField {
      return false
    }
    return true
  }
}

extension EditProfileViewController: UserLoadable {
  func handle(user: User) {
    self.user = user
    firstNameTextField.text = user.firstName
    lastNameTextField.text = user.lastName
    emailTextField.text = user.email
    if let selectedRow = countryCodeAdapter.select(where: { $0.code == user.phoneCountryCode }) {
      countryCodePickerView.selectRow(selectedRow, inComponent: 0, animated: true)
    }
  }
}

extension EditProfileViewController: MaskedTextFieldDelegateListener {
  func textField(
    _ textField: UITextField,
    didFillMandatoryCharacters complete: Bool,
    didExtractValue value: String
  ) {
    user?.phone = value
    didFillMandatoryPhoneCharacters = complete
    validateForm()
  }
}
