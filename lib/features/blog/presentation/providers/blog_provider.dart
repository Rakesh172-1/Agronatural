import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vriddhiapps/features/blog/data/models/blog_model.dart';
import 'package:vriddhiapps/features/blog/data/services/blog_service.dart';

/// Provider for BlogService singleton
final blogServiceProvider = Provider((ref) => BlogService());

/// StateNotifier for managing blog posts
class BlogNotifier extends StateNotifier<AsyncValue<List<BlogPost>>> {
  BlogNotifier(this.ref) : super(const AsyncValue.loading());

  final Ref ref;

  /// Fetch all blog posts
  Future<void> fetchAllBlogPosts() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(blogServiceProvider);
      return service.getAllBlogPosts();
    });
  }

  /// Fetch featured blog posts
  Future<void> fetchFeaturedBlogPosts() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(blogServiceProvider);
      return service.getFeaturedBlogPosts();
    });
  }
}

/// StateNotifierProvider for all blog posts
final blogNotifierProvider =
    StateNotifierProvider<BlogNotifier, AsyncValue<List<BlogPost>>>(
  (ref) => BlogNotifier(ref),
);

/// Provider for featured blog posts
final featuredBlogProvider = FutureProvider<List<BlogPost>>((ref) async {
  final service = ref.watch(blogServiceProvider);
  return service.getFeaturedBlogPosts();
});
