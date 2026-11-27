// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'أو بي دي فيجن';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navService => 'الصيانة';

  @override
  String get navDiagnosis => 'الفحص';

  @override
  String get navHistory => 'السجل';

  @override
  String get navProfile => 'حسابي';

  @override
  String get languageAndUnits => 'اللغة والوحدات';

  @override
  String get languageSection => 'اللغة';

  @override
  String get systemDefault => 'لغة النظام';

  @override
  String get englishLabel => 'English';

  @override
  String get englishSubtitle => 'واجهة التطبيق بالإنجليزية';

  @override
  String get arabicLabel => 'العربية';

  @override
  String get arabicPill => 'عربي';

  @override
  String get arabicSubtitle => 'تخطيط متكامل من اليمين لليسار';

  @override
  String get unitsOfMeasurement => 'وحدات القياس';

  @override
  String get telemetrySync => 'مزامنة القراءات';

  @override
  String get distanceTitle => 'المسافة';

  @override
  String get distanceSubtitle => 'العداد والمدى';

  @override
  String get temperatureTitle => 'درجة الحرارة';

  @override
  String get temperatureSubtitle => 'حرارة المحرك والمبرد';

  @override
  String get unitsReassuranceNote =>
      'تُطبق التغييرات تلقائياً على جميع المركبات المتصلة';

  @override
  String get signInTitle => 'تسجيل الدخول إلى حسابك';

  @override
  String get emailAddressLabel => 'البريد الإلكتروني';

  @override
  String get emailAddressCapLabel => 'البريد الإلكتروني';

  @override
  String get enterEmailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get enterPasswordHint => 'أدخل كلمة المرور';

  @override
  String get forgotPasswordQuestion => 'نسيت كلمة المرور؟';

  @override
  String get signInButton => 'تسجيل الدخول';

  @override
  String get otherWayToSignIn => 'أو سجل الدخول عبر';

  @override
  String get dontHaveAccountPrefix => 'ليس لديك حساب؟ ';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get createAccountTitle => 'إنشاء حساب جديد';

  @override
  String get fullNameLabel => 'الاسم الكامل';

  @override
  String get enterFullNameHint => 'أدخل اسمك الكامل';

  @override
  String get phoneOptionalLabel => 'رقم الهاتف (اختياري)';

  @override
  String get enterPhoneHint => 'أدخل رقم هاتفك';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get enterConfirmPasswordHint => 'أعد إدخال كلمة المرور';

  @override
  String get signUpButton => 'إنشاء حساب';

  @override
  String get alreadyHaveAccountPrefix => 'لديك حساب بالفعل؟ ';

  @override
  String get termsAgreeRequired =>
      'يجب الموافقة على اتفاقية المستخدم وسياسة الخصوصية';

  @override
  String get agreePrefix => 'لقد قرأت وأوافق على ';

  @override
  String get userAgreement => 'اتفاقية المستخدم';

  @override
  String get andWord => ' و';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get forgotPasswordTitle => 'استعادة كلمة المرور';

  @override
  String get forgotPasswordSubtitle =>
      'أدخل بريدك الإلكتروني المسجل لاستلام رابط إعادة تعيين كلمة المرور.';

  @override
  String get enterYourEmailTitle => 'أدخل بريدك الإلكتروني';

  @override
  String get sendResetLinkButton => 'إرسال رابط الاستعادة';

  @override
  String get resetLinkSentTitle => 'افحص بريدك الإلكتروني';

  @override
  String resetLinkSentMessage(String email) {
    return 'أرسلنا رابط إعادة تعيين كلمة المرور إلى $email. افتح الرابط من بريدك للعودة إلى التطبيق واختيار كلمة مرور جديدة.';
  }

  @override
  String get setNewPasswordTitle => 'تعيين كلمة مرور جديدة';

  @override
  String get setNewPasswordSubtitle =>
      'اختر كلمة مرور قوية من 8 أحرف على الأقل لحسابك.';

  @override
  String get newPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get confirmNewPasswordLabel => 'تأكيد كلمة المرور الجديدة';

  @override
  String get updatePasswordButton => 'تحديث كلمة المرور';

  @override
  String get passwordUpdatedSuccess => 'تم تحديث كلمة المرور بنجاح.';

  @override
  String get validationEnterFullName => 'من فضلك أدخل اسمك الكامل';

  @override
  String get validationEnterValidEmail =>
      'من فضلك أدخل بريداً إلكترونياً صحيحاً';

  @override
  String get validationPasswordMinLength =>
      'الباسوورد لازم يكون 8 حروف على الأقل';

  @override
  String get validationPasswordsMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get backToSignIn => 'العودة لتسجيل الدخول';

  @override
  String get profileTitle => 'حسابي';

  @override
  String get myVehicle => 'مركباتي';

  @override
  String get myDevice => 'جهازي';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get helpAndSupport => 'المساعدة والدعم';

  @override
  String get privacyAndData => 'الخصوصية والبيانات';

  @override
  String get settingSection => 'الإعدادات';

  @override
  String get languageAndUnitsMenu => 'اللغة والوحدات';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get editProfile => 'تعديل الحساب';

  @override
  String get saveButton => 'حفظ';

  @override
  String get profileUpdatedSuccess => 'تم تحديث البيانات بنجاح';

  @override
  String get allDataEncrypted => 'جميع بياناتك مشفرة بالكامل';

  @override
  String get firstNameLabel => 'الاسم الأول';

  @override
  String get firstNameHint => 'الاسم الأول';

  @override
  String get lastNameLabel => 'الاسم الأخير';

  @override
  String get lastNameHint => 'الاسم الأخير';

  @override
  String get phoneNumberLabel => 'رقم الهاتف';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get genderLabel => 'النوع';

  @override
  String get genderMale => 'ذكر';

  @override
  String get genderFemale => 'أنثى';

  @override
  String get genderPreferNot => 'أفضل عدم التحديد';

  @override
  String get birthdayLabel => 'تاريخ الميلاد';

  @override
  String get connectedObdLabel => 'متصل · OBD-II v2.4';

  @override
  String get connectingObdLabel => 'جاري الاتصال بـ OBD-II...';

  @override
  String get runDiagnosis => 'بدء الفحص';

  @override
  String get runDiagnosisHome => 'بدء الفحص';

  @override
  String get seeDetails => 'عرض التفاصيل';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get liveTelemetry => 'القراءات الحية';

  @override
  String get earlyWarning => 'تحذير مبكر';

  @override
  String get systemHealthAndAlert => 'صحة النظام والتنبيهات';

  @override
  String get healthScoreBadge => 'الصحة';

  @override
  String get defaultWarningTitle => 'ارتفاع ملحوظ في\nحرارة سائل التبريد';

  @override
  String get defaultWarningSubtitle => 'آخر فحص اليوم 09:40 · افحص الحساس';

  @override
  String get activeWorkshopService => 'حالة الصيانة الحالية';

  @override
  String get trackAction => 'تتبع';

  @override
  String get repairInProgress => 'قيد الإصلاح';

  @override
  String get stageLabel => 'المرحلة 4/5';

  @override
  String get defaultCenterName => 'مركز النور لصيانة السيارات';

  @override
  String get defaultServiceType => 'غسيل وتنظيف الردياتير';

  @override
  String get telemetryIdle => 'ثابت';

  @override
  String get telemetryHigh => 'مرتفع';

  @override
  String get telemetryNormal => 'طبيعي';

  @override
  String get telemetryEngineSpeed => 'سرعة المحرك';

  @override
  String get telemetryCoolantTemp => 'حرارة المبرد';

  @override
  String get telemetryAlternator => 'الدينامو';

  @override
  String get unitRpm => 'لفة/د';

  @override
  String get unitVolt => 'فولت';

  @override
  String get reportTitle => 'التقرير';

  @override
  String get summaryTab => 'الملخص';

  @override
  String get causesTab => 'الأسباب';

  @override
  String get aiEstimateTitle => 'تقدير الذكاء الاصطناعي';

  @override
  String get rankedByLikelihood => 'مرتبة حسب الاحتمالية';

  @override
  String get whatsHappening => 'ماذا يحدث؟';

  @override
  String get nextBestStep => 'الخطوة القادمة المقترحة';

  @override
  String get safetyWarningTitle => 'تنبيه السلامة';

  @override
  String get aiInferenceBadge => 'استنتاج احتمالي بالذكاء الاصطناعي';

  @override
  String get measuredSensorBadge => 'قياس مباشر من الحساسات';

  @override
  String get srsDisclaimer =>
      'تم إنشاء نتائج التشخيص استناداً إلى قراءات OBD-II المتاحة ونماذج الاستنتاج الذكي، وهي تمثل إرشاداً احتمالياً يجب التحقق منه بواسطة فني سيارات معتمد قبل استبدال أي قطعة.';

  @override
  String get findServiceCenter => 'البحث عن مركز صيانة';

  @override
  String get doneButton => 'تم';

  @override
  String get possibleEngineMisfire => 'احتمال تقطيع في احتراق المحرك';

  @override
  String get fallbackExplanation =>
      'قد لا يقوم المحرك بحرق الوقود بانتظام داخل إحدى الأسطوانات، مما يسبب اهتزازاً وزيادة في استهلاك البنزين.';

  @override
  String get fallbackNextStep => 'افحص شمعات الاحتراق (البوجيهات) والموبينة';

  @override
  String get checkSoonBadge => 'يُنصح بالفحص قريباً';

  @override
  String get todayDefaultTime => 'اليوم، 09:40';

  @override
  String get commonCausesHint => 'هذه هي الأسباب الأكثر شيوعاً لهذا الكود';

  @override
  String get liveDataTitle => 'القراءات الحية';

  @override
  String get pauseButton => 'إيقاف مؤقت';

  @override
  String get resumeButton => 'استئناف';

  @override
  String get liveSensorEngineSpeed => 'سرعة المحرك';

  @override
  String get liveSensorBattery => 'البطارية';

  @override
  String get liveSensorShortFuelTrim => 'تصحيح الوقود القصير';

  @override
  String get liveSensorEngineLoad => 'حمل المحرك';

  @override
  String get liveSensorCoolantTemp => 'حرارة المبرد';

  @override
  String get liveSensorVehicleSpeed => 'سرعة السيارة';

  @override
  String get liveSensorThrottlePos => 'فتحة البوابة';

  @override
  String get liveSensorMapPressure => 'ضغط المنفولد MAP';

  @override
  String get statusNormal => 'طبيعي';

  @override
  String get statusHigh => 'مرتفع';

  @override
  String get statusMedium => 'متوسط';

  @override
  String get checkBeforeYouScan => 'فحص ما قبل المسح';

  @override
  String get scanYourVehicle => 'جاري فحص المركبة';

  @override
  String get scanCompleted => 'اكتمل الفحص';

  @override
  String scanStepIndicator(int step) {
    return 'الفحص - $step من 3';
  }

  @override
  String get obdScannerConnected => 'جهاز OBD-II متصل';

  @override
  String get readyToCommunicateEcu => 'جاهز للتواصل مع كمبيوتر السيارة';

  @override
  String get beforeYouStart => 'قبل أن تبدأ:';

  @override
  String get precheckRule1 => 'أوقف السيارة في مكان آمن وجيد التهوية';

  @override
  String get precheckRule2 =>
      'أدر مفتاح التشغيل (المحرك دائر أو في وضع التدوير)';

  @override
  String get precheckRule3 => 'أبقِ الهاتف ضمن نطاق البلوتوث (~5 أمتار)';

  @override
  String get precheckRule4 => 'لا تفصل جهاز الفحص أثناء عملية المسح';

  @override
  String get startScanButton => 'بدء المسح';

  @override
  String get watchLiveDataOnly => 'متابعة القراءات الحية فقط';

  @override
  String get scanningEcu => 'فحص كمبيوتر السيارة';

  @override
  String get readingTroubleCodes => 'قراءة أكواد الأعطال';

  @override
  String get readingLiveSensors => 'قراءة الحساسات الحية';

  @override
  String pidsQueriedProgress(int count) {
    return 'تمت قراءة $count من 27 حساس';
  }

  @override
  String get aiRuleEngineEval => 'تحليل الذكاء الاصطناعي ومحرك القواعد';

  @override
  String get synthesizingReport => 'إعداد تقرير التشخيص النهائي';

  @override
  String get keepIgnitionRange =>
      'أبقِ الإشعال مفعّلاً وحافظ على نطاق البلوتوث';

  @override
  String get cancelScanButton => 'إلغاء الفحص';

  @override
  String get issuesDetected => 'تم رصد أعطال';

  @override
  String get vehicleSystemsHealthy => 'أنظمة المركبة سليمة';

  @override
  String faultCodesRecorded(int count) {
    return 'تم تسجيل $count كود عطل في كمبيوتر السيارة';
  }

  @override
  String get allSensorsNominal =>
      'جميع الحساسات الـ 27 تعمل ضمن النطاق القياسي';

  @override
  String get viewFullAiReport => 'عرض تقرير الذكاء الاصطناعي الكامل';

  @override
  String get findNearbyServiceCenter => 'البحث عن أقرب مركز صيانة';

  @override
  String get runScanAgain => 'إعادة الفحص مجدداً';

  @override
  String get diagnosticHistoryTitle => 'سجل الفحوصات';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterFaults => 'الأعطال';

  @override
  String get filterRoutine => 'الدورية';

  @override
  String get filterTrips => 'الرحلات';

  @override
  String get retryButton => 'إعادة المحاولة';

  @override
  String get noDiagnosticLogs => 'لا توجد سجلات فحص مطابقة لهذا التصنيف.';

  @override
  String get justNowLabel => 'الآن';

  @override
  String get serviceCentersTitle => 'مراكز الصيانة';

  @override
  String get searchCenterHint => 'ابحث باسم المركز أو المنطقة';

  @override
  String centersNearYou(int count) {
    return '$count مركز صيانة بالقرب منك';
  }

  @override
  String get nearestFirst => 'الأقرب أولاً';

  @override
  String get listViewTab => 'القائمة';

  @override
  String get mapViewTab => 'الخريطة';

  @override
  String get activeTag => 'نشط';

  @override
  String get readyThursdaySub => 'مركز النور · التسليم المتوقع الخميس';

  @override
  String get callButton => 'اتصال';

  @override
  String get bookButton => 'حجز';

  @override
  String get compatibleBadge => 'متوافق';

  @override
  String get bookAppointmentTitle => 'حجز موعد';

  @override
  String get bookAppointmentButton => 'حجز موعد صيانة';

  @override
  String reviewsCountText(int count) {
    return '($count تقييم)';
  }

  @override
  String distanceAway(String distance) {
    return 'يبعد $distance';
  }

  @override
  String get specialtiesTitle => 'التخصصات';

  @override
  String get specialtyEngine => 'ميكانيكا المحرك';

  @override
  String get specialtyElectrical => 'كهرباء السيارات';

  @override
  String get specialtyBrakes => 'الفرامل';

  @override
  String get specialtyAc => 'التكييف والتبريد';

  @override
  String get authorizedBrandsTitle => 'الماركات المعتمدة';

  @override
  String get downtownAutomotive => 'منطقة مراكز الصيانة المعتمدة';

  @override
  String get directionsButton => 'الاتجاهات';

  @override
  String get certifiedPartner => 'شريك فحص OBD-II معتمد';

  @override
  String get selectDateTitle => 'اختر اليوم';

  @override
  String get selectTimeTitle => 'اختر الموعد';

  @override
  String get shareDiagnosticReport => 'مشاركة تقرير الفحص';

  @override
  String get includesRecentDtcs => 'يتضمن أحدث الأكواد وحالة صحة المحرك';

  @override
  String get addBookingNoteHint =>
      'أضف ملاحظة (مثلاً: لمبة الأعطال مضاءة أو صوت غريب)...';

  @override
  String get bookingSummaryLabel => 'ملخص الحجز';

  @override
  String get confirmAppointmentButton => 'تأكيد الحجز';

  @override
  String get bookingConfirmationTitle => 'تأكيد الحجز';

  @override
  String get bookingConfirmedHeading => 'تم تأكيد حجزك بنجاح';

  @override
  String get automotiveDiagnosticsCare => 'تشخيص وصيانة السيارات';

  @override
  String get confirmedArrivalSlot => 'موعد الوصول المؤكد';

  @override
  String get selectedVehicleLabel => 'المركبة المختارة';

  @override
  String get trackBookingButton => 'تتبع الحجز';

  @override
  String get backToHomeButton => 'العودة للرئيسية';

  @override
  String get myVehicleTitle => 'مركباتي';

  @override
  String get addVehicleCta => 'إضافة مركبة';

  @override
  String get addVehicleTitle => 'إضافة مركبة';

  @override
  String get editVehicleTitle => 'تعديل المركبة';

  @override
  String get vehicleHistoryNotice => 'تحتفظ كل مركبة بسجل التشخيص الخاص بها.';

  @override
  String get vehicleNameLabel => 'اسم المركبة';

  @override
  String get vehicleNameHint => 'مثال: Corolla 2018';

  @override
  String get nicknameLabel => 'الاسم المختصر';

  @override
  String get nicknameHint => 'مثال: سيارتي اليومية';

  @override
  String get energySourceLabel => 'نوع الوقود / الطاقة';

  @override
  String get energySourceHint => 'بنزين / هايبرد / كهرباء';

  @override
  String get mileageLabel => 'المسافة المقطوعة';

  @override
  String get vinOptionalLabel => 'رقم الشاسيه VIN (اختياري)';

  @override
  String get vinLabel => 'رقم الشاسيه VIN';

  @override
  String get vinHint => 'أدخل رقم الشاسيه (17 حرفاً)';

  @override
  String get vinHelper => '17 حرفاً، يساعدنا على مطابقة موديل مركبتك بدقة';

  @override
  String get enterVehicleNameError => 'من فضلك أدخل اسم المركبة';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get deleteVehicle => 'حذف المركبة';

  @override
  String get setAsCurrent => 'تعيين كحالية';

  @override
  String get currentBadge => 'الحالية';

  @override
  String get myDeviceTitle => 'جهازي';

  @override
  String get deviceConnectedStatus => 'متصل';

  @override
  String get serialLabel => 'الرقم التسلسلي';

  @override
  String get firmwareLabel => 'إصدار البرنامج';

  @override
  String get lastConnectedLabel => 'آخر اتصال';

  @override
  String get linkedVehicleLabel => 'المركبة المرتبطة';

  @override
  String get rePairDevice => 'إعادة اقتران الجهاز';

  @override
  String get checkForUpdates => 'التحقق من التحديثات';

  @override
  String get deactivateDevice => 'إلغاء تفعيل الجهاز';

  @override
  String get earlyWarningsTitle => 'التنبيهات المبكرة';

  @override
  String get earlyWarningsSub => 'عند ملاحظة سلوك غير معتاد في السيارة';

  @override
  String get diagnosticReportsTitle => 'تقارير التشخيص';

  @override
  String get diagnosticReportsSub => 'عندما يصبح تقرير الذكاء الاصطناعي جاهزاً';

  @override
  String get bookingUpdatesTitle => 'تحديثات الحجوزات';

  @override
  String get bookingUpdatesSub => 'تغييرات الحالة من مراكز الصيانة';

  @override
  String get quoteApprovalsTitle => 'موافقات الأسعار';

  @override
  String get quoteApprovalsSub => 'عند وجود مقايسة معدلة تحتاج مراجعتك';

  @override
  String get deviceStatusTitle => 'حالة الجهاز';

  @override
  String get deviceStatusSub => 'عند اتصال جهاز الفحص أو انقطاعه';

  @override
  String get criticalWarningsNote => 'لا يمكن تعطيل تنبيهات السلامة الحرجة.';

  @override
  String get vehicleSupportTitle => 'دعم المركبات';

  @override
  String get activeDiagnosticAssist => 'مساعدة فنية وتشخيصية مباشرة';

  @override
  String get onlineBadge => 'متاح الآن';

  @override
  String get needHelpTitle => 'تحتاج مساعدة؟';

  @override
  String get replyWithinMinutes => 'نرد عادةً خلال دقائق.';

  @override
  String get chatWithUs => 'تحدث معنا';

  @override
  String get callUs => 'اتصل بنا';

  @override
  String get commonQuestions => 'الأسئلة الشائعة';

  @override
  String get faq1Q => 'كيف أصل جهاز الفحص بالسيارة؟';

  @override
  String get faq1A =>
      'وصّل جهاز OBD-II بمنفذ الـ 16 طرفاً أسفل عجلة القيادة، وأدر مفتاح التشغيل، ثم فعّل البلوتوث في هاتفك ليتم الاقتران تلقائياً خلال ثوانٍ.';

  @override
  String get faq2Q => 'ماذا تعني أكواد الأعطال DTC؟';

  @override
  String get faq2A =>
      'أكواد الأعطال هي رموز قياسية يصدرها كمبيوتر السيارة. يترجم الذكاء الاصطناعي هذه الرموز (مثل P0301) إلى أسباب ميكانيكية واضحة ودرجة الخطورة.';

  @override
  String get faq3Q => 'كيف أحجز في مركز صيانة؟';

  @override
  String get faq3A =>
      'افتح تبويب الصيانة، واختر مركزاً معتمداً بالقرب منك، ثم حدد اليوم والوقت المناسبين وأكّد الحجز ليصل التقرير الفني للمركز تلقائياً.';

  @override
  String get faq4Q => 'هل يمكنني تصدير تقارير الفحص كملف PDF؟';

  @override
  String get faq4A =>
      'نعم، يتضمن كل تقرير زر مشاركة/تصدير في أعلى الشاشة لإنشاء ملخص جاهز للعرض على الفني أو الطباعة.';

  @override
  String get privacyPolicyItem => 'سياسة الخصوصية';

  @override
  String get termsOfUseItem => 'شروط الاستخدام';

  @override
  String get downloadMyData => 'تنزيل بياناتي';

  @override
  String get deleteAccountItem => 'حذف الحساب';

  @override
  String get permanentBadge => 'نهائي';

  @override
  String get gdprEncryptedBadge => 'تشفير كامل من الطرف للطرف · متوافق مع GDPR';

  @override
  String get verificationSuccessTitle => 'تم التحقق بنجاح';

  @override
  String get verificationSuccessSub =>
      'تهانينا،\nيمكنك الآن استكشاف وفحص مركبتك.';

  @override
  String get goToHomePage => 'الانتقال إلى الرئيسية';

  @override
  String get otpVerificationTitle => 'التحقق بالرمز';

  @override
  String get otpSentSubtitle => 'أرسلنا رمز تحقق إلى بريدك الإلكتروني المسجل:';

  @override
  String get otpInvalidError => 'من فضلك أدخل الرمز المكون من 4 أرقام كاملاً';

  @override
  String get activateProductTitle => 'تفعيل جهازك';

  @override
  String get letsGetStarted => 'هيا نبدأ الآن';

  @override
  String get setupStep1 => 'الإعداد - 1 من 3';

  @override
  String get scanQrInstruction => 'امسح رمز QR على الجهاز لربطه بأمان مع حسابك';

  @override
  String get serialNumberInvalidError => 'من فضلك أدخل رقماً تسلسلياً صحيحاً';

  @override
  String get onboarding1Title => 'حوّل بيانات سيارتك إلى رؤى ذكية';

  @override
  String get onboarding1Desc =>
      'دع الذكاء الاصطناعي يحلل بيانات سيارتك، ويكشف الأعطال المحتملة، ويرشدك للخطوة القادمة.';

  @override
  String get onboarding2Title => 'تابع حالة سيارتك لحظة بلحظة';

  @override
  String get onboarding2Desc =>
      'راقب القراءات الحية وابقَ على اطلاع دائم بما يدور تحت غطاء المحرك.';

  @override
  String get onboarding3Title => 'اتصل، اكتشف، افهم';

  @override
  String get onboarding3Desc =>
      'اوصل جهازك بمنفذ OBD في سيارتك واكتشف كل ما تخبرك به مركبتك.';

  @override
  String get nextButton => 'التالي';

  @override
  String get skipButton => 'تخطي';

  @override
  String get getStartedButton => 'ابدأ الآن';

  @override
  String get morningSection => 'الصباح';

  @override
  String get afternoonSection => 'المساء';

  @override
  String takenSlot(String time) {
    return '$time (محجوز)';
  }

  @override
  String get didNotReceiveOtpPrefix => 'لم تستلم رمز التحقق؟ ';

  @override
  String resendInSeconds(int seconds) {
    return 'إعادة الإرسال خلال $seconds ث';
  }

  @override
  String get resendCodeButton => 'إعادة إرسال الرمز';

  @override
  String get submitButton => 'إرسال';

  @override
  String get positionQrInsideFrame => 'ضع رمز QR داخل الإطار';

  @override
  String get scanningAutomatically => 'يتم المسح الضوئي تلقائياً';

  @override
  String get orEnterManually => 'أو أدخل يدوياً';

  @override
  String get fourteenDigitSerialLabel => 'الرقم التسلسلي المكون من 14 خانة';

  @override
  String get activateWithSerialButton => 'تفعيل باستخدام الرقم التسلسلي';

  @override
  String get noProductNearbyPrefix => 'هل جهازك غير قريب منك؟ ';

  @override
  String get continueAsGuest => 'المتابعة كضيف';

  @override
  String get loadingLabel => 'جاري التحميل...';

  @override
  String photoNumber(int number) {
    return 'صورة $number';
  }

  @override
  String get openNowStatus => 'مفتوح الآن';

  @override
  String get openNowCloses8Pm => 'مفتوح الآن · يغلق 8:00 م';

  @override
  String get dtcCodesSectionTitle => 'أكواد الأعطال التشخيصية (DTCs)';

  @override
  String get noActiveDtcsMessage =>
      'لا توجد أكواد أعطال نشطة. مجموعة الحركة والانبعاثات تجتاز فحص OBD-II بنجاح.';

  @override
  String get ecuCommunicationError => 'خطأ في الاتصال بوحدة التحكم (ECU)';

  @override
  String get cockpitTitle => 'قمرة فحص OBD-II';

  @override
  String get amSuffix => 'ص';

  @override
  String get pmSuffix => 'م';

  @override
  String get alreadyVerifiedSignIn => 'تم التأكيد بالفعل؟ تسجيل الدخول';

  @override
  String get otp6DigitInstruction =>
      'أدخل رمز التحقق المكون من 6 أرقام المرسل إلى بريدك الإلكتروني:';

  @override
  String get otp6InvalidError => 'من فضلك أدخل الرمز المكون من 6 أرقام كاملاً';

  @override
  String get copiedToClipboard => 'تم النسخ إلى الحافظة';

  @override
  String get reportCopiedMsg => 'تم نسخ تقرير التشخيص إلى الحافظة';

  @override
  String get historyExportedMsg => 'تم نسخ ملخص سجل الفحوصات إلى الحافظة';

  @override
  String get filterAllCenters => 'كل المراكز';

  @override
  String get filterOpenNow => 'المفتوح الآن فقط';

  @override
  String get filterHighestRated => 'الأعلى تقييماً أولاً';

  @override
  String get firmwareUpToDateTitle => 'البرنامج الثابت محدث';

  @override
  String get firmwareUpToDateBody => 'محول OBD-II يعمل بأحدث إصدار (v2.4.1).';

  @override
  String get rePairingDeviceMsg => 'جاري إعادة اقتران جهاز الفحص...';

  @override
  String get devicePairedMsg => 'تم اقتران جهاز الفحص بنجاح';

  @override
  String get deviceDeactivatedMsg => 'تم إلغاء تفعيل الجهاز';

  @override
  String get confirmDeleteAccountTitle => 'حذف الحساب؟';

  @override
  String get confirmDeleteAccountBody =>
      'سيؤدي هذا إلى مسح مركباتك وسجل الفحوصات المحفوظة وتسجيل خروجك فوراً.';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get confirmButton => 'تأكيد';

  @override
  String get dataExportedMsg => 'تم نسخ نسخة بياناتك إلى الحافظة';

  @override
  String get vinHelperTitle => 'مساعد إدخال رقم الشاسيه (VIN)';

  @override
  String get fillSampleVin => 'استخدام رقم تجريبي';

  @override
  String get supportChatCopied => 'تم نسخ بريد الدعم: support@obdvision.app';

  @override
  String get closeButton => 'إغلاق';

  @override
  String callPhoneCopied(String phone) {
    return 'تم نسخ رقم الهاتف: $phone';
  }

  @override
  String addressCopied(String address) {
    return 'تم نسخ العنوان: $address';
  }

  @override
  String get continueWithGoogle => 'المتابعة باستخدام Google';

  @override
  String get cockpitMaxSpeed => 'أقصى سرعة';

  @override
  String get cockpitDuration => 'المدة';

  @override
  String get cockpitCoolantShort => 'الحرارة';

  @override
  String get cockpitBatteryShort => 'البطارية';

  @override
  String get cockpitFullscreenTooltip => 'تكبير العداد أفقي';

  @override
  String get cockpitExitFullscreen => 'إغلاق الوضع الأفقي';

  @override
  String get cockpitDtcBadge => 'الأعطال';

  @override
  String get cockpitSimBadge => 'محاكي';

  @override
  String get cockpitLiveBadge => 'مباشر';

  @override
  String get cockpitOfflineBadge => 'غير متصل';
}
