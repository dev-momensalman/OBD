import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/services/app_preferences.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'package:obd_vision/features/vehicle/presentation/bloc/vehicle_cubit.dart';
import 'package:obd_vision/injection_container.dart' as di;
import '../utils/service_center_l10n.dart';
import '../../../../core/constants/app_routes.dart';
import '../../domain/entities/service_center_entity.dart';
import '../widgets/calendar_strip_picker.dart';
import '../widgets/time_slots_picker.dart';

/// Authentic Book Appointment Screen matching Figma Node 435:2041
/// Features dynamic 7-day calendar picker, time slots, and diagnostic report sharing toggle.
class BookAppointmentPage extends StatefulWidget {
  final ServiceCenterEntity? center;

  const BookAppointmentPage({super.key, this.center});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  int _selectedDateIndex = 0;
  String _selectedTime = '10:00 AM';
  bool _shareDiagnosticReport = true;
  final TextEditingController _noteController = TextEditingController();

  late final List<Map<String, dynamic>> _dynamicDates;

  @override
  void initState() {
    super.initState();
    _dynamicDates = CalendarStripPicker.generateDynamicDates();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final center = widget.center ??
        const ServiceCenterEntity(
          id: 'sc-1',
          name: 'Al-Nour Service Center',
          distance: '1.2 km',
          rating: 4.7,
          reviewsCount: 230,
          workingHours: 'Open now · Closes 8:00 PM',
          isOpen: true,
          tags: ['Engine', 'Electrical'],
          address: '12 Tahrir St, Cairo',
        );

    final selectedDateStr = _dynamicDates[_selectedDateIndex]['full'] as String;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. Figma Header with Curved Gradient
          Container(
            height: 114,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 44, left: 16, right: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF000C24),
                  Color(0xFF002F8A),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const RtlBackIcon(
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    context.l10n.bookAppointmentTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          // 2. Scrollable Appointment Booking Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Center Summary Pill
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.precision_manufacturing_rounded,
                            color: Color(0xFF003FB8),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ServiceCenterL10n.name(context, center.name),
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                '${context.l10n.distanceAway(ServiceCenterL10n.distance(context, center.distance))} · ${ServiceCenterL10n.address(context, center.address ?? 'Cairo')}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section 1: Dynamic Date Strip Picker
                  Text(
                    context.l10n.selectDateTitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.55,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 8),

                  CalendarStripPicker(
                    selectedIndex: _selectedDateIndex,
                    dates: _dynamicDates,
                    onSelectDate: (idx) =>
                        setState(() => _selectedDateIndex = idx),
                  ),
                  const SizedBox(height: 20),

                  // Section 2: Time Slots Grid
                  Text(
                    context.l10n.selectTimeTitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.55,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 8),

                  TimeSlotsPicker(
                    selectedTime: _selectedTime,
                    onSelectTime: (time) => setState(() => _selectedTime = time),
                  ),
                  const SizedBox(height: 20),

                  // Section 3: Diagnostic Report Sharing Toggle
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F8FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD9E2F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF003FB8),
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.shareDiagnosticReport,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                context.l10n.includesRecentDtcs,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _shareDiagnosticReport,
                          activeThumbColor: const Color(0xFF003FB8),
                          onChanged: (val) {
                            setState(() => _shareDiagnosticReport = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section 4: Optional Note
                  TextField(
                    controller: _noteController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText:
                          context.l10n.addBookingNoteHint,
                      hintStyle: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFFA9B4C7),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Bottom Sticky Confirmation Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.bookingSummaryLabel,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      '$selectedDateStr · $_selectedTime',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF003FB8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      String? activeVehicleName;
                      String? activeVehiclePlate;
                      try {
                        final v = context.read<VehicleCubit>().state.activeVehicle;
                        activeVehicleName = v?.name;
                        activeVehiclePlate = v?.plateNumber;
                      } catch (_) {
                        if (di.sl.isRegistered<VehicleCubit>()) {
                          final v = di.sl<VehicleCubit>().state.activeVehicle;
                          activeVehicleName = v?.name;
                          activeVehiclePlate = v?.plateNumber;
                        }
                      }
                      final schedule = '$selectedDateStr · $_selectedTime';
                      if (di.sl.isRegistered<AppPreferences>()) {
                        di.sl<AppPreferences>().setSavedActiveBookingJson(
                              jsonEncode({
                                'centerId': center.id,
                                'centerName': center.name,
                                'distance': center.distance,
                                'rating': center.rating,
                                'reviewsCount': center.reviewsCount,
                                'workingHours': center.workingHours,
                                'isOpen': center.isOpen,
                                'tags': center.tags,
                                'address': center.address,
                                'phoneNumber': center.phoneNumber,
                                'schedule': schedule,
                                'vehicleName': activeVehicleName ?? 'Corolla 2018',
                              }),
                            );
                      }
                      Navigator.of(context).pushNamed(
                        AppRoutes.bookingConfirm,
                        arguments: {
                          'center': center,
                          'schedule': schedule,
                          'vehicleName': activeVehicleName,
                          'vehiclePlate': activeVehiclePlate,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003FB8),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      context.l10n.confirmAppointmentButton,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
