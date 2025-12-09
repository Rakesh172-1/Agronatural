import 'package:vriddhiapps/features/blog/data/models/blog_model.dart';

/// Mock blog service that provides blog posts
class BlogService {
  /// Get all blog posts
  Future<List<BlogPost>> getAllBlogPosts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      // English Posts
      BlogPost(
        id: '1',
        title: 'Soil Health: The Foundation of Successful Farming',
        excerpt: 'Healthy soil is the backbone of productive farming. Learn how to maintain and improve your soil quality.',
        content: '''Soil health is fundamental to agricultural success. A healthy soil not only produces higher yields but also requires fewer inputs like fertilizers and pesticides.

Key Points:
1. Soil Testing: Get your soil tested at least once every 2-3 years to understand its composition and nutrient content. This helps you apply the right amount of fertilizer.

2. Organic Matter: Add organic matter like compost and farm manure regularly. This improves soil structure, increases water retention, and promotes beneficial microorganisms.

3. Crop Rotation: Practice crop rotation to break pest cycles and improve soil fertility naturally.

4. Mulching: Use mulch to retain soil moisture, regulate temperature, and reduce weed growth.

5. Avoid Overuse of Chemicals: Excessive use of chemical fertilizers can degrade soil quality. Balance chemical and organic inputs.

A simple soil health management routine can significantly increase your farm productivity and sustainability.''',
        category: 'Soil Management',
        publishedDate: DateTime(2025, 12, 1),
        imageUrl: '🌍',
        author: 'Agricultural Expert',
      ),
      
      BlogPost(
        id: '2',
        title: 'Water Conservation in Farming: Save Every Drop',
        excerpt: 'Smart irrigation techniques can help you save water and increase crop yield simultaneously.',
        content: '''Water is precious and in many regions, it's becoming scarce. Smart water management is crucial for sustainable farming.

Efficient Irrigation Methods:
1. Drip Irrigation: Delivers water directly to plant roots, reducing wastage by 50% compared to flood irrigation.

2. Sprinkler System: Good for large areas, provides uniform water distribution.

3. Mulching: Reduces evaporation and keeps soil moisture levels stable.

4. Rainwater Harvesting: Collect and store rainwater for dry seasons.

5. Irrigation Scheduling: Water early morning or late evening to reduce evaporation. Monitor soil moisture before watering.

6. Canal Management: Clean canals regularly to prevent water loss.

By implementing these water conservation techniques, you can reduce your water bills by 30-40% while maintaining or even improving crop yields.''',
        category: 'Water Management',
        publishedDate: DateTime(2025, 11, 28),
        imageUrl: '💧',
        author: 'Water Resource Specialist',
      ),

      BlogPost(
        id: '3',
        title: 'Organic Farming: Benefits and Getting Started',
        excerpt: 'Transition to organic farming with proven methods and see health and economic benefits.',
        content: '''Organic farming is becoming increasingly popular due to health benefits and premium prices. Here's how to get started.

Steps to Convert to Organic Farming:
1. Certification: Register with a certification body. It typically takes 3 years of organic practices.

2. Soil Preparation: Build soil health with compost, green manure, and crop residues.

3. Natural Pest Control: Use neem oil, botanical pesticides, and beneficial insects instead of chemicals.

4. Composting: Make on-farm compost from agricultural waste.

5. Biodiversity: Grow multiple crops to maintain ecological balance.

Economic Benefits:
- Premium prices for organic products (20-40% higher)
- Reduced input costs over time
- Better soil health ensures long-term sustainability
- Access to premium markets and export opportunities

Start small with a portion of your land and gradually expand organic farming practices as you gain experience.''',
        category: 'Organic Farming',
        publishedDate: DateTime(2025, 11, 25),
        imageUrl: '🌱',
        author: 'Organic Farming Expert',
      ),

      // Hindi Posts
      BlogPost(
        id: '4',
        title: 'मिट्टी परीक्षण: उत्पादनशील खेती की कुंजी',
        excerpt: 'मिट्टी परीक्षण से आप सही मात्रा में खाद का उपयोग कर सकते हैं और पैदावार बढ़ा सकते हैं।',
        content: '''मिट्टी परीक्षण आधुनिक खेती का एक महत्वपूर्ण अंग है। यह आपको यह जानने में मदद करता है कि आपकी मिट्टी में कौन से पोषक तत्व हैं और कौन से की कमी है।

मिट्टी परीक्षण के लाभ:
1. सही खाद की मात्रा: आप केवल आवश्यक खाद का ही उपयोग करते हैं, जिससे लागत कम होती है।

2. बेहतर पैदावार: सही पोषक तत्वों से फसल की गुणवत्ता और मात्रा दोनों में सुधार होता है।

3. पर्यावरण सुरक्षा: अनावश्यक खाद का उपयोग न करने से जल प्रदूषण से बचा जा सकता है।

4. मिट्टी स्वास्थ्य: नियमित परीक्षण से मिट्टी की उर्वरता का ध्यान रखा जा सकता है।

मिट्टी परीक्षण कैसे करें:
- अपने नजदीकी कृषि विज्ञान केंद्र से संपर्क करें
- 2-3 साल में कम से कम एक बार परीक्षण करवाएं
- परीक्षण के बाद सिफारिशें अपलाएं

नियमित मिट्टी परीक्षण आपकी खेती को अधिक लाभदायक बनाता है।''',
        category: 'मिट्टी प्रबंधन',
        publishedDate: DateTime(2025, 11, 20),
        imageUrl: '🪨',
        author: 'मृदा वैज्ञानिक',
      ),

