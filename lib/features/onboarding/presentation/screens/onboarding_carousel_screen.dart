import 'package:flutter/material.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/theme/makambako_theme.dart';
import '../widgets/service_collage.dart';

/// Screen 3-5: The 3-slide Onboarding Carousel matching the design.
/// Covers Makambako Yetu's core features:
/// 1. Food Delivery & Restaurants
/// 2. Fast Rides & Bodaboda / Bajaji
/// 3. Town Directory & Community News
class OnboardingCarouselScreen extends StatefulWidget {
  const OnboardingCarouselScreen({
    required this.isEnglish,
    required this.onComplete,
    this.onBack,
    super.key,
  });

  final bool isEnglish;
  final VoidCallback onComplete;

  /// Leaves the carousel from its first slide (to the previous screen).
  final VoidCallback? onBack;

  @override
  State<OnboardingCarouselScreen> createState() => _OnboardingCarouselScreenState();
}

class _OnboardingCarouselScreenState extends State<OnboardingCarouselScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      widget.onComplete();
    }
  }

  void _onBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      widget.onBack?.call();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = [
      _SlideData(
        titleSwahili: 'Agiza Chakula Kitamu',
        titleEnglish: 'Order Delicious Food',
        descriptionSwahili:
            'Gundua migahawa bora ya Makambako, chips kuku, vyakula vya asili na uletewe haraka popote ulipo mjini.',
        descriptionEnglish:
            'Explore top Makambako restaurants, local Swahili bites, chips kuku, and get doorstep food delivery.',
        illustration: const ServiceOrbit(focus: AppServiceId.food),
      ),
      _SlideData(
        titleSwahili: 'Usafiri wa Haraka na Uhakika',
        titleEnglish: 'Fast & Reliable Rides',
        descriptionSwahili:
            'Wasiliana na madereva wanaoaminika wa bodaboda, bajaji na magari kwa nauli wazi na usafiri salama.',
        descriptionEnglish:
            'Book verified bodaboda, bajaji, and taxi drivers across Makambako with transparent pricing and quick pickups.',
        illustration: const ServiceOrbit(focus: AppServiceId.ride),
      ),
      _SlideData(
        titleSwahili: 'Gundua Mji na Jamii Yetu',
        titleEnglish: 'Explore Places & Community',
        descriptionSwahili:
            'Pata taarifa za hospitali, hoteli, maduka, mitaa yote ya Makambako na matangazo muhimu ya maendeleo ya jamii.',
        descriptionEnglish:
            'Find local shops, clinics, lodging, ward services, and keep up with local announcements and events.',
        illustration: const ServiceOrbit(focus: AppServiceId.explore),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Brand tag & Skip button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (_currentPage > 0 || widget.onBack != null) ...[
                        InkWell(
                          key: const ValueKey('carousel-back'),
                          onTap: _onBack,
                          customBorder: const CircleBorder(),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFE5EDE7)),
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              size: 19,
                              color: MakambakoColors.ink,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1BAC4B),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Makambako Yetu',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: MakambakoColors.forest,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: widget.onComplete,
                    style: TextButton.styleFrom(
                      foregroundColor: MakambakoColors.muted,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                    child: Text(
                      tx(widget.isEnglish, 'Ruka', 'Skip'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // PageView containing illustrations and content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Center(
                    child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Custom Artwork
                        slide.illustration,
                        const SizedBox(height: 20),

                        // Title in Vibrant Green
                        Text(
                          tx(widget.isEnglish, slide.titleSwahili, slide.titleEnglish),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1BAC4B),
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Subtitle
                        Text(
                          tx(
                            widget.isEnglish,
                            slide.descriptionSwahili,
                            slide.descriptionEnglish,
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: MakambakoColors.muted,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Section: Animated Dot Indicator & Pill Button
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
              child: Column(
                children: [
                  // Smooth Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: isActive ? 28 : 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF1BAC4B)
                              : const Color(0xFFE5EDE7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 28),

                  // Pill Action Button (Next or Get Started)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1BAC4B),
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shadowColor: const Color(0xFF1BAC4B).withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        _currentPage == 2
                            ? tx(widget.isEnglish, 'Anza Sasa', 'Get Started')
                            : tx(widget.isEnglish, 'Endelea', 'Next'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
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
    );
  }
}

class _SlideData {
  const _SlideData({
    required this.titleSwahili,
    required this.titleEnglish,
    required this.descriptionSwahili,
    required this.descriptionEnglish,
    required this.illustration,
  });

  final String titleSwahili;
  final String titleEnglish;
  final String descriptionSwahili;
  final String descriptionEnglish;
  final Widget illustration;
}
