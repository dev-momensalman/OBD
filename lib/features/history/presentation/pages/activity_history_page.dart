import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/utils/app_actions.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../injection_container.dart' as di;
import '../../domain/entities/activity_log_entity.dart';
import '../bloc/history_cubit.dart';
import '../bloc/history_state.dart';

/// Authentic Activity & Diagnostic History Page matching Figma Node 118:74
/// Connected via Clean Architecture (Cubit -> UseCase -> Repository -> DataSource)
class ActivityHistoryPage extends StatelessWidget {
  final VoidCallback? onBack;

  const ActivityHistoryPage({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    HistoryCubit? existing;
    try {
      existing = context.read<HistoryCubit>();
    } catch (_) {}

    if (existing != null) {
      if (existing.state is HistoryInitial) {
        existing.fetchHistory();
      }
      return BlocProvider.value(
        value: existing,
        child: _ActivityHistoryView(onBack: onBack),
      );
    }

    return BlocProvider(
      create: (_) => di.sl<HistoryCubit>()..fetchHistory(),
      child: _ActivityHistoryView(onBack: onBack),
    );
  }
}

class _ActivityHistoryView extends StatefulWidget {
  final VoidCallback? onBack;

  const _ActivityHistoryView({this.onBack});

  @override
  State<_ActivityHistoryView> createState() => _ActivityHistoryViewState();
}

class _ActivityHistoryViewState extends State<_ActivityHistoryView> {
  int _selectedFilter = 0; // 0: All, 1: Faults, 2: Routine, 3: Trips

  final List<String> _filters = ['All', 'Faults', 'Routine', 'Trips'];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filterLabels = [
      l10n.filterAll,
      l10n.filterFaults,
      l10n.filterRoutine,
      l10n.filterTrips,
    ];

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
                      icon: Icon(context.backIcon,
                          color: Color(0xFF0F172A), size: 20),
                      onPressed: widget.onBack,
                    )
                  else
                    const SizedBox(width: 4),
                  Text(
                    context.l10n.diagnosticHistoryTitle,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.file_download_outlined,
                        color: Color(0xFF003FB8), size: 22),
                    onPressed: () {
                      final st = context.read<HistoryCubit>().state;
                      final buffer = StringBuffer(
                        '${context.l10n.diagnosticHistoryTitle}\n',
                      );
                      if (st is HistoryLoaded) {
                        for (final item in st.logs) {
                          buffer.writeln(
                            '• [${item.date}] ${item.title} (${item.healthScore}%) - ${item.subtitle}',
                          );
                        }
                      }
                      AppActions.copyText(
                        context,
                        buffer.toString(),
                        feedback: context.l10n.historyExportedMsg,
                      );
                    },
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
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: ChoiceChip(
                        label: Text(filterLabels[index]),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => _selectedFilter = index);
                          context.read<HistoryCubit>().changeFilter(_filters[index]);
                        },
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

              // 3. Reactive Clean Architecture BlocBuilder
              BlocBuilder<HistoryCubit, HistoryState>(
                builder: (context, state) {
                  if (state is HistoryLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Color(0xFF003FB8)),
                        ),
                      ),
                    );
                  } else if (state is HistoryError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline_rounded,
                                color: Color(0xFFDC2626), size: 36),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFFDC2626),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<HistoryCubit>().fetchHistory(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF003FB8),
                              ),
                              child: Text(context.l10n.retryButton,
                                  style: const TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is HistoryLoaded) {
                    if (state.logs.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            context.l10n.noDiagnosticLogs,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: state.logs
                          .map((log) => _buildActivityItem(context, log))
                          .toList(),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, ActivityLogEntity rawAct) {
    final act = context.isArabic ? _localizeArabicLog(rawAct) : rawAct;
    final isWarning = act.isWarning;
    final score = act.healthScore;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.reportSummary,
          arguments: act,
        );
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
                        act.date,
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
                          act.severity,
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
                    act.title,
                    textDirection: detectTextDirection(act.title),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    act.subtitle,
                    textDirection: detectTextDirection(act.subtitle),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const RtlForwardChevron(color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  ActivityLogEntity _localizeArabicLog(ActivityLogEntity raw) {
    const dateMap = {
      'Just now': 'الآن',
      'Today, 09:40': 'اليوم، 09:40',
      'Yesterday, 14:15': 'أمس، 14:15',
      '3 days ago': 'منذ 3 أيام',
      '1 week ago': 'منذ أسبوع',
    };
    const severityMap = {
      'Warning': 'تحذير',
      'WARNING': 'تحذير',
      'CRITICAL': 'حرج',
      'HEALTHY': 'سليم',
      'Normal': 'طبيعي',
      'Mild': 'طفيف',
      'Optimal': 'مثالي',
    };
    const titleMap = {
      'High Coolant Temp & Misfire': 'ارتفاع حرارة المبرد وتقطيع بالاحتراق',
      'Routine System Pre-Check': 'فحص دوري مبدئي للنظام',
      'Battery Alternator Fluctuation': 'تذبذب جهد البطارية والدينامو',
      'Scheduled Full Vehicle Diagnostic': 'فحص شامل مجدول للمركبة',
    };
    const subtitleMap = {
      'P0301, P0171 detected · 24 sensors recorded':
          'تم رصد P0301، P0171 · قراءة 24 حساساً',
      'All electronic control units responding':
          'جميع وحدات التحكم الإلكترونية تستجيب طبيعياً',
      'Voltage dipped to 12.1V under engine load':
          'انخفض الجهد إلى 12.1V تحت حمل المحرك',
      'Powertrain, ABS & SRS full sweep passed':
          'اجتاز فحص المحرك وABS والوسائد الهوائية بنجاح',
    };

    return ActivityLogEntity(
      id: raw.id,
      date: dateMap[raw.date] ?? raw.date,
      title: titleMap[raw.title] ?? raw.title,
      subtitle: subtitleMap[raw.subtitle] ?? raw.subtitle,
      healthScore: raw.healthScore,
      isWarning: raw.isWarning,
      severity: severityMap[raw.severity] ?? raw.severity,
      detectedDtcs: raw.detectedDtcs,
      sensorsRecorded: raw.sensorsRecorded,
    );
  }
}
