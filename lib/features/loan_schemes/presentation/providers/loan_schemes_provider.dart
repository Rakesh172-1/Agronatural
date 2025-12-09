import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vriddhiapps/features/loan_schemes/data/models/loan_scheme_model.dart';
import 'package:vriddhiapps/features/loan_schemes/data/services/loan_schemes_service.dart';

final loanSchemesServiceProvider = Provider((ref) => LoanSchemesService());

class LoanSchemesNotifier extends StateNotifier<AsyncValue<List<LoanScheme>>> {
  final LoanSchemesService _service;

  LoanSchemesNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> fetchAllSchemes() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _service.getAllSchemes());
  }

  Future<void> fetchSchemesByEligibility(String type) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _service.getSchemesByEligibility(type));
  }

  Future<void> fetchUpcomingDeadlines() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _service.getUpcomingDeadlines());
  }

  Future<void> fetchHighestSubsidySchemes() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _service.getHighestSubsidySchemes());
  }
}

final loanSchemesNotifierProvider = StateNotifierProvider<LoanSchemesNotifier, AsyncValue<List<LoanScheme>>>((ref) {
  final service = ref.watch(loanSchemesServiceProvider);
  return LoanSchemesNotifier(service);
});

final loanSchemeByIdProvider = FutureProvider.family<LoanScheme?, String>((ref, id) async {
  final service = ref.watch(loanSchemesServiceProvider);
  return service.getSchemeById(id);
});

final upcomingDeadlinesProvider = FutureProvider<List<LoanScheme>>((ref) async {
  final service = ref.watch(loanSchemesServiceProvider);
  return service.getUpcomingDeadlines();
});

final highestSubsidyProvider = FutureProvider<List<LoanScheme>>((ref) async {
  final service = ref.watch(loanSchemesServiceProvider);
  return service.getHighestSubsidySchemes();
});
