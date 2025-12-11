import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:vriddhiapps/core/localization/app_localization.dart';
import 'package:vriddhiapps/core/constants/app_constants.dart';
import 'package:vriddhiapps/features/mandi_price/presentation/providers/mandi_price_provider.dart';

class MandiPriceScreen extends ConsumerWidget {
  const MandiPriceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedState = ref.watch(selectedStateProvider);
    final selectedDistrict = ref.watch(selectedDistrictProvider);
    final selectedCrop = ref.watch(selectedMandiCropProvider);
    final districtState = ref.watch(availableDistrictsProvider);
    final priceState = ref.watch(mandiPriceNotifierProvider);
    final localizationAsync = ref.watch(appLocalizationProvider);

    return localizationAsync.when(
      data: (localization) => SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              localization.translate('mandiPrices'),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
            ),
            Text(
              localization.translate('checkMarketPrices'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),

            // Selection Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // State selector
                    _buildDropdownField(
                      context,
                      'राज्य चुनें',
                      selectedState,
                      AppConstants.indianStates,
                      (value) {
                        if (value != null) {
                          ref.read(selectedStateProvider.notifier).state = value;
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // District selector
                    _buildAsyncDropdownField(
                      context,
                      localization.translate('selectDistrict'),
                      selectedDistrict,
                      districtState,
                      (value) {
                        if (value != null) {
                          ref.read(selectedDistrictProvider.notifier).state = value;
                        }
                      },
                      localization,
                    ),
                    const SizedBox(height: 16),

                    // Crop selector
                    _buildDropdownField(
                      context,
                      localization.translate('selectCrop'),
                      selectedCrop,
                      AppConstants.crops,
                      (value) {
                        if (value != null) {
                          ref.read(selectedMandiCropProvider.notifier).state = value;
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // Fetch button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ref
                              .read(mandiPriceNotifierProvider.notifier)
                              .fetchPrices(selectedState, selectedDistrict, selectedCrop);
                        },
                        icon: const Icon(Icons.trending_up),
                        label: Text(localization.translate('viewPrices')),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.green[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Prices display
            priceState.when(
              loading: () => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(
                    color: Colors.green[700],
                  ),
                ),
              ),
              error: (error, stack) => _buildErrorCard('भाव डेटा लोड नहीं हो सका'),
              data: (prices) {
                if (prices.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        localization.translate('selectCrop'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ),
                  );
                }
                final firstPrice = prices[0];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chart
                    Text(
                      localization.translate('forecast'),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: 220,
                          child: _buildPriceChart(firstPrice),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Mandis list
                    Text(
                      localization.translate('mandiPrices'),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: prices.length,
                      itemBuilder: (context, index) {
                        final price = prices[index];
                        return _buildMandiCard(context, price, index);
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

  Widget _buildDropdownField(
    BuildContext context,
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.green[700],
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            underline: const SizedBox(),
            value: value,
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildAsyncDropdownField(
    BuildContext context,
    String label,
    String value,
    AsyncValue<List<String>> asyncItems,
    Function(String?) onChanged,
    AppLocalization localization,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.green[700],
              ),
        ),
        const SizedBox(height: 8),
        asyncItems.when(
          loading: () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const SizedBox(
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          error: (error, stack) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(localization.translate('errorLoadingDistricts'),
                style: TextStyle(color: Colors.red[700])),
          ),
          data: (items) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              underline: const SizedBox(),
              value: items.contains(value) ? value : (items.isNotEmpty ? items[0] : 'N/A'),
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceChart(dynamic firstPrice) {
    final minPrice = firstPrice.priceHistory
        .map((p) => p.price)
        .reduce((a, b) => a < b ? a : b)
        .toDouble();
    final maxPrice = firstPrice.priceHistory
        .map((p) => p.price)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: (maxPrice - minPrice) / 4,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.green[200] ?? Colors.green,
            strokeWidth: 0.5,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() % 2 == 0) {
                  return Text('D${value.toInt() + 1}',
                      style: const TextStyle(fontSize: 10));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                '₹${value.toInt()}',
                style: const TextStyle(fontSize: 10),
              ),
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.green[300] ?? Colors.green)),
        minY: minPrice - 100,
        maxY: maxPrice + 100,
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              firstPrice.priceHistory.length,
              (i) => FlSpot(i.toDouble(), firstPrice.priceHistory[i].price),
            ),
            isCurved: true,
            gradient: LinearGradient(
              colors: [Colors.green[400]!, Colors.green[700]!],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 5,
                color: Colors.green[700]!,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  (Colors.green[300] ?? Colors.green).withValues(alpha: 0.3),
                  (Colors.green[100] ?? Colors.greenAccent).withValues(alpha: 0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMandiCard(BuildContext context, dynamic price, int index) {
    final colorSwatches = [
      Colors.green[700] ?? Colors.green,
      Colors.blue[700] ?? Colors.blue,
      Colors.orange[700] ?? Colors.orange,
    ];
    final color = colorSwatches[index % colorSwatches.length];

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price.mandiName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        price.district,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPriceInfo(
                  context,
                  'न्यूनतम',
                  '₹${price.minPrice.toStringAsFixed(0)}',
                  Colors.blue[700] ?? Colors.blue,
                ),
                _buildPriceInfo(
                  context,
                  'अधिकतम',
                  '₹${price.maxPrice.toStringAsFixed(0)}',
                  Colors.red[700] ?? Colors.red,
                ),
                _buildPriceInfo(
                  context,
                  'औसत',
                  '₹${price.modalPrice.toStringAsFixed(0)}',
                  Colors.green[700] ?? Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceInfo(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }

  Widget _buildErrorCard(String message) {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[700]),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.red[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
