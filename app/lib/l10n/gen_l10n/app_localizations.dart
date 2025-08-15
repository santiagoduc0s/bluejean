import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Lune'**
  String get appName;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @automatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get automatic;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @biometric.
  ///
  /// In en, this message translates to:
  /// **'Biometric'**
  String get biometric;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @always.
  ///
  /// In en, this message translates to:
  /// **'Always'**
  String get always;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @disable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @readLess.
  ///
  /// In en, this message translates to:
  /// **'Read less'**
  String get readLess;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @keyboard.
  ///
  /// In en, this message translates to:
  /// **'Keyboard'**
  String get keyboard;

  /// No description provided for @markAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get markAsRead;

  /// No description provided for @markAsUnread.
  ///
  /// In en, this message translates to:
  /// **'Mark as unread'**
  String get markAsUnread;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get deleteAll;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'There are no notifications'**
  String get noNotifications;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get empty;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up with email'**
  String get signUp;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @takePicture.
  ///
  /// In en, this message translates to:
  /// **'Take Picture'**
  String get takePicture;

  /// No description provided for @deletePicture.
  ///
  /// In en, this message translates to:
  /// **'Delete Picture'**
  String get deletePicture;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @repeatPassword.
  ///
  /// In en, this message translates to:
  /// **'Repeat Password'**
  String get repeatPassword;

  /// No description provided for @forgotMyPassword.
  ///
  /// In en, this message translates to:
  /// **'I forgot my password'**
  String get forgotMyPassword;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// No description provided for @signInWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Sign In with Facebook'**
  String get signInWithFacebook;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get notConnected;

  /// No description provided for @generalError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred.'**
  String get generalError;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @home_welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}'**
  String home_welcomeUser(String name);

  /// No description provided for @forgotPassword_emailSent.
  ///
  /// In en, this message translates to:
  /// **'Email to reset password was sent'**
  String get forgotPassword_emailSent;

  /// No description provided for @forgotPassword_title.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword_title;

  /// No description provided for @profile_userUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profile_userUpdated;

  /// No description provided for @profile_messageActivePermission.
  ///
  /// In en, this message translates to:
  /// **'We need your permission to use the camera'**
  String get profile_messageActivePermission;

  /// No description provided for @profile_imageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Image updated successfully'**
  String get profile_imageUpdated;

  /// No description provided for @profile_imageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Image deleted successfully'**
  String get profile_imageDeleted;

  /// No description provided for @signIn_emailDoesNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Please validate your email to continue'**
  String get signIn_emailDoesNotVerified;

  /// No description provided for @signIn_invalidCredential.
  ///
  /// In en, this message translates to:
  /// **'Check your credentials'**
  String get signIn_invalidCredential;

  /// No description provided for @signIn_wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get signIn_wrongPassword;

  /// No description provided for @signIn_userDisabled.
  ///
  /// In en, this message translates to:
  /// **'User disabled'**
  String get signIn_userDisabled;

  /// No description provided for @signIn_emailValidationSent.
  ///
  /// In en, this message translates to:
  /// **'We sent you an email to verify your account'**
  String get signIn_emailValidationSent;

  /// No description provided for @signUp_emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'The email is already in use'**
  String get signUp_emailAlreadyInUse;

  /// No description provided for @signUp_weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get signUp_weakPassword;

  /// No description provided for @signUp_InvalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'The email is invalid'**
  String get signUp_InvalidEmailFormat;

  /// No description provided for @lock_title.
  ///
  /// In en, this message translates to:
  /// **'The app is locked'**
  String get lock_title;

  /// No description provided for @lock_description.
  ///
  /// In en, this message translates to:
  /// **'Please, unlock the app to continue'**
  String get lock_description;

  /// No description provided for @lock_button.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get lock_button;

  /// No description provided for @lock_message.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to unlock the app'**
  String get lock_message;

  /// No description provided for @settings_titleConfirmDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible'**
  String get settings_titleConfirmDeleteAccount;

  /// No description provided for @settings_messageConfirmDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Before deleting your account, you must reauthenticate'**
  String get settings_messageConfirmDeleteAccount;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @settings_languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get settings_languageSpanish;

  /// No description provided for @settings_languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settings_languageEnglish;

  /// No description provided for @settings_resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get settings_resetPassword;

  /// No description provided for @settings_newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get settings_newPassword;

  /// No description provided for @settings_passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get settings_passwordUpdated;

  /// No description provided for @settings_checkPassword.
  ///
  /// In en, this message translates to:
  /// **'Check the current password'**
  String get settings_checkPassword;

  /// No description provided for @validation_any.
  ///
  /// In en, this message translates to:
  /// **'At least one of the required fields must be filled.'**
  String get validation_any;

  /// No description provided for @validation_compare.
  ///
  /// In en, this message translates to:
  /// **'The fields must match.'**
  String get validation_compare;

  /// No description provided for @validation_contains.
  ///
  /// In en, this message translates to:
  /// **'The input must contain the required value.'**
  String get validation_contains;

  /// No description provided for @validation_creditCard.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid credit card number.'**
  String get validation_creditCard;

  /// No description provided for @validation_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get validation_email;

  /// No description provided for @validation_equals.
  ///
  /// In en, this message translates to:
  /// **'The values do not match.'**
  String get validation_equals;

  /// No description provided for @validation_max.
  ///
  /// In en, this message translates to:
  /// **'Value must be less than or equal to {max}.'**
  String validation_max(num max);

  /// No description provided for @validation_maxLength.
  ///
  /// In en, this message translates to:
  /// **'Maximum length is {max} characters.'**
  String validation_maxLength(int max);

  /// No description provided for @validation_min.
  ///
  /// In en, this message translates to:
  /// **'Value must be greater than or equal to {min}.'**
  String validation_min(num min);

  /// No description provided for @validation_minLength.
  ///
  /// In en, this message translates to:
  /// **'Minimum length is {min} characters.'**
  String validation_minLength(int min);

  /// No description provided for @validation_mustMatch.
  ///
  /// In en, this message translates to:
  /// **'The fields must match.'**
  String get validation_mustMatch;

  /// No description provided for @validation_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number.'**
  String get validation_number;

  /// No description provided for @validation_pattern.
  ///
  /// In en, this message translates to:
  /// **'The input does not match the required pattern.'**
  String get validation_pattern;

  /// No description provided for @validation_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get validation_required;

  /// No description provided for @validation_requiredTrue.
  ///
  /// In en, this message translates to:
  /// **'This field must be selected.'**
  String get validation_requiredTrue;

  /// No description provided for @exception_credentialAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Already exists an account with this email'**
  String get exception_credentialAlreadyExists;

  /// No description provided for @biometricSwitcher_activate.
  ///
  /// In en, this message translates to:
  /// **'Active Biometric'**
  String get biometricSwitcher_activate;

  /// No description provided for @biometricSwitcher_activateConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to activate biometric?'**
  String get biometricSwitcher_activateConfirmation;

  /// No description provided for @biometricSwitcher_deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Biometric'**
  String get biometricSwitcher_deactivate;

  /// No description provided for @biometricSwitcher_deactivateConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to deactivate biometric?'**
  String get biometricSwitcher_deactivateConfirmation;

  /// No description provided for @biometricSwitcher_activateAuthReason.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to active the biometric'**
  String get biometricSwitcher_activateAuthReason;

  /// No description provided for @biometricSwitcher_deactivateAuthReason.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to deactivate the biometric'**
  String get biometricSwitcher_deactivateAuthReason;

  /// No description provided for @biometricSwitcher_notSupported.
  ///
  /// In en, this message translates to:
  /// **'Your device does not support biometric'**
  String get biometricSwitcher_notSupported;

  /// No description provided for @biometricSwitcher_every15Seconds.
  ///
  /// In en, this message translates to:
  /// **'Every 15 seconds'**
  String get biometricSwitcher_every15Seconds;

  /// No description provided for @biometricSwitcher_every30Seconds.
  ///
  /// In en, this message translates to:
  /// **'Every 30 seconds'**
  String get biometricSwitcher_every30Seconds;

  /// No description provided for @biometricSwitcher_everyMinute.
  ///
  /// In en, this message translates to:
  /// **'Every minute'**
  String get biometricSwitcher_everyMinute;

  /// No description provided for @biometricSwitcher_every2Minutes.
  ///
  /// In en, this message translates to:
  /// **'Every 2 minutes'**
  String get biometricSwitcher_every2Minutes;

  /// No description provided for @biometricSwitcher_every5Minutes.
  ///
  /// In en, this message translates to:
  /// **'Every 5 minutes'**
  String get biometricSwitcher_every5Minutes;

  /// No description provided for @biometricSwitcher_every15Minutes.
  ///
  /// In en, this message translates to:
  /// **'Every 15 minutes'**
  String get biometricSwitcher_every15Minutes;

  /// No description provided for @biometricSwitcher_everyHour.
  ///
  /// In en, this message translates to:
  /// **'Every hour'**
  String get biometricSwitcher_everyHour;

  /// No description provided for @biometricSwitcher_everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get biometricSwitcher_everyDay;

  /// No description provided for @home_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get home_title;

  /// No description provided for @home_subTitle.
  ///
  /// In en, this message translates to:
  /// **'Calculate your remaining time'**
  String get home_subTitle;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @enter_birthday.
  ///
  /// In en, this message translates to:
  /// **'Enter your birthday'**
  String get enter_birthday;

  /// No description provided for @onboard_title.
  ///
  /// In en, this message translates to:
  /// **'School Bus Tracker'**
  String get onboard_title;

  /// No description provided for @onboard_description.
  ///
  /// In en, this message translates to:
  /// **'Keep families informed when you\'re near their homes. This app automatically notifies parents via WhatsApp when the school bus is approaching their location.'**
  String get onboard_description;

  /// No description provided for @onboard_start.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboard_start;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @goToSettings.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get goToSettings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @galleryIsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Gallery access is disabled, do you want to enable it?'**
  String get galleryIsDisabled;

  /// No description provided for @cameraIsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Camera access is disabled, do you want to enable it?'**
  String get cameraIsDisabled;

  /// No description provided for @notificationsAreDisabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications are disabled, do you want to enable them?'**
  String get notificationsAreDisabled;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action is irreversible.'**
  String get deleteAccountMessage;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @supportDescription.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions or need assistance, please contact us.'**
  String get supportDescription;

  /// No description provided for @ticketCreated.
  ///
  /// In en, this message translates to:
  /// **'Support ticket created successfully'**
  String get ticketCreated;

  /// No description provided for @attachImages.
  ///
  /// In en, this message translates to:
  /// **'Attach Images'**
  String get attachImages;

  /// No description provided for @maxImages.
  ///
  /// In en, this message translates to:
  /// **'Max images'**
  String get maxImages;

  /// No description provided for @invalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid password'**
  String get invalidPassword;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @iWantIt.
  ///
  /// In en, this message translates to:
  /// **'I want it'**
  String get iWantIt;

  /// No description provided for @confirmSignInNotification.
  ///
  /// In en, this message translates to:
  /// **'To send notifications you must be signed in. Do you want to sign in?'**
  String get confirmSignInNotification;

  /// No description provided for @confirmSignInProfile.
  ///
  /// In en, this message translates to:
  /// **'To access your profile you must be signed in. Do you want to sign in?'**
  String get confirmSignInProfile;

  /// No description provided for @manageDevices.
  ///
  /// In en, this message translates to:
  /// **'Manage Devices'**
  String get manageDevices;

  /// No description provided for @deleteAllDevices.
  ///
  /// In en, this message translates to:
  /// **'Delete All Devices'**
  String get deleteAllDevices;

  /// No description provided for @deleteAllDevicesConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all devices? This action cannot be undone.'**
  String get deleteAllDevicesConfirmation;

  /// No description provided for @noDevicesFound.
  ///
  /// In en, this message translates to:
  /// **'No devices found'**
  String get noDevicesFound;

  /// No description provided for @deleteDevice.
  ///
  /// In en, this message translates to:
  /// **'Delete Device'**
  String get deleteDevice;

  /// No description provided for @deleteDeviceConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this device?'**
  String get deleteDeviceConfirmation;

  /// No description provided for @deleteCurrentDeviceWarning.
  ///
  /// In en, this message translates to:
  /// **'This is your current device. You will be signed out.'**
  String get deleteCurrentDeviceWarning;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorPrefix(String error);

  /// No description provided for @createCompany.
  ///
  /// In en, this message translates to:
  /// **'Create Company'**
  String get createCompany;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @createChannel.
  ///
  /// In en, this message translates to:
  /// **'Create Channel'**
  String get createChannel;

  /// No description provided for @myCompany.
  ///
  /// In en, this message translates to:
  /// **'My Company'**
  String get myCompany;

  /// No description provided for @noCompaniesFound.
  ///
  /// In en, this message translates to:
  /// **'No companies found'**
  String get noCompaniesFound;

  /// No description provided for @channelName.
  ///
  /// In en, this message translates to:
  /// **'Channel Name'**
  String get channelName;

  /// No description provided for @channelCreated.
  ///
  /// In en, this message translates to:
  /// **'Channel created successfully'**
  String get channelCreated;

  /// No description provided for @listeners.
  ///
  /// In en, this message translates to:
  /// **'Listeners'**
  String get listeners;

  /// No description provided for @addListener.
  ///
  /// In en, this message translates to:
  /// **'Add Listener'**
  String get addListener;

  /// No description provided for @editListener.
  ///
  /// In en, this message translates to:
  /// **'Edit Listener'**
  String get editListener;

  /// No description provided for @deleteListener.
  ///
  /// In en, this message translates to:
  /// **'Delete Listener'**
  String get deleteListener;

  /// No description provided for @deleteListenerConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{listenerName}\"?'**
  String deleteListenerConfirmation(String listenerName);

  /// No description provided for @noListenersAdded.
  ///
  /// In en, this message translates to:
  /// **'No listeners added yet'**
  String get noListenersAdded;

  /// No description provided for @phoneNumberIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberIsRequired;

  /// No description provided for @phoneNumberInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be in international format +1234567890 (country code + number, no spaces)'**
  String get phoneNumberInvalidFormat;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @setOnMap.
  ///
  /// In en, this message translates to:
  /// **'Set on Map'**
  String get setOnMap;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @dragMarkerToSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Drag the marker to select a location'**
  String get dragMarkerToSelectLocation;

  /// No description provided for @dragMapToSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Drag the map to select a location'**
  String get dragMapToSelectLocation;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @listenerName.
  ///
  /// In en, this message translates to:
  /// **'Listener Name'**
  String get listenerName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @distanceToNotify.
  ///
  /// In en, this message translates to:
  /// **'Distance to Notify (meters)'**
  String get distanceToNotify;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @removeListener.
  ///
  /// In en, this message translates to:
  /// **'Remove Listener'**
  String get removeListener;

  /// No description provided for @importFromContacts.
  ///
  /// In en, this message translates to:
  /// **'Import from Contacts'**
  String get importFromContacts;

  /// No description provided for @profileEmailNote.
  ///
  /// In en, this message translates to:
  /// **'This email is not your authentication email, just for information'**
  String get profileEmailNote;

  /// No description provided for @deviceDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Device deleted successfully'**
  String get deviceDeletedSuccessfully;

  /// No description provided for @editChannel.
  ///
  /// In en, this message translates to:
  /// **'Edit Channel'**
  String get editChannel;

  /// No description provided for @enterChannelName.
  ///
  /// In en, this message translates to:
  /// **'Enter channel name'**
  String get enterChannelName;

  /// No description provided for @enterChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter channel description (optional)'**
  String get enterChannelDescription;

  /// No description provided for @nameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameIsRequired;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @deleteChannel.
  ///
  /// In en, this message translates to:
  /// **'Delete Channel'**
  String get deleteChannel;

  /// No description provided for @deleteChannelConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{channelName}\"?'**
  String deleteChannelConfirmation(String channelName);

  /// No description provided for @noChannelsFound.
  ///
  /// In en, this message translates to:
  /// **'No channels found. Create one using the + button!'**
  String get noChannelsFound;

  /// No description provided for @searchingLocation.
  ///
  /// In en, this message translates to:
  /// **'Searching location...'**
  String get searchingLocation;

  /// No description provided for @locationFound.
  ///
  /// In en, this message translates to:
  /// **'Location found'**
  String get locationFound;

  /// No description provided for @typeAddressForLocation.
  ///
  /// In en, this message translates to:
  /// **'Type address to find coordinates'**
  String get typeAddressForLocation;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @activeChannels.
  ///
  /// In en, this message translates to:
  /// **'Active Channels'**
  String get activeChannels;

  /// No description provided for @inactiveChannels.
  ///
  /// In en, this message translates to:
  /// **'Inactive Channels'**
  String get inactiveChannels;

  /// No description provided for @activeChannelsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The listeners of these channels will be notified when the car is close to their location'**
  String get activeChannelsSubtitle;

  /// No description provided for @inactiveChannelsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'These channels are disabled and the driving mode needs to be updated'**
  String get inactiveChannelsSubtitle;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @threshold.
  ///
  /// In en, this message translates to:
  /// **'Threshold'**
  String get threshold;

  /// No description provided for @errorLoadingNotifications.
  ///
  /// In en, this message translates to:
  /// **'Error loading notifications'**
  String get errorLoadingNotifications;

  /// No description provided for @noNotificationsFound.
  ///
  /// In en, this message translates to:
  /// **'No notifications found'**
  String get noNotificationsFound;

  /// No description provided for @notificationsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Notifications will appear here when the bus is near this listener\'s location'**
  String get notificationsWillAppearHere;

  /// No description provided for @coordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinates;

  /// No description provided for @tutorialLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Tracking'**
  String get tutorialLocationTitle;

  /// No description provided for @tutorialLocationDescription.
  ///
  /// In en, this message translates to:
  /// **'Press this button to activate your location. The listeners of the activated channels will be notified when you are close to them.'**
  String get tutorialLocationDescription;

  /// No description provided for @tutorialAddChannelTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Channel'**
  String get tutorialAddChannelTitle;

  /// No description provided for @tutorialAddChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Press this button to create a new channel. Channels help you organize your listeners by routes or groups.'**
  String get tutorialAddChannelDescription;

  /// No description provided for @tutorialGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get tutorialGotIt;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
