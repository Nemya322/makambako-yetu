import 'package:flutter/material.dart';

import '../../core/activity/activity_service.dart';
import '../../core/activity/booking_record.dart';
import '../../core/l10n/app_text.dart';
import '../../core/theme/makambako_theme.dart';
import 'presentation/screens/food_tracking_screen.dart';

/// 4-stage Food Delivery workflow matching the real Makambako experience & Pages 5-7 of the workflow.
enum FoodWorkflowStep {
  /// Browse restaurants, cafes, and food spots across Makambako
  restaurants,

  /// Page 5: Selected Restaurant Menu with Delivery/Pickup, categories, dishes & cart bar
  menu,

  /// Page 6: Checkout screen with Deliver To, order items, payment, promo & total
  checkout,

  /// Page 7: Live order tracking with map, 4-stage stepper, rider card & PIN [5 1 8]
  tracking,
}

class FoodDeliveryPage extends StatefulWidget {
  const FoodDeliveryPage({
    required this.isEnglish,
    this.initialRestaurantId,
    this.onBackToHome,
    super.key,
  });

  final bool isEnglish;
  final String? initialRestaurantId;
  final VoidCallback? onBackToHome;

  @override
  State<FoodDeliveryPage> createState() => _FoodDeliveryPageState();
}

class _FoodDeliveryPageState extends State<FoodDeliveryPage> {
  late FoodWorkflowStep _step;
  int _selectedRestaurantIndex = 0;
  String _restaurantSearchQuery = '';
  int _selectedFeedCategoryIndex = 0;
  bool _hasActiveOrder = false;

  bool _isDelivery = true; // true: Delivery, false: Pickup
  bool _isNow = true; // true: Now 25-35 min, false: Schedule
  int _selectedCategoryIndex = 0;
  String _paymentMethod = 'mobile'; // 'mobile', 'wallet', 'cash'
  final TextEditingController _kitchenNoteController = TextEditingController();
  final TextEditingController _feedSearchController = TextEditingController();

  // Feed filter & sort state
  bool _feedDeliveryMode = true; // true: Delivery, false: Pickup
  bool _filterFast = false; // Under 25 min
  bool _filterTopRated = false; // 4.8+ rating
  bool _filterFreeDelivery = false; // Free / low delivery fee
  bool _filterBudget = false; // Budget meals <= 4000
  String _feedSortBy = 'recommended'; // 'recommended', 'fastest', 'rating'
  final Set<String> _favoriteRestaurants = {'neemas'};
  String _selectedDeliveryLocation = 'Stand Kuu, Makambako';

  // Cart: dishId -> quantity. Pre-seeded with realistic defaults for instant smooth test!
  final Map<String, int> _cart = {
    'neema_1': 1, // Rice with chicken
    'neema_3': 1, // Pilau with beef
  };

