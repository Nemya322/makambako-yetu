import 'package:flutter/material.dart';

import '../../core/l10n/app_text.dart';
import '../../core/theme/makambako_theme.dart';
import '../discovery/data/development_fixture_place_repository.dart';
import '../discovery/domain/place.dart';
import '../discovery/presentation/place_detail_page.dart';

/// Makambako Local News, Market Updates & Community Announcements.
class NewsPage extends StatefulWidget {
  const NewsPage({
    required this.isEnglish,
    this.onPlaceSelected,
    super.key,
  });

  final bool isEnglish;
  final ValueChanged<Place>? onPlaceSelected;

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _selectedCategoryIndex = 0;
  final Set<String> _likedArticles = {};

  static const List<Map<String, dynamic>> _newsCategories = [
    {'titleSw': 'Habari Zote', 'titleEn': 'All News'},
    {'titleSw': 'Mnada & Biashara', 'titleEn': 'Markets & Trade'},
    {'titleSw': 'Halmashauri', 'titleEn': 'Town Council'},
    {'titleSw': 'Kilimo & Mazao', 'titleEn': 'Agriculture'},
    {'titleSw': 'Matangazo ya Jamii', 'titleEn': 'Community Notices'},
  ];

  static const List<Map<String, dynamic>> _articles = [
    {
      'id': 'news_1',
      'titleSw': 'Maandalizi ya Mnada Mkubwa wa Makambako Wiki Hii: Wafanyabiashara Wazidi Kufurika',
      'titleEn': 'Makambako Weekly Market Preparations: Traders Arrive Across Southern Highlands',
      'category': 1,
      'timeSw': 'Saa 1 lililopita',
      'timeEn': '1 hour ago',
      'source': 'Makambako Soko Kuu',
      'placeId': 'mko-soko-mwembetogwa',
      'summarySw': 'Soko kuu la Alhamisi na Ijumaa limepokea shehena kubwa ya viazi mviringo, mahindi na mbao kutoka Njombe, Makete na Mbeya.',
      'summaryEn': 'The Thursday & Friday central market has received heavy consignments of round potatoes, maize and timber from Njombe, Makete, and Mbeya.',
      'readTime': '3 min',
      'likes': 142,
      'icon': Icons.storefront_rounded,
    },
    {
      'id': 'news_2',
      'titleSw': 'Ukarabati wa Taa za Barabara Stand Kuu na Mtaa wa Lyamkena Wakamilika',
      'titleEn': 'Street Lights Rehabilitation Completed at Main Bus Terminal & Lyamkena Ward',
      'category': 2,
      'timeSw': 'Masaa 3 yaliyopita',
      'timeEn': '3 hours ago',
      'source': 'Halmashauri ya Mji Makambako',
      'placeId': 'mko-stand-kuu',
      'summarySw': 'Mkurugenzi wa Halmashauri atangaza kuimarishwa kwa usalama wa wafanyabiashara wa usiku kwa kuwasha taa mpya za sola mitaa 6.',
      'summaryEn': 'Town Council Director announces improved night commerce safety with solar street illumination across 6 key neighborhood corridors.',
      'readTime': '2 min',
      'likes': 89,
      'icon': Icons.lightbulb_rounded,
    },
    {
      'id': 'news_3',
      'titleSw': 'Bei Elekezi ya Parachichi na Viazi Mkoani Njombe Yafikia Kiwango Cha Juu Msimu Huu',
      'titleEn': 'Avocado & Potato Farm-Gate Prices Hit Season High in Njombe Region',
      'category': 3,
      'timeSw': 'Jana',
      'timeEn': 'Yesterday',
      'source': 'Umoja wa Wakulima Makambako',
      'summarySw': 'Wakulima wa Makambako na vitongoji vyake wameanza kuvuna parachichi za kisasa huku soko la nje likiweka bei nzuri ya kilo moja.',
      'summaryEn': 'Commercial smallholders in Makambako begin Hass avocado harvesting with strong export benchmark prices benefiting local farmers.',
      'readTime': '4 min',
      'likes': 210,
      'icon': Icons.agriculture_rounded,
    },
    {
      'id': 'news_4',
      'titleSw': 'Tangazo la Chanjo ya Watoto na Vipimo vya Afya Bila Malipo Hospitali ya Joseph',
      'titleEn': 'Free Child Vaccination & Health Screenings at Joseph Referral Hospital',
      'category': 4,
      'timeSw': 'Siku 2 zilizopita',
      'timeEn': '2 days ago',
      'source': 'Hospitali ya Joseph Lyamkena',
      'placeId': 'mko-hospital-st-joseph',
      'summarySw': 'Wazazi wote wanahimizwa kuwapeleka watoto chini ya miaka mitano kwa ajili ya chanjo na upimaji wa afya unaoendelea wiki nzima.',
      'summaryEn': 'Parents across all wards are encouraged to bring children under 5 for comprehensive immunizations and checkups throughout the week.',
      'readTime': '2 min',
      'likes': 67,
      'icon': Icons.local_hospital_rounded,
    },
  ];

