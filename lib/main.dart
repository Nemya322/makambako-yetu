import 'package:flutter/material.dart';

void main() {
  runApp(const MakambakoYetuApp());
}

const _forest = Color(0xFF145C45);
const _green = Color(0xFF237A59);
const _page = Color(0xFFF5F7F2);
const _ink = Color(0xFF1D2B25);
const _muted = Color(0xFF758179);

class MakambakoYetuApp extends StatelessWidget {
  const MakambakoYetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Makambako Yetu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _page,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _green,
          primary: _forest,
          surface: Colors.white,
        ),
        fontFamily: 'Roboto',
      ),
      home: const MakambakoHomePage(),
    );
  }
}

class _CommunityCategory {
  const _CommunityCategory({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String name;
  final String subtitle;
  final IconData icon;
  final Color color;
}

const _categories = [
  _CommunityCategory(
    name: 'Biashara',
    subtitle: 'Maduka na wajasiriamali',
    icon: Icons.storefront_rounded,
    color: Color(0xFFEAF3E9),
  ),
  _CommunityCategory(
    name: 'Huduma',
    subtitle: 'Huduma zilizo karibu',
    icon: Icons.handshake_outlined,
    color: Color(0xFFFFF1DA),
  ),
  _CommunityCategory(
    name: 'Usafiri',
    subtitle: 'Usafiri na safari',
    icon: Icons.directions_bus_rounded,
    color: Color(0xFFE8EFF9),
  ),
  _CommunityCategory(
    name: 'Jamii',
    subtitle: 'Taarifa za jamii',
    icon: Icons.people_alt_outlined,
    color: Color(0xFFF5EAF1),
  ),
];

class MakambakoHomePage extends StatefulWidget {
  const MakambakoHomePage({super.key});

  @override
  State<MakambakoHomePage> createState() => _MakambakoHomePageState();
}

class _MakambakoHomePageState extends State<MakambakoHomePage> {
  int _selectedTab = 0;
  String _search = '';
  String? _selectedCategory;
  final Set<String> _savedCategories = {};

  List<_CommunityCategory> get _visibleCategories {
    return _categories.where((category) {
      final matchesCategory =
          _selectedCategory == null || category.name == _selectedCategory;
      final matchesSearch =
          _search.isEmpty ||
          category.name.toLowerCase().contains(_search.toLowerCase()) ||
          category.subtitle.toLowerCase().contains(_search.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _showCategory(_CommunityCategory category) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _CategoryIcon(category: category, size: 52),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: _savedCategories.contains(category.name)
                      ? 'Ondoa kwenye zilizohifadhiwa'
                      : 'Hifadhi',
                  onPressed: () {
                    setState(() {
                      if (!_savedCategories.add(category.name)) {
                        _savedCategories.remove(category.name);
                      }
                    });
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    _savedCategories.contains(category.name)
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: _forest,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              category.subtitle,
              style: const TextStyle(color: _muted, fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 12),
            const Text(
              'Sehemu hii itakusaidia kugundua taarifa na rasilimali za '
              'Makambako kadri zinavyoongezwa kwenye jukwaa.',
              style: TextStyle(color: _ink, fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  void _selectTab(int index) {
    setState(() {
      _selectedTab = index;
      if (index == 0) {
        _selectedCategory = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onTap: () => _selectTab(3)),
            Expanded(child: _buildCurrentPage()),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: _selectTab,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE5F0E8),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Nyumbani',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Gundua',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border_rounded),
            selectedIcon: Icon(Icons.bookmark_rounded),
            label: 'Zilizohifadhiwa',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Wasifu',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_selectedTab) {
      case 1:
        return _buildExplorePage();
      case 2:
        return _buildSavedPage();
      case 3:
        return _buildProfilePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    final categories = _visibleCategories;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        _WelcomeBanner(onExplore: () => _selectTab(1)),
        const SizedBox(height: 22),
        _SearchField(
          onChanged: (value) => setState(() {
            _search = value.trim();
            _selectedCategory = null;
          }),
        ),
        const SizedBox(height: 25),
        _SectionHeading(
          title: 'Vinjari Makambako',
          action: 'Ona zote',
          onAction: () => _selectTab(1),
        ),
        const SizedBox(height: 13),
        if (categories.isEmpty)
          const _EmptyState(
            icon: Icons.search_off_rounded,
            title: 'Hakuna kilichopatikana',
            message: 'Jaribu neno jingine.',
          )
        else
          GridView.builder(
            itemCount: categories.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.55,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryCard(
                category: category,
                onTap: () {
                  setState(() {
                    _selectedCategory = category.name;
                    _selectedTab = 1;
                  });
                },
              );
            },
          ),
        const SizedBox(height: 22),
        _CommunityCard(onTap: () => _selectTab(1)),
      ],
    );
  }

  Widget _buildExplorePage() {
    final categories = _visibleCategories;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      children: [
        const Text(
          'Gundua',
          style: TextStyle(
            color: _ink,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Biashara, huduma na taarifa za Makambako.',
          style: TextStyle(color: _muted, fontSize: 14),
        ),
        const SizedBox(height: 19),
        _SearchField(
          key: const ValueKey('explore-search'),
          onChanged: (value) => setState(() {
            _search = value.trim();
            _selectedCategory = null;
          }),
        ),
        const SizedBox(height: 17),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FilterChip(
              label: 'Zote',
              selected: _selectedCategory == null,
              onTap: () => setState(() => _selectedCategory = null),
            ),
            ..._categories.map(
              (category) => _FilterChip(
                label: category.name,
                selected: _selectedCategory == category.name,
                onTap: () => setState(
                  () => _selectedCategory = _selectedCategory == category.name
                      ? null
                      : category.name,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (categories.isEmpty)
          const _EmptyState(
            icon: Icons.search_off_rounded,
            title: 'Hakuna kilichopatikana',
            message: 'Jaribu neno jingine au ondoa kichujio.',
          )
        else
          ...categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: _ExploreCategoryTile(
                category: category,
                saved: _savedCategories.contains(category.name),
                onTap: () => _showCategory(category),
                onSave: () => setState(() {
                  if (!_savedCategories.add(category.name)) {
                    _savedCategories.remove(category.name);
                  }
                }),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSavedPage() {
    final saved = _categories
        .where((category) => _savedCategories.contains(category.name))
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      children: [
        const Text(
          'Zilizohifadhiwa',
          style: TextStyle(
            color: _ink,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Vitu ulivyoweka pembeni kwa ajili yako.',
          style: TextStyle(color: _muted, fontSize: 14),
        ),
        const SizedBox(height: 20),
        if (saved.isEmpty)
          const _EmptyState(
            icon: Icons.bookmark_border_rounded,
            title: 'Bado hujahifadhi chochote',
            message: 'Gundua kategoria na uguse alama ya kuhifadhi.',
          )
        else
          ...saved.map(
            (category) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: _ExploreCategoryTile(
                category: category,
                saved: true,
                onTap: () => _showCategory(category),
                onSave: () =>
                    setState(() => _savedCategories.remove(category.name)),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfilePage() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      children: [
        const Text(
          'Wasifu',
          style: TextStyle(
            color: _ink,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: Color(0xFFE5F0E8),
                child: Icon(Icons.person_rounded, color: _forest, size: 34),
              ),
              SizedBox(height: 13),
              Text(
                'Karibu Makambako Yetu',
                style: TextStyle(
                  color: _ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Jukwaa la kuunganisha jamii ya Makambako.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, height: 1.45),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _ProfileOption(
          icon: Icons.info_outline_rounded,
          label: 'Kuhusu Makambako Yetu',
          onTap: () => showAboutDialog(
            context: context,
            applicationName: 'Makambako Yetu',
            applicationVersion: '1.0.0',
            children: const [
              Text('Jukwaa la kugundua biashara, huduma na taarifa za jamii.'),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _forest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.location_city_rounded,
              color: Colors.white,
              size: 23,
            ),
          ),
          const SizedBox(width: 11),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MAKAMBAKO YETU',
                  style: TextStyle(
                    color: _forest,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.05,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Nyumbani ni kwetu',
                  style: TextStyle(color: _muted, fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Wasifu',
            onPressed: onTap,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _forest,
            ),
            icon: const Icon(Icons.person_outline_rounded),
          ),
        ],
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.fromLTRB(21, 22, 21, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_forest, Color(0xFF27805B)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -42,
            top: -58,
            child: Container(
              width: 155,
              height: 155,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            right: 8,
            bottom: -82,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.11),
                  width: 22,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'KARIBU NYUMBANI',
                  style: TextStyle(
                    color: Color(0xFFE8F3C8),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Makambako,\nyetu sote.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  height: 1.08,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Gundua biashara, huduma na taarifa za jamii yako.',
                style: TextStyle(
                  color: Color(0xFFD7E8DD),
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: onExplore,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE7F0D1),
                  foregroundColor: _forest,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Anza kugundua',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 16),
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

class _SearchField extends StatelessWidget {
  const _SearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Tafuta biashara, huduma...',
        hintStyle: const TextStyle(color: _muted, fontSize: 14),
        prefixIcon: const Icon(Icons.search_rounded, color: _green),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE9EDE8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _green, width: 1.4),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    required this.action,
    required this.onAction,
  });

  final String title;
  final String action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: _green,
            visualDensity: VisualDensity.compact,
          ),
          child: Row(
            children: [
              Text(action, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 3),
              const Icon(Icons.arrow_forward_ios_rounded, size: 11),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.category, this.size = 42});

  final _CommunityCategory category;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: category.color,
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: Icon(category.icon, color: _forest, size: size * 0.52),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.onTap});

  final _CommunityCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CategoryIcon(category: category, size: 39),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    category.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: _muted, fontSize: 10.5),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  const _CommunityCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFEAF1E6),
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.diversity_3_rounded,
                  color: _forest,
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nguvu ya jamii yetu',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Sehemu moja ya kuanza kugundua.',
                      style: TextStyle(color: _muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded, color: _forest, size: 19),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      labelStyle: TextStyle(
        color: selected ? Colors.white : _ink,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Colors.white,
      selectedColor: _forest,
      side: BorderSide(color: selected ? _forest : const Color(0xFFE6EAE5)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _ExploreCategoryTile extends StatelessWidget {
  const _ExploreCategoryTile({
    required this.category,
    required this.saved,
    required this.onTap,
    required this.onSave,
  });

  final _CommunityCategory category;
  final bool saved;
  final VoidCallback onTap;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(13, 13, 7, 13),
          child: Row(
            children: [
              _CategoryIcon(category: category, size: 47),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.subtitle,
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: saved ? 'Ondoa kwenye zilizohifadhiwa' : 'Hifadhi',
                onPressed: onSave,
                icon: Icon(
                  saved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: _forest,
                  size: 21,
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: _muted, size: 22),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 18),
      child: Column(
        children: [
          Icon(icon, color: _green, size: 42),
          const SizedBox(height: 13),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _ink,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _muted, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: ListTile(
        leading: Icon(icon, color: _forest),
        title: Text(
          label,
          style: const TextStyle(color: _ink, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: _muted),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
