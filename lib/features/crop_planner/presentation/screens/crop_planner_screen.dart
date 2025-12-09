import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vriddhiapps/core/localization/app_localization.dart';
import 'package:vriddhiapps/core/constants/app_constants.dart';
import 'package:vriddhiapps/features/crop_planner/presentation/providers/crop_planner_provider.dart';

class CropPlannerScreen extends ConsumerWidget {
  const CropPlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSeason = ref.watch(selectedSeasonProvider);
    final selectedCrop = ref.watch(selectedCropProvider);
    final cropPlanState = ref.watch(cropPlannerNotifierProvider);
    final localizationAsync = ref.watch(appLocalizationProvider);

    return localizationAsync.when(
      data: (localization) => SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localization.translate('cropPlanner'), style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            
            // Season selector
            Text(localization.translate('selectSeason'), style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedSeason,
              items: AppConstants.seasons.map((season) => DropdownMenuItem(value: season, child: Text(localization.translate(season.toLowerCase())))).toList(),
              onChanged: (value) {
                if (value != null) ref.read(selectedSeasonProvider.notifier).state = value;
              },
            ),
            const SizedBox(height: 24),

            // Crop selector
            Text(localization.translate('selectCrop'), style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedCrop,
              items: AppConstants.crops.map((crop) => DropdownMenuItem(value: crop, child: Text(localization.translate(crop.toLowerCase())))).toList(),
              onChanged: (value) {
                if (value != null) ref.read(selectedCropProvider.notifier).state = value;
              },
            ),
            const SizedBox(height: 24),

            // Fetch button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(cropPlannerNotifierProvider.notifier).fetchCropPlan(selectedSeason, selectedCrop);
                },
                child: const Text('योजना देखें'),
              ),
            ),
            const SizedBox(height: 32),

            // Crop plan display
            cropPlanState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Card(child: Padding(padding: const EdgeInsets.all(16.0), child: Text('Error: $error'))),
              data: (cropPlan) {
                if (cropPlan == null) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cropPlan.cropName, style: Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(height: 12),
                            Text('मौसम: ${cropPlan.season}', style: Theme.of(context).textTheme.bodyMedium),
                            Text('अनुशंसित किस्म: ${cropPlan.recommendedVariety}', style: Theme.of(context).textTheme.bodyMedium),
                            Text('परिपक्वता अवधि: ${cropPlan.daysToMaturity} दिन', style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 12),
                            Text('बुवाई की खिड़की', style: Theme.of(context).textTheme.labelLarge),
                            Text('${DateFormat('d MMM').format(cropPlan.sowingWindowStart)} से ${DateFormat('d MMM').format(cropPlan.sowingWindowEnd)}', style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('फसल कार्यक्रम', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cropPlan.tasks.length,
                      itemBuilder: (context, index) {
                        final task = cropPlan.tasks[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(task.name, style: Theme.of(context).textTheme.bodyLarge),
                                Text(task.description, style: Theme.of(context).textTheme.bodySmall),
                                const SizedBox(height: 4),
                                Text('बुवाई के ${task.daysFromSowing} दिन बाद', style: Theme.of(context).textTheme.bodySmall),
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
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => const Center(child: Text('Error')),
    );
  }
}
