// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Lune';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get home => 'Home';

  @override
  String get name => 'Name';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get email => 'Email';

  @override
  String get automatic => 'Automatic';

  @override
  String get system => 'System';

  @override
  String get save => 'Save';

  @override
  String get or => 'OR';

  @override
  String get biometric => 'Biometric';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get always => 'Always';

  @override
  String get never => 'Never';

  @override
  String get search => 'Search';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get done => 'Done';

  @override
  String get loading => 'Loading';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get tryAgain => 'Try again';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get logout => 'Logout';

  @override
  String get goBack => 'Go back';

  @override
  String get close => 'Close';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get change => 'Change';

  @override
  String get gotIt => 'Got it';

  @override
  String get accept => 'Accept';

  @override
  String get decline => 'Decline';

  @override
  String get enable => 'Enable';

  @override
  String get disable => 'Disable';

  @override
  String get welcome => 'Welcome';

  @override
  String get termsAndConditions => 'Terms & Conditions';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get update => 'Update';

  @override
  String get readMore => 'Read more';

  @override
  String get readLess => 'Read less';

  @override
  String get join => 'Join';

  @override
  String get keyboard => 'Keyboard';

  @override
  String get markAsRead => 'Mark as read';

  @override
  String get markAsUnread => 'Mark as unread';

  @override
  String get deleteAll => 'Delete all';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'There are no notifications';

  @override
  String get empty => 'Empty';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign up with email';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get send => 'Send';

  @override
  String get open => 'Open';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get takePicture => 'Take Picture';

  @override
  String get deletePicture => 'Delete Picture';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get password => 'Password';

  @override
  String get repeatPassword => 'Repeat Password';

  @override
  String get forgotMyPassword => 'I forgot my password';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get signInWithFacebook => 'Sign In with Facebook';

  @override
  String get connected => 'Connected';

  @override
  String get notConnected => 'No internet connection';

  @override
  String get generalError => 'An error occurred.';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String home_welcomeUser(String name) {
    return 'Hi, $name';
  }

  @override
  String get forgotPassword_emailSent => 'Email to reset password was sent';

  @override
  String get forgotPassword_title => 'Forgot Password';

  @override
  String get profile_userUpdated => 'Profile updated successfully';

  @override
  String get profile_messageActivePermission =>
      'We need your permission to use the camera';

  @override
  String get profile_imageUpdated => 'Image updated successfully';

  @override
  String get profile_imageDeleted => 'Image deleted successfully';

  @override
  String get signIn_emailDoesNotVerified =>
      'Please validate your email to continue';

  @override
  String get signIn_invalidCredential => 'Check your credentials';

  @override
  String get signIn_wrongPassword => 'Wrong password';

  @override
  String get signIn_userDisabled => 'User disabled';

  @override
  String get signIn_emailValidationSent =>
      'We sent you an email to verify your account';

  @override
  String get signUp_emailAlreadyInUse => 'The email is already in use';

  @override
  String get signUp_weakPassword => 'Password is too weak';

  @override
  String get signUp_InvalidEmailFormat => 'The email is invalid';

  @override
  String get lock_title => 'The app is locked';

  @override
  String get lock_description => 'Please, unlock the app to continue';

  @override
  String get lock_button => 'Unlock';

  @override
  String get lock_message => 'Authenticate to unlock the app';

  @override
  String get settings_titleConfirmDeleteAccount =>
      'This action is irreversible';

  @override
  String get settings_messageConfirmDeleteAccount =>
      'Before deleting your account, you must reauthenticate';

  @override
  String get settings_language => 'Language';

  @override
  String get settings_languageSpanish => 'Spanish';

  @override
  String get settings_languageEnglish => 'English';

  @override
  String get settings_resetPassword => 'Reset Password';

  @override
  String get settings_newPassword => 'New Password';

  @override
  String get settings_passwordUpdated => 'Password updated successfully';

  @override
  String get settings_checkPassword => 'Check the current password';

  @override
  String get validation_any =>
      'At least one of the required fields must be filled.';

  @override
  String get validation_compare => 'The fields must match.';

  @override
  String get validation_contains =>
      'The input must contain the required value.';

  @override
  String get validation_creditCard =>
      'Please enter a valid credit card number.';

  @override
  String get validation_email => 'Please enter a valid email address.';

  @override
  String get validation_equals => 'The values do not match.';

  @override
  String validation_max(num max) {
    return 'Value must be less than or equal to $max.';
  }

  @override
  String validation_maxLength(int max) {
    return 'Maximum length is $max characters.';
  }

  @override
  String validation_min(num min) {
    return 'Value must be greater than or equal to $min.';
  }

  @override
  String validation_minLength(int min) {
    return 'Minimum length is $min characters.';
  }

  @override
  String get validation_mustMatch => 'The fields must match.';

  @override
  String get validation_number => 'Please enter a valid number.';

  @override
  String get validation_pattern =>
      'The input does not match the required pattern.';

  @override
  String get validation_required => 'This field is required.';

  @override
  String get validation_requiredTrue => 'This field must be selected.';

  @override
  String get exception_credentialAlreadyExists =>
      'Already exists an account with this email';

  @override
  String get biometricSwitcher_activate => 'Active Biometric';

  @override
  String get biometricSwitcher_activateConfirmation =>
      'Do you want to activate biometric?';

  @override
  String get biometricSwitcher_deactivate => 'Deactivate Biometric';

  @override
  String get biometricSwitcher_deactivateConfirmation =>
      'Do you want to deactivate biometric?';

  @override
  String get biometricSwitcher_activateAuthReason =>
      'Authenticate to active the biometric';

  @override
  String get biometricSwitcher_deactivateAuthReason =>
      'Authenticate to deactivate the biometric';

  @override
  String get biometricSwitcher_notSupported =>
      'Your device does not support biometric';

  @override
  String get biometricSwitcher_every15Seconds => 'Every 15 seconds';

  @override
  String get biometricSwitcher_every30Seconds => 'Every 30 seconds';

  @override
  String get biometricSwitcher_everyMinute => 'Every minute';

  @override
  String get biometricSwitcher_every2Minutes => 'Every 2 minutes';

  @override
  String get biometricSwitcher_every5Minutes => 'Every 5 minutes';

  @override
  String get biometricSwitcher_every15Minutes => 'Every 15 minutes';

  @override
  String get biometricSwitcher_everyHour => 'Every hour';

  @override
  String get biometricSwitcher_everyDay => 'Every day';

  @override
  String get home_title => 'Title';

  @override
  String get home_subTitle => 'Calculate your remaining time';

  @override
  String get calculate => 'Calculate';

  @override
  String get enter_birthday => 'Enter your birthday';

  @override
  String get onboard_title => 'Welcome';

  @override
  String get onboard_description => 'Description';

  @override
  String get onboard_start => 'Start';

  @override
  String get systemDefault => 'System Default';

  @override
  String get legal => 'Legal';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get goToSettings => 'Go to Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get galleryIsDisabled =>
      'Gallery access is disabled, do you want to enable it?';

  @override
  String get cameraIsDisabled =>
      'Camera access is disabled, do you want to enable it?';

  @override
  String get notificationsAreDisabled =>
      'Notifications are disabled, do you want to enable them?';

  @override
  String get deleteAccountMessage =>
      'Are you sure you want to delete your account? This action is irreversible.';

  @override
  String get support => 'Support';

  @override
  String get submit => 'Submit';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get options => 'Options';

  @override
  String get supportDescription =>
      'If you have any questions or need assistance, please contact us.';

  @override
  String get ticketCreated => 'Support ticket created successfully';

  @override
  String get attachImages => 'Attach Images';

  @override
  String get maxImages => 'Max images';

  @override
  String get invalidPassword => 'Invalid password';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get iWantIt => 'I want it';

  @override
  String get confirmSignInNotification =>
      'To send notifications you must be signed in. Do you want to sign in?';

  @override
  String get confirmSignInProfile =>
      'To access your profile you must be signed in. Do you want to sign in?';

  @override
  String get manageDevices => 'Manage Devices';

  @override
  String get deleteAllDevices => 'Delete All Devices';

  @override
  String get deleteAllDevicesConfirmation =>
      'Are you sure you want to delete all devices? This action cannot be undone.';

  @override
  String get noDevicesFound => 'No devices found';

  @override
  String get deleteDevice => 'Delete Device';

  @override
  String get deleteDeviceConfirmation =>
      'Are you sure you want to delete this device?';

  @override
  String get deleteCurrentDeviceWarning =>
      'This is your current device. You will be signed out.';

  @override
  String errorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get createCompany => 'Create Company';

  @override
  String get companyName => 'Company Name';

  @override
  String get createChannel => 'Create Channel';

  @override
  String get myCompany => 'My Company';

  @override
  String get noCompaniesFound => 'No companies found';

  @override
  String get channelName => 'Channel Name';

  @override
  String get channelCreated => 'Channel created successfully';

  @override
  String get listeners => 'Listeners';

  @override
  String get addListener => 'Add Listener';

  @override
  String get editListener => 'Edit Listener';

  @override
  String get deleteListener => 'Delete Listener';

  @override
  String deleteListenerConfirmation(String listenerName) {
    return 'Are you sure you want to delete \"$listenerName\"?';
  }

  @override
  String get noListenersAdded => 'No listeners added yet';

  @override
  String get phoneNumberIsRequired => 'Phone number is required';

  @override
  String get address => 'Address';

  @override
  String get setOnMap => 'Set on Map';

  @override
  String get selectLocation => 'Select Location';

  @override
  String get dragMarkerToSelectLocation =>
      'Drag the marker to select a location';

  @override
  String get dragMapToSelectLocation => 'Drag the map to select a location';

  @override
  String get clear => 'Clear';

  @override
  String get listenerName => 'Listener Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get distanceToNotify => 'Distance to Notify (meters)';

  @override
  String get location => 'Location';

  @override
  String get removeListener => 'Remove Listener';

  @override
  String get importFromContacts => 'Import from Contacts';

  @override
  String get profileEmailNote =>
      'This email is not your authentication email, just for information';

  @override
  String get deviceDeletedSuccessfully => 'Device deleted successfully';

  @override
  String get editChannel => 'Edit Channel';

  @override
  String get enterChannelName => 'Enter channel name';

  @override
  String get enterChannelDescription => 'Enter channel description (optional)';

  @override
  String get nameIsRequired => 'Name is required';

  @override
  String get create => 'Create';

  @override
  String get deleteChannel => 'Delete Channel';

  @override
  String deleteChannelConfirmation(String channelName) {
    return 'Are you sure you want to delete \"$channelName\"?';
  }

  @override
  String get noChannelsFound =>
      'No channels found. Create one using the + button!';

  @override
  String get searchingLocation => 'Searching location...';

  @override
  String get locationFound => 'Location found';

  @override
  String get typeAddressForLocation => 'Type address to find coordinates';
}
