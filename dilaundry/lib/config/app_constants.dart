import 'package:dilaundry/page/dashboard/view/account_view.dart';
import 'package:dilaundry/page/dashboard/view/home_view.dart';
import 'package:dilaundry/page/dashboard/view/my_laundry_view.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static const appName = 'diLaundry';

  static const _host = 'http://192.168.18.85:8000';

  /// ``` base Url = 'http://192.168.18.85:8000/api' ```
  static const baseUrl = '$_host/api';

  /// ``` base Url Image 'http://192.168.18.85:8000/storage' ```
  static const baseImageUrl = '$_host/storage';

  static const laundryStatusCategory = [
    'All',
    'Pickup',
    'Queue',
    'Process',
    'Washing',
    'Dried',
    'Ironed',
    'Done',
    'Delivery'
  ];

  static List<Map> navMenuDashboard = [
    {
      'view': const HomeView(),
      'icon': Icons.home_filled,
      'label': 'Home',
    },
    {
      'view': const MyLaundryView(),
      'icon': Icons.local_laundry_service,
      'label': 'My Laundry'
    },
    {
      'view': const AccountView(),
      'icon': Icons.account_circle,
      'label': 'Account'
    },
  ];

  static const homeCategories = [
    'All',
    'Regular',
    'Express',
    'Economical',
    'Exclusive'
  ];
}
