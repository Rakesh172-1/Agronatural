import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vriddhiapps/core/localization/app_localization.dart';
import 'package:vriddhiapps/features/disease_detector/presentation/providers/disease_detector_provider.dart';

class DiseaseDetectorScreen extends ConsumerStatefulWidget {
  const DiseaseDetectorScreen({super.key});

  @override
  ConsumerState<DiseaseDetectorScreen> createState() => _DiseaseDetectorScreenState();
}

class _DiseaseDetectorScreenState extends ConsumerState<DiseaseDetectorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedCrop = 'Wheat';
  final List<String> crops = ['Wheat', 'Rice', 'Cotton', 'Maize', 'Potato', 'Sugarcane', 'Chickpea', 'Mustard', 'Groundnut', 'Soybean'];
  final TextEditingController searchController = TextEditingController();
  final List<String> selectedSymptoms = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      ref.read(diseaseDetectorNotifierProvider.notifier).fetchAllDiseases();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizationAsync = ref.watch(appLocalizationProvider);
    
    return localizationAsync.when(
      data: (localization) => Scaffold(
        appBar: AppBar(
          title: Text(localization.translate('diseaseDetector')),
          bottom: TabBar(controller: _tabController, tabs: [Tab(text: localization.translate('browseTab')), Tab(text: localization.translate('detectDiseaseTab')), Tab(text: localization.translate('searchTab'))]),
        ),
        body: TabBarView(controller: _tabController, children: [_buildBrowseTab(localization), _buildDetectTab(localization), _buildSearchTab(localization)]),
      ),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => const Scaffold(body: Center(child: Text('Error'))),
    );
  }

  Widget _buildBrowseTab(AppLocalization localization) {
    final diseases = ref.watch(diseaseDetectorNotifierProvider);
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedCrop,
            items: crops.map((c) => DropdownMenuItem(value: c, child: Text(localization.translate(c.toLowerCase())))).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => selectedCrop = value);
                ref.read(diseaseDetectorNotifierProvider.notifier).fetchDiseasesByCrop(value);
              }
            },
          ),
        ),
        Expanded(
          child: diseases.when(
            data: (list) => list.isEmpty
                ? Center(child: Text('No diseases found for $selectedCrop'))
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: list.length,
                    itemBuilder: (context, index) => _buildDiseaseCard(list[index], localization),
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }

  Widget _buildDetectTab(AppLocalization localization) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Crop', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButton<String>(
            isExpanded: true,
            value: selectedCrop,
            items: crops.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (value) => setState(() => selectedCrop = value!),
          ),
          const SizedBox(height: 20),
          Text('Select Symptoms', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _getSymptomList().map((symptom) {
              final isSelected = selectedSymptoms.contains(symptom);
              return FilterChip(
                label: Text(symptom),
                selected: isSelected,
                onSelected: (value) {
                  setState(() {
                    if (value) {
                      selectedSymptoms.add(symptom);
                    } else {
                      selectedSymptoms.remove(symptom);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedSymptoms.isNotEmpty ? _detectDisease : null,
              child: const Text('Detect Disease'),
            ),
          ),
          const SizedBox(height: 20),
          _buildDetectionResult(),
        ],
      ),
    );
  }

  Widget _buildSearchTab(AppLocalization localization) {
    final searchResults = ref.watch(diseaseDetectorNotifierProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: localization.translate('searchDiseases'),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => searchController.clear()))
                  : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onChanged: (value) {
              setState(() {});
              if (value.isNotEmpty) {
                ref.read(diseaseDetectorNotifierProvider.notifier).searchDiseases(value);
              } else {
                ref.read(diseaseDetectorNotifierProvider.notifier).fetchAllDiseases();
              }
            },
          ),
        ),
        Expanded(
          child: searchResults.when(
            data: (list) => list.isEmpty
                ? Center(child: Text(searchController.text.isEmpty ? 'All diseases' : 'No results found'))
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: list.length,
                    itemBuilder: (context, index) => _buildDiseaseCard(list[index], localization),
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }

  Widget _buildDiseaseCard(dynamic disease, AppLocalization localization) {
    final severityColor = disease.severity == 'critical'
        ? Colors.red
        : disease.severity == 'high'
            ? Colors.orange
            : Colors.amber;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(localization.translate(disease.diseaseName), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: severityColor[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: severityColor)),
                  child: Text(localization.translate(disease.severity), style: TextStyle(fontSize: 11, color: severityColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('${localization.translate('crop')}: ${localization.translate(disease.cropType.toLowerCase())}', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Text('${localization.translate('cause')}: ${localization.translate(disease.cause)}', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.info_outline, size: 18),
                label: Text(localization.translate('viewDetails')),
                onPressed: () => _showDiseaseDetails(disease, localization),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDiseaseDetails(dynamic disease, AppLocalization localization) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Text(localization.translate(disease.diseaseName), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('${localization.translate('crop')}: ${localization.translate(disease.cropType.toLowerCase())}', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 16),
              _detailSection(localization.translate('symptoms'), disease.symptoms.join('\n• '), prefix: '• '),
              _detailSection(localization.translate('cause'), localization.translate(disease.cause)),
              _detailSection(localization.translate('severity'), localization.translate(disease.severity)),
              _detailSection(localization.translate('treatment'), disease.treatment),
              _detailSection(localization.translate('prevention'), disease.prevention),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () => Navigator.pop(context), child: Text(localization.translate('cancel'))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailSection(String title, String content, {String prefix = ''}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 6),
          Text('$prefix$content', style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5)),
        ],
      ),
    );
  }

  void _detectDisease() async {
    final localizationAsync = ref.read(appLocalizationProvider);
    final result = await ref.read(
      detectDiseaseProvider((crop: selectedCrop, symptoms: selectedSymptoms)).future,
    );

    if (!mounted) return;

    localizationAsync.when(
      data: (localization) {
        if (result != null) {
          _showDiseaseDetails(result, localization);
          setState(() => selectedSymptoms.clear());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No disease detected with these symptoms')),
          );
        }
      },
      loading: () {},
      error: (_, __) {},
    );
  }

  Widget _buildDetectionResult() {
    return Consumer(
      builder: (context, ref, child) {
        final result = ref.watch(
          detectDiseaseProvider((crop: selectedCrop, symptoms: selectedSymptoms)),
        );

        return result.when(
          data: (disease) => disease != null
              ? Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Detection Result', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(value: disease.confidenceScore / 100),
                        const SizedBox(height: 8),
                        Text('Confidence: ${disease.confidenceScore}%', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          loading: () => const SizedBox(),
          error: (err, _) => const SizedBox(),
        );
      },
    );
  }

  List<String> _getSymptomList() {
    return [
      'Leaf spots',
      'Wilting',
      'Yellow leaves',
      'Brown lesions',
      'Powdery coating',
      'Curling leaves',
      'Stunted growth',
      'Rot',
      'Discoloration',
      'Defoliation',
    ];
  }
}
