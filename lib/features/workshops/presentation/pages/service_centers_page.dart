import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import '../../../../injection_container.dart' as di;
import '../bloc/workshops_cubit.dart';
import '../bloc/workshops_state.dart';
import '../widgets/service_center_list_card.dart';
import '../widgets/service_centers_header.dart';
import '../widgets/service_centers_map_view.dart';
import '../widgets/service_repair_tracker_card.dart';

/// Authentic Service Centers & Workshops Page matching Figma Node 398:3074
/// Connected via Clean Architecture (Cubit -> UseCase -> Repository -> DataSource)
class ServiceCentersPage extends StatelessWidget {
  final VoidCallback? onBack;

  const ServiceCentersPage({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<WorkshopsCubit>()..fetchServiceCenters(),
      child: _ServiceCentersView(onBack: onBack),
    );
  }
}

class _ServiceCentersView extends StatefulWidget {
  final VoidCallback? onBack;

  const _ServiceCentersView({this.onBack});

  @override
  State<_ServiceCentersView> createState() => _ServiceCentersViewState();
}

class _ServiceCentersViewState extends State<_ServiceCentersView> {
  int _selectedViewTab = 0; // 0: List, 1: Map
  int _filterMode = 0; // 0: all, 1: openOnly, 2: highestRated
  final _searchController = TextEditingController();

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final l10n = context.l10n;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.apps_rounded, color: Color(0xFF003FB8)),
                title: Text(l10n.filterAllCenters),
                trailing: _filterMode == 0
                    ? const Icon(Icons.check_rounded, color: Color(0xFF003FB8))
                    : null,
                onTap: () {
                  setState(() => _filterMode = 0);
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.access_time_filled_rounded,
                    color: Color(0xFF16A34A)),
                title: Text(l10n.filterOpenNow),
                trailing: _filterMode == 1
                    ? const Icon(Icons.check_rounded, color: Color(0xFF003FB8))
                    : null,
                onTap: () {
                  setState(() => _filterMode = 1);
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.star_rounded, color: Color(0xFFF59E0B)),
                title: Text(l10n.filterHighestRated),
                trailing: _filterMode == 2
                    ? const Icon(Icons.check_rounded, color: Color(0xFF003FB8))
                    : null,
                onTap: () {
                  setState(() => _filterMode = 2);
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Top Curved Blue Header (matching Figma Node 404:3383)
            ServiceCentersHeader(onBack: widget.onBack),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),

                  // 2. Active Repair Progress Banner (Figma Node 404:3388)
                  const ServiceRepairTrackerCard(),
                  const SizedBox(height: 16),

                  // 3. Search Bar with Filter Dialog Button (Figma Node 404:3407)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 46,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search_rounded,
                                  color: Color(0xFF94A3B8), size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (val) {
                                    context.read<WorkshopsCubit>().filterCenters(val);
                                  },
                                  decoration: InputDecoration(
                                    hintText: context.l10n.searchCenterHint,
                                    hintStyle: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.tune_rounded,
                              color: Color(0xFF003FB8), size: 20),
                          onPressed: _showFilterSheet,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 4. Segmented Control: [List] | [Map] (Figma Node 404:3420)
                  _buildSegmentedControl(),
                  const SizedBox(height: 16),

                  // 5. Reactive Clean Architecture BlocBuilder
                  BlocBuilder<WorkshopsCubit, WorkshopsState>(
                    builder: (context, state) {
                      if (state is WorkshopsLoading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Color(0xFF003FB8)),
                            ),
                          ),
                        );
                      } else if (state is WorkshopsError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Text(
                              state.message,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFFDC2626),
                              ),
                            ),
                          ),
                        );
                      } else if (state is WorkshopsLoaded) {
                        var centers = List.of(state.centers);
                        if (_filterMode == 1) {
                          centers = centers.where((c) => c.isOpen).toList();
                        } else if (_filterMode == 2) {
                          centers.sort((a, b) => b.rating.compareTo(a.rating));
                        }

                        if (_selectedViewTab == 1) {
                          return ServiceCentersMapView(centers: centers);
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Subheader
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  context.l10n.centersNearYou(centers.length),
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      context.l10n.nearestFirst,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF003FB8),
                                      ),
                                    ),
                                    const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 16,
                                        color: Color(0xFF003FB8)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // List of Workshop Cards from Entity
                            ...centers.map(
                              (center) => ServiceCenterListCard(center: center),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),

            // Space for bottom nav bar
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedViewTab = 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _selectedViewTab == 0 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: _selectedViewTab == 0
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.format_list_bulleted_rounded,
                      size: 18,
                      color: _selectedViewTab == 0
                          ? const Color(0xFF003FB8)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      context.l10n.listViewTab,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: _selectedViewTab == 0
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: _selectedViewTab == 0
                            ? const Color(0xFF003FB8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedViewTab = 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _selectedViewTab == 1 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: _selectedViewTab == 1
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 18,
                      color: _selectedViewTab == 1
                          ? const Color(0xFF003FB8)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      context.l10n.mapViewTab,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: _selectedViewTab == 1
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: _selectedViewTab == 1
                            ? const Color(0xFF003FB8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
