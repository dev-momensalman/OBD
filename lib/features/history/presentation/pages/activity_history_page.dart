import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_routes.dart';

/// Authentic Activity & Diagnostic History Page matching Figma Node 118:74
class ActivityHistoryPage extends StatefulWidget {
  final VoidCallback? onBack;

  const ActivityHistoryPage({super.key, this.onBack});

  @override
  State<ActivityHistoryPage> createState() => _ActivityHistoryPageState();
}

class _ActivityHistoryPageState extends State<ActivityHistoryPage> {
  int _selectedFilter = 0; // 0: All, 1: Faults, 2: Routine, 3: Trips

  final List<String> _filters = ['All', 'Faults', 'Routine', 'Trips'];

  final List<Map<String, dynamic>> _activities = [
    {
      'date': 'Today, 09:40',
      'title': 'High Coolant Temp & Misfire',
      'subtitle': 'P0301, P0171 detected · 24 sensors recorded',
      'healthScore': 86,
      'isWarning': true,
      'severity': 'Warning',
    },
    {
      'date': 'Yesterday, 14:15',
      'title': 'Routine System Pre-Check',
      'subtitle': 'All electronic control units responding',
      'healthScore': 98,
      'isWarning': false,
      'severity': 'Normal',
    },
    {
      'date': '3 days ago',
      'title': 'Battery Alternator Fluctuation',
      'subtitle': 'Voltage dipped to 12.1V under engine load',
      'healthScore': 91,
      'isWarning': true,
      'severity': 'Mild',
    },
    {
      'date': '1 week ago',
      'title': 'Scheduled Full Vehicle Diagnostic',
      'subtitle': 'Powertrain, ABS & SRS full sweep passed',
      'healthScore': 100,
      'isWarning': false,
      'severity': 'Optimal',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              // 1. Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.onBack != null)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF0F172A), size: 20),
                      onPressed: widget.onBack,
                    )
                  else
                    const SizedBox(width: 4),
                  Text(
                    'Diagnostic History',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.file_download_outlined,
                        color: Color(0xFF003FB8), size: 22),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. Filter Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: List.generate(_filters.length, (index) {
                    final isSelected = _selectedFilter == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(_filters[index]),
                        selected: isSelected,
                        onSelected: (_) =>
                            setState(() => _selectedFilter = index),
                        labelStyle: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF64748B),
                        ),
                        selectedColor: const Color(0xFF003FB8),
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF003FB8)
                              : const Color(0xFFE2E8F0),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Activity Timeline List
              ..._activities.map((act) => _buildActivityItem(context, act)),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, Map<String, dynamic> act) {
    final isWarning = act['isWarning'] as bool;
    final score = act['healthScore'] as int;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.reportSummary);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Circular Health Score
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isWarning
                    ? const Color(0xFFFEF2F2)
                    : const Color(0xFFF0FDF4),
                border: Border.all(
                  color: isWarning
                      ? const Color(0xFFFCA5A5)
                      : const Color(0xFF86EFAC),
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '$score',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isWarning
                      ? const Color(0xFFDC2626)
                      : const Color(0xFF16A34A),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        act['date'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isWarning
                              ? const Color(0xFFFEE2E2)
                              : const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          act['severity'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isWarning
                                ? const Color(0xFFDC2626)
                                : const Color(0xFF16A34A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    act['title'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    act['subtitle'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}