      BlogPost(
        id: '5',
        title: 'सिंचाई की सही तकनीक से पानी और खर्च दोनों बचाएं',
        excerpt: 'ड्रिप सिंचाई और स्प्रिंकलर सिंचाई से पानी की 40% बचत हो सकती है।',
        content: '''पानी कृषि का सबसे महत्वपूर्ण संसाधन है। सही सिंचाई तकनीक से आप पानी और पैसा दोनों बचा सकते हैं।

विभिन्न सिंचाई विधियां:
1. पारंपरिक सिंचाई (बाढ़ विधि): सबसे कम प्रभावी, 40% पानी बर्बाद होता है।

2. ड्रिप सिंचाई: पानी सीधे पौधों की जड़ों तक पहुंचता है। बचत: 50%
   लागत: 50,000-70,000 प्रति एकड़
   ROI: 2-3 साल में

3. स्प्रिंकलर सिंचाई: पूरे खेत में समान पानी वितरण। बचत: 30-40%

4. वर्षा जल संचयन: छत और खेत से पानी इकट्ठा करके सूखे समय में उपयोग करें।

सिंचाई के समय:
- सुबह 4-6 बजे या शाम 4-6 बजे सिंचाई करें
- दोपहर में सिंचाई न करें (अधिक वाष्पीकरण)
- मिट्टी की नमी जांचकर ही सिंचाई करें

सही तकनीक अपनाकर आप 30-40% तक पानी बचा सकते हैं।''',
        category: 'जल प्रबंधन',
        publishedDate: DateTime(2025, 11, 15),
        imageUrl: '💧',
        author: 'सिंचाई विशेषज्ञ',
      ),

      // Punjabi Posts
      BlogPost(
        id: '6',
        title: 'ਜੈਵਿਕ ਖਾਦ ਤਿਆਰ ਕਰਨਾ ਸਿੱਖੋ',
        excerpt: 'ਘਰ ਤੇ ਹੀ ਜੈਵਿਕ ਖਾਦ ਬਣਾ ਕੇ ਖੇਤ ਦੀ ਸਿਹਤ ਬਿਹਤਰ ਬਣਾਓ।',
        content: '''ਜੈਵਿਕ ਖਾਦ ਤੋਂ ਨਾ ਸਿਰਫ ਮਿੱਟੀ ਦੀ ਸਿਹਤ ਠੀਕ ਰਹਿੰਦੀ ਹੈ ਬਲਕਿ ਫਸਲ ਦੀ ਗੁਣਵੱਤਾ ਵੀ ਚੰਗੀ ਹੁੰਦੀ ਹੈ।

ਘਰ ਤੇ ਜੈਵਿਕ ਖਾਦ ਬਣਾਉਣ ਦੀ ਵਿਧੀ:

ਸਮੱਗਰੀ:
- ਗੋਬਰ: 1000 ਕਿ.ਗ੍ਰਾ.
- ਪੰਜਾਬ ਦੇ ਪਤੇ ਅਤੇ ਖਾਲੀ: 500 ਕਿ.ਗ੍ਰਾ.
- ਜਾਨਵਰਾਂ ਦੇ ਚੋਰੇ: 500 ਕਿ.ਗ੍ਰਾ.
- ਮਿਨਰਲ ਮਿਸ਼ਰਣ: 50 ਕਿ.ਗ੍ਰਾ.

ਪ੍ਰਕਿਰਿਆ:
1. ਪਹਿਲਾ ਹਫ਼ਤਾ: ਸਾਰੀ ਸਮੱਗਰੀ ਨੂੰ ਮਿਲਾ ਕੇ ਢੇਰ ਬਣਾਓ।

2. ਕ੍ਰਾਸ-ਮਿਲਿੰਗ: ਹਰ 7 ਦਿਨ ਬਾਅਦ ਢੇਰ ਨੂੰ ਪਲਟਾਓ।

3. 3 ਮਹੀਨੇ: ਪੂਰੀ ਪ੍ਰਕ੍ਰਿਆ 3 ਮਹੀਨੇ ਵਿਚ ਪੂਰੀ ਹੁੰਦੀ ਹੈ।

ਖੂਬੀਆਂ:
- ਸਸਤਾ ਅਤੇ ਪਰਿਵਾਰ ਵਿਚ ਹੀ ਬਣਾਇਆ ਜਾ ਸਕਦਾ ਹੈ
- ਕੋਈ ਕੈਮੀਕਲ ਨਹੀਂ
- ਮਿੱਟੀ ਦਾ PH ਸੰਤੁਲਿਤ ਰਹਿੰਦਾ ਹੈ
- ਮਿੱਟੀ ਵਿਚ ਲਾਭਦਾਇਕ ਬੈਕਟੀਰੀਆ ਵਧਦੇ ਹਨ

ਇਸ ਤਰ੍ਹਾਂ ਤਿਆਰ ਖਾਦ ਵਰਤ ਕੇ ਤੁਸੀਂ ਰਾਸਾਇਣਿਕ ਖਾਦ ਤੇ 50% ਖਰਚ ਘਟਾ ਸਕਦੇ ਹੋ।''',
        category: 'ਖਾਦ ਪ੍ਰਬੰਧਨ',
        publishedDate: DateTime(2025, 11, 10),
        imageUrl: '🥬',
        author: 'ਕਸ਼ਤਕਾਰੀ ਮਾਹਿਰ',
      ),

