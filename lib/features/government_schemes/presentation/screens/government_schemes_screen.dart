import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GovernmentSchemesScreen extends ConsumerWidget {
  const GovernmentSchemesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('सरकारी योजनाएं', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            
            // Schemes List
            _buildSchemeCard(
              context,
              'प्रधानमंत्री कृषि सिंचाई योजना',
              'खेत की सिंचाई के लिए सहायता',
              Icons.water_drop,
            ),
            const SizedBox(height: 16),
            
            _buildSchemeCard(
              context,
              'पीएम किसान सम्मान निधि',
              'सभी किसानों को प्रति वर्ष ₹6000',
              Icons.wallet_giftcard,
            ),
            const SizedBox(height: 16),
            
            _buildSchemeCard(
              context,
              'मृदा स्वास्थ्य कार्ड योजना',
              'मिट्टी की जांच और सुधार के लिए',
              Icons.science,
            ),
            const SizedBox(height: 16),
            
            _buildSchemeCard(
              context,
              'कृषि अवसंरचना निधि',
              'कृषि व्यवसाय के लिए कम ब्याज ऋण',
              Icons.business_center,
            ),
            const SizedBox(height: 16),
            
            _buildSchemeCard(
              context,
              'प्रधानमंत्री फसल बीमा योजना',
              'फसल को नुकसान से बचाव',
              Icons.shield,
            ),
            const SizedBox(height: 16),
            
            _buildSchemeCard(
              context,
              'राष्ट्रीय बीज मिशन',
              'उच्च गुणवत्ता के बीज उपलब्ध कराना',
              Icons.grain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchemeCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