  static const List<Map<String, dynamic>> _restaurants = [
    {
      'id': 'neemas',
      'name': "Neema's Kitchen",
      'cuisineSw': 'Vyakula vya Nyumbani · Soko Kuu',
      'cuisineEn': 'Home cooking · Main Market',
      'locationSw': 'Uhuru Street, Stand Kuu',
      'locationEn': 'Uhuru Street, Bus Stand',
      'distance': '0.8 km',
      'rating': 4.8,
      'reviews': 214,
      'deliveryTimeSw': 'dak 20 hadi 30',
      'deliveryTimeEn': '20 to 30 min',
      'deliveryFee': 1500,
      'hoursSw': 'Imefunguliwa · hadi 20:00',
      'hoursEn': 'Open · until 20:00',
      'tagSw': 'Maarufu zaidi',
      'tagEn': 'Most popular',
      'feedCategory': 2, // Rice
      'image': 'assets/images/restaurant_neemas.jpg',
      'categories': [
        {'titleSw': 'Maarufu', 'titleEn': 'Popular'},
        {'titleSw': 'Vyakula vya Wali', 'titleEn': 'Rice dishes'},
        {'titleSw': 'Nyama & Kuku Choma', 'titleEn': 'Grill'},
        {'titleSw': 'Vitafunwa & Mboga', 'titleEn': 'Sides'},
      ],
      'dishes': [
        {
          'id': 'neema_1',
          'titleSw': 'Wali na Kuku Choma',
          'titleEn': 'Rice with grilled chicken',
          'descSw': 'Wali wa kunukia, maharage ya supu na paja la kuku choma pamoja na mboga za majani.',
          'descEn': 'Fragrant rice, stewed beans and grilled chicken thigh with fresh greens.',
          'price': 8000,
          'badgeSw': 'Inayoagizwa zaidi',
          'badgeEn': 'Most ordered',
          'category': 1,
          'icon': Icons.lunch_dining_rounded,
        },
        {
          'id': 'neema_2',
          'titleSw': 'Wali, Maharage ya Nazi na Mboga',
          'titleEn': 'Rice, coconut beans & greens',
          'descSw': 'Mlo wetu wa kila siku. Maharage ya nazi, mchicha na wali mweupe uliopikwa vizuri.',
          'descEn': 'Our everyday plate. Coconut stewed beans, sautéed greens and fluffy rice.',
          'price': 4000,
          'badgeSw': null,
          'badgeEn': null,
          'category': 1,
          'icon': Icons.soup_kitchen_rounded,
        },
        {
          'id': 'neema_3',
          'titleSw': 'Pilau ya Nyama ya Ng\'ombe',
          'titleEn': 'Pilau with tender beef',
          'descSw': 'Wali wenye viungo vya asili uliopikwa na vipande laini vya nyama ya ng\'ombe na kachumbari.',
          'descEn': 'Spiced rice slow-cooked with tender beef. Served with fresh tomato salad.',
          'price': 7000,
          'badgeSw': 'Chaguo la Mpishi',
          'badgeEn': "Chef's choice",
          'category': 1,
          'icon': Icons.dinner_dining_rounded,
        },
        {
          'id': 'neema_4',
          'titleSw': 'Samaki Sato wa Kukaanga na Ugali',
          'titleEn': 'Crispy Tilapia with ugali',
          'descSw': 'Sato mzima wa kukaangwa vizuri, ugali moto wa dona na kachumbari safi.',
          'descEn': 'Whole tilapia fried crisp, with hot maize meal and tomato kachumbari.',
          'price': 9500,
          'badgeSw': null,
          'badgeEn': null,
          'category': 2,
          'icon': Icons.set_meal_rounded,
        },
        {
          'id': 'neema_5',
          'titleSw': 'Chapati Laini za Mafuta, vipande 2',
          'titleEn': 'Soft layered chapatis, 2 pcs',
          'descSw': 'Chapati laini za kusukuma za mafuta. Nzuri sana na maharage au supu.',
          'descEn': 'Soft, flaky flatbread. Great with beans or soup.',
          'price': 1000,
          'badgeSw': null,
          'badgeEn': null,
          'category': 3,
          'icon': Icons.breakfast_dining_rounded,
        },
      ],
    },
    {
      'id': 'midland',
      'name': 'Midland Restaurant & Grill',
      'cuisineSw': 'Hoteli & Nyama Choma · Mjimwema',
      'cuisineEn': 'Hotel Dining & BBQ · Mjimwema',
      'locationSw': 'Mjimwema, TANZAM Highway',
      'locationEn': 'Mjimwema, TANZAM Highway',
      'distance': '1.4 km',
      'rating': 4.7,
      'reviews': 189,
      'deliveryTimeSw': 'dak 25 hadi 35',
      'deliveryTimeEn': '25 to 35 min',
      'deliveryFee': 2000,
      'hoursSw': 'Imefunguliwa · Masaa 24',
      'hoursEn': 'Open · 24 Hours',
      'tagSw': 'Hoteli ya Kitalii',
      'tagEn': 'Premium hotel',
      'feedCategory': 1, // BBQ
      'image': 'assets/images/restaurant_midland_grill.jpg',
      'categories': [
        {'titleSw': 'Maarufu', 'titleEn': 'Popular'},
        {'titleSw': 'Nyama & Kuku Choma', 'titleEn': 'Grill & BBQ'},
        {'titleSw': 'Supu & Kiamsha Kinywa', 'titleEn': 'Soups & Breakfast'},
        {'titleSw': 'Vinywaji', 'titleEn': 'Drinks'},
      ],
      'dishes': [
        {
          'id': 'mid_1',
          'titleSw': 'Kuku Choma Nusu na Chips',
          'titleEn': 'Half Grilled Chicken & Chips',
          'descSw': 'Kuku choma nusu aliyeokwa na viungo vitamu, chips kavu na saladi.',
          'descEn': 'Half seasoned grilled chicken, crispy french fries and salad.',
          'price': 12000,
          'badgeSw': 'Maarufu',
          'badgeEn': 'Popular',
          'category': 1,
          'icon': Icons.lunch_dining_rounded,
        },
        {
          'id': 'mid_2',
          'titleSw': 'Mishkaki ya Ng\'ombe, vijiti 5',
          'titleEn': 'Beef Skewers, 5 sticks',
          'descSw': 'Vipande laini vya nyama ya ng\'ombe vilivyotiwa viungo na kuchomwa kwenye makaa.',
          'descEn': 'Tender beef skewers marinated with local spices and grilled over coals.',
          'price': 5000,
          'badgeSw': null,
          'badgeEn': null,
          'category': 1,
          'icon': Icons.kebab_dining_rounded,
        },
        {
          'id': 'mid_3',
          'titleSw': 'Supu ya Kuku wa Kienyeji & Chapati 2',
          'titleEn': 'Free-range Chicken Soup & 2 Chapatis',
          'descSw': 'Supu moto ya kuku wa kienyeji yenye tangawizi na limao pamoja na chapati 2.',
          'descEn': 'Hot free-range chicken broth infused with ginger and lime, served with 2 chapatis.',
          'price': 6500,
          'badgeSw': 'Asubuhi & Jioni',
          'badgeEn': 'Morning & Evening',
          'category': 2,
          'icon': Icons.soup_kitchen_rounded,
        },
        {
          'id': 'mid_4',
          'titleSw': 'Juisi Safi ya Matunda Halisi',
          'titleEn': 'Fresh Mixed Fruit Juice',
          'descSw': 'Juisi safi ya matunda ya msimu bila sukari ya ziada.',
          'descEn': 'Fresh blended seasonal fruits with no added sugar.',
          'price': 3000,
          'badgeSw': null,
          'badgeEn': null,
          'category': 3,
          'icon': Icons.local_drink_rounded,
        },
      ],
    },
    {
      'id': 'mamalishe',
      'name': 'Mama Lishe Kituoni',
      'cuisineSw': 'Vyakula vya Asili na Haraka · Stand Kuu',
      'cuisineEn': 'Local Street Food & Fast Meals · Bus Stand',
      'locationSw': 'Stand Kuu, Makambako',
      'locationEn': 'Main Bus Terminal, Makambako',
      'distance': '0.3 km',
      'rating': 4.6,
      'reviews': 310,
      'deliveryTimeSw': 'dak 15 hadi 25',
      'deliveryTimeEn': '15 to 25 min',
      'deliveryFee': 1000,
      'hoursSw': 'Imefunguliwa · hadi 21:00',
      'hoursEn': 'Open · until 21:00',
      'tagSw': 'Bei Nafuu',
      'tagEn': 'Budget friendly',
      'feedCategory': 3, // Fast Food / Chips
      'image': 'assets/images/restaurant_mama_lishe.jpg',
      'categories': [
        {'titleSw': 'Maarufu', 'titleEn': 'Popular'},
        {'titleSw': 'Chakula cha Mchana', 'titleEn': 'Lunch'},
        {'titleSw': 'Chips & Vitafunwa', 'titleEn': 'Chips & Bites'},
      ],
      'dishes': [
        {
          'id': 'mama_1',
          'titleSw': 'Chips Mayai (Zege) Moto',
          'titleEn': 'Chips Mayai (Fries Omelette)',
          'descSw': 'Chips safi zilizopikwa na mayai mawili ya kisasa, kachumbari na pili pili.',
          'descEn': 'Crispy fries cooked into a 2-egg omelette, served with kachumbari and chilli.',
          'price': 3500,
          'badgeSw': 'Kipenzi cha Mji',
          'badgeEn': 'City favorite',
          'category': 2,
          'icon': Icons.egg_rounded,
        },
        {
          'id': 'mama_2',
          'titleSw': 'Ugali wa Dona na Dagaa wa Kigoma',
          'titleEn': 'Dona Ugali with Kigoma Dagaa',
          'descSw': 'Ugali moto wa dona na dagaa safi wa kukaangwa kwenye mchuzi wa nyanya na mchicha.',
          'descEn': 'Hot wholegrain ugali with fried Lake Tanganyika sardines in tomato sauce and spinach.',
          'price': 4000,
          'badgeSw': null,
          'badgeEn': null,
          'category': 1,
          'icon': Icons.dinner_dining_rounded,
        },
        {
          'id': 'mama_3',
          'titleSw': 'Ndizi Nyama ya Ng\'ombe',
          'titleEn': 'Plantain & Beef Stew',
          'descSw': 'Ndizi za kupika zilizoiva vizuri na mchuzi mzito wa nyama ya ng\'ombe.',
          'descEn': 'Cooked green plantains simmered in rich beef gravy.',
          'price': 5000,
          'badgeSw': null,
          'badgeEn': null,
          'category': 1,
          'icon': Icons.restaurant_rounded,
        },
      ],
    },
    {
      'id': 'tazarabbq',
      'name': 'TAZARA Corner BBQ & Nyama Choma',
      'cuisineSw': 'Nyama Choma, Mbuzi & Kuku · TAZARA',
      'cuisineEn': 'Charcoal BBQ, Goat & Chicken · TAZARA',
      'locationSw': 'TAZARA Station Road',
      'locationEn': 'TAZARA Station Road',
      'distance': '2.1 km',
      'rating': 4.9,
      'reviews': 165,
      'deliveryTimeSw': 'dak 30 hadi 40',
      'deliveryTimeEn': '30 to 40 min',
      'deliveryFee': 2000,
      'hoursSw': 'Imefunguliwa · hadi 23:00',
      'hoursEn': 'Open · until 23:00',
      'tagSw': 'Choma Bora',
      'tagEn': 'Best BBQ',
      'feedCategory': 1, // BBQ
      'image': 'assets/images/restaurant_tazara_bbq.jpg',
      'categories': [
        {'titleSw': 'Maarufu', 'titleEn': 'Popular'},
        {'titleSw': 'Nyama Choma', 'titleEn': 'BBQ Meats'},
        {'titleSw': 'Viongezeo', 'titleEn': 'Sides'},
      ],
      'dishes': [
        {
          'id': 'bbq_1',
          'titleSw': 'Mbuzi Choma (Kilo Moja)',
          'titleEn': 'Grilled Goat Meat (1 Kg)',
          'descSw': 'Nyama ya mbuzi laini iliyochomwa kwenye makaa kwa masaa 2, ndizi 2 na kachumbari.',
          'descEn': 'Tender goat slow-grilled over charcoal for 2 hours, 2 roast plantains and kachumbari.',
          'price': 18000,
          'badgeSw': 'Ya kipekee',
          'badgeEn': 'House Special',
          'category': 1,
          'icon': Icons.kebab_dining_rounded,
        },
        {
          'id': 'bbq_2',
          'titleSw': 'Kuku Choma Mzima',
          'titleEn': 'Full Roast Chicken',
          'descSw': 'Kuku mzima wa kienyeji aliyechomwa na viungo, chips au ugali.',
          'descEn': 'Whole seasoned roast chicken served with chips or ugali.',
          'price': 22000,
          'badgeSw': null,
          'badgeEn': null,
          'category': 1,
          'icon': Icons.lunch_dining_rounded,
        },
      ],
    },
    {
      'id': 'royalbakers',
      'name': 'Royal Bakery & Cafe',
      'cuisineSw': 'Kahawa, Sambusa, Keki & Vitafunwa',
      'cuisineEn': 'Fresh Coffee, Samosas, Pastries & Cafe',
      'locationSw': 'Main Market, Makambako',
      'locationEn': 'Main Market, Makambako',
      'distance': '0.5 km',
      'rating': 4.7,
      'reviews': 94,
      'deliveryTimeSw': 'dak 15 hadi 25',
      'deliveryTimeEn': '15 to 25 min',
      'deliveryFee': 1000,
      'hoursSw': 'Imefunguliwa · hadi 20:00',
      'hoursEn': 'Open · until 20:00',
      'tagSw': 'Kahawa Safi',
      'tagEn': 'Fresh Coffee',
      'feedCategory': 4, // Cafe
      'image': 'assets/images/restaurant_royal_bakery.jpg',
      'categories': [
        {'titleSw': 'Maarufu', 'titleEn': 'Popular'},
        {'titleSw': 'Kahawa & Chai', 'titleEn': 'Coffee & Tea'},
        {'titleSw': 'Vitafunwa & Sambusa', 'titleEn': 'Pastries & Bites'},
      ],
      'dishes': [
        {
          'id': 'royal_1',
          'titleSw': 'Kahawa ya Iringa na Mdalasini',
          'titleEn': 'Iringa Filter Coffee with Cinnamon',
          'descSw': 'Kahawa ya asili ya nyanda za juu kusini iliyochujwa vizuri na mdalasini.',
          'descEn': 'Freshly brewed Southern Highlands coffee infused with cinnamon.',
          'price': 2000,
          'badgeSw': 'Harufu Nzuri',
          'badgeEn': 'Aromatic',
          'category': 1,
          'icon': Icons.coffee_rounded,
        },
        {
          'id': 'royal_2',
          'titleSw': 'Sambusa za Nyama, vipande 3',
          'titleEn': 'Beef Samosas, 3 pieces',
          'descSw': 'Sambusa nyembamba zenye nyama ya ng\'ombe, vitunguu na viungo.',
          'descEn': 'Crisp triangular pastries filled with seasoned minced beef and onions.',
          'price': 2500,
          'badgeSw': 'Zinapendwa',
          'badgeEn': 'Favorite',
          'category': 2,
          'icon': Icons.bakery_dining_rounded,
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialRestaurantId != null) {
      final idx = _restaurants.indexWhere(
        (r) =>
            r['id'] == widget.initialRestaurantId ||
            (r['name'] as String).toLowerCase().contains(widget.initialRestaurantId!.toLowerCase()),
      );
      if (idx != -1) {
        _selectedRestaurantIndex = idx;
        _step = FoodWorkflowStep.menu;
      } else {
        _step = FoodWorkflowStep.restaurants;
      }
    } else {
      _step = FoodWorkflowStep.restaurants;
    }
  }

  @override
  void dispose() {
    _kitchenNoteController.dispose();
    _feedSearchController.dispose();
    super.dispose();
  }

  Map<String, dynamic> get _currentRestaurant => _restaurants[_selectedRestaurantIndex];
  List<Map<String, dynamic>> get _currentDishes =>
      _currentRestaurant['dishes'] as List<Map<String, dynamic>>;
  List<Map<String, dynamic>> get _currentCategories =>
      _currentRestaurant['categories'] as List<Map<String, dynamic>>;

  List<Map<String, dynamic>> get _allDishes {
    final list = <Map<String, dynamic>>[];
    for (final r in _restaurants) {
      list.addAll(r['dishes'] as List<Map<String, dynamic>>);
    }
    return list;
  }

  int get _cartItemCount => _cart.values.fold(0, (sum, count) => sum + count);

  int get _cartSubtotal {
    int sum = 0;
    _cart.forEach((dishId, count) {
      final match = _allDishes.where((d) => d['id'] == dishId);
      if (match.isNotEmpty) {
        sum += (match.first['price'] as int) * count;
      }
    });
    return sum;
  }

  int get _deliveryFee => _isDelivery ? (_currentRestaurant['deliveryFee'] as int? ?? 1500) : 0;
  int get _serviceFee => 500;
  int get _promoDiscount => _isDelivery ? 1500 : 0; // WELCOME3 gives free delivery!
  int get _cartTotal => (_cartSubtotal + _deliveryFee + _serviceFee - _promoDiscount).clamp(0, 9999999);

  void _increment(String dishId) {
    setState(() {
      _cart[dishId] = (_cart[dishId] ?? 0) + 1;
    });
  }

  void _decrement(String dishId) {
    setState(() {
      final count = _cart[dishId] ?? 0;
      if (count <= 1) {
        _cart.remove(dishId);
      } else {
        _cart[dishId] = count - 1;
      }
    });
  }

  void _openRestaurant(int index) {
    setState(() {
      _selectedRestaurantIndex = index;
      _selectedCategoryIndex = 0;
      _step = FoodWorkflowStep.menu;
    });
  }

  void _recordFoodOrder() {
    final restaurant = _restaurants[_selectedRestaurantIndex];
    final orderId = 'MY-${(DateTime.now().millisecondsSinceEpoch % 10000).toString().padLeft(4, '0')}';
    const activityService = ActivityService();
    activityService.recordBooking(
      BookingRecord(
        id: orderId,
        type: 'food',
        title: restaurant['name'] as String,
        subtitle: '$_cartItemCount ${tx(widget.isEnglish, 'vyakula', 'items')} · $_selectedDeliveryLocation',
        amount: _cartTotal,
        status: 'inProgress',
        createdAt: DateTime.now(),
        placeId: (restaurant['id'] as String) == 'neemas' ? 'mko-neemas-kitchen' : null,
        metadata: {
          'restaurantName': restaurant['name'],
          'itemCount': _cartItemCount,
          'cartTotal': _cartTotal,
          'securityPin': '5 1 8',
          'driverName': 'Hassan K.',
          'location': _selectedDeliveryLocation,
        },
      ),
    );
  }

  void _handleBackPress() {
    switch (_step) {
      case FoodWorkflowStep.tracking:
        setState(() => _step = FoodWorkflowStep.restaurants);
        break;
      case FoodWorkflowStep.checkout:
        setState(() => _step = FoodWorkflowStep.menu);
        break;
      case FoodWorkflowStep.menu:
        if (widget.initialRestaurantId != null && Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          setState(() => _step = FoodWorkflowStep.restaurants);
        }
        break;
      case FoodWorkflowStep.restaurants:
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else if (widget.onBackToHome != null) {
          widget.onBackToHome!();
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEn = widget.isEnglish;

    return PopScope(
      canPop: _step == FoodWorkflowStep.restaurants &&
          !Navigator.canPop(context) &&
          widget.onBackToHome == null,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackPress();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          child: switch (_step) {
            FoodWorkflowStep.restaurants => _buildRestaurantsFeed(isEn),
            FoodWorkflowStep.menu => _buildMenuPage(isEn),
            FoodWorkflowStep.checkout => _buildCheckoutPage(isEn),
            FoodWorkflowStep.tracking => _buildTrackingPage(isEn),
          },
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // -------------------------------------------------------------
  // RESTAURANTS FEED: Makambako Food Directory & Delivery Hub
  // -------------------------------------------------------------
  Widget _buildRestaurantsFeed(bool isEn) {
    final query = _restaurantSearchQuery.trim().toLowerCase();
    final filtered = _restaurants.where((r) {
      // 1. Cuisine Category filter
      final matchesCat = _selectedFeedCategoryIndex == 0 ||
          r['feedCategory'] == _selectedFeedCategoryIndex;
      if (!matchesCat) return false;

      // 2. Rating filter (4.8+)
      if (_filterTopRated && (r['rating'] as num) < 4.8) return false;

      // 3. Fast delivery (< 25 min)
      if (_filterFast) {
        final timeStr = (r['deliveryTimeEn'] as String).toLowerCase();
        if (!timeStr.contains('15') && !timeStr.contains('20') && !timeStr.contains('25')) {
          return false;
        }
      }

      // 4. Free/Low delivery fee
      if (_filterFreeDelivery && (r['deliveryFee'] as num) > 1000) return false;

      // 5. Budget filter
      if (_filterBudget) {
        final dishes = r['dishes'] as List<Map<String, dynamic>>;
        final hasBudget = dishes.any((d) => (d['price'] as num) <= 4000);
        if (!hasBudget) return false;
      }

      // 6. Search query
      if (query.isEmpty) return true;
      final name = (r['name'] as String).toLowerCase();
      final cuisine = ((r['cuisineSw'] as String) + (r['cuisineEn'] as String)).toLowerCase();
      final dishes = (r['dishes'] as List<Map<String, dynamic>>)
          .map((d) => (d['titleSw'] as String) + (d['titleEn'] as String))
          .join(' ')
          .toLowerCase();
      return name.contains(query) || cuisine.contains(query) || dishes.contains(query);
    }).toList();

    // Sorting
    if (_feedSortBy == 'fastest') {
      filtered.sort((a, b) => (a['deliveryFee'] as num).compareTo(b['deliveryFee'] as num));
    } else if (_feedSortBy == 'rating') {
      filtered.sort((a, b) => (b['rating'] as num).compareTo(a['rating'] as num));
    }

    final hasActiveFilters = _filterFast ||
        _filterTopRated ||
        _filterFreeDelivery ||
        _filterBudget ||
        _selectedFeedCategoryIndex != 0 ||
        _feedSortBy != 'recommended';

    // Featured signature dishes for the popular shelf
    final featuredDishes = [
      {
        'restaurantIndex': 0,
        'restaurantName': "Neema's Kitchen",
        'dish': _restaurants[0]['dishes'][0],
        'image': 'assets/images/restaurant_neemas.jpg',
      },
      {
        'restaurantIndex': 3,
        'restaurantName': 'TAZARA Corner BBQ',
        'dish': _restaurants[3]['dishes'][0],
        'image': 'assets/images/restaurant_tazara_bbq.jpg',
      },
      {
        'restaurantIndex': 2,
        'restaurantName': 'Mama Lishe',
        'dish': _restaurants[2]['dishes'][0],
        'image': 'assets/images/restaurant_mama_lishe.jpg',
      },
      {
        'restaurantIndex': 4,
        'restaurantName': 'Royal Bakery & Cafe',
        'dish': _restaurants[4]['dishes'][1],
        'image': 'assets/images/restaurant_royal_bakery.jpg',
      },
      {
        'restaurantIndex': 1,
        'restaurantName': 'Midland Grill',
        'dish': _restaurants[1]['dishes'][0],
        'image': 'assets/images/restaurant_midland_grill.jpg',
      },
    ];

    return Scaffold(
      key: const ValueKey('food-feed-page'),
      backgroundColor: const Color(0xFFF8FAF9),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          physics: const BouncingScrollPhysics(),
          children: [
            // Top Bar: Location Switcher + Delivery/Pickup Segmented Control + Cart
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _showLocationBottomSheet(isEn),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_rounded, size: 16, color: MakambakoColors.forest),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              _selectedDeliveryLocation,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: MakambakoColors.muted),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildModeToggleItem(
                        icon: Icons.two_wheeler_rounded,
                        label: tx(isEn, 'Uletaji', 'Delivery'),
                        isSelected: _feedDeliveryMode,
                        onTap: () => setState(() => _feedDeliveryMode = true),
                      ),
                      _buildModeToggleItem(
                        icon: Icons.shopping_bag_outlined,
                        label: tx(isEn, 'Chukua', 'Pickup'),
                        isSelected: !_feedDeliveryMode,
                        onTap: () => setState(() => _feedDeliveryMode = false),
                      ),
                    ],
                  ),
                ),

                if (_cartItemCount > 0) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => setState(() => _step = FoodWorkflowStep.checkout),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: MakambakoColors.forest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shopping_bag_rounded, size: 15, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            '$_cartItemCount',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 14),

            // Live Order Tracker Banner (If active)
            if (_hasActiveOrder) ...[
              InkWell(
                onTap: () => setState(() => _step = FoodWorkflowStep.tracking),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF065F46), Color(0xFF047857)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF065F46).withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.delivery_dining_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF34D399),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    tx(
                                      isEn,
                                      'Oda yako kutoka ${_currentRestaurant['name']} iko njiani',
                                      'Order from ${_currentRestaurant['name']} is on the way',
                                    ),
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tx(
                                isEn,
                                'Hassan K. · Dakika 12 zimebaki · Namba ya PIN: 518',
                                'Hassan K. · Arriving in 12 min · PIN: 518',
                              ),
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Main Header Title
            Text(
              tx(isEn, 'Agiza Chakula Makambako', 'Food Delivery in Makambako'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: MakambakoColors.ink,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              tx(
                isEn,
                'Vyakula vya nyumbani, nyama choma, chips na vitafunwa vya haraka.',
                'Fresh home cooking, sizzling BBQ, fast food, and local coffee.',
              ),
              style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
            ),
            const SizedBox(height: 12),

            // Search Bar with Filter Trigger
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _feedSearchController,
                    onChanged: (val) => setState(() => _restaurantSearchQuery = val),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: tx(
                        isEn,
                        'Tafuta chakula, mgahawa au chips...',
                        'Search dishes, restaurants or snacks...',
                      ),
                      hintStyle: const TextStyle(fontSize: 13, color: MakambakoColors.muted),
                      prefixIcon: const Icon(Icons.search_rounded, color: MakambakoColors.forest, size: 20),
                      suffixIcon: _restaurantSearchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18),
                              onPressed: () {
                                _feedSearchController.clear();
                                setState(() => _restaurantSearchQuery = '');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _showFilterBottomSheet(isEn),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: hasActiveFilters ? MakambakoColors.forest : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: hasActiveFilters ? MakambakoColors.forest : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.tune_rounded,
                          size: 20,
                          color: hasActiveFilters ? Colors.white : MakambakoColors.ink,
                        ),
                        if (hasActiveFilters)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: Colors.amber,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Quick Filter Chips (HCI: Immediate refinement without modal friction)
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildQuickFilterPill(
                    icon: Icons.bolt_rounded,
                    label: tx(isEn, '< 25 min', '< 25 min'),
                    isActive: _filterFast,
                    onTap: () => setState(() => _filterFast = !_filterFast),
                  ),
                  _buildQuickFilterPill(
                    icon: Icons.star_rounded,
                    label: '4.8+',
                    isActive: _filterTopRated,
                    onTap: () => setState(() => _filterTopRated = !_filterTopRated),
                  ),
                  _buildQuickFilterPill(
                    icon: Icons.local_offer_outlined,
                    label: tx(isEn, 'Uletaji Bure', 'Free Delivery'),
                    isActive: _filterFreeDelivery,
                    onTap: () => setState(() => _filterFreeDelivery = !_filterFreeDelivery),
                  ),
                  _buildQuickFilterPill(
                    icon: Icons.payments_outlined,
                    label: tx(isEn, 'Bei Nafuu (≤ 4k)', 'Budget (≤ 4k)'),
                    isActive: _filterBudget,
                    onTap: () => setState(() => _filterBudget = !_filterBudget),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Cuisine Category Filter Chips
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildFeedCategoryChip(0, tx(isEn, 'Zote', 'All'), Icons.restaurant_rounded),
                  _buildFeedCategoryChip(1, tx(isEn, 'Nyama & Choma', 'Grill & BBQ'), Icons.kebab_dining_rounded),
                  _buildFeedCategoryChip(2, tx(isEn, 'Wali & Pilau', 'Rice & Stew'), Icons.dinner_dining_rounded),
                  _buildFeedCategoryChip(3, tx(isEn, 'Chips & Zege', 'Chips & Fast food'), Icons.fastfood_rounded),
                  _buildFeedCategoryChip(4, tx(isEn, 'Kahawa & Cafe', 'Coffee & Cafe'), Icons.coffee_rounded),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Promo Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF831843), Color(0xFFBE185D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF831843).withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tx(isEn, 'OFA MAALUM YA MAKAMBAKO', 'MAKAMBAKO SPECIAL OFFER'),
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tx(isEn, 'Uletewe Bure kwenye Oda 3 za Kwanza!', 'Free Delivery on Your First 3 Orders!'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tx(isEn, 'Tumia namba ya kuponi WELCOME3 unapolipa.', 'Use promo code WELCOME3 at checkout.'),
                          style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.85)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delivery_dining_rounded, color: Colors.white, size: 36),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Popular Dishes Shelf (Dedicated horizontal shelf for dishes)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded, size: 18, color: Color(0xFFDC2626)),
                    const SizedBox(width: 5),
                    Text(
                      tx(isEn, 'Vyakula Vinavyopendwa', 'Popular Dishes in Makambako'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: MakambakoColors.ink),
                    ),
                  ],
                ),
                Text(
                  tx(isEn, 'Agiza Moja kwa Moja', 'Quick Add'),
                  style: const TextStyle(fontSize: 11, color: MakambakoColors.muted, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: featuredDishes.length,
                itemBuilder: (context, idx) {
                  final item = featuredDishes[idx];
                  final dish = item['dish'] as Map<String, dynamic>;
                  final rName = item['restaurantName'] as String;
                  final rIdx = item['restaurantIndex'] as int;
                  final dishId = dish['id'] as String;

                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () => _openRestaurant(rIdx),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    item['image'] as String,
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        rName,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: MakambakoColors.forest,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'TSh ${dish['price']}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                          color: MakambakoColors.ink,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              tx(isEn, dish['titleSw'], dish['titleEn']),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: MakambakoColors.ink,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              height: 28,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _increment(dishId);
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        tx(
                                          isEn,
                                          'Imeongezwa kwenye kikapu: ${dish['titleSw']}',
                                          'Added to cart: ${dish['titleEn']}',
                                        ),
                                      ),
                                      duration: const Duration(seconds: 2),
                                      action: SnackBarAction(
                                        label: tx(isEn, 'Kikapu', 'Cart'),
                                        onPressed: () => setState(() => _step = FoodWorkflowStep.checkout),
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add_shopping_cart_rounded, size: 14),
                                label: Text(
                                  tx(isEn, 'Weka Kikapuni', 'Add to Cart'),
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF1F5F9),
                                  foregroundColor: MakambakoColors.forest,
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 22),

            // Section Header: Restaurant Count, Sort & Clear Filters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      tx(
                        isEn,
                        'Migahawa (${filtered.length})',
                        'Restaurants (${filtered.length})',
                      ),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: MakambakoColors.ink),
                    ),
                    if (hasActiveFilters) ...[
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _filterFast = false;
                            _filterTopRated = false;
                            _filterFreeDelivery = false;
                            _filterBudget = false;
                            _selectedFeedCategoryIndex = 0;
                            _feedSortBy = 'recommended';
                          });
                        },
                        child: Text(
                          tx(isEn, 'Futa Vichujio', 'Reset'),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                PopupMenuButton<String>(
                  onSelected: (val) => setState(() => _feedSortBy = val),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'recommended',
                      child: Text(tx(isEn, 'Inayopendekezwa', 'Recommended')),
                    ),
                    PopupMenuItem(
                      value: 'fastest',
                      child: Text(tx(isEn, 'Haraka Zaidi (Dakika)', 'Fastest Delivery')),
                    ),
                    PopupMenuItem(
                      value: 'rating',
                      child: Text(tx(isEn, 'Alama ya Juu (4.8+)', 'Highest Rated (4.8+)')),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _feedSortBy == 'fastest'
                              ? tx(isEn, 'Haraka Zaidi', 'Fastest')
                              : _feedSortBy == 'rating'
                                  ? tx(isEn, 'Alama ya Juu', 'Top Rated')
                                  : tx(isEn, 'Inayopendekezwa', 'Recommended'),
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: MakambakoColors.ink),
                        ),
                        const SizedBox(width: 3),
                        const Icon(Icons.arrow_drop_down_rounded, size: 18, color: MakambakoColors.muted),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Clean Restaurant Cards List (Decluttered HCI Design)
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.search_off_rounded, size: 48, color: MakambakoColors.muted),
                      const SizedBox(height: 8),
                      Text(
                        tx(isEn, 'Hakuna mgahawa uliolingana na vichujio vyako', 'No restaurants match your filters'),
                        style: const TextStyle(fontWeight: FontWeight.w700, color: MakambakoColors.ink),
                      ),
                      const SizedBox(height: 6),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _filterFast = false;
                            _filterTopRated = false;
                            _filterFreeDelivery = false;
                            _filterBudget = false;
                            _selectedFeedCategoryIndex = 0;
                            _restaurantSearchQuery = '';
                            _feedSearchController.clear();
                          });
                        },
                        child: Text(tx(isEn, 'Onyesha Migahawa Yote', 'Show All Restaurants')),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...filtered.map((restaurant) {
                final originalIndex = _restaurants.indexOf(restaurant);
                return _buildCleanRestaurantCard(restaurant, originalIndex, isEn);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildModeToggleItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? MakambakoColors.forest : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? Colors.white : MakambakoColors.ink,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : MakambakoColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickFilterPill({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: isActive ? MakambakoColors.forest : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isActive ? MakambakoColors.forest : const Color(0xFFCBD5E1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isActive ? Colors.white : MakambakoColors.forest,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                  color: isActive ? Colors.white : MakambakoColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedCategoryChip(int index, String label, IconData icon) {
    final isSelected = _selectedFeedCategoryIndex == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => _selectedFeedCategoryIndex = index),
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : MakambakoColors.muted,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? Colors.white : MakambakoColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCleanRestaurantCard(Map<String, dynamic> restaurant, int originalIndex, bool isEn) {
    final rId = restaurant['id'] as String;
    final isFav = _favoriteRestaurants.contains(rId);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: () => _openRestaurant(originalIndex),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Photo with Overlays
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: Image.asset(
                        restaurant['image'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: const Color(0xFF0F766E),
                          child: const Center(
                            child: Icon(Icons.restaurant_rounded, size: 48, color: Colors.white38),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Tag Badge (Top Left)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        tx(isEn, restaurant['tagSw'], restaurant['tagEn']),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),

                  // Heart Favorite Toggle (Top Right)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (isFav) {
                            _favoriteRestaurants.remove(rId);
                          } else {
                            _favoriteRestaurants.add(rId);
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 4),
                          ],
                        ),
                        child: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 18,
                          color: isFav ? const Color(0xFFE11D48) : MakambakoColors.ink,
                        ),
                      ),
                    ),
                  ),

                  // ETA Pill (Bottom Right of Image)
                  Positioned(
                    bottom: 10,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 4),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time_rounded, size: 12, color: MakambakoColors.ink),
                          const SizedBox(width: 4),
                          Text(
                            tx(isEn, restaurant['deliveryTimeSw'], restaurant['deliveryTimeEn']),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: MakambakoColors.ink),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Glanceable Attributes Body
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Restaurant Name + Rating Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            restaurant['name'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: MakambakoColors.ink,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded, size: 14, color: Color(0xFFD97706)),
                              const SizedBox(width: 3),
                              Text(
                                '${restaurant['rating']}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                              Text(
                                ' (${restaurant['reviews']})',
                                style: const TextStyle(fontSize: 10, color: Color(0xFFB45309)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Row 2: Cuisine and Location / Distance
                    Text(
                      '${tx(isEn, restaurant['cuisineSw'], restaurant['cuisineEn'])} · ${restaurant['distance']}',
                      style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Row 3: Service / Delivery Fee and Hours
                    Row(
                      children: [
                        if (_feedDeliveryMode) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.two_wheeler_rounded, size: 12, color: MakambakoColors.forest),
                                const SizedBox(width: 3),
                                Text(
                                  (restaurant['deliveryFee'] as int) <= 1000
                                      ? tx(isEn, 'Uletaji TSh 1,000', 'TSh 1,000 Delivery')
                                      : 'TSh ${restaurant['deliveryFee']} ${tx(isEn, 'uletaji', 'delivery')}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: MakambakoColors.forest,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAF5FF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.shopping_bag_outlined, size: 12, color: Color(0xFF7E22CE)),
                                const SizedBox(width: 3),
                                Text(
                                  tx(isEn, 'Kujichukulia: Bure', 'Pickup: Free'),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF7E22CE),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(width: 8),
                        Text(
                          '·  ${tx(isEn, restaurant['hoursSw'], restaurant['hoursEn'])}',
                          style: const TextStyle(fontSize: 11, color: MakambakoColors.muted, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLocationBottomSheet(bool isEn) {
    final locations = [
      'Stand Kuu, Makambako',
      'Mjimwema, TANZAM Highway',
      'Mwembetogwa, Makambako',
      'TAZARA Station Road',
      'Kitandililo, Makambako',
    ];

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                tx(isEn, 'Chagua Eneo la Kuletewa', 'Select Delivery Location'),
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: MakambakoColors.ink),
              ),
              const SizedBox(height: 6),
              Text(
                tx(isEn, 'Chagua mtaa wako Makambako kupata migahawa ya karibu na muda sahihi wa uletaji.',
                    'Select your neighborhood in Makambako to see nearby spots and accurate delivery ETA.'),
                style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
              ),
              const SizedBox(height: 14),
              ...locations.map((loc) {
                final isCurrent = _selectedDeliveryLocation == loc;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.location_on_rounded,
                    color: isCurrent ? MakambakoColors.forest : MakambakoColors.muted,
                  ),
                  title: Text(
                    loc,
                    style: TextStyle(
                      fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                      color: isCurrent ? MakambakoColors.forest : MakambakoColors.ink,
                      fontSize: 14,
                    ),
                  ),
                  trailing: isCurrent ? const Icon(Icons.check_circle_rounded, color: MakambakoColors.forest) : null,
                  onTap: () {
                    setState(() => _selectedDeliveryLocation = loc);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet(bool isEn) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tx(isEn, 'Vichujio vya Migahawa', 'Restaurant Filters'),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: MakambakoColors.ink),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _filterFast = false;
                              _filterTopRated = false;
                              _filterFreeDelivery = false;
                              _filterBudget = false;
                              _feedSortBy = 'recommended';
                            });
                            setModalState(() {});
                          },
                          child: Text(
                            tx(isEn, 'Futa Zote', 'Reset All'),
                            style: const TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tx(isEn, 'Panga kwa (Sort by)', 'Sort by'),
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: Text(tx(isEn, 'Inayopendekezwa', 'Recommended')),
                          selected: _feedSortBy == 'recommended',
                          onSelected: (val) {
                            setState(() => _feedSortBy = 'recommended');
                            setModalState(() {});
                          },
                        ),
                        ChoiceChip(
                          label: Text(tx(isEn, 'Haraka Zaidi', 'Fastest')),
                          selected: _feedSortBy == 'fastest',
                          onSelected: (val) {
                            setState(() => _feedSortBy = 'fastest');
                            setModalState(() {});
                          },
                        ),
                        ChoiceChip(
                          label: Text(tx(isEn, 'Alama ya Juu', 'Top Rated')),
                          selected: _feedSortBy == 'rating',
                          onSelected: (val) {
                            setState(() => _feedSortBy = 'rating');
                            setModalState(() {});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tx(isEn, 'Vipengele Maalum', 'Special Features'),
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    FilterChip(
                      avatar: Icon(Icons.bolt_rounded, size: 16, color: _filterFast ? Colors.white : MakambakoColors.forest),
                      label: Text(tx(isEn, 'Haraka (Chini ya dakika 25)', 'Fast (Under 25 mins)')),
                      selected: _filterFast,
                      onSelected: (val) {
                        setState(() => _filterFast = val);
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(height: 4),
                    FilterChip(
                      avatar: Icon(Icons.star_rounded, size: 16, color: _filterTopRated ? Colors.white : const Color(0xFFD97706)),
                      label: Text(tx(isEn, 'Alama ya Juu (4.8+ Stars)', 'Top Rated (4.8+ Stars)')),
                      selected: _filterTopRated,
                      onSelected: (val) {
                        setState(() => _filterTopRated = val);
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(height: 4),
                    FilterChip(
                      avatar: Icon(Icons.local_offer_outlined, size: 16, color: _filterFreeDelivery ? Colors.white : MakambakoColors.forest),
                      label: Text(tx(isEn, 'Uletaji Nafuu / Bure', 'Free / Low Delivery')),
                      selected: _filterFreeDelivery,
                      onSelected: (val) {
                        setState(() => _filterFreeDelivery = val);
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(height: 4),
                    FilterChip(
                      avatar: Icon(Icons.payments_outlined, size: 16, color: _filterBudget ? Colors.white : MakambakoColors.forest),
                      label: Text(tx(isEn, 'Vyakula vya Bei Nafuu (≤ 4k)', 'Budget Friendly (≤ 4k)')),
                      selected: _filterBudget,
                      onSelected: (val) {
                        setState(() => _filterBudget = val);
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MakambakoColors.forest,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          tx(isEn, 'Tumia Vichujio', 'Apply Filters'),
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // -------------------------------------------------------------
  // PAGE 5: Restaurant Menu (Customized per selected restaurant)
  // -------------------------------------------------------------
  Widget _buildMenuPage(bool isEn) {
    final restaurant = _currentRestaurant;
    final dishes = _currentDishes;
    final categories = _currentCategories;

    final filteredDishes = _selectedCategoryIndex == 0
        ? dishes
        : dishes.where((d) => d['category'] == _selectedCategoryIndex).toList();

    return Stack(
      children: [
        ListView(
          key: const ValueKey('food-menu-page'),
          padding: const EdgeInsets.only(bottom: 96),
          physics: const BouncingScrollPhysics(),
          children: [
            // Top Hero Image with Back & Favorite Buttons
            Stack(
              children: [
                SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: Image.asset(
                    restaurant['image'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF831843), Color(0xFFC2410C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.restaurant_rounded, size: 64, color: Colors.white24),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.35),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.55),
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_rounded, color: MakambakoColors.ink, size: 20),
                            onPressed: () {
                              if (widget.initialRestaurantId != null && Navigator.canPop(context)) {
                                Navigator.pop(context);
                              } else {
                                setState(() => _step = FoodWorkflowStep.restaurants);
                              }
                            },
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: IconButton(
                            icon: const Icon(Icons.favorite_rounded, color: Color(0xFFDC2626), size: 20),
                            onPressed: () => _showLocationBottomSheet(isEn),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Floating Restaurant Info Card
            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              restaurant['name'] as String,
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                                color: MakambakoColors.ink,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5F0E8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              tx(isEn, restaurant['hoursSw'], restaurant['hoursEn']),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: MakambakoColors.forest,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${tx(isEn, restaurant['cuisineSw'], restaurant['cuisineEn'])} · ${restaurant['distance']}',
                        style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                      ),
                      const SizedBox(height: 12),

                      // Metrics: ★ 4.8 (214), ⏱ 20 to 30 min, Delivery TSh 1,500
                      Row(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 17, color: Color(0xFFD97706)),
                              const SizedBox(width: 3),
                              Text(
                                '${restaurant['rating']} (${restaurant['reviews']})',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 16, color: MakambakoColors.muted),
                              const SizedBox(width: 4),
                              Text(
                                tx(isEn, restaurant['deliveryTimeSw'], restaurant['deliveryTimeEn']),
                                style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              const Icon(Icons.two_wheeler_rounded, size: 16, color: MakambakoColors.forest),
                              const SizedBox(width: 4),
                              Text(
                                'TSh ${restaurant['deliveryFee']}',
                                style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Delivery / Pickup Segmented Control
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() => _isDelivery = true),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _isDelivery ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: _isDelivery
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.05),
                                              blurRadius: 4,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      tx(isEn, 'Uletewe (Delivery)', 'Delivery'),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: _isDelivery ? FontWeight.w800 : FontWeight.w600,
                                        color: _isDelivery ? MakambakoColors.forest : MakambakoColors.muted,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() => _isDelivery = false),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: !_isDelivery ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: !_isDelivery
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.05),
                                              blurRadius: 4,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      tx(isEn, 'Kujichukulia (Pickup)', 'Pickup'),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: !_isDelivery ? FontWeight.w800 : FontWeight.w600,
                                        color: !_isDelivery ? MakambakoColors.forest : MakambakoColors.muted,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Horizontal Menu Category Tabs
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final cat = categories[idx];
                  final isSelected = _selectedCategoryIndex == idx;
                  return ChoiceChip(
                    selected: isSelected,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => _selectedCategoryIndex = idx),
                    label: Text(tx(isEn, cat['titleSw'], cat['titleEn'])),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : MakambakoColors.ink,
                    ),
                    selectedColor: MakambakoColors.forest,
                    backgroundColor: const Color(0xFFF1F5F9),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),

            // Category Subheading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                tx(isEn, 'Vyakula vya Mgahawa', 'Restaurant Menu'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: MakambakoColors.ink,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Dish List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: filteredDishes.map((dish) {
                  final dishId = dish['id'] as String;
                  final count = _cart[dishId] ?? 0;
                  final price = dish['price'] as int;
                  final badgeSw = dish['badgeSw'] as String?;
                  final badgeEn = dish['badgeEn'] as String?;
                  final badge = (badgeSw != null && badgeEn != null)
                      ? tx(isEn, badgeSw, badgeEn)
                      : '';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE5EDE7)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx(isEn, dish['titleSw'], dish['titleEn']),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: MakambakoColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tx(isEn, dish['descSw'], dish['descEn']),
                                  style: const TextStyle(fontSize: 12, color: MakambakoColors.muted, height: 1.35),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'TSh ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                                ),
                                if (badge.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEF3C7),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      badge,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF92400E),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Dish Icon / Thumbnail & +/- Stepper
                          Column(
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF1DA),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(dish['icon'] as IconData? ?? Icons.restaurant_rounded, color: const Color(0xFFD97706), size: 36),
                              ),
                              const SizedBox(height: 8),
                              if (count == 0)
                                SizedBox(
                                  height: 32,
                                  child: ElevatedButton(
                                    onPressed: () => _increment(dishId),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MakambakoColors.forest,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    child: Text(
                                      tx(isEn, '+ Weka', '+ Add'),
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAF3E9),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                        icon: const Icon(Icons.remove_rounded, size: 16, color: MakambakoColors.forest),
                                        onPressed: () => _decrement(dishId),
                                      ),
                                      Text(
                                        '$count',
                                        style: const TextStyle(fontWeight: FontWeight.w900, color: MakambakoColors.forest, fontSize: 13),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                        icon: const Icon(Icons.add_rounded, size: 16, color: MakambakoColors.forest),
                                        onPressed: () => _increment(dishId),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),

        // Floating Bottom Cart Pill
        if (_cartItemCount > 0)
          Positioned(
            left: 18,
            right: 18,
            bottom: 20,
            child: SizedBox(
              height: 54,
              child: ElevatedButton(
                key: const ValueKey('view-cart-button'),
                onPressed: () => setState(() => _step = FoodWorkflowStep.checkout),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MakambakoColors.forest,
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shadowColor: MakambakoColors.forest.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$_cartItemCount',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      tx(isEn, 'Tazama Kikapu', 'View Cart'),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    Text(
                      'TSh ${_cartSubtotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  // -------------------------------------------------------------
  // PAGE 6: Checkout ("Checkout - Selected Restaurant")
  // -------------------------------------------------------------
  Widget _buildCheckoutPage(bool isEn) {
    final restaurant = _currentRestaurant;

    return Scaffold(
      key: const ValueKey('food-checkout-page'),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: MakambakoColors.ink),
          onPressed: () => setState(() => _step = FoodWorkflowStep.menu),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tx(isEn, 'Malipo na Anwani', 'Checkout'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: MakambakoColors.ink),
            ),
            Text(
              restaurant['name'] as String,
              style: const TextStyle(fontSize: 11, color: MakambakoColors.muted),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 100),
        physics: const BouncingScrollPhysics(),
        children: [
          // DELIVER TO Card with mini-map thumbnail
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE5EDE7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Mini map thumbnail preview
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: const [
                          Icon(Icons.map_rounded, color: Color(0xFF94A3B8), size: 28),
                          Icon(Icons.location_on_rounded, color: MakambakoColors.forest, size: 22),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx(isEn, 'LETWA KWA', 'DELIVER TO'),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: MakambakoColors.muted,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Main Market, Makambako',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: MakambakoColors.ink,
                            ),
                          ),
                          Text(
                            tx(isEn, 'Geti la Mashariki, karibu na duka la bluu', 'East gate, next to the blue kiosk'),
                            style: const TextStyle(fontSize: 11, color: MakambakoColors.muted),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        tx(isEn, 'Badili', 'Edit'),
                        style: const TextStyle(
                          color: MakambakoColors.forest,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 12),

                // Now vs Schedule Toggle
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _isNow = true),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _isNow ? const Color(0xFFEAF3E9) : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              tx(isEn, 'Sasa · dak 20 hadi 35', 'Now · 20 to 35 min'),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: _isNow ? FontWeight.w800 : FontWeight.w600,
                                color: _isNow ? MakambakoColors.forest : MakambakoColors.muted,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _isNow = false),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: !_isNow ? const Color(0xFFEAF3E9) : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              tx(isEn, 'Panga Muda', 'Schedule'),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: !_isNow ? FontWeight.w800 : FontWeight.w600,
                                color: !_isNow ? MakambakoColors.forest : MakambakoColors.muted,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Order Items List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tx(isEn, 'Orodha ya chakula', 'Your order'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
              TextButton(
                onPressed: () => setState(() => _step = FoodWorkflowStep.menu),
                child: Text(
                  tx(isEn, '+ Ongeza vingine', 'Add items'),
                  style: const TextStyle(color: MakambakoColors.forest, fontWeight: FontWeight.w800, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE5EDE7)),
            ),
            child: Column(
              children: [
                ..._cart.entries.map((entry) {
                  final match = _allDishes.where((d) => d['id'] == entry.key);
                  final dish = match.isNotEmpty ? match.first : <String, dynamic>{'titleSw': 'Chakula', 'titleEn': 'Dish', 'price': 0};
                  final price = (dish['price'] as int) * entry.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx(isEn, dish['titleSw'], dish['titleEn']),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                              ),
                              Text(
                                'TSh ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                                style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline_rounded, size: 20, color: MakambakoColors.muted),
                              onPressed: () => _decrement(entry.key),
                            ),
                            Text(
                              '${entry.value}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline_rounded, size: 20, color: MakambakoColors.forest),
                              onPressed: () => _increment(entry.key),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(height: 18),
                TextField(
                  controller: _kitchenNoteController,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: tx(isEn, 'Ujumbe jikoni (k.m. bila pilipili)', 'Add a note for the kitchen, like no chilli'),
                    hintStyle: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                    prefixIcon: const Icon(Icons.notes_rounded, size: 18, color: MakambakoColors.muted),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Payment Options
          Text(
            tx(isEn, 'Lipa kwa', 'Pay with'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE5EDE7)),
            ),
            child: Column(
              children: [
                _buildPaymentOption(
                  value: 'mobile',
                  title: 'Mobile money · 07•• ••• 421',
                  subtitle: 'M-Pesa / Tigo Pesa / Airtel Money',
                  icon: Icons.phone_android_rounded,
                ),
                const Divider(height: 1),
                _buildPaymentOption(
                  value: 'wallet',
                  title: 'Wallet',
                  subtitle: tx(isEn, 'Salio TSh 12,400', 'Balance TSh 12,400'),
                  icon: Icons.account_balance_wallet_rounded,
                ),
                const Divider(height: 1),
                _buildPaymentOption(
                  value: 'cash',
                  title: tx(isEn, 'Pesa Taslimu', 'Cash on delivery'),
                  subtitle: tx(isEn, 'Mlipe dereva ukipokea', 'Pay your rider in cash'),
                  icon: Icons.payments_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Promo Code Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_offer_rounded, size: 16, color: Color(0xFFB45309)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tx(isEn, 'WELCOME3 imetumika · Uletewe Bure', 'WELCOME3 applied · Free delivery'),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
                  ),
                ),
                const Icon(Icons.check_circle_rounded, size: 18, color: Color(0xFFB45309)),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Price Calculation Breakdown
          _buildPriceRow(tx(isEn, 'Vyakula', 'Subtotal'), 'TSh ${_cartSubtotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}'),
          const SizedBox(height: 6),
          _buildPriceRow(tx(isEn, 'Uletaji', 'Delivery'), 'TSh ${_deliveryFee.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}'),
          const SizedBox(height: 6),
          _buildPriceRow(tx(isEn, 'Ada ya huduma', 'Service fee'), 'TSh $_serviceFee'),
          const SizedBox(height: 6),
          _buildPriceRow(tx(isEn, 'Punguzo la Promo', 'Promo'), '− TSh $_promoDiscount', isPromo: true),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tx(isEn, 'Jumla ya Malipo', 'Total'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
              Text(
                'TSh ${_cartTotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: MakambakoColors.forest),
              ),
            ],
          ),
        ],
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            key: const ValueKey('place-order-button'),
            onPressed: () {
              _recordFoodOrder();
              setState(() {
                _hasActiveOrder = true;
                _step = FoodWorkflowStep.tracking;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MakambakoColors.forest,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              tx(
                isEn,
                'Thibitisha Oda · TSh ${_cartTotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                'Place Order · TSh ${_cartTotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
              ),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isPromo = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isPromo ? const Color(0xFFB45309) : MakambakoColors.muted,
            fontWeight: isPromo ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isPromo ? const Color(0xFFB45309) : MakambakoColors.ink,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _paymentMethod == value;
    return InkWell(
      onTap: () => setState(() => _paymentMethod = value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? MakambakoColors.forest : const Color(0xFFCBD5E1),
                  width: 2,
                ),
                color: isSelected ? MakambakoColors.forest : Colors.transparent,
              ),
              child: isSelected
                  ? const Center(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: SizedBox(width: 8, height: 8),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Icon(icon, size: 20, color: isSelected ? MakambakoColors.forest : MakambakoColors.muted),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: MakambakoColors.muted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // PAGE 7: Live Order Tracking (Hassan K. arriving in 12 min)
  // -------------------------------------------------------------
  Widget _buildTrackingPage(bool isEn) {
    final restaurant = _currentRestaurant;

    return FoodTrackingScreen(
      isEnglish: isEn,
      restaurantName: restaurant['name'] as String,
      cartItemCount: _cartItemCount,
      cartTotal: _cartTotal,
      onBrowseMore: () => setState(() => _step = FoodWorkflowStep.restaurants),
    );
  }
}
