import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'OBD Vision'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get navService;

  /// No description provided for @navDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get navDiagnosis;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @languageAndUnits.
  ///
  /// In en, this message translates to:
  /// **'Language & Units'**
  String get languageAndUnits;

  /// No description provided for @languageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSection;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @englishLabel.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLabel;

  /// No description provided for @englishSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Default interface translation'**
  String get englishSubtitle;

  /// No description provided for @arabicLabel.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabicLabel;

  /// No description provided for @arabicPill.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabicPill;

  /// No description provided for @arabicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'RTL layout optimized'**
  String get arabicSubtitle;

  /// No description provided for @unitsOfMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Units of Measurement'**
  String get unitsOfMeasurement;

  /// No description provided for @telemetrySync.
  ///
  /// In en, this message translates to:
  /// **'Telemetry sync'**
  String get telemetrySync;

  /// No description provided for @distanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distanceTitle;

  /// No description provided for @distanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Odometer & range'**
  String get distanceSubtitle;

  /// No description provided for @temperatureTitle.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperatureTitle;

  /// No description provided for @temperatureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Coolant, oil & cabin'**
  String get temperatureSubtitle;

  /// No description provided for @unitsReassuranceNote.
  ///
  /// In en, this message translates to:
  /// **'Changes apply automatically across all connected vehicles'**
  String get unitsReassuranceNote;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your Account'**
  String get signInTitle;

  /// No description provided for @emailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddressLabel;

  /// No description provided for @emailAddressCapLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddressCapLabel;

  /// No description provided for @enterEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterEmailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @enterPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPasswordHint;

  /// No description provided for @forgotPasswordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordQuestion;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInButton;

  /// No description provided for @otherWayToSignIn.
  ///
  /// In en, this message translates to:
  /// **'other way to sign in'**
  String get otherWayToSignIn;

  /// No description provided for @dontHaveAccountPrefix.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account? '**
  String get dontHaveAccountPrefix;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @enterFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullNameHint;

  /// No description provided for @phoneOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number (optional)'**
  String get phoneOptionalLabel;

  /// No description provided for @enterPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneHint;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @enterConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your confirm password'**
  String get enterConfirmPasswordHint;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUpButton;

  /// No description provided for @alreadyHaveAccountPrefix.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccountPrefix;

  /// No description provided for @termsAgreeRequired.
  ///
  /// In en, this message translates to:
  /// **'You must agree to the User Agreement & Privacy Policy'**
  String get termsAgreeRequired;

  /// No description provided for @agreePrefix.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to '**
  String get agreePrefix;

  /// No description provided for @userAgreement.
  ///
  /// In en, this message translates to:
  /// **'User Agreement'**
  String get userAgreement;

  /// No description provided for @andWord.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get andWord;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email address to receive a password reset link.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @enterYourEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Email Address'**
  String get enterYourEmailTitle;

  /// No description provided for @sendResetLinkButton.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLinkButton;

  /// No description provided for @resetLinkSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get resetLinkSentTitle;

  /// No description provided for @resetLinkSentMessage.
  ///
  /// In en, this message translates to:
  /// **'We sent a password reset link to {email}. Tap the link in your email to open the app and choose a new password.'**
  String resetLinkSentMessage(String email);

  /// No description provided for @setNewPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get setNewPasswordTitle;

  /// No description provided for @setNewPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a strong password of at least 8 characters for your account.'**
  String get setNewPasswordSubtitle;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordLabel;

  /// No description provided for @confirmNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPasswordLabel;

  /// No description provided for @updatePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePasswordButton;

  /// No description provided for @passwordUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your password has been updated successfully.'**
  String get passwordUpdatedSuccess;

  /// No description provided for @validationEnterFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get validationEnterFullName;

  /// No description provided for @validationEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validationEnterValidEmail;

  /// No description provided for @validationPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get validationPasswordMinLength;

  /// No description provided for @validationPasswordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordsMismatch;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign in'**
  String get backToSignIn;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @myVehicle.
  ///
  /// In en, this message translates to:
  /// **'My vehicle'**
  String get myVehicle;

  /// No description provided for @myDevice.
  ///
  /// In en, this message translates to:
  /// **'My device'**
  String get myDevice;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @privacyAndData.
  ///
  /// In en, this message translates to:
  /// **'Privacy & data'**
  String get privacyAndData;

  /// No description provided for @settingSection.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get settingSection;

  /// No description provided for @languageAndUnitsMenu.
  ///
  /// In en, this message translates to:
  /// **'Language & units'**
  String get languageAndUnitsMenu;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccess;

  /// No description provided for @allDataEncrypted.
  ///
  /// In en, this message translates to:
  /// **'All data will be encrypted'**
  String get allDataEncrypted;

  /// No description provided for @firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameLabel;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstNameHint;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameLabel;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastNameHint;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderPreferNot.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get genderPreferNot;

  /// No description provided for @birthdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthdayLabel;

  /// No description provided for @connectedObdLabel.
  ///
  /// In en, this message translates to:
  /// **'Connected · OBD-II v2.4'**
  String get connectedObdLabel;

  /// No description provided for @connectingObdLabel.
  ///
  /// In en, this message translates to:
  /// **'Connecting to OBD-II...'**
  String get connectingObdLabel;

  /// No description provided for @runDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Run Diagnosis'**
  String get runDiagnosis;

  /// No description provided for @runDiagnosisHome.
  ///
  /// In en, this message translates to:
  /// **'Run diagnosis'**
  String get runDiagnosisHome;

  /// No description provided for @seeDetails.
  ///
  /// In en, this message translates to:
  /// **'See Details'**
  String get seeDetails;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @liveTelemetry.
  ///
  /// In en, this message translates to:
  /// **'Live Telemetry'**
  String get liveTelemetry;

  /// No description provided for @earlyWarning.
  ///
  /// In en, this message translates to:
  /// **'Early Warning'**
  String get earlyWarning;

  /// No description provided for @systemHealthAndAlert.
  ///
  /// In en, this message translates to:
  /// **'System Health & Alert'**
  String get systemHealthAndAlert;

  /// No description provided for @healthScoreBadge.
  ///
  /// In en, this message translates to:
  /// **'HEALTH'**
  String get healthScoreBadge;

  /// No description provided for @defaultWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Coolant temperature\ntrending high'**
  String get defaultWarningTitle;

  /// No description provided for @defaultWarningSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Last scan today, 09:40 · Inspect sensor'**
  String get defaultWarningSubtitle;

  /// No description provided for @activeWorkshopService.
  ///
  /// In en, this message translates to:
  /// **'Active Workshop Service'**
  String get activeWorkshopService;

  /// No description provided for @trackAction.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get trackAction;

  /// No description provided for @repairInProgress.
  ///
  /// In en, this message translates to:
  /// **'Repair in progress'**
  String get repairInProgress;

  /// No description provided for @stageLabel.
  ///
  /// In en, this message translates to:
  /// **'Stage 4/5'**
  String get stageLabel;

  /// No description provided for @defaultCenterName.
  ///
  /// In en, this message translates to:
  /// **'Al-Nour Service Center'**
  String get defaultCenterName;

  /// No description provided for @defaultServiceType.
  ///
  /// In en, this message translates to:
  /// **'Radiator Flush'**
  String get defaultServiceType;

  /// No description provided for @telemetryIdle.
  ///
  /// In en, this message translates to:
  /// **'IDLE'**
  String get telemetryIdle;

  /// No description provided for @telemetryHigh.
  ///
  /// In en, this message translates to:
  /// **'HIGH'**
  String get telemetryHigh;

  /// No description provided for @telemetryNormal.
  ///
  /// In en, this message translates to:
  /// **'NORMAL'**
  String get telemetryNormal;

  /// No description provided for @telemetryEngineSpeed.
  ///
  /// In en, this message translates to:
  /// **'Engine Speed'**
  String get telemetryEngineSpeed;

  /// No description provided for @telemetryCoolantTemp.
  ///
  /// In en, this message translates to:
  /// **'Coolant Temp'**
  String get telemetryCoolantTemp;

  /// No description provided for @telemetryAlternator.
  ///
  /// In en, this message translates to:
  /// **'Alternator'**
  String get telemetryAlternator;

  /// No description provided for @unitRpm.
  ///
  /// In en, this message translates to:
  /// **'RPM'**
  String get unitRpm;

  /// No description provided for @unitVolt.
  ///
  /// In en, this message translates to:
  /// **'Volt'**
  String get unitVolt;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportTitle;

  /// No description provided for @summaryTab.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summaryTab;

  /// No description provided for @causesTab.
  ///
  /// In en, this message translates to:
  /// **'Causes'**
  String get causesTab;

  /// No description provided for @aiEstimateTitle.
  ///
  /// In en, this message translates to:
  /// **'AI estimate'**
  String get aiEstimateTitle;

  /// No description provided for @rankedByLikelihood.
  ///
  /// In en, this message translates to:
  /// **'Ranked by likelihood'**
  String get rankedByLikelihood;

  /// No description provided for @whatsHappening.
  ///
  /// In en, this message translates to:
  /// **'What\'s happening'**
  String get whatsHappening;

  /// No description provided for @nextBestStep.
  ///
  /// In en, this message translates to:
  /// **'Next best step'**
  String get nextBestStep;

  /// No description provided for @safetyWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Safety Warning'**
  String get safetyWarningTitle;

  /// No description provided for @aiInferenceBadge.
  ///
  /// In en, this message translates to:
  /// **'AI Probabilistic Inference'**
  String get aiInferenceBadge;

  /// No description provided for @measuredSensorBadge.
  ///
  /// In en, this message translates to:
  /// **'Direct Sensor Measurement'**
  String get measuredSensorBadge;

  /// No description provided for @srsDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic findings are generated based on available OBD-II telemetry and AI inference models. They constitute probabilistic guidance and must be validated by a certified automotive technician before part replacement.'**
  String get srsDisclaimer;

  /// No description provided for @findServiceCenter.
  ///
  /// In en, this message translates to:
  /// **'Find service center'**
  String get findServiceCenter;

  /// No description provided for @doneButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneButton;

  /// No description provided for @possibleEngineMisfire.
  ///
  /// In en, this message translates to:
  /// **'Possible engine misfire'**
  String get possibleEngineMisfire;

  /// No description provided for @fallbackExplanation.
  ///
  /// In en, this message translates to:
  /// **'Your engine may not be burning fuel properly in one cylinder. This can cause shaking and higher fuel use.'**
  String get fallbackExplanation;

  /// No description provided for @fallbackNextStep.
  ///
  /// In en, this message translates to:
  /// **'Check the spark plugs and ignition coil'**
  String get fallbackNextStep;

  /// No description provided for @checkSoonBadge.
  ///
  /// In en, this message translates to:
  /// **'Check soon'**
  String get checkSoonBadge;

  /// No description provided for @todayDefaultTime.
  ///
  /// In en, this message translates to:
  /// **'Today, 9:40'**
  String get todayDefaultTime;

  /// No description provided for @commonCausesHint.
  ///
  /// In en, this message translates to:
  /// **'These are the most common causes of this code'**
  String get commonCausesHint;

  /// No description provided for @liveDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Live data'**
  String get liveDataTitle;

  /// No description provided for @pauseButton.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseButton;

  /// No description provided for @resumeButton.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resumeButton;

  /// No description provided for @liveSensorEngineSpeed.
  ///
  /// In en, this message translates to:
  /// **'Engine speed'**
  String get liveSensorEngineSpeed;

  /// No description provided for @liveSensorBattery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get liveSensorBattery;

  /// No description provided for @liveSensorShortFuelTrim.
  ///
  /// In en, this message translates to:
  /// **'Short fuel trim'**
  String get liveSensorShortFuelTrim;

  /// No description provided for @liveSensorEngineLoad.
  ///
  /// In en, this message translates to:
  /// **'Engine Load'**
  String get liveSensorEngineLoad;

  /// No description provided for @liveSensorCoolantTemp.
  ///
  /// In en, this message translates to:
  /// **'Coolant temp'**
  String get liveSensorCoolantTemp;

  /// No description provided for @liveSensorVehicleSpeed.
  ///
  /// In en, this message translates to:
  /// **'Vehicle speed'**
  String get liveSensorVehicleSpeed;

  /// No description provided for @liveSensorThrottlePos.
  ///
  /// In en, this message translates to:
  /// **'Throttle pos'**
  String get liveSensorThrottlePos;

  /// No description provided for @liveSensorMapPressure.
  ///
  /// In en, this message translates to:
  /// **'MAP Pressure'**
  String get liveSensorMapPressure;

  /// No description provided for @statusNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get statusNormal;

  /// No description provided for @statusHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get statusHigh;

  /// No description provided for @statusMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get statusMedium;

  /// No description provided for @checkBeforeYouScan.
  ///
  /// In en, this message translates to:
  /// **'Check before you scan'**
  String get checkBeforeYouScan;

  /// No description provided for @scanYourVehicle.
  ///
  /// In en, this message translates to:
  /// **'Scan your vehicle'**
  String get scanYourVehicle;

  /// No description provided for @scanCompleted.
  ///
  /// In en, this message translates to:
  /// **'Scan completed'**
  String get scanCompleted;

  /// No description provided for @scanStepIndicator.
  ///
  /// In en, this message translates to:
  /// **'SCAN - {step} OF 3'**
  String scanStepIndicator(int step);

  /// No description provided for @obdScannerConnected.
  ///
  /// In en, this message translates to:
  /// **'OBD-II Scanner Connected'**
  String get obdScannerConnected;

  /// No description provided for @readyToCommunicateEcu.
  ///
  /// In en, this message translates to:
  /// **'Ready to communicate with ECU bus'**
  String get readyToCommunicateEcu;

  /// No description provided for @beforeYouStart.
  ///
  /// In en, this message translates to:
  /// **'Before you start:'**
  String get beforeYouStart;

  /// No description provided for @precheckRule1.
  ///
  /// In en, this message translates to:
  /// **'Park car in a safe, ventilated area'**
  String get precheckRule1;

  /// No description provided for @precheckRule2.
  ///
  /// In en, this message translates to:
  /// **'Turn ignition ON (engine running or idle)'**
  String get precheckRule2;

  /// No description provided for @precheckRule3.
  ///
  /// In en, this message translates to:
  /// **'Keep device within Bluetooth range (~5m)'**
  String get precheckRule3;

  /// No description provided for @precheckRule4.
  ///
  /// In en, this message translates to:
  /// **'Do not unplug scanner during scan'**
  String get precheckRule4;

  /// No description provided for @startScanButton.
  ///
  /// In en, this message translates to:
  /// **'Start scan'**
  String get startScanButton;

  /// No description provided for @watchLiveDataOnly.
  ///
  /// In en, this message translates to:
  /// **'Watch live data only'**
  String get watchLiveDataOnly;

  /// No description provided for @scanningEcu.
  ///
  /// In en, this message translates to:
  /// **'Scanning ECU'**
  String get scanningEcu;

  /// No description provided for @readingTroubleCodes.
  ///
  /// In en, this message translates to:
  /// **'Reading trouble codes'**
  String get readingTroubleCodes;

  /// No description provided for @readingLiveSensors.
  ///
  /// In en, this message translates to:
  /// **'Reading live sensors'**
  String get readingLiveSensors;

  /// No description provided for @pidsQueriedProgress.
  ///
  /// In en, this message translates to:
  /// **'{count} of 27 PIDs queried'**
  String pidsQueriedProgress(int count);

  /// No description provided for @aiRuleEngineEval.
  ///
  /// In en, this message translates to:
  /// **'AI RuleEngine Diagnostic Evaluation'**
  String get aiRuleEngineEval;

  /// No description provided for @synthesizingReport.
  ///
  /// In en, this message translates to:
  /// **'Synthesizing diagnostic report'**
  String get synthesizingReport;

  /// No description provided for @keepIgnitionRange.
  ///
  /// In en, this message translates to:
  /// **'Keep ignition on and stay within OBD Bluetooth range'**
  String get keepIgnitionRange;

  /// No description provided for @cancelScanButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel scan'**
  String get cancelScanButton;

  /// No description provided for @issuesDetected.
  ///
  /// In en, this message translates to:
  /// **'Issues Detected'**
  String get issuesDetected;

  /// No description provided for @vehicleSystemsHealthy.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Systems Healthy'**
  String get vehicleSystemsHealthy;

  /// No description provided for @faultCodesRecorded.
  ///
  /// In en, this message translates to:
  /// **'{count} fault code(s) recorded in ECU bus'**
  String faultCodesRecorded(int count);

  /// No description provided for @allSensorsNominal.
  ///
  /// In en, this message translates to:
  /// **'All 27 sensors operating within factory tolerance'**
  String get allSensorsNominal;

  /// No description provided for @viewFullAiReport.
  ///
  /// In en, this message translates to:
  /// **'View Full AI Report'**
  String get viewFullAiReport;

  /// No description provided for @findNearbyServiceCenter.
  ///
  /// In en, this message translates to:
  /// **'Find Nearby Service Center'**
  String get findNearbyServiceCenter;

  /// No description provided for @runScanAgain.
  ///
  /// In en, this message translates to:
  /// **'Run Scan Again'**
  String get runScanAgain;

  /// No description provided for @diagnosticHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic History'**
  String get diagnosticHistoryTitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterFaults.
  ///
  /// In en, this message translates to:
  /// **'Faults'**
  String get filterFaults;

  /// No description provided for @filterRoutine.
  ///
  /// In en, this message translates to:
  /// **'Routine'**
  String get filterRoutine;

  /// No description provided for @filterTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get filterTrips;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @noDiagnosticLogs.
  ///
  /// In en, this message translates to:
  /// **'No diagnostic logs found for this filter.'**
  String get noDiagnosticLogs;

  /// No description provided for @justNowLabel.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNowLabel;

  /// No description provided for @serviceCentersTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Centers'**
  String get serviceCentersTitle;

  /// No description provided for @searchCenterHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or area'**
  String get searchCenterHint;

  /// No description provided for @centersNearYou.
  ///
  /// In en, this message translates to:
  /// **'{count} centers near you'**
  String centersNearYou(int count);

  /// No description provided for @nearestFirst.
  ///
  /// In en, this message translates to:
  /// **'Nearest first'**
  String get nearestFirst;

  /// No description provided for @listViewTab.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get listViewTab;

  /// No description provided for @mapViewTab.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapViewTab;

  /// No description provided for @activeTag.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeTag;

  /// No description provided for @readyThursdaySub.
  ///
  /// In en, this message translates to:
  /// **'Al-Nour Service · Ready Thursday'**
  String get readyThursdaySub;

  /// No description provided for @callButton.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get callButton;

  /// No description provided for @bookButton.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get bookButton;

  /// No description provided for @compatibleBadge.
  ///
  /// In en, this message translates to:
  /// **'Compatible'**
  String get compatibleBadge;

  /// No description provided for @bookAppointmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get bookAppointmentTitle;

  /// No description provided for @bookAppointmentButton.
  ///
  /// In en, this message translates to:
  /// **'Book appointment'**
  String get bookAppointmentButton;

  /// No description provided for @reviewsCountText.
  ///
  /// In en, this message translates to:
  /// **'({count} reviews)'**
  String reviewsCountText(int count);

  /// No description provided for @distanceAway.
  ///
  /// In en, this message translates to:
  /// **'{distance} away'**
  String distanceAway(String distance);

  /// No description provided for @specialtiesTitle.
  ///
  /// In en, this message translates to:
  /// **'SPECIALTIES'**
  String get specialtiesTitle;

  /// No description provided for @specialtyEngine.
  ///
  /// In en, this message translates to:
  /// **'Engine Repair'**
  String get specialtyEngine;

  /// No description provided for @specialtyElectrical.
  ///
  /// In en, this message translates to:
  /// **'Electrical'**
  String get specialtyElectrical;

  /// No description provided for @specialtyBrakes.
  ///
  /// In en, this message translates to:
  /// **'Brakes'**
  String get specialtyBrakes;

  /// No description provided for @specialtyAc.
  ///
  /// In en, this message translates to:
  /// **'AC & Climate'**
  String get specialtyAc;

  /// No description provided for @authorizedBrandsTitle.
  ///
  /// In en, this message translates to:
  /// **'AUTHORIZED BRANDS'**
  String get authorizedBrandsTitle;

  /// No description provided for @downtownAutomotive.
  ///
  /// In en, this message translates to:
  /// **'Downtown Automotive District'**
  String get downtownAutomotive;

  /// No description provided for @directionsButton.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directionsButton;

  /// No description provided for @certifiedPartner.
  ///
  /// In en, this message translates to:
  /// **'Certified OBD-II Diagnostic Partner'**
  String get certifiedPartner;

  /// No description provided for @selectDateTitle.
  ///
  /// In en, this message translates to:
  /// **'SELECT DATE'**
  String get selectDateTitle;

  /// No description provided for @selectTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'SELECT TIME'**
  String get selectTimeTitle;

  /// No description provided for @shareDiagnosticReport.
  ///
  /// In en, this message translates to:
  /// **'Share Diagnostic Report'**
  String get shareDiagnosticReport;

  /// No description provided for @includesRecentDtcs.
  ///
  /// In en, this message translates to:
  /// **'Includes recent DTCs & engine health status'**
  String get includesRecentDtcs;

  /// No description provided for @addBookingNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Add a note (e.g. check engine light on, strange noise)...'**
  String get addBookingNoteHint;

  /// No description provided for @bookingSummaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Booking Summary'**
  String get bookingSummaryLabel;

  /// No description provided for @confirmAppointmentButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Appointment'**
  String get confirmAppointmentButton;

  /// No description provided for @bookingConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmation'**
  String get bookingConfirmationTitle;

  /// No description provided for @bookingConfirmedHeading.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed'**
  String get bookingConfirmedHeading;

  /// No description provided for @automotiveDiagnosticsCare.
  ///
  /// In en, this message translates to:
  /// **'Automotive Diagnostics & Care'**
  String get automotiveDiagnosticsCare;

  /// No description provided for @confirmedArrivalSlot.
  ///
  /// In en, this message translates to:
  /// **'Confirmed arrival slot'**
  String get confirmedArrivalSlot;

  /// No description provided for @selectedVehicleLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected vehicle'**
  String get selectedVehicleLabel;

  /// No description provided for @trackBookingButton.
  ///
  /// In en, this message translates to:
  /// **'Track booking'**
  String get trackBookingButton;

  /// No description provided for @backToHomeButton.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backToHomeButton;

  /// No description provided for @myVehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'My Vehicle'**
  String get myVehicleTitle;

  /// No description provided for @addVehicleCta.
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get addVehicleCta;

  /// No description provided for @addVehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'Add vehicle'**
  String get addVehicleTitle;

  /// No description provided for @editVehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit vehicle'**
  String get editVehicleTitle;

  /// No description provided for @vehicleHistoryNotice.
  ///
  /// In en, this message translates to:
  /// **'Each vehicle keeps its own diagnostic history.'**
  String get vehicleHistoryNotice;

  /// No description provided for @vehicleNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Name'**
  String get vehicleNameLabel;

  /// No description provided for @vehicleNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Corolla 2018'**
  String get vehicleNameHint;

  /// No description provided for @nicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nicknameLabel;

  /// No description provided for @nicknameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. My daily car'**
  String get nicknameHint;

  /// No description provided for @energySourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Energy source'**
  String get energySourceLabel;

  /// No description provided for @energySourceHint.
  ///
  /// In en, this message translates to:
  /// **'Petrol / Hybrid / Electric'**
  String get energySourceHint;

  /// No description provided for @mileageLabel.
  ///
  /// In en, this message translates to:
  /// **'Mileage'**
  String get mileageLabel;

  /// No description provided for @vinOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'VIN (optional)'**
  String get vinOptionalLabel;

  /// No description provided for @vinLabel.
  ///
  /// In en, this message translates to:
  /// **'VIN'**
  String get vinLabel;

  /// No description provided for @vinHint.
  ///
  /// In en, this message translates to:
  /// **'ENTER 17-CHARACTER VIN'**
  String get vinHint;

  /// No description provided for @vinHelper.
  ///
  /// In en, this message translates to:
  /// **'17 characters. Helps us match your exact vehicle model'**
  String get vinHelper;

  /// No description provided for @enterVehicleNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter vehicle name'**
  String get enterVehicleNameError;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @deleteVehicle.
  ///
  /// In en, this message translates to:
  /// **'Delete vehicle'**
  String get deleteVehicle;

  /// No description provided for @setAsCurrent.
  ///
  /// In en, this message translates to:
  /// **'Set as current'**
  String get setAsCurrent;

  /// No description provided for @currentBadge.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentBadge;

  /// No description provided for @myDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'My device'**
  String get myDeviceTitle;

  /// No description provided for @deviceConnectedStatus.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get deviceConnectedStatus;

  /// No description provided for @serialLabel.
  ///
  /// In en, this message translates to:
  /// **'Serial'**
  String get serialLabel;

  /// No description provided for @firmwareLabel.
  ///
  /// In en, this message translates to:
  /// **'Firmware'**
  String get firmwareLabel;

  /// No description provided for @lastConnectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Last connected'**
  String get lastConnectedLabel;

  /// No description provided for @linkedVehicleLabel.
  ///
  /// In en, this message translates to:
  /// **'Linked vehicle'**
  String get linkedVehicleLabel;

  /// No description provided for @rePairDevice.
  ///
  /// In en, this message translates to:
  /// **'Re-pair device'**
  String get rePairDevice;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get checkForUpdates;

  /// No description provided for @deactivateDevice.
  ///
  /// In en, this message translates to:
  /// **'Deactivate device'**
  String get deactivateDevice;

  /// No description provided for @earlyWarningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Early warnings'**
  String get earlyWarningsTitle;

  /// No description provided for @earlyWarningsSub.
  ///
  /// In en, this message translates to:
  /// **'When we notice unusual vehicle behavior'**
  String get earlyWarningsSub;

  /// No description provided for @diagnosticReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic reports'**
  String get diagnosticReportsTitle;

  /// No description provided for @diagnosticReportsSub.
  ///
  /// In en, this message translates to:
  /// **'When your AI analysis report is ready'**
  String get diagnosticReportsSub;

  /// No description provided for @bookingUpdatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking updates'**
  String get bookingUpdatesTitle;

  /// No description provided for @bookingUpdatesSub.
  ///
  /// In en, this message translates to:
  /// **'Status changes from your service centers'**
  String get bookingUpdatesSub;

  /// No description provided for @quoteApprovalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quote approvals'**
  String get quoteApprovalsTitle;

  /// No description provided for @quoteApprovalsSub.
  ///
  /// In en, this message translates to:
  /// **'When a revised quote needs your review'**
  String get quoteApprovalsSub;

  /// No description provided for @deviceStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Device status'**
  String get deviceStatusTitle;

  /// No description provided for @deviceStatusSub.
  ///
  /// In en, this message translates to:
  /// **'When your scanner disconnects or connects'**
  String get deviceStatusSub;

  /// No description provided for @criticalWarningsNote.
  ///
  /// In en, this message translates to:
  /// **'Critical safety warnings cannot be disabled.'**
  String get criticalWarningsNote;

  /// No description provided for @vehicleSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Support'**
  String get vehicleSupportTitle;

  /// No description provided for @activeDiagnosticAssist.
  ///
  /// In en, this message translates to:
  /// **'Active diagnostic assistance'**
  String get activeDiagnosticAssist;

  /// No description provided for @onlineBadge.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get onlineBadge;

  /// No description provided for @needHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get needHelpTitle;

  /// No description provided for @replyWithinMinutes.
  ///
  /// In en, this message translates to:
  /// **'We usually reply within minutes.'**
  String get replyWithinMinutes;

  /// No description provided for @chatWithUs.
  ///
  /// In en, this message translates to:
  /// **'Chat with us'**
  String get chatWithUs;

  /// No description provided for @callUs.
  ///
  /// In en, this message translates to:
  /// **'Call us'**
  String get callUs;

  /// No description provided for @commonQuestions.
  ///
  /// In en, this message translates to:
  /// **'Common questions'**
  String get commonQuestions;

  /// No description provided for @faq1Q.
  ///
  /// In en, this message translates to:
  /// **'How do I connect my device?'**
  String get faq1Q;

  /// No description provided for @faq1A.
  ///
  /// In en, this message translates to:
  /// **'Plug the OBD-II scanner into the 16-pin port under your dashboard, switch on your vehicle ignition, and ensure Bluetooth is enabled on your phone. The app will auto-pair within seconds.'**
  String get faq1A;

  /// No description provided for @faq2Q.
  ///
  /// In en, this message translates to:
  /// **'What do the DTC fault codes mean?'**
  String get faq2Q;

  /// No description provided for @faq2A.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic Trouble Codes (DTCs) are standardized codes generated by your car’s computer. Our AI translates technical codes (e.g. P0301) into clear mechanical causes and severity ratings.'**
  String get faq2A;

  /// No description provided for @faq3Q.
  ///
  /// In en, this message translates to:
  /// **'How do I book a repair workshop?'**
  String get faq3Q;

  /// No description provided for @faq3A.
  ///
  /// In en, this message translates to:
  /// **'Navigate to the Workshops tab, select a certified service center near you, pick your preferred date and time slot, and confirm. Your diagnostic report will be shared automatically.'**
  String get faq3A;

  /// No description provided for @faq4Q.
  ///
  /// In en, this message translates to:
  /// **'Can I export my diagnostic reports as PDF?'**
  String get faq4Q;

  /// No description provided for @faq4A.
  ///
  /// In en, this message translates to:
  /// **'Yes, every report summary includes a Share/Export button in the top right header to instantly generate a printable summary for your mechanic.'**
  String get faq4A;

  /// No description provided for @privacyPolicyItem.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicyItem;

  /// No description provided for @termsOfUseItem.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsOfUseItem;

  /// No description provided for @downloadMyData.
  ///
  /// In en, this message translates to:
  /// **'Download my data'**
  String get downloadMyData;

  /// No description provided for @deleteAccountItem.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccountItem;

  /// No description provided for @permanentBadge.
  ///
  /// In en, this message translates to:
  /// **'Permanent'**
  String get permanentBadge;

  /// No description provided for @gdprEncryptedBadge.
  ///
  /// In en, this message translates to:
  /// **'End-to-end encrypted · GDPR ready'**
  String get gdprEncryptedBadge;

  /// No description provided for @verificationSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Success'**
  String get verificationSuccessTitle;

  /// No description provided for @verificationSuccessSub.
  ///
  /// In en, this message translates to:
  /// **'Congratulations,\nyou can now explore and diagnose your vehicle.'**
  String get verificationSuccessSub;

  /// No description provided for @goToHomePage.
  ///
  /// In en, this message translates to:
  /// **'Go to home page'**
  String get goToHomePage;

  /// No description provided for @otpVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerificationTitle;

  /// No description provided for @otpSentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We have sent a verification code to your registered email address:'**
  String get otpSentSubtitle;

  /// No description provided for @otpInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete 4-digit code'**
  String get otpInvalidError;

  /// No description provided for @activateProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Activate your product'**
  String get activateProductTitle;

  /// No description provided for @letsGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get started now'**
  String get letsGetStarted;

  /// No description provided for @setupStep1.
  ///
  /// In en, this message translates to:
  /// **'SETUP - 1 OF 3'**
  String get setupStep1;

  /// No description provided for @scanQrInstruction.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code on your product to securely connect it to your account'**
  String get scanQrInstruction;

  /// No description provided for @serialNumberInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 14-digit serial number'**
  String get serialNumberInvalidError;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Turn Vehicle Data Into Smart Insights'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Desc.
  ///
  /// In en, this message translates to:
  /// **'Let AI analyze your car’s data, uncover potential issues, and guide you toward the next step.'**
  String get onboarding1Desc;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'See Your Car’s Story in Real Time'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Desc.
  ///
  /// In en, this message translates to:
  /// **'Monitor live vehicle data and stay connected to what’s happening under the hood.'**
  String get onboarding2Desc;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Connect, Discover, Understand'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Desc.
  ///
  /// In en, this message translates to:
  /// **'Plug into your vehicle’s OBD port and unlock the data your car has to tell you.'**
  String get onboarding3Desc;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @skipButton.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipButton;

  /// No description provided for @getStartedButton.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStartedButton;

  /// No description provided for @morningSection.
  ///
  /// In en, this message translates to:
  /// **'MORNING'**
  String get morningSection;

  /// No description provided for @afternoonSection.
  ///
  /// In en, this message translates to:
  /// **'AFTERNOON'**
  String get afternoonSection;

  /// No description provided for @takenSlot.
  ///
  /// In en, this message translates to:
  /// **'{time} (Taken)'**
  String takenSlot(String time);

  /// No description provided for @didNotReceiveOtpPrefix.
  ///
  /// In en, this message translates to:
  /// **'Didn’t receive OTP? '**
  String get didNotReceiveOtpPrefix;

  /// No description provided for @resendInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendInSeconds(int seconds);

  /// No description provided for @resendCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCodeButton;

  /// No description provided for @submitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitButton;

  /// No description provided for @positionQrInsideFrame.
  ///
  /// In en, this message translates to:
  /// **'Position QR code inside the frame'**
  String get positionQrInsideFrame;

  /// No description provided for @scanningAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Scanning happens automatically'**
  String get scanningAutomatically;

  /// No description provided for @orEnterManually.
  ///
  /// In en, this message translates to:
  /// **'Or enter manually'**
  String get orEnterManually;

  /// No description provided for @fourteenDigitSerialLabel.
  ///
  /// In en, this message translates to:
  /// **'14-digit serial number'**
  String get fourteenDigitSerialLabel;

  /// No description provided for @activateWithSerialButton.
  ///
  /// In en, this message translates to:
  /// **'Activate with serial number'**
  String get activateWithSerialButton;

  /// No description provided for @noProductNearbyPrefix.
  ///
  /// In en, this message translates to:
  /// **'Don’t have your product nearby? '**
  String get noProductNearbyPrefix;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get continueAsGuest;

  /// No description provided for @loadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingLabel;

  /// No description provided for @photoNumber.
  ///
  /// In en, this message translates to:
  /// **'Photo {number}'**
  String photoNumber(int number);

  /// No description provided for @openNowStatus.
  ///
  /// In en, this message translates to:
  /// **'Open now'**
  String get openNowStatus;

  /// No description provided for @openNowCloses8Pm.
  ///
  /// In en, this message translates to:
  /// **'Open now · Closes 8:00 PM'**
  String get openNowCloses8Pm;

  /// No description provided for @dtcCodesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic Trouble Codes (DTCs)'**
  String get dtcCodesSectionTitle;

  /// No description provided for @noActiveDtcsMessage.
  ///
  /// In en, this message translates to:
  /// **'No active DTC trouble codes found. Powertrain and emissions pass OBD-II inspection.'**
  String get noActiveDtcsMessage;

  /// No description provided for @ecuCommunicationError.
  ///
  /// In en, this message translates to:
  /// **'ECU communication error'**
  String get ecuCommunicationError;

  /// No description provided for @cockpitTitle.
  ///
  /// In en, this message translates to:
  /// **'OBD-II COCKPIT'**
  String get cockpitTitle;

  /// No description provided for @amSuffix.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get amSuffix;

  /// No description provided for @pmSuffix.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pmSuffix;

  /// No description provided for @alreadyVerifiedSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already verified? Sign in'**
  String get alreadyVerifiedSignIn;

  /// No description provided for @otp6DigitInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit verification code sent to your registered email:'**
  String get otp6DigitInstruction;

  /// No description provided for @otp6InvalidError.
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete 6-digit verification code'**
  String get otp6InvalidError;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @reportCopiedMsg.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic report copied to clipboard'**
  String get reportCopiedMsg;

  /// No description provided for @historyExportedMsg.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic history summary copied to clipboard'**
  String get historyExportedMsg;

  /// No description provided for @filterAllCenters.
  ///
  /// In en, this message translates to:
  /// **'All centers'**
  String get filterAllCenters;

  /// No description provided for @filterOpenNow.
  ///
  /// In en, this message translates to:
  /// **'Open now only'**
  String get filterOpenNow;

  /// No description provided for @filterHighestRated.
  ///
  /// In en, this message translates to:
  /// **'Highest rated first'**
  String get filterHighestRated;

  /// No description provided for @firmwareUpToDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Firmware Up to Date'**
  String get firmwareUpToDateTitle;

  /// No description provided for @firmwareUpToDateBody.
  ///
  /// In en, this message translates to:
  /// **'Your OBD-II adapter is running the latest firmware (v2.4.1).'**
  String get firmwareUpToDateBody;

  /// No description provided for @rePairingDeviceMsg.
  ///
  /// In en, this message translates to:
  /// **'Re-pairing OBD-II scanner...'**
  String get rePairingDeviceMsg;

  /// No description provided for @devicePairedMsg.
  ///
  /// In en, this message translates to:
  /// **'OBD-II scanner paired and active'**
  String get devicePairedMsg;

  /// No description provided for @deviceDeactivatedMsg.
  ///
  /// In en, this message translates to:
  /// **'Scanner deactivated'**
  String get deviceDeactivatedMsg;

  /// No description provided for @confirmDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get confirmDeleteAccountTitle;

  /// No description provided for @confirmDeleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'This clears your saved vehicles and diagnostic history and signs you out immediately.'**
  String get confirmDeleteAccountBody;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @confirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// No description provided for @dataExportedMsg.
  ///
  /// In en, this message translates to:
  /// **'Account data snapshot copied to clipboard'**
  String get dataExportedMsg;

  /// No description provided for @vinHelperTitle.
  ///
  /// In en, this message translates to:
  /// **'VIN Quick Fill'**
  String get vinHelperTitle;

  /// No description provided for @fillSampleVin.
  ///
  /// In en, this message translates to:
  /// **'Use Sample VIN'**
  String get fillSampleVin;

  /// No description provided for @supportChatCopied.
  ///
  /// In en, this message translates to:
  /// **'Support email copied: support@obdvision.app'**
  String get supportChatCopied;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @callPhoneCopied.
  ///
  /// In en, this message translates to:
  /// **'Phone number copied: {phone}'**
  String callPhoneCopied(String phone);

  /// No description provided for @addressCopied.
  ///
  /// In en, this message translates to:
  /// **'Location copied: {address}'**
  String addressCopied(String address);

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @cockpitMaxSpeed.
  ///
  /// In en, this message translates to:
  /// **'MAX SPEED'**
  String get cockpitMaxSpeed;

  /// No description provided for @cockpitDuration.
  ///
  /// In en, this message translates to:
  /// **'DURATION'**
  String get cockpitDuration;

  /// No description provided for @cockpitCoolantShort.
  ///
  /// In en, this message translates to:
  /// **'COOLANT'**
  String get cockpitCoolantShort;

  /// No description provided for @cockpitBatteryShort.
  ///
  /// In en, this message translates to:
  /// **'BATTERY'**
  String get cockpitBatteryShort;

  /// No description provided for @cockpitFullscreenTooltip.
  ///
  /// In en, this message translates to:
  /// **'Fullscreen HUD'**
  String get cockpitFullscreenTooltip;

  /// No description provided for @cockpitExitFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Exit HUD'**
  String get cockpitExitFullscreen;

  /// No description provided for @cockpitDtcBadge.
  ///
  /// In en, this message translates to:
  /// **'DTC'**
  String get cockpitDtcBadge;

  /// No description provided for @cockpitSimBadge.
  ///
  /// In en, this message translates to:
  /// **'SIM'**
  String get cockpitSimBadge;

  /// No description provided for @cockpitLiveBadge.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get cockpitLiveBadge;

  /// No description provided for @cockpitOfflineBadge.
  ///
  /// In en, this message translates to:
  /// **'OFFLINE'**
  String get cockpitOfflineBadge;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
