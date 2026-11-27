// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'OBD Vision';

  @override
  String get navHome => 'Home';

  @override
  String get navService => 'Service';

  @override
  String get navDiagnosis => 'Diagnosis';

  @override
  String get navHistory => 'History';

  @override
  String get navProfile => 'Profile';

  @override
  String get languageAndUnits => 'Language & Units';

  @override
  String get languageSection => 'Language';

  @override
  String get systemDefault => 'System default';

  @override
  String get englishLabel => 'English';

  @override
  String get englishSubtitle => 'Default interface translation';

  @override
  String get arabicLabel => 'العربية';

  @override
  String get arabicPill => 'Arabic';

  @override
  String get arabicSubtitle => 'RTL layout optimized';

  @override
  String get unitsOfMeasurement => 'Units of Measurement';

  @override
  String get telemetrySync => 'Telemetry sync';

  @override
  String get distanceTitle => 'Distance';

  @override
  String get distanceSubtitle => 'Odometer & range';

  @override
  String get temperatureTitle => 'Temperature';

  @override
  String get temperatureSubtitle => 'Coolant, oil & cabin';

  @override
  String get unitsReassuranceNote =>
      'Changes apply automatically across all connected vehicles';

  @override
  String get signInTitle => 'Sign in to your Account';

  @override
  String get emailAddressLabel => 'Email address';

  @override
  String get emailAddressCapLabel => 'Email Address';

  @override
  String get enterEmailHint => 'Enter your email address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get enterPasswordHint => 'Enter your password';

  @override
  String get forgotPasswordQuestion => 'Forgot password?';

  @override
  String get signInButton => 'Sign in';

  @override
  String get otherWayToSignIn => 'other way to sign in';

  @override
  String get dontHaveAccountPrefix => 'Don’t have an account? ';

  @override
  String get createAccount => 'Create Account';

  @override
  String get createAccountTitle => 'Create Account';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get enterFullNameHint => 'Enter your full name';

  @override
  String get phoneOptionalLabel => 'Phone Number (optional)';

  @override
  String get enterPhoneHint => 'Enter your phone number';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get enterConfirmPasswordHint => 'Enter your confirm password';

  @override
  String get signUpButton => 'Sign up';

  @override
  String get alreadyHaveAccountPrefix => 'Already have an account? ';

  @override
  String get termsAgreeRequired =>
      'You must agree to the User Agreement & Privacy Policy';

  @override
  String get agreePrefix => 'I have read and agree to ';

  @override
  String get userAgreement => 'User Agreement';

  @override
  String get andWord => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your registered email address to receive a password reset link.';

  @override
  String get enterYourEmailTitle => 'Enter Your Email Address';

  @override
  String get sendResetLinkButton => 'Send Reset Link';

  @override
  String get resetLinkSentTitle => 'Check Your Email';

  @override
  String resetLinkSentMessage(String email) {
    return 'We sent a password reset link to $email. Tap the link in your email to open the app and choose a new password.';
  }

  @override
  String get setNewPasswordTitle => 'Set New Password';

  @override
  String get setNewPasswordSubtitle =>
      'Choose a strong password of at least 8 characters for your account.';

  @override
  String get newPasswordLabel => 'New Password';

  @override
  String get confirmNewPasswordLabel => 'Confirm New Password';

  @override
  String get updatePasswordButton => 'Update Password';

  @override
  String get passwordUpdatedSuccess =>
      'Your password has been updated successfully.';

  @override
  String get validationEnterFullName => 'Please enter your full name';

  @override
  String get validationEnterValidEmail => 'Please enter a valid email address';

  @override
  String get validationPasswordMinLength =>
      'Password must be at least 8 characters';

  @override
  String get validationPasswordsMismatch => 'Passwords do not match';

  @override
  String get backToSignIn => 'Back to Sign in';

  @override
  String get profileTitle => 'Profile';

  @override
  String get myVehicle => 'My vehicle';

  @override
  String get myDevice => 'My device';

  @override
  String get notifications => 'Notifications';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get privacyAndData => 'Privacy & data';

  @override
  String get settingSection => 'Setting';

  @override
  String get languageAndUnitsMenu => 'Language & units';

  @override
  String get logOut => 'Log out';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get saveButton => 'Save';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully';

  @override
  String get allDataEncrypted => 'All data will be encrypted';

  @override
  String get firstNameLabel => 'First Name';

  @override
  String get firstNameHint => 'First name';

  @override
  String get lastNameLabel => 'Last Name';

  @override
  String get lastNameHint => 'Last name';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get emailLabel => 'Email';

  @override
  String get genderLabel => 'Gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderPreferNot => 'Prefer not to say';

  @override
  String get birthdayLabel => 'Birthday';

  @override
  String get connectedObdLabel => 'Connected · OBD-II v2.4';

  @override
  String get connectingObdLabel => 'Connecting to OBD-II...';

  @override
  String get runDiagnosis => 'Run Diagnosis';

  @override
  String get runDiagnosisHome => 'Run diagnosis';

  @override
  String get seeDetails => 'See Details';

  @override
  String get seeAll => 'See all';

  @override
  String get liveTelemetry => 'Live Telemetry';

  @override
  String get earlyWarning => 'Early Warning';

  @override
  String get systemHealthAndAlert => 'System Health & Alert';

  @override
  String get healthScoreBadge => 'HEALTH';

  @override
  String get defaultWarningTitle => 'Coolant temperature\ntrending high';

  @override
  String get defaultWarningSubtitle =>
      'Last scan today, 09:40 · Inspect sensor';

  @override
  String get activeWorkshopService => 'Active Workshop Service';

  @override
  String get trackAction => 'Track';

  @override
  String get repairInProgress => 'Repair in progress';

  @override
  String get stageLabel => 'Stage 4/5';

  @override
  String get defaultCenterName => 'Al-Nour Service Center';

  @override
  String get defaultServiceType => 'Radiator Flush';

  @override
  String get telemetryIdle => 'IDLE';

  @override
  String get telemetryHigh => 'HIGH';

  @override
  String get telemetryNormal => 'NORMAL';

  @override
  String get telemetryEngineSpeed => 'Engine Speed';

  @override
  String get telemetryCoolantTemp => 'Coolant Temp';

  @override
  String get telemetryAlternator => 'Alternator';

  @override
  String get unitRpm => 'RPM';

  @override
  String get unitVolt => 'Volt';

  @override
  String get reportTitle => 'Report';

  @override
  String get summaryTab => 'Summary';

  @override
  String get causesTab => 'Causes';

  @override
  String get aiEstimateTitle => 'AI estimate';

  @override
  String get rankedByLikelihood => 'Ranked by likelihood';

  @override
  String get whatsHappening => 'What\'s happening';

  @override
  String get nextBestStep => 'Next best step';

  @override
  String get safetyWarningTitle => 'Safety Warning';

  @override
  String get aiInferenceBadge => 'AI Probabilistic Inference';

  @override
  String get measuredSensorBadge => 'Direct Sensor Measurement';

  @override
  String get srsDisclaimer =>
      'Diagnostic findings are generated based on available OBD-II telemetry and AI inference models. They constitute probabilistic guidance and must be validated by a certified automotive technician before part replacement.';

  @override
  String get findServiceCenter => 'Find service center';

  @override
  String get doneButton => 'Done';

  @override
  String get possibleEngineMisfire => 'Possible engine misfire';

  @override
  String get fallbackExplanation =>
      'Your engine may not be burning fuel properly in one cylinder. This can cause shaking and higher fuel use.';

  @override
  String get fallbackNextStep => 'Check the spark plugs and ignition coil';

  @override
  String get checkSoonBadge => 'Check soon';

  @override
  String get todayDefaultTime => 'Today, 9:40';

  @override
  String get commonCausesHint =>
      'These are the most common causes of this code';

  @override
  String get liveDataTitle => 'Live data';

  @override
  String get pauseButton => 'Pause';

  @override
  String get resumeButton => 'Resume';

  @override
  String get liveSensorEngineSpeed => 'Engine speed';

  @override
  String get liveSensorBattery => 'Battery';

  @override
  String get liveSensorShortFuelTrim => 'Short fuel trim';

  @override
  String get liveSensorEngineLoad => 'Engine Load';

  @override
  String get liveSensorCoolantTemp => 'Coolant temp';

  @override
  String get liveSensorVehicleSpeed => 'Vehicle speed';

  @override
  String get liveSensorThrottlePos => 'Throttle pos';

  @override
  String get liveSensorMapPressure => 'MAP Pressure';

  @override
  String get statusNormal => 'Normal';

  @override
  String get statusHigh => 'High';

  @override
  String get statusMedium => 'Medium';

  @override
  String get checkBeforeYouScan => 'Check before you scan';

  @override
  String get scanYourVehicle => 'Scan your vehicle';

  @override
  String get scanCompleted => 'Scan completed';

  @override
  String scanStepIndicator(int step) {
    return 'SCAN - $step OF 3';
  }

  @override
  String get obdScannerConnected => 'OBD-II Scanner Connected';

  @override
  String get readyToCommunicateEcu => 'Ready to communicate with ECU bus';

  @override
  String get beforeYouStart => 'Before you start:';

  @override
  String get precheckRule1 => 'Park car in a safe, ventilated area';

  @override
  String get precheckRule2 => 'Turn ignition ON (engine running or idle)';

  @override
  String get precheckRule3 => 'Keep device within Bluetooth range (~5m)';

  @override
  String get precheckRule4 => 'Do not unplug scanner during scan';

  @override
  String get startScanButton => 'Start scan';

  @override
  String get watchLiveDataOnly => 'Watch live data only';

  @override
  String get scanningEcu => 'Scanning ECU';

  @override
  String get readingTroubleCodes => 'Reading trouble codes';

  @override
  String get readingLiveSensors => 'Reading live sensors';

  @override
  String pidsQueriedProgress(int count) {
    return '$count of 27 PIDs queried';
  }

  @override
  String get aiRuleEngineEval => 'AI RuleEngine Diagnostic Evaluation';

  @override
  String get synthesizingReport => 'Synthesizing diagnostic report';

  @override
  String get keepIgnitionRange =>
      'Keep ignition on and stay within OBD Bluetooth range';

  @override
  String get cancelScanButton => 'Cancel scan';

  @override
  String get issuesDetected => 'Issues Detected';

  @override
  String get vehicleSystemsHealthy => 'Vehicle Systems Healthy';

  @override
  String faultCodesRecorded(int count) {
    return '$count fault code(s) recorded in ECU bus';
  }

  @override
  String get allSensorsNominal =>
      'All 27 sensors operating within factory tolerance';

  @override
  String get viewFullAiReport => 'View Full AI Report';

  @override
  String get findNearbyServiceCenter => 'Find Nearby Service Center';

  @override
  String get runScanAgain => 'Run Scan Again';

  @override
  String get diagnosticHistoryTitle => 'Diagnostic History';

  @override
  String get filterAll => 'All';

  @override
  String get filterFaults => 'Faults';

  @override
  String get filterRoutine => 'Routine';

  @override
  String get filterTrips => 'Trips';

  @override
  String get retryButton => 'Retry';

  @override
  String get noDiagnosticLogs => 'No diagnostic logs found for this filter.';

  @override
  String get justNowLabel => 'Just now';

  @override
  String get serviceCentersTitle => 'Service Centers';

  @override
  String get searchCenterHint => 'Search by name or area';

  @override
  String centersNearYou(int count) {
    return '$count centers near you';
  }

  @override
  String get nearestFirst => 'Nearest first';

  @override
  String get listViewTab => 'List';

  @override
  String get mapViewTab => 'Map';

  @override
  String get activeTag => 'Active';

  @override
  String get readyThursdaySub => 'Al-Nour Service · Ready Thursday';

  @override
  String get callButton => 'Call';

  @override
  String get bookButton => 'Book';

  @override
  String get compatibleBadge => 'Compatible';

  @override
  String get bookAppointmentTitle => 'Book Appointment';

  @override
  String get bookAppointmentButton => 'Book appointment';

  @override
  String reviewsCountText(int count) {
    return '($count reviews)';
  }

  @override
  String distanceAway(String distance) {
    return '$distance away';
  }

  @override
  String get specialtiesTitle => 'SPECIALTIES';

  @override
  String get specialtyEngine => 'Engine Repair';

  @override
  String get specialtyElectrical => 'Electrical';

  @override
  String get specialtyBrakes => 'Brakes';

  @override
  String get specialtyAc => 'AC & Climate';

  @override
  String get authorizedBrandsTitle => 'AUTHORIZED BRANDS';

  @override
  String get downtownAutomotive => 'Downtown Automotive District';

  @override
  String get directionsButton => 'Directions';

  @override
  String get certifiedPartner => 'Certified OBD-II Diagnostic Partner';

  @override
  String get selectDateTitle => 'SELECT DATE';

  @override
  String get selectTimeTitle => 'SELECT TIME';

  @override
  String get shareDiagnosticReport => 'Share Diagnostic Report';

  @override
  String get includesRecentDtcs =>
      'Includes recent DTCs & engine health status';

  @override
  String get addBookingNoteHint =>
      'Add a note (e.g. check engine light on, strange noise)...';

  @override
  String get bookingSummaryLabel => 'Booking Summary';

  @override
  String get confirmAppointmentButton => 'Confirm Appointment';

  @override
  String get bookingConfirmationTitle => 'Booking Confirmation';

  @override
  String get bookingConfirmedHeading => 'Booking Confirmed';

  @override
  String get automotiveDiagnosticsCare => 'Automotive Diagnostics & Care';

  @override
  String get confirmedArrivalSlot => 'Confirmed arrival slot';

  @override
  String get selectedVehicleLabel => 'Selected vehicle';

  @override
  String get trackBookingButton => 'Track booking';

  @override
  String get backToHomeButton => 'Back to home';

  @override
  String get myVehicleTitle => 'My Vehicle';

  @override
  String get addVehicleCta => 'Add Vehicle';

  @override
  String get addVehicleTitle => 'Add vehicle';

  @override
  String get editVehicleTitle => 'Edit vehicle';

  @override
  String get vehicleHistoryNotice =>
      'Each vehicle keeps its own diagnostic history.';

  @override
  String get vehicleNameLabel => 'Vehicle Name';

  @override
  String get vehicleNameHint => 'e.g. Corolla 2018';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get nicknameHint => 'e.g. My daily car';

  @override
  String get energySourceLabel => 'Energy source';

  @override
  String get energySourceHint => 'Petrol / Hybrid / Electric';

  @override
  String get mileageLabel => 'Mileage';

  @override
  String get vinOptionalLabel => 'VIN (optional)';

  @override
  String get vinLabel => 'VIN';

  @override
  String get vinHint => 'ENTER 17-CHARACTER VIN';

  @override
  String get vinHelper =>
      '17 characters. Helps us match your exact vehicle model';

  @override
  String get enterVehicleNameError => 'Please enter vehicle name';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get deleteVehicle => 'Delete vehicle';

  @override
  String get setAsCurrent => 'Set as current';

  @override
  String get currentBadge => 'Current';

  @override
  String get myDeviceTitle => 'My device';

  @override
  String get deviceConnectedStatus => 'Connected';

  @override
  String get serialLabel => 'Serial';

  @override
  String get firmwareLabel => 'Firmware';

  @override
  String get lastConnectedLabel => 'Last connected';

  @override
  String get linkedVehicleLabel => 'Linked vehicle';

  @override
  String get rePairDevice => 'Re-pair device';

  @override
  String get checkForUpdates => 'Check for updates';

  @override
  String get deactivateDevice => 'Deactivate device';

  @override
  String get earlyWarningsTitle => 'Early warnings';

  @override
  String get earlyWarningsSub => 'When we notice unusual vehicle behavior';

  @override
  String get diagnosticReportsTitle => 'Diagnostic reports';

  @override
  String get diagnosticReportsSub => 'When your AI analysis report is ready';

  @override
  String get bookingUpdatesTitle => 'Booking updates';

  @override
  String get bookingUpdatesSub => 'Status changes from your service centers';

  @override
  String get quoteApprovalsTitle => 'Quote approvals';

  @override
  String get quoteApprovalsSub => 'When a revised quote needs your review';

  @override
  String get deviceStatusTitle => 'Device status';

  @override
  String get deviceStatusSub => 'When your scanner disconnects or connects';

  @override
  String get criticalWarningsNote =>
      'Critical safety warnings cannot be disabled.';

  @override
  String get vehicleSupportTitle => 'Vehicle Support';

  @override
  String get activeDiagnosticAssist => 'Active diagnostic assistance';

  @override
  String get onlineBadge => 'Online';

  @override
  String get needHelpTitle => 'Need help?';

  @override
  String get replyWithinMinutes => 'We usually reply within minutes.';

  @override
  String get chatWithUs => 'Chat with us';

  @override
  String get callUs => 'Call us';

  @override
  String get commonQuestions => 'Common questions';

  @override
  String get faq1Q => 'How do I connect my device?';

  @override
  String get faq1A =>
      'Plug the OBD-II scanner into the 16-pin port under your dashboard, switch on your vehicle ignition, and ensure Bluetooth is enabled on your phone. The app will auto-pair within seconds.';

  @override
  String get faq2Q => 'What do the DTC fault codes mean?';

  @override
  String get faq2A =>
      'Diagnostic Trouble Codes (DTCs) are standardized codes generated by your car’s computer. Our AI translates technical codes (e.g. P0301) into clear mechanical causes and severity ratings.';

  @override
  String get faq3Q => 'How do I book a repair workshop?';

  @override
  String get faq3A =>
      'Navigate to the Workshops tab, select a certified service center near you, pick your preferred date and time slot, and confirm. Your diagnostic report will be shared automatically.';

  @override
  String get faq4Q => 'Can I export my diagnostic reports as PDF?';

  @override
  String get faq4A =>
      'Yes, every report summary includes a Share/Export button in the top right header to instantly generate a printable summary for your mechanic.';

  @override
  String get privacyPolicyItem => 'Privacy policy';

  @override
  String get termsOfUseItem => 'Terms of use';

  @override
  String get downloadMyData => 'Download my data';

  @override
  String get deleteAccountItem => 'Delete account';

  @override
  String get permanentBadge => 'Permanent';

  @override
  String get gdprEncryptedBadge => 'End-to-end encrypted · GDPR ready';

  @override
  String get verificationSuccessTitle => 'Verification Success';

  @override
  String get verificationSuccessSub =>
      'Congratulations,\nyou can now explore and diagnose your vehicle.';

  @override
  String get goToHomePage => 'Go to home page';

  @override
  String get otpVerificationTitle => 'OTP Verification';

  @override
  String get otpSentSubtitle =>
      'We have sent a verification code to your registered email address:';

  @override
  String get otpInvalidError => 'Please enter the complete 4-digit code';

  @override
  String get activateProductTitle => 'Activate your product';

  @override
  String get letsGetStarted => 'Let\'s get started now';

  @override
  String get setupStep1 => 'SETUP - 1 OF 3';

  @override
  String get scanQrInstruction =>
      'Scan the QR code on your product to securely connect it to your account';

  @override
  String get serialNumberInvalidError =>
      'Please enter a valid 14-digit serial number';

  @override
  String get onboarding1Title => 'Turn Vehicle Data Into Smart Insights';

  @override
  String get onboarding1Desc =>
      'Let AI analyze your car’s data, uncover potential issues, and guide you toward the next step.';

  @override
  String get onboarding2Title => 'See Your Car’s Story in Real Time';

  @override
  String get onboarding2Desc =>
      'Monitor live vehicle data and stay connected to what’s happening under the hood.';

  @override
  String get onboarding3Title => 'Connect, Discover, Understand';

  @override
  String get onboarding3Desc =>
      'Plug into your vehicle’s OBD port and unlock the data your car has to tell you.';

  @override
  String get nextButton => 'Next';

  @override
  String get skipButton => 'Skip';

  @override
  String get getStartedButton => 'Get Started';

  @override
  String get morningSection => 'MORNING';

  @override
  String get afternoonSection => 'AFTERNOON';

  @override
  String takenSlot(String time) {
    return '$time (Taken)';
  }

  @override
  String get didNotReceiveOtpPrefix => 'Didn’t receive OTP? ';

  @override
  String resendInSeconds(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get resendCodeButton => 'Resend code';

  @override
  String get submitButton => 'Submit';

  @override
  String get positionQrInsideFrame => 'Position QR code inside the frame';

  @override
  String get scanningAutomatically => 'Scanning happens automatically';

  @override
  String get orEnterManually => 'Or enter manually';

  @override
  String get fourteenDigitSerialLabel => '14-digit serial number';

  @override
  String get activateWithSerialButton => 'Activate with serial number';

  @override
  String get noProductNearbyPrefix => 'Don’t have your product nearby? ';

  @override
  String get continueAsGuest => 'Continue as guest';

  @override
  String get loadingLabel => 'Loading...';

  @override
  String photoNumber(int number) {
    return 'Photo $number';
  }

  @override
  String get openNowStatus => 'Open now';

  @override
  String get openNowCloses8Pm => 'Open now · Closes 8:00 PM';

  @override
  String get dtcCodesSectionTitle => 'Diagnostic Trouble Codes (DTCs)';

  @override
  String get noActiveDtcsMessage =>
      'No active DTC trouble codes found. Powertrain and emissions pass OBD-II inspection.';

  @override
  String get ecuCommunicationError => 'ECU communication error';

  @override
  String get cockpitTitle => 'OBD-II COCKPIT';

  @override
  String get amSuffix => 'AM';

  @override
  String get pmSuffix => 'PM';

  @override
  String get alreadyVerifiedSignIn => 'Already verified? Sign in';

  @override
  String get otp6DigitInstruction =>
      'Enter the 6-digit verification code sent to your registered email:';

  @override
  String get otp6InvalidError =>
      'Please enter the complete 6-digit verification code';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get reportCopiedMsg => 'Diagnostic report copied to clipboard';

  @override
  String get historyExportedMsg =>
      'Diagnostic history summary copied to clipboard';

  @override
  String get filterAllCenters => 'All centers';

  @override
  String get filterOpenNow => 'Open now only';

  @override
  String get filterHighestRated => 'Highest rated first';

  @override
  String get firmwareUpToDateTitle => 'Firmware Up to Date';

  @override
  String get firmwareUpToDateBody =>
      'Your OBD-II adapter is running the latest firmware (v2.4.1).';

  @override
  String get rePairingDeviceMsg => 'Re-pairing OBD-II scanner...';

  @override
  String get devicePairedMsg => 'OBD-II scanner paired and active';

  @override
  String get deviceDeactivatedMsg => 'Scanner deactivated';

  @override
  String get confirmDeleteAccountTitle => 'Delete Account?';

  @override
  String get confirmDeleteAccountBody =>
      'This clears your saved vehicles and diagnostic history and signs you out immediately.';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get dataExportedMsg => 'Account data snapshot copied to clipboard';

  @override
  String get vinHelperTitle => 'VIN Quick Fill';

  @override
  String get fillSampleVin => 'Use Sample VIN';

  @override
  String get supportChatCopied => 'Support email copied: support@obdvision.app';

  @override
  String get closeButton => 'Close';

  @override
  String callPhoneCopied(String phone) {
    return 'Phone number copied: $phone';
  }

  @override
  String addressCopied(String address) {
    return 'Location copied: $address';
  }

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get cockpitMaxSpeed => 'MAX SPEED';

  @override
  String get cockpitDuration => 'DURATION';

  @override
  String get cockpitCoolantShort => 'COOLANT';

  @override
  String get cockpitBatteryShort => 'BATTERY';

  @override
  String get cockpitFullscreenTooltip => 'Fullscreen HUD';

  @override
  String get cockpitExitFullscreen => 'Exit HUD';

  @override
  String get cockpitDtcBadge => 'DTC';

  @override
  String get cockpitSimBadge => 'SIM';

  @override
  String get cockpitLiveBadge => 'LIVE';

  @override
  String get cockpitOfflineBadge => 'OFFLINE';
}
