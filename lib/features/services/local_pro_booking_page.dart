import 'package:flutter/material.dart';

import '../../core/activity/activity_service.dart';
import '../../core/activity/booking_record.dart';
import '../../core/l10n/app_text.dart';
import '../../core/theme/makambako_theme.dart';

/// Local Pro / Repair Service Booking workflow matching Page 10 of the activity workflow.
class LocalProBookingPage extends StatefulWidget {
  const LocalProBookingPage({
    required this.isEnglish,
    this.onBack,
    super.key,
  });

  final bool isEnglish;
  final VoidCallback? onBack;

  @override
  State<LocalProBookingPage> createState() => _LocalProBookingPageState();
}

class _LocalProBookingPageState extends State<LocalProBookingPage> {
  int _selectedCategoryIndex = 0;
  int _selectedJobIndex = 0;
  int _selectedDayIndex = 2; // Mon 26
  String _selectedTimeSlot = '11:00';
  final TextEditingController _problemController = TextEditingController();
  bool _isBooked = false;

  static const List<Map<String, dynamic>> _proCategories = [
    {'titleSw': 'Mabomba (Plumbing)', 'titleEn': 'Plumbing'},
    {'titleSw': 'Umeme (Electrical)', 'titleEn': 'Electrical'},
    {'titleSw': 'Usafi (Cleaning)', 'titleEn': 'Cleaning'},
    {'titleSw': 'Urembo (Hair & beauty)', 'titleEn': 'Hair and beauty'},
  ];

  static const List<Map<String, dynamic>> _jobOptions = [
    {
      'titleSw': 'Kuziba uvujaji wa bomba',
      'titleEn': 'Fix a leak',
      'timeSw': 'Takriban saa 1',
      'timeEn': 'About 1 hour',
      'price': 10000,
    },
    {
      'titleSw': 'Kuweka bomba jipya au bafu',
      'titleEn': 'Install a tap or shower',
      'timeSw': 'Takriban masaa 2',
      'timeEn': 'About 2 hours',
      'price': 15000,
    },
    {
      'titleSw': 'Kuzibua mfereji / sinki lililoziba',
      'titleEn': 'Unblock a drain',
      'timeSw': 'Takriban masaa 1 hadi 2',
      'timeEn': 'About 1 to 2 hours',
      'price': 12000,
    },
  ];

  static const List<Map<String, String>> _days = [
    {'labelSw': 'Leo', 'labelEn': 'Today', 'num': '24'},
    {'labelSw': 'Jpili', 'labelEn': 'Sun', 'num': '25'},
    {'labelSw': 'Jtatu', 'labelEn': 'Mon', 'num': '26'},
    {'labelSw': 'Jnne', 'labelEn': 'Tue', 'num': '27'},
    {'labelSw': 'Jtano', 'labelEn': 'Wed', 'num': '28'},
  ];

  static const List<String> _timeSlots = [
    '08:00',
    '09:00',
    '10:00', // disabled
    '11:00',
    '12:00',
    '14:00',
    '15:00',
    '16:00', // disabled
    '17:00',
  ];

  @override
  void dispose() {
    _problemController.dispose();
    super.dispose();
  }

  int get _jobPrice => _jobOptions[_selectedJobIndex]['price'] as int;

