import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('खाद चयन', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            Text('फसल चुनें', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedCrop,
              items: AppConstants.crops.map((crop) => DropdownMenuItem(value: crop, child: Text(crop))).toList(),
              onChanged: (value) { if (value != null) ref.read(selectedFertilizerCropProvider.notifier).state = value; },
            ),
            const SizedBox(height: 24),
            Text('मिट्टी का प्रकार', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedSoilType,
              items: AppConstants.soilTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (value) { if (value != null) ref.read(selectedSoilTypeProvider.notifier).state = value; },
            ),
            const SizedBox(height: 24),
            Text('भूमि का आकार (एकड़)', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'एकड़ में प्रवेश करें', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
              onChanged: (value) { final size = double.tryParse(value) ?? 1.0; ref.read(landSizeProvider.notifier).state = size; },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () { ref.read(fertilizerNotifierProvider.notifier).fetchFertilizerPlan(selectedCrop, landSize, selectedSoilType); },
                child: const Text('खाद योजना देखें'),
              ),
            ),
            const SizedBox(height: 32),
            planState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Card(child: Padding(padding: const EdgeInsets.all(16.0), child: Text('Error: $error'))),
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
                            Text('क्षेत्र: ${plan.landSizeAcre} एकड़', style: Theme.of(context).textTheme.bodyMedium),
                            Text('मिट्टी: ${plan.soilType}', style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 12),
                            Text('एनपीके आवश्यकता (प्रति एकड़)', style: Theme.of(context).textTheme.labelLarge),
                            const SizedBox(height: 8),
                            Text('नाइट्रोजन (N): ${plan.npkRequirement.nitrogen.toStringAsFixed(1)} kg', style: Theme.of(context).textTheme.bodyMedium),
                            Text('फॉस्फोरस (P): ${plan.npkRequirement.phosphorus.toStringAsFixed(1)} kg', style: Theme.of(context).textTheme.bodyMedium),
                            Text('पोटेशियम (K): ${plan.npkRequirement.potassium.toStringAsFixed(1)} kg', style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('अनुशंसित खाद', style: Theme.of(context).textTheme.headlineSmall),
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
                                Text('मात्रा: ${product.quantityKg.toStringAsFixed(1)} kg', style: Theme.of(context).textTheme.bodyMedium),
                                Text('समय: ${product.timing}', style: Theme.of(context).textTheme.bodySmall),
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
    );
  }
}
