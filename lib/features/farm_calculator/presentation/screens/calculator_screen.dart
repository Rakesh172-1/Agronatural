import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vriddhiapps/core/localization/app_localization.dart';
import 'package:vriddhiapps/features/farm_calculator/presentation/providers/calculator_provider.dart';

class FarmCalculatorScreen extends ConsumerStatefulWidget {
  const FarmCalculatorScreen({super.key});

  @override
  ConsumerState<FarmCalculatorScreen> createState() => _FarmCalculatorScreenState();
}

class _FarmCalculatorScreenState extends ConsumerState<FarmCalculatorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizationAsync = ref.watch(appLocalizationProvider);
    
    return localizationAsync.when(
      data: (localization) => Scaffold(
        appBar: AppBar(
          title: Text(localization.translate('calculator')),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: localization.translate('seedQuantity')),
              Tab(text: localization.translate('farmingCost')),
              Tab(text: localization.translate('yieldAndProfit')),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _SeedCalculator(localization: localization),
            _CostCalculator(localization: localization),
            _YieldCalculator(localization: localization),
          ],
        ),
      ),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => const Scaffold(body: Center(child: Text('Error'))),
    );
  }
}

class _SeedCalculator extends ConsumerStatefulWidget {
  final AppLocalization localization;
  
  const _SeedCalculator({required this.localization});
  
  @override
  ConsumerState<_SeedCalculator> createState() => _SeedCalculatorState();
}

class _SeedCalculatorState extends ConsumerState<_SeedCalculator> {
  String selectedCrop = 'Wheat';
  double landSize = 1;

  final List<String> crops = ['Wheat', 'Rice', 'Cotton', 'Maize', 'Sugarcane', 'Soybean', 'Chickpea', 'Mustard'];

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(calculatorNotifierProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.localization.translate('selectCropType'), style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          DropdownButton<String>(
            isExpanded: true,
            value: selectedCrop,
            items: crops
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => selectedCrop = value);
            },
          ),
          const SizedBox(height: 24),
          Text(widget.localization.translate('landSize'), style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() => landSize = double.tryParse(value) ?? 1);
            },
            decoration: InputDecoration(
              hintText: widget.localization.translate('enterLandSize'),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              prefixText: widget.localization.translate('land'),
              suffixText: widget.localization.translate('acres'),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ref.read(calculatorNotifierProvider.notifier).calculateSeed(selectedCrop, landSize);
              },
              child: Text(widget.localization.translate('calculateSeedQuantity')),
            ),
          ),
          const SizedBox(height: 24),
          result.when(
            data: (calculation) {
              if (calculation == null) return const SizedBox.shrink();
              return _buildResultCard(
                title: 'Seed Quantity Needed',
                value: calculation.result,
                unit: calculation.unit,
                details: 'For ${calculation.landSizeAcres} acre(s) of ${calculation.cropName}',
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ],
      ),
    );
  }
}

class _CostCalculator extends ConsumerStatefulWidget {
  final AppLocalization localization;
  
  const _CostCalculator({required this.localization});
  
  @override
  ConsumerState<_CostCalculator> createState() => _CostCalculatorState();
}

class _CostCalculatorState extends ConsumerState<_CostCalculator> {
  String selectedCrop = 'Wheat';
  double landSize = 1;
  double seedCost = 100;
  double fertilizerCost = 10;
  double laborDays = 20;

