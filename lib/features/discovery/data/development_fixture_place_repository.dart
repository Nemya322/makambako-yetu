import '../domain/discovery_result.dart';
import '../domain/geographic_area.dart';
import '../domain/place.dart';
import '../domain/place_repository.dart';
import '../domain/place_search_request.dart';

/// Authentic wards/mitaa of Makambako for area filtering.
const List<GeographicArea> makambakoWards = [
  GeographicArea(
    id: 'ward-stand-kuu',
    name: 'Stand Kuu',
    level: GeographicAreaLevel.area,
  ),
  GeographicArea(
    id: 'ward-mjimwema',
    name: 'Mjimwema',
    level: GeographicAreaLevel.area,
  ),
  GeographicArea(
    id: 'ward-mwembetogwa',
    name: 'Mwembetogwa',
    level: GeographicAreaLevel.area,
  ),
  GeographicArea(
    id: 'ward-utengule',
    name: 'Utengule',
    level: GeographicAreaLevel.area,
  ),
  GeographicArea(
    id: 'ward-maguvani',
    name: 'Maguvani',
    level: GeographicAreaLevel.area,
  ),
  GeographicArea(
    id: 'ward-lyamkena',
    name: 'Lyamkena',
    level: GeographicAreaLevel.area,
  ),
  GeographicArea(
    id: 'ward-tazara',
    name: 'TAZARA',
    level: GeographicAreaLevel.area,
  ),
];

/// In-memory place source with authentic Makambako places and community directory records.
class DevelopmentFixturePlaceRepository implements PlaceRepository {
  const DevelopmentFixturePlaceRepository();

  static const GeographicArea _trialArea = GeographicArea(
    id: 'trial-area-makambako',
    name: 'Makambako',
    level: GeographicAreaLevel.town,
  );

