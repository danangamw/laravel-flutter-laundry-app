import 'package:d_button/d_button.dart';
import 'package:d_view/d_view.dart';
import 'package:dilaundry/config/config.dart';
import 'package:dilaundry/datasources/promo_datasource.dart';
import 'package:dilaundry/datasources/shop_datasource.dart';
import 'package:dilaundry/models/models.dart';
import 'package:dilaundry/page/detail_shop_page.dart';
import 'package:dilaundry/page/search_by_city_page.dart';
import 'package:dilaundry/provider/home_provider.dart';
import 'package:dilaundry/widgets/error_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final edtSearch = TextEditingController();

  gotoSearchCity() {
    Nav.push(context, SearchByCityPage(query: edtSearch.text));
  }

  getPromo() {
    PromoDatasource.readLimit().then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setHomePromoStatus(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setHomePromoStatus(ref, 'Error Not Found');
              break;
            case ForbiddenFailure:
              setHomePromoStatus(ref, 'You don\'t have access');
              break;
            case BadRequestFailure:
              setHomePromoStatus(ref, 'Bad Request');
              break;
            case UnauthorizedFailure:
              setHomePromoStatus(ref, 'Unauthorized');
              break;
            default:
              break;
          }
        },
        (result) {
          setHomePromoStatus(ref, 'Success');
          List data = result['data'];
          List<PromoModel> promos =
              data.map((e) => PromoModel.fromJson(e)).toList();
          ref.read(homePromoListProvider.notifier).setData(promos);
        },
      );
    });
  }

  getRecommendation() {
    ShopDatasource.readRecommendationLimit().then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setHomePromoStatus(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setHomePromoStatus(ref, 'Error Not Found');
              break;
            case ForbiddenFailure:
              setHomePromoStatus(ref, 'You don\'t have access');
              break;
            case BadRequestFailure:
              setHomePromoStatus(ref, 'Bad Request');
              break;
            case UnauthorizedFailure:
              setHomePromoStatus(ref, 'Unauthorized');
              break;
            default:
              break;
          }
        },
        (result) {
          setHomePromoStatus(ref, 'Success');
          List data = result['data'];
          List<ShopModel> shops =
              data.map((e) => ShopModel.fromJson(e)).toList();

          ref.read(homeRecommendationListProvider.notifier).setData(shops);
        },
      );
    });
  }

  refresh() {
    getPromo();
    getRecommendation();
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => refresh(),
      child: ListView(
        children: [
          header(),
          categories(),
          DView.height(20),
          promoList(),
          DView.height(20),
          recommendation()
        ],
      ),
    );
  }

  Consumer recommendation() {
    return Consumer(
      builder: (_, wiRef, __) {
        List<ShopModel> list = wiRef.watch(homeRecommendationListProvider);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DView.textTitle('Recommendation', color: Colors.black),
                  DView.textAction(
                    () {},
                    color: AppColors.primary,
                    text: "See All",
                  ),
                ],
              ),
            ),
            if (list.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: ErrorBackground(
                    ratio: 1.2, message: 'No Recommendation yet'),
              ),
            if (list.isNotEmpty)
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    ShopModel item = list[index];

                    return GestureDetector(
                      onTap: () {
                        Nav.push(context, DetailShopPage(shop: item));
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                          index == 0 ? 30 : 10,
                          0,
                          index == list.length - 1 ? 30 : 10,
                          0,
                        ),
                        width: 200,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage(
                                placeholder: const AssetImage(
                                    AppAssets.placeholderlaundry),
                                image: NetworkImage(
                                    '${AppConstants.baseImageUrl}/shop/${item.image}'),
                                fit: BoxFit.cover,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 150,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [Colors.transparent, Colors.black],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 8,
                              bottom: 8,
                              right: 8,
                              child: Column(
                                children: [
                                  Row(
                                    children: ['Regular', 'Express'].map((e) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        margin: const EdgeInsets.only(right: 4),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        child: Text(
                                          e,
                                          style: const TextStyle(
                                            height: 1,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  DView.height(8),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        Text(
                                          item.name,
                                          style: GoogleFonts.ptSans(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        DView.height(4),
                                        Row(
                                          children: [
                                            RatingBar.builder(
                                              initialRating: item.rate,
                                              itemCount: 5,
                                              allowHalfRating: true,
                                              itemPadding:
                                                  const EdgeInsets.all(0),
                                              unratedColor: Colors.grey[300],
                                              itemBuilder: (context, index) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              itemSize: 12,
                                              onRatingUpdate: (value) {},
                                              ignoreGestures: true,
                                            ),
                                            DView.spaceWidth(4),
                                            Text(
                                              '(${item.rate})',
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                        DView.spaceHeight(4),
                                        Text(
                                          item.location,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
          ],
        );
      },
    );
  }

  Consumer promoList() {
    final pageController = PageController();

    return Consumer(
      builder: (_, wiRef, __) {
        List<PromoModel> list = wiRef.watch(homePromoListProvider);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DView.textTitle('Promo', color: Colors.black),
                  DView.textAction(
                    () {},
                    color: AppColors.primary,
                    text: "See All",
                  ),
                ],
              ),
            ),
            if (list.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: ErrorBackground(ratio: 16 / 9, message: 'No Promo'),
              ),
            if (list.isNotEmpty)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    PromoModel item = list[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage(
                                placeholder: const AssetImage(
                                  AppAssets.placeholderlaundry,
                                ),
                                image: NetworkImage(
                                  "${AppConstants.baseImageUrl}/promo/${item.image}",
                                ),
                                fit: BoxFit.cover,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 6,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.shop.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  DView.height(4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${AppFormat.shortPrice(item.newPrice)} /kg",
                                        style: const TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                      DView.width(),
                                      Text(
                                        "${AppFormat.shortPrice(item.oldPrice)} /kg",
                                        style: const TextStyle(
                                          color: Colors.red,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            if (list.isEmpty) DView.height(8),
            if (list.isNotEmpty)
              SmoothPageIndicator(
                controller: pageController,
                count: list.length,
                effect: WormEffect(
                  dotHeight: 4,
                  dotWidth: 12,
                  dotColor: Colors.grey[300]!,
                  activeDotColor: Colors.green,
                ),
              )
          ],
        );
      },
    );
  }

  Consumer categories() {
    return Consumer(
      builder: (_, wiRef, __) {
        String categorySelected = wiRef.watch(homeCategoryProvider);

        return SizedBox(
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AppConstants.homeCategories.length,
            itemBuilder: (context, index) {
              String category = AppConstants.homeCategories[index];
              int categoryLength = AppConstants.homeCategories.length;

              return Padding(
                padding: EdgeInsets.fromLTRB(
                  index == 0 ? 30 : 8,
                  0,
                  index == categoryLength ? 30 : 8,
                  0,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setHomeCategory(ref, category);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: categorySelected == category
                            ? Colors.green
                            : Colors.grey[400]!,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: categorySelected == category
                          ? Colors.green
                          : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      category,
                      style: TextStyle(
                        height: 1,
                        color: categorySelected == category
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Padding header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'We\'re ready',
            style: GoogleFonts.ptSans(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          DView.height(4),
          Text(
            'to clean your clothes',
            style: GoogleFonts.ptSans(
              color: Colors.black54,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          DView.height(20),

          // Find By City
          Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_city,
                    color: Colors.green,
                    size: 20,
                  ),
                  DView.width(4),
                  Text(
                    'Find by city',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.grey[600],
                    ),
                  )
                ],
              ),
              DView.height(8),

              //
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                gotoSearchCity();
                              },
                              icon: const Icon(Icons.search),
                            ),
                            Expanded(
                              child: TextField(
                                controller: edtSearch,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search...',
                                ),
                                onSubmitted: (value) => gotoSearchCity(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DView.spaceWidth(),
                    DButtonElevation(
                      onClick: () {},
                      mainColor: Colors.green,
                      splashColor: Colors.greenAccent,
                      width: 50,
                      radius: 10,
                      child: const Icon(Icons.tune, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}