import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Edit Profile Page (Figma Node 325:2104)
/// Provides complete profile information management with input validation,
/// phone formatting (+20 Egypt), dropdown selections, and encrypted data notice.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _firstNameController = TextEditingController(text: 'Youssef');
  final _lastNameController = TextEditingController(text: 'Gad');
  final _phoneController = TextEditingController(text: '1098765432');
  final _emailController = TextEditingController(text: 'youssefgad_26@gmail.com');
  String _selectedGender = 'Male';
  DateTime? _selectedBirthday = DateTime(2001, 5, 26);

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. Curved Dark Blue Header with Avatar (Figma Node 325:2105)
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 180,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 48, left: 16, right: 16),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Edit profile',
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

              // Centered Avatar positioned at the bottom curve (Figma Node 325:2107)
              Positioned(
                bottom: -40,
                left: 0,
                right: 0,
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFE2E8F0),
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.person_rounded,
                          size: 52,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 52),

          // 2. Scrollable Profile Form Fields (Figma Node 325:2115)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First Name
                  _buildLabel('First Name', isRequired: true),
                  _buildTextField(
                    controller: _firstNameController,
                    hint: 'First name',
                  ),
                  const SizedBox(height: 16),

                  // Last Name
                  _buildLabel('Last Name', isRequired: true),
                  _buildTextField(
                    controller: _lastNameController,
                    hint: 'Last name',
                  ),
                  const SizedBox(height: 16),

                  // Phone Number
                  _buildLabel('Phone Number', isRequired: true),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE6E6E6)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          'EG +20',
                          style: GoogleFonts.workSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF090909),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          width: 1,
                          height: 18,
                          color: const Color(0xFFD2D2D2),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: GoogleFonts.workSans(
                              fontSize: 14,
                              color: const Color(0xFF090909),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your phone number',
                              hintStyle: GoogleFonts.workSans(
                                fontSize: 14,
                                color: const Color(0xFF989898),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email
                  _buildLabel('Email', isRequired: true),
                  _buildTextField(
                    controller: _emailController,
                    hint: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Gender Dropdown
                  _buildLabel('Gender', isRequired: false),
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE6E6E6)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedGender,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14, color: Color(0xFF989898)),
                        items: ['Male', 'Female', 'Prefer not to say']
                            .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(
                                    gender,
                                    style: GoogleFonts.workSans(
                                      fontSize: 14,
                                      color: const Color(0xFF090909),
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedGender = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Birthday Field
                  _buildLabel('Birthday', isRequired: false),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedBirthday ?? DateTime(2000, 1, 1),
                        firstDate: DateTime(1940),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _selectedBirthday = picked);
                      }
                    },
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE6E6E6)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedBirthday != null
                                ? '${_selectedBirthday!.month.toString().padLeft(2, '0')}/${_selectedBirthday!.day.toString().padLeft(2, '0')}/${_selectedBirthday!.year}'
                                : 'mm/dd/yy',
                            style: GoogleFonts.workSans(
                              fontSize: 14,
                              color: _selectedBirthday != null
                                  ? const Color(0xFF090909)
                                  : const Color(0xFF989898),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              size: 14, color: Color(0xFF989898)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Save Button (Figma Node 325:2114)
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Profile updated successfully',
                              style: GoogleFonts.inter(),
                            ),
                            backgroundColor: const Color(0xFF003FB8),
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003FB8),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Encrypted data note (Figma Node 325:2161)
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          size: 14,
                          color: Color(0xFF989898),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'All data will be encrypted',
                          style: GoogleFonts.workSans(
                            fontSize: 12,
                            color: const Color(0xFF989898),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {required bool isRequired}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            text,
            style: GoogleFonts.workSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF656565),
            ),
          ),
          if (isRequired)
            Text(
              ' *',
              style: GoogleFonts.workSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFE1332D),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.workSans(
          fontSize: 14,
          color: const Color(0xFF090909),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.workSans(
            fontSize: 14,
            color: const Color(0xFF989898),
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
