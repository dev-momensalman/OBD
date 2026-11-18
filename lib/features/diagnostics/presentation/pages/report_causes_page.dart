import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_routes.dart';

/// Authentic Report Causes Screen matching Figma Node 253:979
/// Displays AI-estimated root causes for diagnostic trouble codes ranked by likelihood.
class ReportCausesPage extends StatefulWidget {
  const ReportCausesPage({super.key});

  @override
  State<ReportCausesPage> createState() => _ReportCausesPageState();
}

class _ReportCausesPageState extends State<ReportCausesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF242424), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Report',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF242424),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined,
                color: Color(0xFF242424), size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),

                    // 1. Segmented Control: [Summary] | [Causes] (Figma Node 253:986)
                    Container(
                      height: 42,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC4AAFF).withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacementNamed(
                                    AppRoutes.reportSummary);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Summary',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF8855FF),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Causes',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 2. Subheader: AI Estimate Pill & Ranked text (Figma Node 253:1131)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFA2C2FF).withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.auto_awesome_rounded,
                                size: 14,
                                color: Color(0xFF003FB8),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'AI estimate',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Ranked by likelihood',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF5B6780),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 3. Cause Card 1: Worn spark plug (93%)
                    _buildCauseCard(
                      title: 'Worn spark plug',
                      subtitle: 'A common cause of cylinder 1 misfire',
                      percentage: 93,
                      hasTrend: true,
                    ),

                    const SizedBox(height: 16),

                    // 4. Cause Card 2: Faulty ignition coil (65%)
                    _buildCauseCard(
                      title: 'Faulty ignition coil',
                      subtitle: 'Often leads to misfires in multiple cylinders',
                      percentage: 65,
                      hasTrend: false,
                    ),

                    const SizedBox(height: 16),

                    // 5. Cause Card 3: Clogged fuel injector (22%)
                    _buildCauseCard(
                      title: 'Clogged fuel injector',
                      subtitle: 'Can cause poor fuel delivery and misfires',
                      percentage: 22,
                      hasTrend: false,
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom CTAs: Find service center & Done (Figma Node 253:1009)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.serviceCentersList);
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
                        'Find service center',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.home,
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF003FB8),
                        side: const BorderSide(color: Color(0xFFD2D2D2)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Done',
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
      ),
    );
  }

  Widget _buildCauseCard({
    required String title,
    required String subtitle,
    required int percentage,
    required bool hasTrend,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF19213D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF6D758F),
                      ),
                    ),
                  ],
                ),
              ),
              if (hasTrend)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: Color(0xFF7C3AED),
                    size: 18,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Percentage Bar (Figma Node 264:1758)
          LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              final filledWidth = totalWidth * (percentage / 100);

              return Container(
                height: 24,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F7),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: const Color(0xFFE1E4ED)),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: filledWidth,
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFC4AAFF),
                            Color(0xFF8855FF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        '$percentage%',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
