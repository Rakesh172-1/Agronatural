import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vriddhiapps/core/localization/app_localization.dart';
import 'package:vriddhiapps/core/constants/app_constants.dart';
import 'package:vriddhiapps/features/fertilizer/presentation/providers/fertilizer_provider.dart';

class FertilizerScreen extends ConsumerWidget {
  const FertilizerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCrop = ref.watch(selectedFertilizerCropProvider);
    final selectedSoilType = ref.watch(selectedSoilTypeProvider);
    final landSize = ref.watch(landSizeProvider);
    final planState = ref.watch(fertilizerNotifierProvider);
    final localizationAsync = ref.watch(appLocalizationProvider);

    return localizationAsync.when(
      data: (localization) => Scaffold(
        appBar: AppBar(
          title: Text(localization.translate('fertilizerTitle')),
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(localization.translate('selectFertilizer'), style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 24),
              Text(localization.translate('chooseCrop'), style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedCrop,
                items: AppConstants.crops.map((crop) => DropdownMenuItem(value: crop, child: Text(localization.translate(crop.toLowerCase())))).toList(),
                onChanged: (value) { if (value != null) ref.read(selectedFertilizerCropProvider.notifier).state = value; },
              ),
              const SizedBox(height: 24),
              Text(localization.translate('soilType'), style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedSoilType,
                items: AppConstants.soilTypes.map((type) => DropdownMenuItem(value: type, child: Text(localization.translate(type.toLowerCase().replaceAll(' ', ''))))).toList(),
                onChanged: (value) { if (value != null) ref.read(selectedSoilTypeProvider.notifier).state = value; },
              ),
              const SizedBox(height: 24),
              Text(localization.translate('landSize'), style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: localization.translate('enterSizeInAcres'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: (value) { 
                  final size = double.tryParse(value) ?? 1.0; 
                  ref.read(landSizeProvider.notifier).state = size; 
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () { 
                    ref.read(fertilizerNotifierProvider.notifier).fetchFertilizerPlan(selectedCrop, landSize, selectedSoilType); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text(localization.translate('viewFertilizerPlan')),
                ),
              ),
              const SizedBox(height: 32),
              planState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Error: $error'),
                  ),
                ),
                data: (plan) {
                  if (plan == null) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(plan.cropName, style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: 12),
                              Text('${localization.translate('area')}: ${plan.landSizeAcre} ${localization.translate('acres')}', style: Theme.of(context).textTheme.bodyMedium),
                              Text('${localization.translate('soil')}: ${plan.soilType}', style: Theme.of(context).textTheme.bodyMedium),
                              const SizedBox(height: 12),
                              Text(localization.translate('npkRequirementPerAcre'), style: Theme.of(context).textTheme.labelLarge),
                              const SizedBox(height: 8),
                              Text('${localization.translate('nitrogenN')}: ${plan.npkRequirement.nitrogen.toStringAsFixed(1)} ${localization.translate('kg')}', style: Theme.of(context).textTheme.bodyMedium),
                              Text('${localization.translate('phosphorusP')}: ${plan.npkRequirement.phosphorus.toStringAsFixed(1)} ${localization.translate('kg')}', style: Theme.of(context).textTheme.bodyMedium),
                              Text('${localization.translate('potassiumK')}: ${plan.npkRequirement.potassium.toStringAsFixed(1)} ${localization.translate('kg')}', style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(localization.translate('recommendedFertilizers'), style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: plan.products.length,
                        itemBuilder: (context, index) {
                          final product = plan.products[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name, style: Theme.of(context).textTheme.bodyLarge),
                                  const SizedBox(height: 4),
                                  Text('${localization.translate('quantity')}: ${product.quantityKg.toStringAsFixed(1)} ${localization.translate('kg')}', style: Theme.of(context).textTheme.bodyMedium),
                                  Text('${localization.translate('timing')}: ${product.timing}', style: Theme.of(context).textTheme.bodySmall),
                                  const SizedBox(height: 8),
                                  Text(product.instruction, style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      ),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => const Scaffold(body: Center(child: Text('Error'))),
    );
  }
}
