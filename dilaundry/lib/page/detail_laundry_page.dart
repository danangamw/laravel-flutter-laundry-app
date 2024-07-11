import 'package:d_view/d_view.dart';
import 'package:dilaundry/config/config.dart';
import 'package:dilaundry/models/models.dart';
import 'package:flutter/material.dart';

class DetailLaundryPage extends StatelessWidget {
  const DetailLaundryPage({super.key, required this.laundry});
  final LaundryModel laundry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          headerCover(context),
          DView.height(10),
          Center(
            child: Container(
              width: 90,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey,
              ),
            ),
          ),
          DView.height(),
          itemInfo(Icons.sell, AppFormat.longPrice(laundry.total)),
          itemInfo(Icons.event, AppFormat.fullDate(laundry.createdAt)),
          InkWell(
            onTap: () {},
            child: itemInfo(Icons.store, laundry.shop.name),
          ),
          itemInfo(Icons.shopping_basket, '${laundry.weight}kg'),
          if (laundry.withPickup) itemInfo(Icons.shopping_bag, 'Pickup'),
          if (laundry.withPickup) itemDescription(laundry.pickupAddress),
          if (laundry.withDelivery) itemInfo(Icons.local_shipping, 'Delivery'),
          if (laundry.withDelivery) itemDescription(laundry.deliveryAddress),
          itemInfo(Icons.description, 'Description'),
          itemDescription(laundry.description),
        ],
      ),
    );
  }

  Padding headerCover(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                AppAssets.emptyBg,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AspectRatio(
                  aspectRatio: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
                  child: Text(
                    laundry.status,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 40,
                      height: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 36,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID: ${laundry.id}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        height: 1,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    ),
                    FloatingActionButton.small(
                      heroTag: 'fab-back',
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.arrow_back,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget itemInfo(IconData icon, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
          ),
          DView.width(10),
          Text(info),
        ],
      ),
    );
  }

  Widget itemDescription(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          const Icon(Icons.abc, color: Colors.transparent),
          DView.width(10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Divider(
      indent: 30,
      endIndent: 30,
      color: Colors.grey[400],
    );
  }
}
