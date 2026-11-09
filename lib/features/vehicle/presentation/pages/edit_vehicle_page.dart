import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Edit Vehicle Page (Figma Node 325:2164)
/// Enables editing vehicle nickname, mileage, energy source, and deleting vehicle.
class EditVehiclePage extends StatefulWidget {
  final Map<String, dynamic>? initialVehicle;

  const EditVehiclePage({
    super.key,
    this.initialVehicle,
  });

  @override
  State<EditVehiclePage> createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends State<EditVehiclePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _nicknameController;
  late final TextEditingController _energyController;
  late final TextEditingController _mileageController;
  late final TextEditingController _vinController;

  String _distanceUnit = 'km';

  @override
  void initState() {
    super.initState();
    final v = widget.initialVehicle ?? {};
    _nameController = TextEditingController(text: v['name'] ?? 'Corolla 2018');
    _nicknameController =
        TextEditingController(text: v['nickname'] ?? 'My daily car');
    _energyController = TextEditingController(text: v['fuel'] ?? 'Petrol');
    _mileageController =
        TextEditingController(text: v['mileage'] ?? '84,200');
    _vinController =
        TextEditingController(text: v['vin'] ?? 'JTDBR32E820194821');
  }

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
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Edit vehicle',
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
                  // Vehicle Name
                  _buildLabel('Vehicle Name'),
                  const SizedBox(height: 6),
                  _buildTextField(controller: _nameController),
                  const SizedBox(height: 18),

                  // Nickname
                  _buildLabel('Nickname'),
                  const SizedBox(height: 6),
                  _buildTextField(controller: _nicknameController),
                  const SizedBox(height: 18),

                  // Energy Source
                  _buildLabel('Energy source'),
                  const SizedBox(height: 6),
                  _buildTextField(controller: _energyController),
                  const SizedBox(height: 18),

                  // Mileage with Unit Toggle Pill
                  _buildLabel('Mileage'),
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
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
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

                  // VIN
                  _buildLabel('VIN'),
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
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Delete vehicle destructive button
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: Color(0xFFDC2626), size: 18),
                      label: Text(
                        'Delete vehicle',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFDC2626),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Save Changes CTA
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
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
                  'Save changes',
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

  Widget _buildTextField({required TextEditingController controller}) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.25),
        ),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.inter(fontSize: 15),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
        ),
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