  final List<String> crops = ['Wheat', 'Rice', 'Cotton', 'Maize', 'Sugarcane', 'Soybean', 'Chickpea', 'Mustard'];

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(calculatorNotifierProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.localization.translate('selectCrop'), style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          DropdownButton<String>(
            isExpanded: true,
            value: selectedCrop,
            items: crops
                .map((c) => DropdownMenuItem(value: c, child: Text(widget.localization.translate(c.toLowerCase()))))
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => selectedCrop = value);
            },
          ),
          const SizedBox(height: 16),
          _buildInputField('Land Size (Acres)', (v) => landSize = double.tryParse(v) ?? 1),
          const SizedBox(height: 16),
          _buildInputField('Seed Cost (Per kg)', (v) => seedCost = double.tryParse(v) ?? 100),
          const SizedBox(height: 16),
          _buildInputField('Fertilizer Cost (Per kg)', (v) => fertilizerCost = double.tryParse(v) ?? 10),
          const SizedBox(height: 16),
          _buildInputField('Labor Days Needed', (v) => laborDays = double.tryParse(v) ?? 20),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ref.read(calculatorNotifierProvider.notifier).calculateCost(
                  selectedCrop,
                  landSize,
                  seedCost,
                  fertilizerCost,
                  laborDays,
                );
              },
              child: const Text('Calculate Total Cost'),
            ),
          ),
          const SizedBox(height: 24),
          result.when(
            data: (calculation) {
              if (calculation == null) return const SizedBox.shrink();
              return _buildResultCard(
                title: 'Total Farming Cost',
                value: calculation.result,
                unit: calculation.unit,
                details: 'Cost per acre: ₹${(calculation.costPerUnit ?? 0).toStringAsFixed(0)}',
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'Enter value',
          ),
        ),
      ],
    );
  }
}

class _YieldCalculator extends ConsumerStatefulWidget {
  final AppLocalization localization;
  
  const _YieldCalculator({required this.localization});
  
  @override
  ConsumerState<_YieldCalculator> createState() => _YieldCalculatorState();
}

class _YieldCalculatorState extends ConsumerState<_YieldCalculator> {
  String selectedCrop = 'Wheat';
  double landSize = 1;
  double totalCost = 50000;
  double yieldPerAcre = 50;
  double sellingPrice = 2000;

  final List<String> crops = ['Wheat', 'Rice', 'Cotton', 'Maize', 'Sugarcane', 'Soybean', 'Chickpea', 'Mustard'];

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(calculatorNotifierProvider);
    final yieldExpectations = ref.watch(yieldExpectationsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.localization.translate('selectCropType'), style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          DropdownButton<String>(
            isExpanded: true,
            value: selectedCrop,
            items: crops
                .map((c) => DropdownMenuItem(value: c, child: Text(widget.localization.translate(c.toLowerCase()))))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedCrop = value;
                  yieldPerAcre = yieldExpectations[value] ?? 50;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          _buildInputField('Land Size (Acres)', (v) => landSize = double.tryParse(v) ?? 1),
          const SizedBox(height: 16),
          _buildInputField('Total Cost (INR)', (v) => totalCost = double.tryParse(v) ?? 50000),
          const SizedBox(height: 16),
          _buildInputField('Expected Yield (Quintals/Acre)', (v) => yieldPerAcre = double.tryParse(v) ?? 50),
          const SizedBox(height: 16),
          _buildInputField('Selling Price (Per Quintal)', (v) => sellingPrice = double.tryParse(v) ?? 2000),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ref.read(calculatorNotifierProvider.notifier).calculateYield(
                  selectedCrop,
                  landSize,
                  totalCost,
                  yieldPerAcre,
                  sellingPrice,
                );
              },
              child: const Text('Calculate Profit'),
            ),
          ),
          const SizedBox(height: 24),
          result.when(
            data: (calculation) {
              if (calculation == null) return const SizedBox.shrink();
              return _buildResultCard(
                title: 'Expected Profit',
                value: calculation.result,
                unit: calculation.unit,
                details: 'Total yield: ${(calculation.expectedYield ?? 0).toStringAsFixed(1)} quintals',
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'Enter value',
          ),
        ),
      ],
    );
  }
}

Widget _buildResultCard({
  required String title,
  required String value,
  required String unit,
  required String details,
}) {
  return Card(
    elevation: 4,
    child: Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF52B788), Color(0xFF66BB6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                unit,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            details,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    ),
  );
}
