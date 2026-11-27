import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'package:obd_vision/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:obd_vision/features/vehicle/presentation/bloc/vehicle_cubit.dart';

/// Add Vehicle Page (Figma Node 446:4069)
/// Allows user to input vehicle name, nickname, energy source, mileage with unit toggle [km|mi],
/// and 17-character VIN with camera scanner shortcut.
class AddVehiclePage extends StatefulWidget {
  const AddVehiclePage({super.key});

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _energyController = TextEditingController(text: 'Petrol');
  final _mileageController = TextEditingController();
  final _vinController = TextEditingController();

  String _distanceUnit = 'km';

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _energyController.dispose();
    _mileageController.dispose();
    _vinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. Curved Header
          Container(
            height: 124,
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
                    context.l10n.addVehicleTitle,
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

          // 2. Input Fields
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Field 1: Vehicle Name
                  _buildLabel(context.l10n.vehicleNameLabel),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _nameController,
                    hintText: context.l10n.vehicleNameHint,
                  ),
                  const SizedBox(height: 18),

                  // Field 2: Nickname
                  _buildLabel(context.l10n.nicknameLabel),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _nicknameController,
                    hintText: context.l10n.nicknameHint,
                  ),
                  const SizedBox(height: 18),

                  // Field 3: Energy Source
                  _buildLabel(context.l10n.energySourceLabel),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _energyController,
                    hintText: context.l10n.energySourceHint,
                  ),
                  const SizedBox(height: 18),

                  // Field 4: Mileage with Unit Toggle Pill
                  _buildLabel(context.l10n.mileageLabel),
                  const SizedBox(height: 6),
                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _mileageController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.inter(fontSize: 15),
                            decoration: InputDecoration(
                              hintText: '84,000',
                              hintStyle: GoogleFonts.inter(
                                fontSize: 15,
                                color: const Color(0xFF777777),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        // Unit toggle [km | mi]
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              _buildUnitPill('km'),
                              _buildUnitPill('mi'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Field 5: VIN (Optional)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.vinOptionalLabel,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2A44),
                        ),
                      ),
                      Text(
                        '${_vinController.text.length}/17',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _vinController,
                            maxLength: 17,
                            textCapitalization: TextCapitalization.characters,
                            onChanged: (_) => setState(() {}),
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: context.l10n.vinHint,
                              hintStyle: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFF94A3B8),
                                letterSpacing: 0.8,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.qr_code_scanner_rounded,
                              size: 20, color: Color(0xFF003FB8)),
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (dlgCtx) => AlertDialog(
                                title: Text(context.l10n.vinHelperTitle),
                                content: Text(context.l10n.vinHelper),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(dlgCtx).pop(),
                                    child: Text(context.l10n.cancelButton),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _vinController.text = 'JTDBR32E820194821';
                                      Navigator.of(dlgCtx).pop();
                                    },
                                    child: Text(context.l10n.fillSampleVin),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          size: 13, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          context.l10n.vinHelper,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 3. Bottom CTA Action Button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  final rawName = _nameController.text.trim();
                  if (rawName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.l10n.enterVehicleNameError)),
                    );
                    return;
                  }
                  final parts = rawName.split(' ');
                  final brand = parts.first;
                  final modelYear = RegExp(r'\d{4}').firstMatch(rawName)?.group(0) ??
                      DateTime.now().year.toString();
                  final mileageText = _mileageController.text.trim().isEmpty
                      ? '0 $_distanceUnit'
                      : '${_mileageController.text.trim()} $_distanceUnit';

                  final entity = VehicleEntity(
                    id: 'veh_${DateTime.now().millisecondsSinceEpoch}',
                    name: rawName,
                    nickname: _nicknameController.text.trim().isEmpty
                        ? rawName
                        : _nicknameController.text.trim(),
                    brand: brand,
                    modelYear: modelYear,
                    fuelType: _energyController.text.trim().isEmpty
                        ? 'Petrol'
                        : _energyController.text.trim(),
                    mileage: mileageText,
                    plateNumber: 'NEW',
                    vin: _vinController.text.trim().isEmpty
                        ? 'PENDINGVIN0000000'
                        : _vinController.text.trim().toUpperCase(),
                  );

                  try {
                    context.read<VehicleCubit>().addVehicle(entity);
                  } catch (_) {}
                  Navigator.of(context).pop();
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
                  context.l10n.addVehicleTitle,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1F2A44),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: GoogleFonts.inter(fontSize: 15),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.inter(
                  fontSize: 15,
                  color: const Color(0xFF777777),
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                setState(() {
                  controller.clear();
                });
              },
              child: const Icon(Icons.close_rounded,
                  size: 18, color: Color(0xFF94A3B8)),
            ),
        ],
      ),
    );
  }

  Widget _buildUnitPill(String unit) {
    final isSelected = _distanceUnit == unit;
    return GestureDetector(
      onTap: () {
        setState(() {
          _distanceUnit = unit;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          unit,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}
