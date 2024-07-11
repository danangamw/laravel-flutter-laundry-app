import 'package:dilaundry/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeCategoryProvider = StateProvider.autoDispose((ref) => 'all');
final homePromoStatusProvider = StateProvider.autoDispose((ref) => '');
final homeRecommendationStatusProvider = StateProvider.autoDispose((ref) => '');

setHomeCategory(WidgetRef ref, String newCategory) {
  ref.read(homeCategoryProvider.notifier).state = newCategory;
}

setHomePromoStatus(WidgetRef ref, String newStatus) {
  ref.read(homePromoStatusProvider.notifier).state = newStatus;
}

setHomeRecommendationStatus(WidgetRef ref, String newStatus) {
  ref.read(homeRecommendationStatusProvider.notifier).state = newStatus;
}

// Promo List Provider
final homePromoListProvider =
    StateNotifierProvider.autoDispose<HomePromoList, List<PromoModel>>(
        (ref) => HomePromoList([]));

class HomePromoList extends StateNotifier<List<PromoModel>> {
  HomePromoList(super._state);

  setData(List<PromoModel> newData) {
    state = newData;
  }
}

// Recommendation List Provider
final homeRecommendationListProvider =
    StateNotifierProvider.autoDispose<HomeRecommendationList, List<ShopModel>>(
        (ref) => HomeRecommendationList([]));

class HomeRecommendationList extends StateNotifier<List<ShopModel>> {
  HomeRecommendationList(super._state);

  setData(List<ShopModel> newData) {
    state = newData;
  }
}
