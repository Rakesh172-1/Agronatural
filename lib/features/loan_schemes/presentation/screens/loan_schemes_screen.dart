import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vriddhiapps/core/localization/app_localization.dart';
import 'package:vriddhiapps/features/loan_schemes/presentation/providers/loan_schemes_provider.dart';

class LoanSchemesScreen extends ConsumerStatefulWidget {
  const LoanSchemesScreen({super.key});

  @override
  ConsumerState<LoanSchemesScreen> createState() => _LoanSchemesScreenState();
}

class _LoanSchemesScreenState extends ConsumerState<LoanSchemesScreen> {
  String selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(loanSchemesNotifierProvider.notifier).fetchAllSchemes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final schemes = ref.watch(loanSchemesNotifierProvider);
    final localizationAsync = ref.watch(appLocalizationProvider);

    return localizationAsync.when(
      data: (localization) => Scaffold(
        appBar: AppBar(
          title: Text(localization.translate('loanSchemes')),
          elevation: 0,
        ),
        body: Column(
          children: [
            _buildFilterBar(),
            Expanded(
              child: schemes.when(
                data: (schemeList) => _buildSchemesList(schemeList),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => _buildErrorWidget(err),
              ),
            ),
          ],
        ),
      ),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => const Scaffold(body: Center(child: Text('Error'))),
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildFilterButton('All', 'all'),
          const SizedBox(width: 8),
          _buildFilterButton('Upcoming', 'upcoming'),
          const SizedBox(width: 8),
          _buildFilterButton('Subsidy', 'subsidy'),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, String filterId) {
    final isSelected = selectedFilter == filterId;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (value) {
        setState(() => selectedFilter = filterId);
        _applyFilter(filterId);
      },
    );
  }

  void _applyFilter(String filterId) {
    final notifier = ref.read(loanSchemesNotifierProvider.notifier);
    switch (filterId) {
      case 'upcoming':
        notifier.fetchUpcomingDeadlines();
        break;
      case 'subsidy':
        notifier.fetchHighestSubsidySchemes();
        break;
      default:
        notifier.fetchAllSchemes();
    }
  }

  Widget _buildSchemesList(List schemeList) {
    if (schemeList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No schemes found', style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: schemeList.length,
      itemBuilder: (context, index) => _buildCard(schemeList[index]),
    );
  }

  Widget _buildErrorWidget(Object err) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text('Error loading schemes'),
        ],
      ),
    );
  }

  Widget _buildCard(dynamic scheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(scheme.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Interest: ${scheme.interestRate}%', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(scheme.subsidy.split(' ').first, style: TextStyle(fontSize: 11, color: Colors.green[700])),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Amount: ${scheme.minAmount} - ${scheme.maxAmount}', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text('Tenure: ${scheme.tenure}', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text('Deadline: ${scheme.applicationDeadline}', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showDetails(scheme),
                child: const Text('Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(dynamic scheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Text(scheme.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _detailItem('Description', scheme.description),
              _detailItem('Eligibility', scheme.eligibility),
              _detailItem('Loan Amount', '${scheme.minAmount} to ${scheme.maxAmount}'),
              _detailItem('Interest Rate', '${scheme.interestRate}%'),
              _detailItem('Subsidy', scheme.subsidy),
              _detailItem('Required Documents', scheme.requiredDocuments),
              _detailItem('Processing Time', scheme.processingTime),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Apply Now')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        ],
      ),
    );
  }
}
