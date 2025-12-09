import 'package:vriddhiapps/features/loan_schemes/data/models/loan_scheme_model.dart';

class LoanSchemesService {
  static final List<LoanScheme> _punjabSchemes = [
    LoanScheme(
      id: 'pnb_1',
      name: 'Kisan Credit Card (KCC)',
      minAmount: '₹1,00,000',
      maxAmount: '₹3,00,000',
      interestRate: 4.0,
      tenure: '5 years',
      eligibility: 'Farmers with agricultural land in Punjab',
      description: 'Credit facility for crop cultivation and farm activities. Renewable annually with flexible repayment.',
      applicationDeadline: '31-Dec-2025',
      subsidy: 'Up to 3% interest subvention for timely payments',
      processingTime: '5-7 business days',
      requiredDocuments: 'Aadhaar, Land documents, Income certificate, Bank statements',
      state: 'Punjab',
    ),
    LoanScheme(
      id: 'pnb_2',
      name: 'Prime Minister Kisan Samman Nidhi (PM-KISAN)',
      minAmount: '₹6,000',
      maxAmount: '₹6,000',
      interestRate: 0.0,
      tenure: 'Annual',
      eligibility: 'All land-holding farmers in India',
      description: 'Direct benefit transfer of ₹6,000 per year in 3 installments. No loan, only grant.',
      applicationDeadline: '15-Jan-2026',
      subsidy: 'Full grant - 100% subsidy',
      processingTime: '30-45 days',
      requiredDocuments: 'Aadhaar, Bank account details, Land record',
      state: 'Punjab',
    ),
    LoanScheme(
      id: 'nabard_1',
      name: 'Dairy Entrepreneurship Development Scheme',
      minAmount: '₹25,000',
      maxAmount: '₹10,00,000',
      interestRate: 6.5,
      tenure: '5-7 years',
      eligibility: 'Farmers interested in dairy farming',
      description: 'Loan for establishing dairy units with 25-40 dairy animals. Includes subsidy component.',
      applicationDeadline: '28-Feb-2026',
      subsidy: '25-40% subsidy depending on category',
      processingTime: '21-30 days',
      requiredDocuments: 'Aadhaar, Project report, Land proof, Bank statements',
      state: 'Punjab',
    ),
    LoanScheme(
      id: 'nabard_2',
      name: 'Horticulture Mission for North East & Himalayan States',
      minAmount: '₹50,000',
      maxAmount: '₹25,00,000',
      interestRate: 5.5,
      tenure: '5-7 years',
      eligibility: 'Farmers in Punjab interested in horticulture',
      description: 'Development of orchards, nurseries, and high-value horticultural crops.',
      applicationDeadline: '31-Mar-2026',
      subsidy: '30-40% capital subsidy',
      processingTime: '15-20 days',
      requiredDocuments: 'Aadhaar, Project feasibility, Land documents, Technical report',
      state: 'Punjab',
    ),
    LoanScheme(
      id: 'sidbi_1',
      name: 'SIDBI Stand-up India Scheme',
      minAmount: '₹10,00,000',
      maxAmount: '₹1,00,00,000',
      interestRate: 7.0,
      tenure: '7 years',
      eligibility: 'SC/ST farmers and women farmers for agricultural enterprise',
      description: 'Fund first-generation agri-entrepreneurs with focus on job creation.',
      applicationDeadline: '30-Jun-2026',
      subsidy: 'No subsidy but concessional rates for SC/ST',
      processingTime: '45-60 days',
      requiredDocuments: 'Aadhaar, Business plan, Caste certificate (if applicable), Bank statements',
      state: 'Punjab',
    ),
    LoanScheme(
      id: 'icar_1',
      name: 'Agricultural Infrastructure Fund',
      minAmount: '₹40,000',
      maxAmount: '₹50,00,000',
      interestRate: 6.0,
      tenure: '10 years',
      eligibility: 'Farmers for agri-infrastructure like storage, processing, marketing',
      description: 'Create or upgrade farm infrastructure: godowns, cold storage, processing units.',
      applicationDeadline: '31-Dec-2025',
      subsidy: 'Up to 3% interest subvention for 3 years',
      processingTime: '20-25 days',
      requiredDocuments: 'Aadhaar, Project cost estimate, Land proof, Bank statements',
      state: 'Punjab',
    ),
    LoanScheme(
      id: 'nia_1',
      name: 'Pradhan Mantri Fasal Bima Yojana (PMFBY)',
      minAmount: 'Premium based',
      maxAmount: 'Premium based',
      interestRate: 0.0,
      tenure: 'Per season',
      eligibility: 'All farmers with notified crops',
      description: 'Crop insurance scheme providing coverage against crop loss due to natural calamities.',
      applicationDeadline: '31-Dec-2025',
      subsidy: '75-90% premium subsidy by government',
      processingTime: '7-14 days',
      requiredDocuments: 'Aadhaar, Crop details, Land record, Sowing certificate',
      state: 'Punjab',
    ),
    LoanScheme(
      id: 'pib_1',
      name: 'Punjab Agricultural Department - Subsidy on Farm Inputs',
      minAmount: '₹5,000',
      maxAmount: '₹50,000',
      interestRate: 0.0,
      tenure: 'One-time',
      eligibility: 'Registered farmers in Punjab',
      description: 'Direct subsidy on improved seeds, fertilizers, and farm equipment purchase.',
      applicationDeadline: '15-Feb-2026',
      subsidy: '40-50% cost of farm inputs',
      processingTime: '10-15 days',
      requiredDocuments: 'Aadhaar, Farmer ID, Purchase receipt, Paddy Procurement Certificate',
      state: 'Punjab',
    ),
    LoanScheme(
      id: 'pib_2',
      name: 'Mechanization of Agricultural Operations Scheme',
      minAmount: '₹2,00,000',
      maxAmount: '₹1,00,00,000',
      interestRate: 5.5,
      tenure: '5 years',
      eligibility: 'Farmers and agricultural entrepreneurs for machinery purchase',
      description: 'Loan for purchasing tractors, combines, threshers, and modern farm equipment.',
      applicationDeadline: '28-Feb-2026',
      subsidy: '30-50% subsidy depending on equipment type',
      processingTime: '25-30 days',
      requiredDocuments: 'Aadhaar, Machine quotation, Land proof, Technical specification',
      state: 'Punjab',
    ),
    LoanScheme(
      id: 'sbi_1',
      name: 'SBI Agri-Business Loan',
      minAmount: '₹50,000',
      maxAmount: '₹5,00,00,000',
      interestRate: 6.5,
      tenure: '3-10 years',
      eligibility: 'Farmers and agri-entrepreneurs in Punjab',
      description: 'Flexible loan for crop production, marketing, and agricultural infrastructure development.',
      applicationDeadline: '30-Jun-2026',
      subsidy: 'Interest subvention available for some categories',
      processingTime: '15-20 days',
      requiredDocuments: 'Aadhaar, Business plan, Land documents, 3 months bank statements',
      state: 'Punjab',
    ),
    LoanScheme(
      id: 'pnb_3',
      name: 'Term Loan for Farm Equipment',
      minAmount: '₹1,00,000',
      maxAmount: '₹50,00,000',
      interestRate: 5.0,
      tenure: '7 years',
      eligibility: 'Farmers for purchasing agricultural machinery and equipment',
      description: 'Medium-term loan specifically for farm mechanization and equipment purchase.',
      applicationDeadline: '31-Mar-2026',
      subsidy: 'Concessional rates for SC/ST farmers',
      processingTime: '10-15 days',
      requiredDocuments: 'Aadhaar, Equipment details, Land proof, Dealer invoice',
      state: 'Punjab',
    ),
  ];

