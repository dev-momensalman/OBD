import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obd_vision/features/diagnostics/presentation/bloc/dashboard_cubit.dart';

/// Reuses an ancestor [DashboardCubit] when provided by [ObdVisionApp],
/// or creates and owns a scoped [DashboardCubit] for standalone tests.
class DashboardCubitScope extends StatelessWidget {
  final DashboardCubit Function() create;
  final Widget child;

  const DashboardCubitScope({
    super.key,
    required this.create,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    DashboardCubit? existing;
    try {
      existing = context.read<DashboardCubit>();
    } catch (_) {}

    if (existing != null) {
      return BlocProvider<DashboardCubit>.value(
        value: existing,
        child: child,
      );
    }

    return BlocProvider<DashboardCubit>(
      create: (_) => create(),
      child: child,
    );
  }
}