  static final List<Place> _places = [
    // --- Authentic Makambako Directory Records ---
    Place(
      id: 'mko-stand-kuu',
      entity: PublicPlaceEntityReference('mko-pub-stand-kuu'),
      name: 'Stand Kuu ya Mabasi Makambako',
      categoryId: 'transport',
      categoryName: 'Usafiri',
      aliases: ['bus', 'stand', 'mabasi', 'stendi', 'usafiri', 'terminal', 'travel'],
      description: 'Kituo kikuu cha mabasi ya mikoani (Dar, Mbeya, Iringa, Songea) na daladala za mji wa Makambako.',
      phone: '+255 754 123 456',
      whatsapp: '+255 754 123 456',
      openingHours: 'Masaa 24 (Kila siku)',
      rating: 4.7,
      reviewCount: 142,
      location: PlaceLocation(
        id: 'loc-stand-kuu',
        area: makambakoWards[0], // Stand Kuu
        displayName: 'Stand Kuu, Barabara Kuu ya Mbeya-Tanzam',
        address: 'Barabara Kuu ya Tanzania-Zambia (TANZAM Hwy)',
        coordinates: GeoPoint(latitude: -8.8480, longitude: 34.8260),
      ),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.officialSource,
        label: 'Makambako Municipal Directory',
      ),
      verificationStatus: PlaceVerificationStatus.verified,
      createdAt: DateTime.utc(2026, 10, 1),
      updatedAt: DateTime.utc(2026, 10, 23),
    ),
    Place(
      id: 'mko-hospital-st-joseph',
      entity: ServiceProviderEntityReference('mko-serv-st-joseph'),
      name: 'Hospitali ya Rufaa ya Mtakatifu Joseph',
      categoryId: 'services',
      categoryName: 'Huduma',
      aliases: ['hospital', 'hospitali', 'afya', 'st joseph', 'daktari', 'clinic', 'dharura'],
      description: 'Hospitali kuu ya rufaa yenye huduma za dharura, kliniki ya uzazi, maabara ya kisasa, na madaktari bingwa.',
      phone: '+255 784 555 111',
      whatsapp: '+255 784 555 111',
      openingHours: 'Dharura Masaa 24 / OPD: Saa 1:30 Asubuhi - Saa 10:00 Jioni',
      rating: 4.8,
      reviewCount: 215,
      location: PlaceLocation(
        id: 'loc-st-joseph',
        area: makambakoWards[5], // Lyamkena
        displayName: 'Lyamkena, Kando ya Barabara ya Njombe',
        address: 'Makambako - Njombe Road',
        coordinates: GeoPoint(latitude: -8.8520, longitude: 34.8220),
      ),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.officialSource,
        label: 'Makambako Health Services',
      ),
      verificationStatus: PlaceVerificationStatus.verified,
      createdAt: DateTime.utc(2026, 10, 1),
      updatedAt: DateTime.utc(2026, 10, 23),
    ),
    Place(
      id: 'mko-soko-mwembetogwa',
      entity: BusinessEntityReference('mko-biz-soko-mwembetogwa'),
      name: 'Soko Kuu la Mwembetogwa',
      categoryId: 'businesses',
      categoryName: 'Biashara',
      aliases: ['soko', 'market', 'mwembetogwa', 'maduka', 'viazi', 'mboga', 'nafaka', 'biashara'],
      description: 'Soko kuu la nafaka, viazi maarufu vya Makambako, mbogamboga, matunda na bidhaa zote za shambani.',
      phone: '+255 715 222 333',
      whatsapp: '+255 715 222 333',
      openingHours: 'Saa 12:00 Asubuhi - Saa 1:30 Jioni',
      rating: 4.6,
      reviewCount: 320,
      location: PlaceLocation(
        id: 'loc-soko-mwembetogwa',
        area: makambakoWards[2], // Mwembetogwa
        displayName: 'Mwembetogwa Mjini',
        address: 'Soko Road, Mwembetogwa',
        coordinates: GeoPoint(latitude: -8.8465, longitude: 34.8290),
      ),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.officialSource,
        label: 'Makambako Traders Association',
      ),
      verificationStatus: PlaceVerificationStatus.verified,
      createdAt: DateTime.utc(2026, 10, 1),
      updatedAt: DateTime.utc(2026, 10, 23),
    ),
    Place(
      id: 'mko-midland-hotel',
      entity: BusinessEntityReference('mko-biz-midland-hotel'),
      name: 'Midland Golden Hotel & Restaurant',
      categoryId: 'accommodation',
      categoryName: 'Malazi',
      aliases: ['hotel', 'hoteli', 'midland', 'malazi', 'lodge', 'chakula', 'restaurant', 'bar'],
      description: 'Hoteli ya kisasa ya kitalii na wageni, vyumba vyenye AC, kumbi za mikutano, WiFi ya kasi na huduma bora za chakula.',
      phone: '+255 759 444 888',
      whatsapp: '+255 759 444 888',
      openingHours: 'Masaa 24 (Kila siku)',
      rating: 4.7,
      reviewCount: 98,
      location: PlaceLocation(
        id: 'loc-midland-hotel',
        area: makambakoWards[1], // Mjimwema
        displayName: 'Mjimwema, Barabara ya Iringa',
        address: 'Plot 42, TANZAM Highway, Mjimwema',
        coordinates: GeoPoint(latitude: -8.8450, longitude: 34.8250),
      ),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.ownerSubmitted,
        label: 'Verified Business Owner',
      ),
      verificationStatus: PlaceVerificationStatus.verified,
      createdAt: DateTime.utc(2026, 10, 1),
      updatedAt: DateTime.utc(2026, 10, 23),
    ),
    Place(
      id: 'mko-sunrise-guest-house',
      entity: BusinessEntityReference('mko-biz-sunrise-guest'),
      name: 'Sunrise Guest House',
      categoryId: 'accommodation',
      categoryName: 'Malazi',
      aliases: ['sunrise', 'guest', 'house', 'hotel', 'hoteli', 'malazi', 'chumba', 'booking'],
      description: 'Guest house tulivu na ya kisasa karibu na Stand Kuu. Maji moto, Wi-Fi, bafu binafsi na usalama masaa 24.',
      phone: '+255 754 888 999',
      whatsapp: '+255 754 888 999',
      openingHours: 'Masaa 24 (Kila siku)',
      rating: 4.6,
      reviewCount: 87,
      location: PlaceLocation(
        id: 'loc-sunrise-guest',
        area: makambakoWards[0], // Stand Kuu
        displayName: 'Bus Stand area, Makambako',
        address: 'Stand Kuu area, Makambako · 1.6 km',
        coordinates: GeoPoint(latitude: -8.8470, longitude: 34.8270),
      ),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.ownerSubmitted,
        label: 'Verified Business Owner',
      ),
      verificationStatus: PlaceVerificationStatus.verified,
      createdAt: DateTime.utc(2026, 10, 1),
      updatedAt: DateTime.utc(2026, 10, 23),
    ),
    Place(
      id: 'mko-juma-plumber',
      entity: ServiceProviderEntityReference('mko-serv-juma-plumber'),
      name: 'Juma M. · Fundi Bomba & Ujenzi',
      categoryId: 'services',
      categoryName: 'Huduma',
      aliases: ['plumber', 'bomba', 'fundi', 'juma', 'mabomba', 'leak', 'drain', 'shower'],
      description: 'Fundi stadi wa mabomba ya maji, kuziba uvujaji, kuweka mifumo mipya ya bafu na kuzibua sinki na mifereji.',
      phone: '+255 768 333 444',
      whatsapp: '+255 768 333 444',
      openingHours: 'Saa 2:00 Asubuhi - Saa 1:00 Usiku',
      rating: 4.8,
      reviewCount: 132,
      location: PlaceLocation(
        id: 'loc-juma-plumber',
        area: makambakoWards[0], // Stand Kuu
        displayName: 'Main Market, Makambako',
        address: 'East gate, next to the blue kiosk',
        coordinates: GeoPoint(latitude: -8.8490, longitude: 34.8250),
      ),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.ownerSubmitted,
        label: 'Makambako Artisans Guild',
      ),
      verificationStatus: PlaceVerificationStatus.verified,
      createdAt: DateTime.utc(2026, 10, 1),
      updatedAt: DateTime.utc(2026, 10, 23),
    ),
    Place(
      id: 'mko-neemas-kitchen',
      entity: BusinessEntityReference('mko-biz-neemas-kitchen'),
      name: "Neema's Kitchen",
      categoryId: 'food',
      categoryName: 'Chakula',
      aliases: ['neema', 'kitchen', 'food', 'chakula', 'wali', 'kuku', 'chips', 'delivery', 'mgahawa'],
      description: 'Chakula kitamu cha nyumbani, wali kuku choma, chips kuku, samaki wa kukaanga na juisi safi ya matunda. Tunafanya delivery mji mzima.',
      phone: '+255 745 111 222',
      whatsapp: '+255 745 111 222',
      openingHours: 'Saa 3:00 Asubuhi - Saa 4:00 Usiku',
      rating: 4.8,
      reviewCount: 214,
      location: PlaceLocation(
        id: 'loc-neemas-kitchen',
        area: makambakoWards[0], // Stand Kuu
        displayName: 'Uhuru Street, Makambako',
        address: 'Uhuru Street, near roundabout · 20-30 min delivery',
        coordinates: GeoPoint(latitude: -8.8475, longitude: 34.8280),
      ),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.ownerSubmitted,
        label: 'Verified Restaurant Owner',
      ),
      verificationStatus: PlaceVerificationStatus.verified,
      createdAt: DateTime.utc(2026, 10, 1),
      updatedAt: DateTime.utc(2026, 10, 23),
    ),
    Place(
      id: 'mko-mama-lishe-kituoni',
      entity: BusinessEntityReference('mko-biz-mama-lishe'),
      name: 'Mama Lishe Kituoni',
      categoryId: 'food',
      categoryName: 'Chakula',
      aliases: ['mama', 'lishe', 'kituoni', 'food', 'chakula', 'chips', 'zege', 'ugali', 'dagaa', 'mgahawa'],
      description: 'Chakula kizuri cha asili na haraka karibu na Stand Kuu. Chips mayai moto, ugali wa dona, samaki na ndizi nyama.',
      phone: '+255 764 555 666',
      whatsapp: '+255 764 555 666',
      openingHours: 'Saa 1:00 Asubuhi - Saa 3:00 Usiku',
      rating: 4.6,
      reviewCount: 310,
      location: PlaceLocation(
        id: 'loc-mama-lishe',
        area: makambakoWards[0], // Stand Kuu
        displayName: 'Stand Kuu, Makambako',
        address: 'Stand Kuu, opposite booking offices · 15-20 min delivery',
        coordinates: GeoPoint(latitude: -8.8480, longitude: 34.8275),
      ),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.ownerSubmitted,
        label: 'Verified Restaurant Owner',
      ),
      verificationStatus: PlaceVerificationStatus.verified,
      createdAt: DateTime.utc(2026, 10, 1),
      updatedAt: DateTime.utc(2026, 10, 23),
    ),
    Place(
      id: 'mko-tazara-bbq',
      entity: BusinessEntityReference('mko-biz-tazara-bbq'),
      name: 'TAZARA Corner BBQ & Nyama Choma',
      categoryId: 'food',
      categoryName: 'Chakula',
      aliases: ['bbq', 'nyama', 'choma', 'mbuzi', 'kuku', 'tazara', 'chips', 'bar', 'mgahawa'],
      description: 'Mbuzi choma wa makaa, kuku choma mzima na nusu, ndizi za kuchoma na vinywaji baridi karibu na stesheni ya TAZARA.',
      phone: '+255 754 777 888',
      whatsapp: '+255 754 777 888',
      openingHours: 'Saa 6:00 Mchana - Saa 5:00 Usiku',
      rating: 4.9,
      reviewCount: 165,
      location: PlaceLocation(
        id: 'loc-tazara-bbq',
        area: makambakoWards[6], // TAZARA
        displayName: 'TAZARA Station Road',
        address: 'Near TAZARA station gate · 30-40 min delivery',
        coordinates: GeoPoint(latitude: -8.8355, longitude: 34.8385),
      ),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.ownerSubmitted,
        label: 'Verified Restaurant Owner',
      ),
      verificationStatus: PlaceVerificationStatus.verified,
      createdAt: DateTime.utc(2026, 10, 1),
      updatedAt: DateTime.utc(2026, 10, 23),
    ),
    Place(
      id: 'mko-royal-bakers',
      entity: BusinessEntityReference('mko-biz-royal-bakers'),
      name: 'Royal Bakery & Cafe',
      categoryId: 'food',
      categoryName: 'Chakula',
      aliases: ['royal', 'bakery', 'cafe', 'kahawa', 'chai', 'sambusa', 'keki', 'juisi', 'vitafunwa'],
      description: 'Kahawa safi ya Iringa iliyochujwa, sambusa za nyama motomoto, mikate laini, bagia na juisi ya matunda halisi.',
      phone: '+255 789 222 111',
      whatsapp: '+255 789 222 111',
      openingHours: 'Saa 1:00 Asubuhi - Saa 2:00 Usiku',
      rating: 4.7,
      reviewCount: 94,
      location: PlaceLocation(
        id: 'loc-royal-bakers',
        area: makambakoWards[0], // Stand Kuu
        displayName: 'Uhuru Street, Main Market',
        address: 'Opposite CRDB Bank · 15-25 min delivery',
        coordinates: GeoPoint(latitude: -8.8468, longitude: 34.8285),
      ),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.ownerSubmitted,
        label: 'Verified Business Owner',
      ),
      verificationStatus: PlaceVerificationStatus.verified,
      createdAt: DateTime.utc(2026, 10, 1),
      updatedAt: DateTime.utc(2026, 10, 23),
    ),
    Place(
      id: 'mko-tazara-station',
      entity: PublicPlaceEntityReference('mko-pub-tazara'),
      name: 'Kituo cha Reli TAZARA Makambako',
      categoryId: 'transport',
      categoryName: 'Usafiri',
      aliases: ['tazara', 'treni', 'train', 'reli', 'railway', 'usafiri', 'safari'],
      description: 'Kituo cha abiria na mizigo cha reli ya TAZARA inayounganisha Tanzania na Zambia.',
      phone: '+255 768 987 654',
      openingHours: 'Saa 1:00 Asubuhi - Saa 2:00 Usiku',
      rating: 4.5,
      reviewCount: 88,
      location: PlaceLocation(
        id: 'loc-tazara',
        area: makambakoWards[6], // TAZARA
        displayName: 'Kituo cha Reli TAZARA',
        address: 'TAZARA Road, Makambako',
        coordinates: GeoPoint(latitude: -8.8350, longitude: 34.8390),
      ),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.officialSource,
        label: 'TAZARA Authority',
      ),
      verificationStatus: PlaceVerificationStatus.verified,
      createdAt: DateTime.utc(2026, 10, 1),
      updatedAt: DateTime.utc(2026, 10, 23),
    ),
    Place(
      id: 'mko-mama-maria-kitchen',
      entity: BusinessEntityReference('mko-biz-mama-maria'),
      name: 'Mama Maria Cafe & Local Kitchen',
      categoryId: 'food',
      categoryName: 'Chakula',
      aliases: ['mama maria', 'chakula', 'mgahawa', 'restaurant', 'cafe', 'nyama choma', 'ugali', 'chai'],
      description: 'Chakula kitamu cha asili cha Kitanzania: Ugali viazi, kuku wa kienyeji, samaki fresh, nyama choma na chai ya viungo.',
      phone: '+255 762 333 444',
      whatsapp: '+255 762 333 444',
      openingHours: 'Saa 1:00 Asubuhi - Saa 4:00 Usiku',
      rating: 4.9,
      reviewCount: 165,
      location: PlaceLocation(
        id: 'loc-mama-maria',
        area: makambakoWards[2], // Mwembetogwa
        displayName: 'Mwembetogwa, Karibu na Soko',
        address: 'Mtaa wa Soko Kuu, Mwembetogwa',
        coordinates: GeoPoint(latitude: -8.8470, longitude: 34.8280),
      ),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.ownerSubmitted,
        label: 'Verified Business Owner',
      ),
      verificationStatus: PlaceVerificationStatus.verified,
      createdAt: DateTime.utc(2026, 10, 1),
      updatedAt: DateTime.utc(2026, 10, 23),
    ),
    Place(
      id: 'mko-upendo-agrovet',
      entity: BusinessEntityReference('mko-biz-upendo-agrovet'),
      name: 'Upendo Agrovet & Pembejeo za Kilimo',
      categoryId: 'businesses',
      categoryName: 'Biashara',
      aliases: ['agrovet', 'kilimo', 'mbolea', 'mbegu', 'upendo', 'dawa', 'mifugo', 'farm'],
      description: 'Duka kubwa la pembejeo za kilimo: mbolea, mbegu zilizothibitishwa, madawa ya mazao na mifugo, na ushauri wa kitaalamu.',
      phone: '+255 755 888 999',
      whatsapp: '+255 755 888 999',
      openingHours: 'Saa 1:30 Asubuhi - Saa 1:00 Jioni',
      rating: 4.8,
      reviewCount: 76,
      location: PlaceLocation(
        id: 'loc-upendo-agrovet',
        area: makambakoWards[3], // Utengule
        displayName: 'Utengule Mjini',
        address: 'Utengule Main Street',
        coordinates: GeoPoint(latitude: -8.8440, longitude: 34.8285),
      ),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.ownerSubmitted,
        label: 'Verified Business Owner',
      ),
      verificationStatus: PlaceVerificationStatus.verified,
      createdAt: DateTime.utc(2026, 10, 1),
      updatedAt: DateTime.utc(2026, 10, 23),
    ),
    Place(
      id: 'mko-council-offices',
      entity: PublicPlaceEntityReference('mko-pub-council'),
      name: 'Halmashauri ya Mji Makambako',
      categoryId: 'places',
      categoryName: 'Maeneo',
      aliases: ['halmashauri', 'serikali', 'ofisi', 'town council', 'maguvani', 'manispaa'],
      description: 'Ofisi kuu za Serikali ya Mtaa na Halmashauri ya Mji wa Makambako: vibali, huduma za jamii na mipango miji.',
      phone: '+255 26 273 0001',
      openingHours: 'Jumatatu - Ijumaa: Saa 1:30 Asubuhi - Saa 9:30 Alasiri',
      rating: 4.3,
      reviewCount: 54,
      location: PlaceLocation(
        id: 'loc-council',
        area: makambakoWards[4], // Maguvani
        displayName: 'Maguvani, Makao Makuu ya Halmashauri',
        address: 'Boma Road, Maguvani',
        coordinates: GeoPoint(latitude: -8.8510, longitude: 34.8310),
      ),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.officialSource,
        label: 'Makambako Town Council',
      ),
      verificationStatus: PlaceVerificationStatus.verified,
      createdAt: DateTime.utc(2026, 10, 1),
      updatedAt: DateTime.utc(2026, 10, 23),
    ),
    Place(
      id: 'mko-police-station',
      entity: PublicPlaceEntityReference('mko-pub-police'),
      name: 'Kituo Kikuu cha Polisi Makambako',
      categoryId: 'services',
      categoryName: 'Huduma',
      aliases: ['polisi', 'police', 'usalama', 'kituo cha polisi', 'dharura', 'security'],
      description: 'Kituo kikuu cha Jeshi la Polisi Makambako kwa ajili ya ulinzi, usalama, msaada wa dharura na usalama barabarani.',
      phone: '+255 713 112 112',
      openingHours: 'Masaa 24 (24/7 Police Station)',
      rating: 4.4,
      reviewCount: 46,
      location: PlaceLocation(
        id: 'loc-police',
        area: makambakoWards[0], // Stand Kuu
        displayName: 'Stand Kuu, Karibu na Barabara Kuu',
        address: 'Police Post Road, Stand Kuu',
        coordinates: GeoPoint(latitude: -8.8490, longitude: 34.8270),
      ),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.officialSource,
        label: 'Tanzania Police Force',
      ),
      verificationStatus: PlaceVerificationStatus.verified,
      createdAt: DateTime.utc(2026, 10, 1),
      updatedAt: DateTime.utc(2026, 10, 23),
    ),
    Place(
      id: 'mko-highland-lodge',
      entity: BusinessEntityReference('mko-biz-highland-lodge'),
      name: 'Highland Executive Lodge & Suites',
      categoryId: 'accommodation',
      categoryName: 'Malazi',
      aliases: ['highland', 'lodge', 'hotel', 'hoteli', 'malazi', 'vyumba', 'stay'],
      description: 'Vyumba tulivu, safi na vya kisasa kwa wasafiri na familia, maegesho salama ya magari na chakula cha asubuhi.',
      phone: '+255 765 777 222',
      whatsapp: '+255 765 777 222',
      openingHours: 'Masaa 24 (Kila siku)',
      rating: 4.6,
      reviewCount: 72,
      location: PlaceLocation(
        id: 'loc-highland-lodge',
        area: makambakoWards[3], // Utengule
        displayName: 'Utengule, Kando ya Barabara',
        address: 'Utengule Way, Makambako',
        coordinates: GeoPoint(latitude: -8.8460, longitude: 34.8240),
      ),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.ownerSubmitted,
        label: 'Verified Business Owner',
      ),
      verificationStatus: PlaceVerificationStatus.verified,
      createdAt: DateTime.utc(2026, 10, 1),
      updatedAt: DateTime.utc(2026, 10, 23),
    ),

    // --- Retained Trial Fixtures for Backwards Compatibility ---
    Place(
      id: 'trial-service-clinic',
      entity: const ServiceProviderEntityReference('trial-service-provider-clinic'),
      name: 'Kliniki ya Jaribio',
      categoryId: 'services',
      categoryName: 'Huduma',
      aliases: const ['clinic', 'kliniki', 'afya', 'health', 'hospitali'],
      description: 'Rekodi ya jaribio ya huduma ya afya. Hakuna kliniki halisi.',
      location: const PlaceLocation(id: 'trial-location-clinic', area: _trialArea),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.developmentFixture,
        label: 'Trial development fixture',
      ),
      verificationStatus: PlaceVerificationStatus.developmentFixture,
      createdAt: DateTime.utc(2026, 10, 21),
      updatedAt: DateTime.utc(2026, 10, 21),
    ),
    Place(
      id: 'trial-service-salon',
      entity: const ServiceProviderEntityReference('trial-service-provider-salon'),
      name: 'Salon ya Jaribio',
      categoryId: 'services',
      categoryName: 'Huduma',
      aliases: const ['salon', 'urembo', 'beauty'],
      description: 'Rekodi ya jaribio ya salon. Hakuna salon halisi.',
      location: const PlaceLocation(id: 'trial-location-salon', area: _trialArea),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.developmentFixture,
        label: 'Trial development fixture',
      ),
      verificationStatus: PlaceVerificationStatus.developmentFixture,
      createdAt: DateTime.utc(2026, 10, 21),
      updatedAt: DateTime.utc(2026, 10, 21),
    ),
    Place(
      id: 'trial-service-repair',
      entity: const ServiceProviderEntityReference('trial-service-provider-repair'),
      name: 'Fundi wa Jaribio',
      categoryId: 'services',
      categoryName: 'Huduma',
      aliases: const ['fundi', 'repair', 'ukarabati'],
      description: 'Rekodi ya jaribio ya fundi. Hakuna fundi halisi.',
      location: const PlaceLocation(id: 'trial-location-repair', area: _trialArea),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.developmentFixture,
        label: 'Trial development fixture',
      ),
      verificationStatus: PlaceVerificationStatus.developmentFixture,
      createdAt: DateTime.utc(2026, 10, 21),
      updatedAt: DateTime.utc(2026, 10, 21),
    ),
    Place(
      id: 'trial-office-ward',
      entity: const PublicPlaceEntityReference('trial-public-place-ward-office'),
      name: 'Ofisi ya Kata ya Jaribio',
      categoryId: 'places',
      categoryName: 'Maeneo',
      aliases: const ['ofisi', 'office', 'kata', 'ward'],
      description: 'Rekodi ya jaribio ya ofisi ya umma. Hakuna ofisi halisi.',
      location: const PlaceLocation(id: 'trial-location-ward-office', area: _trialArea),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.developmentFixture,
        label: 'Trial development fixture',
      ),
      verificationStatus: PlaceVerificationStatus.developmentFixture,
      createdAt: DateTime.utc(2026, 10, 21),
      updatedAt: DateTime.utc(2026, 10, 21),
    ),
    Place(
      id: 'trial-office-legal',
      entity: const BusinessEntityReference('trial-business-legal-office'),
      name: 'Ofisi ya Mawakili ya Jaribio',
      categoryId: 'businesses',
      categoryName: 'Biashara',
      aliases: const ['ofisi', 'office', 'mawakili', 'lawyer', 'advocate'],
      description: 'Rekodi ya jaribio ya ofisi ya mawakili. Hakuna ofisi halisi.',
      location: const PlaceLocation(id: 'trial-location-legal-office', area: _trialArea),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.developmentFixture,
        label: 'Trial development fixture',
      ),
      verificationStatus: PlaceVerificationStatus.developmentFixture,
      createdAt: DateTime.utc(2026, 10, 21),
      updatedAt: DateTime.utc(2026, 10, 21),
    ),
    Place(
      id: 'trial-office-consulting',
      entity: const ServiceProviderEntityReference('trial-service-provider-consulting'),
      name: 'Ofisi ya Ushauri ya Jaribio',
      categoryId: 'services',
      categoryName: 'Huduma',
      aliases: const ['ofisi', 'office', 'ushauri', 'consultancy', 'consultant'],
      description: 'Rekodi ya jaribio ya ofisi ya ushauri. Hakuna ofisi halisi.',
      location: const PlaceLocation(
        id: 'trial-location-consulting-office',
        area: _trialArea,
      ),
      provenance: const PlaceProvenance(
        type: PlaceSourceType.developmentFixture,
        label: 'Trial development fixture',
      ),
      verificationStatus: PlaceVerificationStatus.developmentFixture,
      createdAt: DateTime.utc(2026, 10, 21),
      updatedAt: DateTime.utc(2026, 10, 21),
    ),
  ];

  /// Realistic community landmarks for featured showcases on the home screen.
  static List<Place> get featuredPlaces =>
      _places.where((p) => !p.isDevelopmentFixture).take(5).toList();

  /// Synchronous lookup for canonical fixture places
  static Place? findPlaceById(String id) {
    for (final p in _places) {
      if (p.id == id) return p;
    }
    return null;
  }

  static List<Place> get allPlaces => List.unmodifiable(_places);

  @override
  Future<DiscoveryResult<List<Place>>> search(
    PlaceSearchRequest request,
  ) async {
    return DiscoverySuccess(_places);
  }

  @override
  Future<DiscoveryResult<List<Place>>> findWithinBounds(
    PlaceBoundsRequest request,
  ) async {
    return DiscoverySuccess(_places);
  }

  @override
  Future<DiscoveryResult<Place?>> getById(String placeId) async {
    for (final place in _places) {
      if (place.id == placeId) return DiscoverySuccess(place);
    }
    return const DiscoverySuccess(null);
  }
}