  Future<List<LoanScheme>> getAllSchemes() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return _punjabSchemes;
  }

  Future<List<LoanScheme>> getSchemesByEligibility(String type) async {
    // Filter schemes based on eligibility: 'all', 'women', 'youth', 'sc_st'
    await Future.delayed(const Duration(milliseconds: 500));
    
    return _punjabSchemes.where((scheme) {
      switch (type) {
        case 'women':
          return scheme.name.contains('Women') || scheme.id == 'sidbi_1';
        case 'youth':
          return scheme.name.contains('Youth') || scheme.name.contains('Entrepreneur');
        case 'sc_st':
          return scheme.eligibility.contains('SC/ST') || scheme.id == 'sidbi_1';
        default:
          return true;
      }
    }).toList();
  }

  Future<LoanScheme?> getSchemeById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _punjabSchemes.firstWhere((scheme) => scheme.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<LoanScheme>> getUpcomingDeadlines() async {
    // Sort by deadline and return schemes with deadlines within 60 days
    await Future.delayed(const Duration(milliseconds: 500));
    return _punjabSchemes
        .where((scheme) {
          final now = DateTime.now();
          final deadline = DateTime.parse('2025-12-31'); // Example deadline
          return deadline.difference(now).inDays > 0 && deadline.difference(now).inDays <= 60;
        })
        .toList();
  }

  Future<List<LoanScheme>> getHighestSubsidySchemes() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Return schemes with highest subsidy percentage
    return _punjabSchemes.take(5).toList();
  }
}