      BlogPost(
        id: '7',
        title: 'ਫਸਲ ਦੀ ਬਿਮਾਰੀ ਤੋਂ ਬਚਾਓ',
        excerpt: 'ਕੀਟ ਰੋਗ ਤੇ ਕਾਬੂ ਪਾਉਣ ਦੀ ਪ੍ਰਾਚੀਨ ਅਤੇ ਅਧੁਨਿਕ ਵਿਧੀਆਂ।',
        content: '''ਫਸਲ ਦੀ ਚੰਗੀ ਪੈਦਾਵਾਰ ਲਈ ਬਿਮਾਰੀਆਂ ਅਤੇ ਕੀਟਾਂ ਤੋਂ ਬਚਾਅ ਜ਼ਰੂਰੀ ਹੈ।

ਪ੍ਰਾਕ੍ਰਿਤਕ ਢੰਗ:
1. ਨੀਮ ਦੇ ਬਿਜ ਦਾ ਘੋਲ:
   - 5 ਕਿ.ਗ੍ਰਾ. ਪਾਣੀ ਵਿਚ 1 ਕਿ.ਗ੍ਰਾ. ਨੀਮ ਦੇ ਬਿਜ ਮਿਲਾਓ
   - ਛੱਨ ਕੇ ਛਿੜਕਾਓ
   - ਗਾਂ ਦਾ ਮੂਤਰ ਵੀ ਮਿਲਾ ਸਕਦੇ ਹੋ

2. ਛਾਛ ਜਾਂ ਮਠਾ:
   - 20 ਲੀਟਰ ਪਾਣੀ ਵਿਚ 2 ਲੀਟਰ ਛਾਛ ਮਿਲਾਓ
   - ਹਜ਼ਾਰਾਂ ਕੀਟਾਂ ਤੋਂ ਬਚਾਅ

3. ਸੁਤੋਰੀ ਦੀ ਸਫ਼ਾਈ:
   - ਖਰਪਤਵਾਰ ਨੂੰ ਤੁਰੰਤ ਹਟਾ ਦੇਓ
   - ਸਫ਼ਾਈ ਘਟਾਲ ਨੂੰ 50% ਕਮ ਕਰਦੀ ਹੈ

4. ਜੈਵਿਕ ਤੀਵੜ:
   - ਪਲਾਂਟਿੰਗ ਪਾਮ ਦੂਰ ਰਖੋ
   - ਅੰਤਰ ਕਟਾਈ ਕਰੋ

ਰਾਸਾਇਣਿਕ ਦਵਾਈਆਂ ਤੋਂ ਬਚੋ - ਮਿੱਟੀ ਖਰਾਬ ਹੁੰਦੀ ਹੈ!''',
        category: 'ਕੀਟ ਪ੍ਰਬੰਧਨ',
        publishedDate: DateTime(2025, 11, 5),
        imageUrl: '🦗',
        author: 'ਜੈਵਿਕ ਖੇਤੀ ਮਾਹਿਰ',
      ),
    ];
  }

  /// Get featured blog posts
  Future<List<BlogPost>> getFeaturedBlogPosts() async {
    final allPosts = await getAllBlogPosts();
    return allPosts.take(3).toList();
  }

  /// Get blog posts by category
  Future<List<BlogPost>> getBlogPostsByCategory(String category) async {
    final allPosts = await getAllBlogPosts();
    return allPosts.where((post) => post.category == category).toList();
  }
}