  void _confirmBooking() {
    setState(() => _isBooked = true);
    final selectedJob = _jobOptions[_selectedJobIndex];
    final selectedCat = _proCategories[_selectedCategoryIndex];
    final selectedDay = _days[_selectedDayIndex];
    const activityService = ActivityService();
    activityService.recordBooking(
      BookingRecord(
        id: 'PRO-${(DateTime.now().millisecondsSinceEpoch % 100000).toString().padLeft(5, '0')}',
        type: 'service',
        title: 'Fundi Juma M. · ${widget.isEnglish ? selectedCat['titleEn'] : selectedCat['titleSw']}',
        subtitle: '${widget.isEnglish ? selectedJob['titleEn'] : selectedJob['titleSw']} · ${widget.isEnglish ? selectedDay['labelEn'] : selectedDay['labelSw']} ${selectedDay['num']}, $_selectedTimeSlot',
        amount: _jobPrice,
        status: 'confirmed',
        createdAt: DateTime.now(),
        placeId: 'mko-juma-plumber',
        metadata: {
          'jobTitle': selectedJob['titleSw'],
          'categoryTitle': selectedCat['titleSw'],
          'timeSlot': _selectedTimeSlot,
          'day': '${selectedDay['labelSw']} ${selectedDay['num']}',
          'description': _problemController.text.trim(),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEn = widget.isEnglish;
    final selectedJob = _jobOptions[_selectedJobIndex];

    return PopScope(
      canPop: !_isBooked,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_isBooked) {
          if (widget.onBack != null) {
            widget.onBack!();
          } else {
            Navigator.maybePop(context);
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: MakambakoColors.ink),
            onPressed: () {
              if (widget.onBack != null) {
                widget.onBack!();
              } else {
                Navigator.maybePop(context);
              }
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tx(isEn, 'Agiza Fundi wa Karibu', 'Book a local pro'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: MakambakoColors.ink),
              ),
              Text(
                tx(isEn, 'Mabomba, umeme, ukarabati na usafi', 'Plumbing, repairs, cleaning and more'),
                style: const TextStyle(fontSize: 11, color: MakambakoColors.muted),
              ),
            ],
          ),
        ),
        body: _isBooked ? _buildBookingConfirmation(isEn) : _buildBookingForm(isEn, selectedJob),
        bottomSheet: _isBooked
            ? null
            : Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    key: const ValueKey('confirm-pro-booking-button'),
                    onPressed: _confirmBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF145C45),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                    ),
                    child: Text(
                      tx(
                        isEn,
                        'Thibitisha Agizo la Fundi · TSh ${_jobPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                        'Confirm Booking · TSh ${_jobPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                      ),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildBookingForm(bool isEn, Map<String, dynamic> selectedJob) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
      physics: const BouncingScrollPhysics(),
      children: [
        // Category Pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(_proCategories.length, (index) {
              final cat = _proCategories[index];
              final isSelected = _selectedCategoryIndex == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(tx(isEn, cat['titleSw'], cat['titleEn'])),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedCategoryIndex = index),
                  selectedColor: const Color(0xFF145C45),
                  backgroundColor: const Color(0xFFF1F5F9),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : MakambakoColors.ink,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  showCheckmark: false,
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 18),

        // Pro Profile Card (Juma M. · Plumber)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAF9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5EDE7)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF145C45),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'JM',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx(isEn, 'Juma M. · Fundi Bomba', 'Juma M. · Plumber'),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 16, color: Color(0xFFD97706)),
                            const SizedBox(width: 3),
                            Text(
                              '4.8 · 132 ${tx(isEn, 'kazi', 'jobs')} · km 2.1',
                              style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tx(isEn, 'Hujibu ndani ya dak 5', 'Usually replies in 5 min'),
                          style: const TextStyle(fontSize: 11, color: Color(0xFF1BAC4B), fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(tx(isEn, 'Meseji kwa Fundi Juma M.', 'Chat with Juma M.'))),
                        );
                      },
                      icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                      label: Text(tx(isEn, 'Meseji', 'Chat')),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        foregroundColor: MakambakoColors.ink,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(tx(isEn, 'Inapiga: +255 768 333 444', 'Calling: +255 768 333 444'))),
                        );
                      },
                      icon: const Icon(Icons.call_rounded, size: 16),
                      label: Text(tx(isEn, 'Piga Simu', 'Call')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF145C45),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Section: "What do you need?"
        Text(
          tx(isEn, 'Unahitaji huduma gani?', 'What do you need?'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),

        ...List.generate(_jobOptions.length, (index) {
          final job = _jobOptions[index];
          final isSelected = _selectedJobIndex == index;
          final price = job['price'] as int;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF145C45) : const Color(0xFFE5EDE7),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: InkWell(
                onTap: () => setState(() => _selectedJobIndex = index),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx(isEn, job['titleSw'], job['titleEn']),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              tx(isEn, job['timeSw'], job['timeEn']),
                              style: const TextStyle(fontSize: 12, color: MakambakoColors.muted),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'TSh ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}+',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF145C45)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 20),

        // Section: "Pick a day"
        Text(
          tx(isEn, 'Chagua siku', 'Pick a day'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_days.length, (index) {
            final day = _days[index];
            final isSelected = _selectedDayIndex == index;

            return InkWell(
              onTap: () => setState(() => _selectedDayIndex = index),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 58,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF145C45) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF145C45) : const Color(0xFFE5EDE7),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      tx(isEn, day['labelSw']!, day['labelEn']!),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : MakambakoColors.muted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      day['num']!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: isSelected ? Colors.white : MakambakoColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),

        // Section: "Pick a time"
        Text(
          tx(isEn, 'Chagua muda', 'Pick a time'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _timeSlots.map((slot) {
            final isDisabled = slot == '10:00' || slot == '16:00';
            final isSelected = _selectedTimeSlot == slot && !isDisabled;

            return InkWell(
              onTap: isDisabled ? null : () => setState(() => _selectedTimeSlot = slot),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF145C45)
                      : (isDisabled ? const Color(0xFFF1F5F9) : Colors.white),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF145C45) : const Color(0xFFE5EDE7),
                  ),
                ),
                child: Text(
                  slot,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isSelected
                        ? Colors.white
                        : (isDisabled ? const Color(0xFFCBD5E1) : MakambakoColors.ink),
                    decoration: isDisabled ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Address Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAF9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5EDE7)),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on_rounded, color: MakambakoColors.forest, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Main Market, Makambako',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      tx(isEn, 'Geti la Mashariki, karibu na duka la bluu', 'East gate, next to the blue kiosk'),
                      style: const TextStyle(fontSize: 11, color: MakambakoColors.muted),
                    ),
                  ],
                ),
              ),
              Text(
                tx(isEn, 'Badili', 'Edit'),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: MakambakoColors.forest),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Problem Description
        TextField(
          controller: _problemController,
          decoration: InputDecoration(
            hintText: tx(isEn, 'Eleza tatizo lako kwa ufupi (si lazima)', 'Describe the problem (optional)'),
            hintStyle: const TextStyle(fontSize: 13, color: MakambakoColors.muted),
            filled: true,
            fillColor: const Color(0xFFF8FAF9),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE5EDE7)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE5EDE7)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookingConfirmation(bool isEn) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFF145C45),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 20),
          Text(
            tx(isEn, 'Fundi Amethibitishwa!', 'Booking Confirmed!'),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            tx(
              isEn,
              'Fundi Juma M. atawasili Main Market mnamo Mon 26, saa 11:00 asubuhi.',
              'Juma M. will arrive at Main Market on Mon 26 at 11:00 AM.',
            ),
            style: const TextStyle(fontSize: 14, color: MakambakoColors.muted, height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAF9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5EDE7)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tx(isEn, 'Gharama ya Awali', 'Estimated Cost'), style: const TextStyle(color: MakambakoColors.muted)),
                    Text(
                      'TSh ${_jobPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}+',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF145C45)),
                    ),
                  ],
                ),
                const Divider(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tx(isEn, 'Njia ya Malipo', 'Payment'), style: const TextStyle(color: MakambakoColors.muted)),
                    Text(tx(isEn, 'Mlipe fundi akimaliza kazi', 'Pay pro upon job completion'), style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                if (widget.onBack != null) {
                  widget.onBack!();
                } else {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF145C45),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: Text(
                tx(isEn, 'Rudi Nyumbani', 'Back to Home'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