  void _openArticleDetail(Map<String, dynamic> article) {
    final placeId = article['placeId'] as String?;
    final place = placeId != null ? DevelopmentFixturePlaceRepository.findPlaceById(placeId) : null;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5F0E8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      article['source'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: MakambakoColors.forest,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    tx(widget.isEnglish, article['timeSw'], article['timeEn']),
                    style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                tx(widget.isEnglish, article['titleSw'], article['titleEn']),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: MakambakoColors.ink,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                tx(widget.isEnglish, article['summarySw'], article['summaryEn']),
                style: const TextStyle(
                  fontSize: 14,
                  color: MakambakoColors.ink,
                  height: 1.6,
                ),
              ),
              if (place != null) ...[
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF3E9),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFCCE0CB)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MakambakoColors.forest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.place_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx(widget.isEnglish, 'Eneo Linalohusika', 'Related Landmark'),
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: MakambakoColors.forest,
                              ),
                            ),
                            Text(
                              place.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: MakambakoColors.ink,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              place.location.area.name,
                              style: const TextStyle(fontSize: 11, color: MakambakoColors.muted),
                            ),
                          ],
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          if (widget.onPlaceSelected != null) {
                            widget.onPlaceSelected!(place);
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) => PlaceDetailPage(
                                  place: place,
                                  isEnglish: widget.isEnglish,
                                ),
                              ),
                            );
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: MakambakoColors.forest,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                        label: Text(
                          tx(widget.isEnglish, 'Tazama', 'View'),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            tx(widget.isEnglish, 'Kiungo cha habari kimenakiliwa.', 'Article link copied.'),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.share_rounded, size: 18),
                    label: Text(tx(widget.isEnglish, 'Shiriki Habari', 'Share')),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: MakambakoColors.forest,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(tx(widget.isEnglish, 'Funga', 'Close')),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEn = widget.isEnglish;
    final filteredArticles = _selectedCategoryIndex == 0
        ? _articles
        : _articles.where((a) => a['category'] == _selectedCategoryIndex).toList();

    return Scaffold(
      backgroundColor: MakambakoColors.page,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
        physics: const BouncingScrollPhysics(),
        children: [
          // Header title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx(isEn, 'Habari za Makambako', 'Makambako News'),
                      style: const TextStyle(
                        color: MakambakoColors.ink,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      tx(
                        isEn,
                        'Matangazo, masoko na taarifa za jamii ya mjini',
                        'Announcements, trade updates & local bulletins',
                      ),
                      style: const TextStyle(color: MakambakoColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD8E4DC)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      tx(isEn, 'Mubashara', 'Live Updates'),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: MakambakoColors.forest,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Categories Filter
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _newsCategories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _newsCategories[index];
                final isSelected = _selectedCategoryIndex == index;
                return InkWell(
                  onTap: () => setState(() => _selectedCategoryIndex = index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? MakambakoColors.forest : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? MakambakoColors.forest : const Color(0xFFDFE8E2),
                      ),
                    ),
                    child: Text(
                      tx(isEn, cat['titleSw'], cat['titleEn']),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : MakambakoColors.ink,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Featured News Banner
          InkWell(
            onTap: () => _openArticleDetail(_articles.first),
            borderRadius: BorderRadius.circular(22),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1D2B25), Color(0xFF145C45)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tx(isEn, 'HABARI KUU', 'TOP STORY'),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _articles.first['readTime'] as String,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tx(isEn, _articles.first['titleSw'], _articles.first['titleEn']),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tx(isEn, _articles.first['summarySw'], _articles.first['summaryEn']),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.82),
                      fontSize: 12,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        _articles.first['source'] as String,
                        style: const TextStyle(
                          color: Color(0xFF9AD2B9),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        tx(isEn, 'Soma habari yote →', 'Read full story →'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // News Feed List
          Text(
            tx(isEn, 'Taarifa za Hivi Karibuni', 'Latest Announcements'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: MakambakoColors.ink,
            ),
          ),
          const SizedBox(height: 12),

          ...filteredArticles.skip(_selectedCategoryIndex == 0 ? 1 : 0).map((article) {
            final articleId = article['id'] as String;
            final isLiked = _likedArticles.contains(articleId);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => _openArticleDetail(article),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE5EDE7)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F5F2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              article['icon'] as IconData,
                              size: 18,
                              color: MakambakoColors.forest,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article['source'] as String,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: MakambakoColors.forest,
                                  ),
                                ),
                                Text(
                                  tx(isEn, article['timeSw'], article['timeEn']),
                                  style: const TextStyle(fontSize: 10, color: MakambakoColors.muted),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              size: 18,
                              color: isLiked ? Colors.redAccent : MakambakoColors.muted,
                            ),
                            onPressed: () {
                              setState(() {
                                if (isLiked) {
                                  _likedArticles.remove(articleId);
                                } else {
                                  _likedArticles.add(articleId);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        tx(isEn, article['titleSw'], article['titleEn']),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: MakambakoColors.ink,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        tx(isEn, article['summarySw'], article['summaryEn']),
                        style: const TextStyle(
                          fontSize: 12,
                          color: MakambakoColors.muted,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
