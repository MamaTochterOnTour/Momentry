// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Mom-Daughter Journal`
  String get pageTitle {
    return Intl.message(
      'Mom-Daughter Journal',
      name: 'pageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Journals`
  String get tabTagebuecher {
    return Intl.message('Journals', name: 'tabTagebuecher', desc: '', args: []);
  }

  /// `Insider`
  String get tabInsider {
    return Intl.message('Insider', name: 'tabInsider', desc: '', args: []);
  }

  /// `Tips`
  String get tabTipps {
    return Intl.message('Tips', name: 'tabTipps', desc: '', args: []);
  }

  /// `Welcome to our travel journal! Here we collect all our wonderful memories, big and small adventures, spontaneous experiences, and very special moments we shared as mom and daughter. 💖\n\nWe traveled to Norway, Italy, the Caribbean, UAE, USA, Spain, Portugal, France, and much more. 🌏\n\nYou will also find hotel recommendations 🏨, restaurant tips 🍽️, and exclusive insider tips 🔍.`
  String get welcomeText {
    return Intl.message(
      'Welcome to our travel journal! Here we collect all our wonderful memories, big and small adventures, spontaneous experiences, and very special moments we shared as mom and daughter. 💖\n\nWe traveled to Norway, Italy, the Caribbean, UAE, USA, Spain, Portugal, France, and much more. 🌏\n\nYou will also find hotel recommendations 🏨, restaurant tips 🍽️, and exclusive insider tips 🔍.',
      name: 'welcomeText',
      desc: '',
      args: [],
    );
  }

  /// `Our Destinations 🌟`
  String get ourDestinations {
    return Intl.message(
      'Our Destinations 🌟',
      name: 'ourDestinations',
      desc: '',
      args: [],
    );
  }

  /// `Discover our adventures around the world`
  String get discoverAdventures {
    return Intl.message(
      'Discover our adventures around the world',
      name: 'discoverAdventures',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message('Note', name: 'note', desc: '', args: []);
  }

  /// `All content and images shown in this app originate either from our private trips and personal experiences or from explicitly marked partnerships with partner companies.`
  String get disclaimer {
    return Intl.message(
      'All content and images shown in this app originate either from our private trips and personal experiences or from explicitly marked partnerships with partner companies.',
      name: 'disclaimer',
      desc: '',
      args: [],
    );
  }

  /// `Mallorca`
  String get mallorcaTitle {
    return Intl.message('Mallorca', name: 'mallorcaTitle', desc: '', args: []);
  }

  /// `Island of our hearts`
  String get mallorcaSubtitle {
    return Intl.message(
      'Island of our hearts',
      name: 'mallorcaSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `AIDA Cruises`
  String get aidaCruisesTitle {
    return Intl.message(
      'AIDA Cruises',
      name: 'aidaCruisesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Ocean adventures full of magic 🌊💫`
  String get aidaCruisesSubtitle {
    return Intl.message(
      'Ocean adventures full of magic 🌊💫',
      name: 'aidaCruisesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Long-Distance Trips`
  String get longDistanceTitle {
    return Intl.message(
      'Long-Distance Trips',
      name: 'longDistanceTitle',
      desc: '',
      args: [],
    );
  }

  /// `Wide worlds, big dreams 🌍❤️`
  String get longDistanceSubtitle {
    return Intl.message(
      'Wide worlds, big dreams 🌍❤️',
      name: 'longDistanceSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Road Trips Europe`
  String get roadtripEuropeTitle {
    return Intl.message(
      'Road Trips Europe',
      name: 'roadtripEuropeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Driving through Europe's wonders 🚗💜`
  String get roadtripEuropeSubtitle {
    return Intl.message(
      'Driving through Europe\'s wonders 🚗💜',
      name: 'roadtripEuropeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `City Trips`
  String get cityTripsTitle {
    return Intl.message(
      'City Trips',
      name: 'cityTripsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Between towers, cafés & cobblestones 🏰✨`
  String get cityTripsSubtitle {
    return Intl.message(
      'Between towers, cafés & cobblestones 🏰✨',
      name: 'cityTripsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Seaside Getaways`
  String get seasideGetawaysTitle {
    return Intl.message(
      'Seaside Getaways',
      name: 'seasideGetawaysTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sea moments to dream 🏖️✨`
  String get seasideGetawaysSubtitle {
    return Intl.message(
      'Sea moments to dream 🏖️✨',
      name: 'seasideGetawaysSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Join our journey 🧭✨`
  String get followOurJourney {
    return Intl.message(
      'Join our journey 🧭✨',
      name: 'followOurJourney',
      desc: '',
      args: [],
    );
  }

  /// `TUI Aschaffenburg (Travel Agency)`
  String get tuiAschaffenburgTitle {
    return Intl.message(
      'TUI Aschaffenburg (Travel Agency)',
      name: 'tuiAschaffenburgTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your contact for unforgettable vacations – personal, competent, warm-hearted.`
  String get tuiAschaffenburgSubtitle {
    return Intl.message(
      'Your contact for unforgettable vacations – personal, competent, warm-hearted.',
      name: 'tuiAschaffenburgSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Travel Agencies`
  String get pageTitleReisebueros {
    return Intl.message(
      'Travel Agencies',
      name: 'pageTitleReisebueros',
      desc: '',
      args: [],
    );
  }

  /// `TUI Aschaffenburg`
  String get headerTitleTUI {
    return Intl.message(
      'TUI Aschaffenburg',
      name: 'headerTitleTUI',
      desc: '',
      args: [],
    );
  }

  /// `The world is huge – come, we will show it to you!\n\nWe are a well-coordinated team of 15 passionate travel experts, who have been creating unforgettable vacation moments together for many years.\n\nNo matter where you want to go – with us, you'll always find the right contact person: competent, experienced, and attentive to all your wishes.\n\nWhat makes us special? We love what we do. That's why every consultation contains not only expertise but also a lot of heart and real enthusiasm.\n\nOur travel agency has existed for many years – and from colleagues, our very own little TUI family has long been formed. It is important to us that you feel not only professionally advised but also completely well taken care of.\n\nTrust us with your vacation: we plan every trip as if it were our own.\nFor us, not only expertise matters but above all humanity, passion, and the desire to make every trip something truly special.`
  String get fullTextReisebuero {
    return Intl.message(
      'The world is huge – come, we will show it to you!\n\nWe are a well-coordinated team of 15 passionate travel experts, who have been creating unforgettable vacation moments together for many years.\n\nNo matter where you want to go – with us, you\'ll always find the right contact person: competent, experienced, and attentive to all your wishes.\n\nWhat makes us special? We love what we do. That\'s why every consultation contains not only expertise but also a lot of heart and real enthusiasm.\n\nOur travel agency has existed for many years – and from colleagues, our very own little TUI family has long been formed. It is important to us that you feel not only professionally advised but also completely well taken care of.\n\nTrust us with your vacation: we plan every trip as if it were our own.\nFor us, not only expertise matters but above all humanity, passion, and the desire to make every trip something truly special.',
      name: 'fullTextReisebuero',
      desc: '',
      args: [],
    );
  }

  /// `The world is huge – come, we will show it to you!\n\nWe are a well-coordinated team of 15 passionate travel experts, who have been creating unforgettable vacation moments together for many years.`
  String get previewTextReisebuero {
    return Intl.message(
      'The world is huge – come, we will show it to you!\n\nWe are a well-coordinated team of 15 passionate travel experts, who have been creating unforgettable vacation moments together for many years.',
      name: 'previewTextReisebuero',
      desc: '',
      args: [],
    );
  }

  /// `... read more`
  String get readMore {
    return Intl.message('... read more', name: 'readMore', desc: '', args: []);
  }

  /// `Read less`
  String get readLess {
    return Intl.message('Read less', name: 'readLess', desc: '', args: []);
  }

  /// `Services`
  String get servicesTitle {
    return Intl.message('Services', name: 'servicesTitle', desc: '', args: []);
  }

  /// `Travel around the world – near or far`
  String get serviceTravel {
    return Intl.message(
      'Travel around the world – near or far',
      name: 'serviceTravel',
      desc: '',
      args: [],
    );
  }

  /// `Contact & Consultation`
  String get contactTitle {
    return Intl.message(
      'Contact & Consultation',
      name: 'contactTitle',
      desc: '',
      args: [],
    );
  }

  /// `Send Email`
  String get emailLabel {
    return Intl.message('Send Email', name: 'emailLabel', desc: '', args: []);
  }

  /// `WhatsApp`
  String get whatsappLabel {
    return Intl.message('WhatsApp', name: 'whatsappLabel', desc: '', args: []);
  }

  /// `Instagram`
  String get instagramLabel {
    return Intl.message(
      'Instagram',
      name: 'instagramLabel',
      desc: '',
      args: [],
    );
  }

  /// `View on Google`
  String get googleMapsLabel {
    return Intl.message(
      'View on Google',
      name: 'googleMapsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Online & video consultation available by appointment`
  String get onlineConsultation {
    return Intl.message(
      'Online & video consultation available by appointment',
      name: 'onlineConsultation',
      desc: '',
      args: [],
    );
  }

  /// `Advertisement / Partner Travel Agency · Recommended by MamaTochterOnTour`
  String get disclaimerPartner {
    return Intl.message(
      'Advertisement / Partner Travel Agency · Recommended by MamaTochterOnTour',
      name: 'disclaimerPartner',
      desc: '',
      args: [],
    );
  }

  /// `Long-haul travel`
  String get featureLongHaul {
    return Intl.message(
      'Long-haul travel',
      name: 'featureLongHaul',
      desc: '',
      args: [],
    );
  }

  /// `Package holidays`
  String get featurePackage {
    return Intl.message(
      'Package holidays',
      name: 'featurePackage',
      desc: '',
      args: [],
    );
  }

  /// `Individual trips`
  String get featureIndividual {
    return Intl.message(
      'Individual trips',
      name: 'featureIndividual',
      desc: '',
      args: [],
    );
  }

  /// `Round trips`
  String get featureRoundTrips {
    return Intl.message(
      'Round trips',
      name: 'featureRoundTrips',
      desc: '',
      args: [],
    );
  }

  /// `Cruises`
  String get featureCruises {
    return Intl.message('Cruises', name: 'featureCruises', desc: '', args: []);
  }

  /// `Family vacations`
  String get featureFamily {
    return Intl.message(
      'Family vacations',
      name: 'featureFamily',
      desc: '',
      args: [],
    );
  }

  /// `Honeymoon`
  String get featureHoneymoon {
    return Intl.message(
      'Honeymoon',
      name: 'featureHoneymoon',
      desc: '',
      args: [],
    );
  }

  /// `Club holidays`
  String get featureClub {
    return Intl.message(
      'Club holidays',
      name: 'featureClub',
      desc: '',
      args: [],
    );
  }

  /// `City trips`
  String get featureCityTrips {
    return Intl.message(
      'City trips',
      name: 'featureCityTrips',
      desc: '',
      args: [],
    );
  }

  /// `Camper travel`
  String get featureCamper {
    return Intl.message(
      'Camper travel',
      name: 'featureCamper',
      desc: '',
      args: [],
    );
  }

  /// `Luxury travel`
  String get featureLuxury {
    return Intl.message(
      'Luxury travel',
      name: 'featureLuxury',
      desc: '',
      args: [],
    );
  }

  /// `Wellness & spa`
  String get featureWellness {
    return Intl.message(
      'Wellness & spa',
      name: 'featureWellness',
      desc: '',
      args: [],
    );
  }

  /// `Our Insider Tips ✨`
  String get insiderTitle {
    return Intl.message(
      'Our Insider Tips ✨',
      name: 'insiderTitle',
      desc: '',
      args: [],
    );
  }

  /// `Search…`
  String get searchHint {
    return Intl.message('Search…', name: 'searchHint', desc: '', args: []);
  }

  /// `No places found 😕`
  String get noResults {
    return Intl.message(
      'No places found 😕',
      name: 'noResults',
      desc: '',
      args: [],
    );
  }

  /// `More insider tips for exciting destinations coming soon! ✨`
  String get moreComing {
    return Intl.message(
      'More insider tips for exciting destinations coming soon! ✨',
      name: 'moreComing',
      desc: '',
      args: [],
    );
  }

  /// `Error loading settings`
  String get errorLoading {
    return Intl.message(
      'Error loading settings',
      name: 'errorLoading',
      desc: '',
      args: [],
    );
  }

  /// `Italy`
  String get countryItaly {
    return Intl.message('Italy', name: 'countryItaly', desc: '', args: []);
  }

  /// `Norway`
  String get countryNorway {
    return Intl.message('Norway', name: 'countryNorway', desc: '', args: []);
  }

  /// `Spain`
  String get countrySpain {
    return Intl.message('Spain', name: 'countrySpain', desc: '', args: []);
  }

  /// `Rome`
  String get cityRome {
    return Intl.message('Rome', name: 'cityRome', desc: '', args: []);
  }

  /// `Geiranger`
  String get cityGeiranger {
    return Intl.message('Geiranger', name: 'cityGeiranger', desc: '', args: []);
  }

  /// `Mallorca`
  String get cityMallorca {
    return Intl.message('Mallorca', name: 'cityMallorca', desc: '', args: []);
  }

  /// `Historic capital full of ancient architecture, vibrant squares, charming streets and amazing food.`
  String get descRome {
    return Intl.message(
      'Historic capital full of ancient architecture, vibrant squares, charming streets and amazing food.',
      name: 'descRome',
      desc: '',
      args: [],
    );
  }

  /// `Spectacular fjord with breathtaking waterfalls and stunning natural scenery.`
  String get descGeiranger {
    return Intl.message(
      'Spectacular fjord with breathtaking waterfalls and stunning natural scenery.',
      name: 'descGeiranger',
      desc: '',
      args: [],
    );
  }

  /// `Mediterranean dream island with white sandy beaches, dramatic cliffs, charming villages and vibrant nightlife.`
  String get descMallorca {
    return Intl.message(
      'Mediterranean dream island with white sandy beaches, dramatic cliffs, charming villages and vibrant nightlife.',
      name: 'descMallorca',
      desc: '',
      args: [],
    );
  }

  /// `Insider content is only available for premium users. Tap here to unlock premium.`
  String get premiumLocked {
    return Intl.message(
      'Insider content is only available for premium users. Tap here to unlock premium.',
      name: 'premiumLocked',
      desc: '',
      args: [],
    );
  }

  /// `Seaside Getaways`
  String get auszeitenAmMeerTitle {
    return Intl.message(
      'Seaside Getaways',
      name: 'auszeitenAmMeerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Our most beautiful seaside experiences 🌊🌅💙\n\nSalt air, sunsets and that feeling of freedom – these are our favorite sea moments.`
  String get auszeitenAmMeerIntro {
    return Intl.message(
      'Our most beautiful seaside experiences 🌊🌅💙\n\nSalt air, sunsets and that feeling of freedom – these are our favorite sea moments.',
      name: 'auszeitenAmMeerIntro',
      desc: '',
      args: [],
    );
  }

  /// `Scheveningen`
  String get scheveningenTitle {
    return Intl.message(
      'Scheveningen',
      name: 'scheveningenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Wind, sea & feeling of freedom`
  String get scheveningenSubtitle {
    return Intl.message(
      'Wind, sea & feeling of freedom',
      name: 'scheveningenSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Noordwijk`
  String get noordwijkTitle {
    return Intl.message(
      'Noordwijk',
      name: 'noordwijkTitle',
      desc: '',
      args: [],
    );
  }

  /// `Dunes, calm & North Sea magic`
  String get noordwijkSubtitle {
    return Intl.message(
      'Dunes, calm & North Sea magic',
      name: 'noordwijkSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `You are not a premium member and cannot read our journals. Tap here to unlock premium ✨`
  String get premiumSnackbarText {
    return Intl.message(
      'You are not a premium member and cannot read our journals. Tap here to unlock premium ✨',
      name: 'premiumSnackbarText',
      desc: '',
      args: [],
    );
  }

  /// `Error loading premium status. Please try again.`
  String get premiumErrorText {
    return Intl.message(
      'Error loading premium status. Please try again.',
      name: 'premiumErrorText',
      desc: '',
      args: [],
    );
  }

  /// `City Trips`
  String get staedtereisenTitle {
    return Intl.message(
      'City Trips',
      name: 'staedtereisenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Our city trip highlights 🏙️💜\n\nHere we collect our most beautiful experiences from the cities we love.`
  String get staedtereisenIntro {
    return Intl.message(
      'Our city trip highlights 🏙️💜\n\nHere we collect our most beautiful experiences from the cities we love.',
      name: 'staedtereisenIntro',
      desc: '',
      args: [],
    );
  }

  /// `Cologne`
  String get koelnTitle {
    return Intl.message('Cologne', name: 'koelnTitle', desc: '', args: []);
  }

  /// `Heart between Cathedral and Rhine`
  String get koelnSubtitle {
    return Intl.message(
      'Heart between Cathedral and Rhine',
      name: 'koelnSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Paris`
  String get parisTitle {
    return Intl.message('Paris', name: 'parisTitle', desc: '', args: []);
  }

  /// `Flair of the French metropolis`
  String get parisSubtitle {
    return Intl.message(
      'Flair of the French metropolis',
      name: 'parisSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Berlin`
  String get berlinTitle {
    return Intl.message('Berlin', name: 'berlinTitle', desc: '', args: []);
  }

  /// `Capital & History`
  String get berlinSubtitle {
    return Intl.message(
      'Capital & History',
      name: 'berlinSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Hamburg`
  String get hamburgTitle {
    return Intl.message('Hamburg', name: 'hamburgTitle', desc: '', args: []);
  }

  /// `Gateway to the world`
  String get hamburgSubtitle {
    return Intl.message(
      'Gateway to the world',
      name: 'hamburgSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `London`
  String get londonTitle {
    return Intl.message('London', name: 'londonTitle', desc: '', args: []);
  }

  /// `City of Royals & Culture`
  String get londonSubtitle {
    return Intl.message(
      'City of Royals & Culture',
      name: 'londonSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Rome`
  String get romTitle {
    return Intl.message('Rome', name: 'romTitle', desc: '', args: []);
  }

  /// `Eternal city & history`
  String get romSubtitle {
    return Intl.message(
      'Eternal city & history',
      name: 'romSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Vienna`
  String get wienTitle {
    return Intl.message('Vienna', name: 'wienTitle', desc: '', args: []);
  }

  /// `Culture & coffeehouse charm`
  String get wienSubtitle {
    return Intl.message(
      'Culture & coffeehouse charm',
      name: 'wienSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Genoa`
  String get genuaTitle {
    return Intl.message('Genoa', name: 'genuaTitle', desc: '', args: []);
  }

  /// `Port city & Liguria`
  String get genuaSubtitle {
    return Intl.message(
      'Port city & Liguria',
      name: 'genuaSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Europe Roadtrip`
  String get roadtripEuropaTitle {
    return Intl.message(
      'Europe Roadtrip',
      name: 'roadtripEuropaTitle',
      desc: '',
      args: [],
    );
  }

  /// `Our best experiences by car 🚗✨\n\nRoadtrips across Europe – freedom, music, and unforgettable moments on the way.`
  String get roadtripEuropaIntro {
    return Intl.message(
      'Our best experiences by car 🚗✨\n\nRoadtrips across Europe – freedom, music, and unforgettable moments on the way.',
      name: 'roadtripEuropaIntro',
      desc: '',
      args: [],
    );
  }

  /// `Roadtrips across Europe`
  String get roadtripEuropaGridTitle {
    return Intl.message(
      'Roadtrips across Europe',
      name: 'roadtripEuropaGridTitle',
      desc: '',
      args: [],
    );
  }

  /// `Côte d'Azur`
  String get cotedazurTitle {
    return Intl.message(
      'Côte d\'Azur',
      name: 'cotedazurTitle',
      desc: '',
      args: [],
    );
  }

  /// `Coast of our dreams`
  String get cotedazurSubtitle {
    return Intl.message(
      'Coast of our dreams',
      name: 'cotedazurSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Italy`
  String get italienTitle {
    return Intl.message('Italy', name: 'italienTitle', desc: '', args: []);
  }

  /// `Discover Bella Italia`
  String get italienSubtitle {
    return Intl.message(
      'Discover Bella Italia',
      name: 'italienSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Long-Haul Trips`
  String get fernreisenTitle {
    return Intl.message(
      'Long-Haul Trips',
      name: 'fernreisenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Our best experiences far away ✈️🌍\nAdventures, discoveries, and unforgettable moments – get inspired for your next trip!`
  String get fernreisenIntro {
    return Intl.message(
      'Our best experiences far away ✈️🌍\nAdventures, discoveries, and unforgettable moments – get inspired for your next trip!',
      name: 'fernreisenIntro',
      desc: '',
      args: [],
    );
  }

  /// `Our Long-Haul Trips`
  String get fernreisenGridTitle {
    return Intl.message(
      'Our Long-Haul Trips',
      name: 'fernreisenGridTitle',
      desc: '',
      args: [],
    );
  }

  /// `Florida`
  String get floridaTitle {
    return Intl.message('Florida', name: 'floridaTitle', desc: '', args: []);
  }

  /// `Roadtrip through paradise`
  String get floridaSubtitle {
    return Intl.message(
      'Roadtrip through paradise',
      name: 'floridaSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `California`
  String get kalifornienTitle {
    return Intl.message(
      'California',
      name: 'kalifornienTitle',
      desc: '',
      args: [],
    );
  }

  /// `Roadtrip through the Golden State`
  String get kalifornienSubtitle {
    return Intl.message(
      'Roadtrip through the Golden State',
      name: 'kalifornienSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Dubai`
  String get dubaiTitle {
    return Intl.message('Dubai', name: 'dubaiTitle', desc: '', args: []);
  }

  /// `Adventure between desert & skyline`
  String get dubaiSubtitle {
    return Intl.message(
      'Adventure between desert & skyline',
      name: 'dubaiSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `New York`
  String get newyorkTitle {
    return Intl.message('New York', name: 'newyorkTitle', desc: '', args: []);
  }

  /// `Magic at Christmas time`
  String get newyorkSubtitle {
    return Intl.message(
      'Magic at Christmas time',
      name: 'newyorkSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `AIDA Cruises`
  String get aidaTitle {
    return Intl.message('AIDA Cruises', name: 'aidaTitle', desc: '', args: []);
  }

  /// `Our best experiences on the high seas ⛴️🌊\n\nWelcome to our cruise page! Here you’ll find all our special memories from our AIDA trips, from the Caribbean to Norway. Every cruise is a unique adventure full of discovery, enjoyment, and family time at sea. ⚓`
  String get aidaIntro {
    return Intl.message(
      'Our best experiences on the high seas ⛴️🌊\n\nWelcome to our cruise page! Here you’ll find all our special memories from our AIDA trips, from the Caribbean to Norway. Every cruise is a unique adventure full of discovery, enjoyment, and family time at sea. ⚓',
      name: 'aidaIntro',
      desc: '',
      args: [],
    );
  }

  /// `Our Cruises`
  String get aidaGridTitle {
    return Intl.message(
      'Our Cruises',
      name: 'aidaGridTitle',
      desc: '',
      args: [],
    );
  }

  /// `Mediterranean Treasures`
  String get aidaMediterraneSchaetze {
    return Intl.message(
      'Mediterranean Treasures',
      name: 'aidaMediterraneSchaetze',
      desc: '',
      args: [],
    );
  }

  /// `Experience dreamlike coasts`
  String get aidaMediterraneSchaetzeSubtitle {
    return Intl.message(
      'Experience dreamlike coasts',
      name: 'aidaMediterraneSchaetzeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Mediterranean Highlights`
  String get aidaMediterraneHighlights {
    return Intl.message(
      'Mediterranean Highlights',
      name: 'aidaMediterraneHighlights',
      desc: '',
      args: [],
    );
  }

  /// `Adventurous coasts`
  String get aidaMediterraneHighlightsSubtitle {
    return Intl.message(
      'Adventurous coasts',
      name: 'aidaMediterraneHighlightsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Orient`
  String get aidaOrient {
    return Intl.message('Orient', name: 'aidaOrient', desc: '', args: []);
  }

  /// `Adventure & luxury`
  String get aidaOrientSubtitle {
    return Intl.message(
      'Adventure & luxury',
      name: 'aidaOrientSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Denmark & Sweden`
  String get aidaDaenemarkSchweden {
    return Intl.message(
      'Denmark & Sweden',
      name: 'aidaDaenemarkSchweden',
      desc: '',
      args: [],
    );
  }

  /// `Experience fjords & coasts`
  String get aidaDaenemarkSchwedenSubtitle {
    return Intl.message(
      'Experience fjords & coasts',
      name: 'aidaDaenemarkSchwedenSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Metropolises`
  String get aidaMetropolen {
    return Intl.message(
      'Metropolises',
      name: 'aidaMetropolen',
      desc: '',
      args: [],
    );
  }

  /// `Our highlights`
  String get aidaMetropolenSubtitle {
    return Intl.message(
      'Our highlights',
      name: 'aidaMetropolenSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Spain & Portugal`
  String get aidaSpanienPortugal {
    return Intl.message(
      'Spain & Portugal',
      name: 'aidaSpanienPortugal',
      desc: '',
      args: [],
    );
  }

  /// `Discover sun & culture`
  String get aidaSpanienPortugalSubtitle {
    return Intl.message(
      'Discover sun & culture',
      name: 'aidaSpanienPortugalSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Caribbean Islands`
  String get aidaKaribik {
    return Intl.message(
      'Caribbean Islands',
      name: 'aidaKaribik',
      desc: '',
      args: [],
    );
  }

  /// `Our highlights`
  String get aidaKaribikSubtitle {
    return Intl.message(
      'Our highlights',
      name: 'aidaKaribikSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Norwegian Fjords`
  String get aidaNorwegensFjorde {
    return Intl.message(
      'Norwegian Fjords',
      name: 'aidaNorwegensFjorde',
      desc: '',
      args: [],
    );
  }

  /// `Magic of the North`
  String get aidaNorwegensFjordeSubtitle {
    return Intl.message(
      'Magic of the North',
      name: 'aidaNorwegensFjordeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Mediterranean Treasures with Corsica`
  String get aidaMediterraneMitKorsika {
    return Intl.message(
      'Mediterranean Treasures with Corsica',
      name: 'aidaMediterraneMitKorsika',
      desc: '',
      args: [],
    );
  }

  /// `Coast full of wonders`
  String get aidaMediterraneMitKorsikaSubtitle {
    return Intl.message(
      'Coast full of wonders',
      name: 'aidaMediterraneMitKorsikaSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Norwegian Fjords with Geiranger & Trondheim`
  String get aidaNorwegensFjordeGeiranger {
    return Intl.message(
      'Norwegian Fjords with Geiranger & Trondheim',
      name: 'aidaNorwegensFjordeGeiranger',
      desc: '',
      args: [],
    );
  }

  /// `Majestic fjords`
  String get aidaNorwegensFjordeGeirangerSubtitle {
    return Intl.message(
      'Majestic fjords',
      name: 'aidaNorwegensFjordeGeirangerSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Manage Premium`
  String get premiumTitle {
    return Intl.message(
      'Manage Premium',
      name: 'premiumTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your Premium Benefits at a Glance`
  String get premiumBenefitsTitle {
    return Intl.message(
      'Your Premium Benefits at a Glance',
      name: 'premiumBenefitsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Access to all travel journals from MamaTochterOnTour`
  String get premiumBenefit1 {
    return Intl.message(
      'Access to all travel journals from MamaTochterOnTour',
      name: 'premiumBenefit1',
      desc: '',
      args: [],
    );
  }

  /// `Includes insider tips for each location`
  String get premiumBenefit2 {
    return Intl.message(
      'Includes insider tips for each location',
      name: 'premiumBenefit2',
      desc: '',
      args: [],
    );
  }

  /// `Create a packing list for your trips`
  String get premiumBenefit3 {
    return Intl.message(
      'Create a packing list for your trips',
      name: 'premiumBenefit3',
      desc: '',
      args: [],
    );
  }

  /// `Travel countdown for your next trip`
  String get premiumBenefit4 {
    return Intl.message(
      'Travel countdown for your next trip',
      name: 'premiumBenefit4',
      desc: '',
      args: [],
    );
  }

  /// `Save posts`
  String get premiumBenefit5 {
    return Intl.message(
      'Save posts',
      name: 'premiumBenefit5',
      desc: '',
      args: [],
    );
  }

  /// `✨More coming soon!\nWe are constantly working to make your travel experiences even better. Look forward to many new features, exclusive content, and exciting extras – all automatically included in the Premium subscription.`
  String get premiumComingSoon {
    return Intl.message(
      '✨More coming soon!\nWe are constantly working to make your travel experiences even better. Look forward to many new features, exclusive content, and exciting extras – all automatically included in the Premium subscription.',
      name: 'premiumComingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Your Subscription Status`
  String get premiumStatusTitle {
    return Intl.message(
      'Your Subscription Status',
      name: 'premiumStatusTitle',
      desc: '',
      args: [],
    );
  }

  /// `You are now a Premium member – all features unlocked!`
  String get premiumStatusActive {
    return Intl.message(
      'You are now a Premium member – all features unlocked!',
      name: 'premiumStatusActive',
      desc: '',
      args: [],
    );
  }

  /// `You are currently using the free version of the app.`
  String get premiumStatusInactive {
    return Intl.message(
      'You are currently using the free version of the app.',
      name: 'premiumStatusInactive',
      desc: '',
      args: [],
    );
  }

  /// `Premium Monthly`
  String get premiumMonthly {
    return Intl.message(
      'Premium Monthly',
      name: 'premiumMonthly',
      desc: '',
      args: [],
    );
  }

  /// `Premium Yearly`
  String get premiumYearly {
    return Intl.message(
      'Premium Yearly',
      name: 'premiumYearly',
      desc: '',
      args: [],
    );
  }

  /// `Restore Purchase`
  String get premiumRestoreButton {
    return Intl.message(
      'Restore Purchase',
      name: 'premiumRestoreButton',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get premiumPrivacy {
    return Intl.message(
      'Privacy Policy',
      name: 'premiumPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get premiumTerms {
    return Intl.message(
      'Terms of Service',
      name: 'premiumTerms',
      desc: '',
      args: [],
    );
  }

  /// `By subscribing, you agree to our`
  String get premiumLegalIntro {
    return Intl.message(
      'By subscribing, you agree to our',
      name: 'premiumLegalIntro',
      desc: '',
      args: [],
    );
  }

  /// `and`
  String get premiumLegalAnd {
    return Intl.message('and', name: 'premiumLegalAnd', desc: '', args: []);
  }

  /// `.`
  String get premiumLegalDot {
    return Intl.message('.', name: 'premiumLegalDot', desc: '', args: []);
  }

  /// `Best Price`
  String get premiumBestPrice {
    return Intl.message(
      'Best Price',
      name: 'premiumBestPrice',
      desc: '',
      args: [],
    );
  }

  /// `Buy`
  String get premiumBuyButton {
    return Intl.message('Buy', name: 'premiumBuyButton', desc: '', args: []);
  }

  /// `https://mamatochterontour.com/pages/datenschutzrichtlinie-von-momentry`
  String get premiumPrivacyUrl {
    return Intl.message(
      'https://mamatochterontour.com/pages/datenschutzrichtlinie-von-momentry',
      name: 'premiumPrivacyUrl',
      desc: '',
      args: [],
    );
  }

  /// `https://www.apple.com/legal/internet-services/itunes/dev/stdeula/`
  String get premiumTermsUrl {
    return Intl.message(
      'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/',
      name: 'premiumTermsUrl',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsTitle {
    return Intl.message('Settings', name: 'settingsTitle', desc: '', args: []);
  }

  /// `Account Settings`
  String get accountSettings {
    return Intl.message(
      'Account Settings',
      name: 'accountSettings',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message('Dark Mode', name: 'darkMode', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Reset Password`
  String get passwordReset {
    return Intl.message(
      'Reset Password',
      name: 'passwordReset',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get signOut {
    return Intl.message('Sign Out', name: 'signOut', desc: '', args: []);
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Legal & Help`
  String get legalHelp {
    return Intl.message('Legal & Help', name: 'legalHelp', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Conditions`
  String get termsConditions {
    return Intl.message(
      'Terms & Conditions',
      name: 'termsConditions',
      desc: '',
      args: [],
    );
  }

  /// `Contact & Feedback`
  String get contactFeedback {
    return Intl.message(
      'Contact & Feedback',
      name: 'contactFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Imprint`
  String get impressum {
    return Intl.message('Imprint', name: 'impressum', desc: '', args: []);
  }

  /// `App Version {version}`
  String appVersion(Object version) {
    return Intl.message(
      'App Version $version',
      name: 'appVersion',
      desc: '',
      args: [version],
    );
  }

  /// `Mode changed to {mode}`
  String darkModeChanged(Object mode) {
    return Intl.message(
      'Mode changed to $mode',
      name: 'darkModeChanged',
      desc: '',
      args: [mode],
    );
  }

  /// `Delete Account Permanently`
  String get passwordDialogTitle {
    return Intl.message(
      'Delete Account Permanently',
      name: 'passwordDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password to permanently delete your account.`
  String get passwordDialogDescription {
    return Intl.message(
      'Please enter your password to permanently delete your account.',
      name: 'passwordDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordDialogLabel {
    return Intl.message(
      'Password',
      name: 'passwordDialogLabel',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Do you really want to delete this post?`
  String get deleteConfirm {
    return Intl.message(
      'Do you really want to delete this post?',
      name: 'deleteConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Please sign in again to delete your account.`
  String get reauthOAuthError {
    return Intl.message(
      'Please sign in again to delete your account.',
      name: 'reauthOAuthError',
      desc: '',
      args: [],
    );
  }

  /// `Error while deleting`
  String deleteError(Object error) {
    return Intl.message(
      'Error while deleting',
      name: 'deleteError',
      desc: '',
      args: [error],
    );
  }

  /// `Password reset link sent via email!`
  String get passwordResetSuccess {
    return Intl.message(
      'Password reset link sent via email!',
      name: 'passwordResetSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Error: {error}`
  String error(Object error) {
    return Intl.message(
      'Error: $error',
      name: 'error',
      desc: '',
      args: [error],
    );
  }

  /// `Privacy Policy`
  String get privacyTitle {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy – Updated December 2025`
  String get privacyLastUpdated {
    return Intl.message(
      'Privacy Policy – Updated December 2025',
      name: 'privacyLastUpdated',
      desc: '',
      args: [],
    );
  }

  /// `This privacy policy informs you about the processing of your personal data when using our app.`
  String get privacyIntro {
    return Intl.message(
      'This privacy policy informs you about the processing of your personal data when using our app.',
      name: 'privacyIntro',
      desc: '',
      args: [],
    );
  }

  /// `1. Controller`
  String get privacySection1Title {
    return Intl.message(
      '1. Controller',
      name: 'privacySection1Title',
      desc: '',
      args: [],
    );
  }

  /// `Name: Jenny Weinreich\nAddress: Stettiner Straße 41, 35410 Hungen\nEmail: mamatochterontour@outlook.de`
  String get privacySection1Content {
    return Intl.message(
      'Name: Jenny Weinreich\nAddress: Stettiner Straße 41, 35410 Hungen\nEmail: mamatochterontour@outlook.de',
      name: 'privacySection1Content',
      desc: '',
      args: [],
    );
  }

  /// `2. Collected Data`
  String get privacySection2Title {
    return Intl.message(
      '2. Collected Data',
      name: 'privacySection2Title',
      desc: '',
      args: [],
    );
  }

  /// `We collect the following data:\n• Name and email address\n• Profile picture\n• Your posts and diary entries\n• Saved tips\n• Timestamps and activities within the app`
  String get privacySection2Content {
    return Intl.message(
      'We collect the following data:\n• Name and email address\n• Profile picture\n• Your posts and diary entries\n• Saved tips\n• Timestamps and activities within the app',
      name: 'privacySection2Content',
      desc: '',
      args: [],
    );
  }

  /// `3. Purpose of Data Processing`
  String get privacySection3Title {
    return Intl.message(
      '3. Purpose of Data Processing',
      name: 'privacySection3Title',
      desc: '',
      args: [],
    );
  }

  /// `We process your data for the following purposes:\n• Account creation and management\n• Provision of app functionalities\n• Community features and sharing posts\n• Premium features within the app\n• Handling of in-app purchases`
  String get privacySection3Content {
    return Intl.message(
      'We process your data for the following purposes:\n• Account creation and management\n• Provision of app functionalities\n• Community features and sharing posts\n• Premium features within the app\n• Handling of in-app purchases',
      name: 'privacySection3Content',
      desc: '',
      args: [],
    );
  }

  /// `4. Legal Basis`
  String get privacySection4Title {
    return Intl.message(
      '4. Legal Basis',
      name: 'privacySection4Title',
      desc: '',
      args: [],
    );
  }

  /// `Processing is based on your consent (Art. 6(1)(a) GDPR) and for contract performance (Art. 6(1)(b) GDPR).`
  String get privacySection4Content {
    return Intl.message(
      'Processing is based on your consent (Art. 6(1)(a) GDPR) and for contract performance (Art. 6(1)(b) GDPR).',
      name: 'privacySection4Content',
      desc: '',
      args: [],
    );
  }

  /// `5. Data Transfer`
  String get privacySection5Title {
    return Intl.message(
      '5. Data Transfer',
      name: 'privacySection5Title',
      desc: '',
      args: [],
    );
  }

  /// `We use Google Firebase services (Firebase Authentication, Firestore, Storage, Analytics). Data is processed exclusively on servers in Germany.`
  String get privacySection5Content {
    return Intl.message(
      'We use Google Firebase services (Firebase Authentication, Firestore, Storage, Analytics). Data is processed exclusively on servers in Germany.',
      name: 'privacySection5Content',
      desc: '',
      args: [],
    );
  }

  /// `6. Storage Duration`
  String get privacySection6Title {
    return Intl.message(
      '6. Storage Duration',
      name: 'privacySection6Title',
      desc: '',
      args: [],
    );
  }

  /// `Your data is stored as long as your account is active or statutory retention periods exist. After deletion of your account, all personal data is removed.`
  String get privacySection6Content {
    return Intl.message(
      'Your data is stored as long as your account is active or statutory retention periods exist. After deletion of your account, all personal data is removed.',
      name: 'privacySection6Content',
      desc: '',
      args: [],
    );
  }

  /// `7. Your Rights`
  String get privacySection7Title {
    return Intl.message(
      '7. Your Rights',
      name: 'privacySection7Title',
      desc: '',
      args: [],
    );
  }

  /// `You have the following rights regarding your data:\n• Access to stored data\n• Correction of incorrect data\n• Deletion of your data\n• Data portability\n• Withdrawal of your consent`
  String get privacySection7Content {
    return Intl.message(
      'You have the following rights regarding your data:\n• Access to stored data\n• Correction of incorrect data\n• Deletion of your data\n• Data portability\n• Withdrawal of your consent',
      name: 'privacySection7Content',
      desc: '',
      args: [],
    );
  }

  /// `8. Premium Features`
  String get privacySection8Title {
    return Intl.message(
      '8. Premium Features',
      name: 'privacySection8Title',
      desc: '',
      args: [],
    );
  }

  /// `Premium features are handled via in-app purchases. For these transactions, the app’s privacy policy applies.`
  String get privacySection8Content {
    return Intl.message(
      'Premium features are handled via in-app purchases. For these transactions, the app’s privacy policy applies.',
      name: 'privacySection8Content',
      desc: '',
      args: [],
    );
  }

  /// `9. Contact`
  String get privacySection9Title {
    return Intl.message(
      '9. Contact',
      name: 'privacySection9Title',
      desc: '',
      args: [],
    );
  }

  /// `For questions regarding data protection, reach us at: mamatochterontour@outlook.de. We respond within one week.`
  String get privacySection9Content {
    return Intl.message(
      'For questions regarding data protection, reach us at: mamatochterontour@outlook.de. We respond within one week.',
      name: 'privacySection9Content',
      desc: '',
      args: [],
    );
  }

  /// `10. Right to Complain`
  String get privacySection10Title {
    return Intl.message(
      '10. Right to Complain',
      name: 'privacySection10Title',
      desc: '',
      args: [],
    );
  }

  /// `You have the right to lodge a complaint with a data protection supervisory authority regarding the processing of your data.`
  String get privacySection10Content {
    return Intl.message(
      'You have the right to lodge a complaint with a data protection supervisory authority regarding the processing of your data.',
      name: 'privacySection10Content',
      desc: '',
      args: [],
    );
  }

  /// `11. Changes to Privacy Policy`
  String get privacySection11Title {
    return Intl.message(
      '11. Changes to Privacy Policy',
      name: 'privacySection11Title',
      desc: '',
      args: [],
    );
  }

  /// `The privacy policy may be updated due to app changes or legal requirements. The current version is always available in the app.`
  String get privacySection11Content {
    return Intl.message(
      'The privacy policy may be updated due to app changes or legal requirements. The current version is always available in the app.',
      name: 'privacySection11Content',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get termsTitle {
    return Intl.message(
      'Terms and Conditions',
      name: 'termsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions – Updated December 2025`
  String get termsLastUpdated {
    return Intl.message(
      'Terms and Conditions – Updated December 2025',
      name: 'termsLastUpdated',
      desc: '',
      args: [],
    );
  }

  /// `1. Provider`
  String get terms1Title {
    return Intl.message('1. Provider', name: 'terms1Title', desc: '', args: []);
  }

  /// `Name: Jenny Weinreich\nAddress: Stettiner Straße 41, 35410 Hungen\nEmail: mamatochterontour@outlook.de\nVAT ID: DE441919331`
  String get terms1Content {
    return Intl.message(
      'Name: Jenny Weinreich\nAddress: Stettiner Straße 41, 35410 Hungen\nEmail: mamatochterontour@outlook.de\nVAT ID: DE441919331',
      name: 'terms1Content',
      desc: '',
      args: [],
    );
  }

  /// `2. Scope`
  String get terms2Title {
    return Intl.message('2. Scope', name: 'terms2Title', desc: '', args: []);
  }

  /// `These terms and conditions apply to the use of our travel community app. By registering, you fully accept these terms.`
  String get terms2Content {
    return Intl.message(
      'These terms and conditions apply to the use of our travel community app. By registering, you fully accept these terms.',
      name: 'terms2Content',
      desc: '',
      args: [],
    );
  }

  /// `3. Registration and User Account`
  String get terms3Title {
    return Intl.message(
      '3. Registration and User Account',
      name: 'terms3Title',
      desc: '',
      args: [],
    );
  }

  /// `• The app is only usable with registration.\n• You must provide truthful information.\n• Keep your password confidential.\n• You are responsible for all activities in your account.`
  String get terms3Content {
    return Intl.message(
      '• The app is only usable with registration.\n• You must provide truthful information.\n• Keep your password confidential.\n• You are responsible for all activities in your account.',
      name: 'terms3Content',
      desc: '',
      args: [],
    );
  }

  /// `4. Permitted Use`
  String get terms4Title {
    return Intl.message(
      '4. Permitted Use',
      name: 'terms4Title',
      desc: '',
      args: [],
    );
  }

  /// `• You may create travel diaries and posts.\n• Share your own travel tips.\n• Use the app for private, non-commercial purposes.`
  String get terms4Content {
    return Intl.message(
      '• You may create travel diaries and posts.\n• Share your own travel tips.\n• Use the app for private, non-commercial purposes.',
      name: 'terms4Content',
      desc: '',
      args: [],
    );
  }

  /// `5. Prohibited Content`
  String get terms5Title {
    return Intl.message(
      '5. Prohibited Content',
      name: 'terms5Title',
      desc: '',
      args: [],
    );
  }

  /// `The following content is not allowed:\n• Illegal, offensive, or discriminatory content\n• Spam or advertising without permission\n• Copyright infringement\n• False or misleading information\n• Content that could endanger other users`
  String get terms5Content {
    return Intl.message(
      'The following content is not allowed:\n• Illegal, offensive, or discriminatory content\n• Spam or advertising without permission\n• Copyright infringement\n• False or misleading information\n• Content that could endanger other users',
      name: 'terms5Content',
      desc: '',
      args: [],
    );
  }

  /// `6. Premium Membership`
  String get terms6Title {
    return Intl.message(
      '6. Premium Membership',
      name: 'terms6Title',
      desc: '',
      args: [],
    );
  }

  /// `Premium features within the app are paid and can be cancelled at any time.`
  String get terms6Content {
    return Intl.message(
      'Premium features within the app are paid and can be cancelled at any time.',
      name: 'terms6Content',
      desc: '',
      args: [],
    );
  }

  /// `7. Your Content`
  String get terms7Title {
    return Intl.message(
      '7. Your Content',
      name: 'terms7Title',
      desc: '',
      args: [],
    );
  }

  /// `• You retain rights to your content.\n• You grant us the right to display your content in the app.\n• You are responsible for the legality of your content.\n• Illegal content may be deleted without notice.`
  String get terms7Content {
    return Intl.message(
      '• You retain rights to your content.\n• You grant us the right to display your content in the app.\n• You are responsible for the legality of your content.\n• Illegal content may be deleted without notice.',
      name: 'terms7Content',
      desc: '',
      args: [],
    );
  }

  /// `8. Data Protection`
  String get terms8Title {
    return Intl.message(
      '8. Data Protection',
      name: 'terms8Title',
      desc: '',
      args: [],
    );
  }

  /// `Protecting your data is important to us. Details on data processing can be found in our Privacy Policy available in the app.`
  String get terms8Content {
    return Intl.message(
      'Protecting your data is important to us. Details on data processing can be found in our Privacy Policy available in the app.',
      name: 'terms8Content',
      desc: '',
      args: [],
    );
  }

  /// `9. Disclaimer`
  String get terms9Title {
    return Intl.message(
      '9. Disclaimer',
      name: 'terms9Title',
      desc: '',
      args: [],
    );
  }

  /// `• The app is provided without warranty.\n• User information does not reflect our opinion.\n• We are not liable for damages from app usage.\n• Travel information is without guarantee; verify it yourself.\n• We are fully liable in cases of intent or gross negligence.`
  String get terms9Content {
    return Intl.message(
      '• The app is provided without warranty.\n• User information does not reflect our opinion.\n• We are not liable for damages from app usage.\n• Travel information is without guarantee; verify it yourself.\n• We are fully liable in cases of intent or gross negligence.',
      name: 'terms9Content',
      desc: '',
      args: [],
    );
  }

  /// `10. Termination`
  String get terms10Title {
    return Intl.message(
      '10. Termination',
      name: 'terms10Title',
      desc: '',
      args: [],
    );
  }

  /// `• You can delete your account at any time in settings.\n• We may suspend or delete accounts in case of violations.\n• After deletion, your data will be handled according to the Privacy Policy.`
  String get terms10Content {
    return Intl.message(
      '• You can delete your account at any time in settings.\n• We may suspend or delete accounts in case of violations.\n• After deletion, your data will be handled according to the Privacy Policy.',
      name: 'terms10Content',
      desc: '',
      args: [],
    );
  }

  /// `11. Changes`
  String get terms11Title {
    return Intl.message(
      '11. Changes',
      name: 'terms11Title',
      desc: '',
      args: [],
    );
  }

  /// `We may change the terms and conditions. You will be informed about important changes in the app. In case of objection, you can delete your account.`
  String get terms11Content {
    return Intl.message(
      'We may change the terms and conditions. You will be informed about important changes in the app. In case of objection, you can delete your account.',
      name: 'terms11Content',
      desc: '',
      args: [],
    );
  }

  /// `12. Final Provisions`
  String get terms12Title {
    return Intl.message(
      '12. Final Provisions',
      name: 'terms12Title',
      desc: '',
      args: [],
    );
  }

  /// `German law applies. Jurisdiction as legally permitted. If individual provisions are invalid, the remaining provisions remain valid.`
  String get terms12Content {
    return Intl.message(
      'German law applies. Jurisdiction as legally permitted. If individual provisions are invalid, the remaining provisions remain valid.',
      name: 'terms12Content',
      desc: '',
      args: [],
    );
  }

  /// `13. Contact`
  String get terms13Title {
    return Intl.message(
      '13. Contact',
      name: 'terms13Title',
      desc: '',
      args: [],
    );
  }

  /// `For questions, please contact us at: mamatochterontour@outlook.de`
  String get terms13Content {
    return Intl.message(
      'For questions, please contact us at: mamatochterontour@outlook.de',
      name: 'terms13Content',
      desc: '',
      args: [],
    );
  }

  /// `Important notice: The terms and conditions are legally binding. Please read them carefully.`
  String get termsImportantNotice {
    return Intl.message(
      'Important notice: The terms and conditions are legally binding. Please read them carefully.',
      name: 'termsImportantNotice',
      desc: '',
      args: [],
    );
  }

  /// `Imprint`
  String get impressumTitle {
    return Intl.message('Imprint', name: 'impressumTitle', desc: '', args: []);
  }

  /// `Information according to §5 TMG`
  String get impressumHeader {
    return Intl.message(
      'Information according to §5 TMG',
      name: 'impressumHeader',
      desc: '',
      args: [],
    );
  }

  /// `Person responsible for the content of this app:`
  String get impressumResponsibleTitle {
    return Intl.message(
      'Person responsible for the content of this app:',
      name: 'impressumResponsibleTitle',
      desc: '',
      args: [],
    );
  }

  /// `Jenny Weinreich\nStettiner Straße 41\n35410 Hungen\nGermany\nEmail: mamatochterontour@outlook.de`
  String get impressumResponsibleContent {
    return Intl.message(
      'Jenny Weinreich\nStettiner Straße 41\n35410 Hungen\nGermany\nEmail: mamatochterontour@outlook.de',
      name: 'impressumResponsibleContent',
      desc: '',
      args: [],
    );
  }

  /// `VAT ID according to §27a of the German VAT Act:`
  String get impressumVatTitle {
    return Intl.message(
      'VAT ID according to §27a of the German VAT Act:',
      name: 'impressumVatTitle',
      desc: '',
      args: [],
    );
  }

  /// `DE441919331`
  String get impressumVatContent {
    return Intl.message(
      'DE441919331',
      name: 'impressumVatContent',
      desc: '',
      args: [],
    );
  }

  /// `Liability for content`
  String get impressumLiabilityContentTitle {
    return Intl.message(
      'Liability for content',
      name: 'impressumLiabilityContentTitle',
      desc: '',
      args: [],
    );
  }

  /// `We do not guarantee the timeliness, correctness, completeness or quality of the information provided.`
  String get impressumLiabilityContentContent {
    return Intl.message(
      'We do not guarantee the timeliness, correctness, completeness or quality of the information provided.',
      name: 'impressumLiabilityContentContent',
      desc: '',
      args: [],
    );
  }

  /// `Liability for links`
  String get impressumLiabilityLinksTitle {
    return Intl.message(
      'Liability for links',
      name: 'impressumLiabilityLinksTitle',
      desc: '',
      args: [],
    );
  }

  /// `Our app contains links to external third-party websites, over whose content we have no influence. The respective provider or operator of the pages is always responsible for the content of the linked pages.`
  String get impressumLiabilityLinksContent {
    return Intl.message(
      'Our app contains links to external third-party websites, over whose content we have no influence. The respective provider or operator of the pages is always responsible for the content of the linked pages.',
      name: 'impressumLiabilityLinksContent',
      desc: '',
      args: [],
    );
  }

  /// `Copyright`
  String get impressumCopyrightTitle {
    return Intl.message(
      'Copyright',
      name: 'impressumCopyrightTitle',
      desc: '',
      args: [],
    );
  }

  /// `The content and works created through the app are subject to German copyright law. Reproduction, editing, distribution and any kind of use outside the limits of copyright require the written consent of the respective author or creator.`
  String get impressumCopyrightContent {
    return Intl.message(
      'The content and works created through the app are subject to German copyright law. Reproduction, editing, distribution and any kind of use outside the limits of copyright require the written consent of the respective author or creator.',
      name: 'impressumCopyrightContent',
      desc: '',
      args: [],
    );
  }

  /// `Dispute resolution`
  String get impressumDisputeTitle {
    return Intl.message(
      'Dispute resolution',
      name: 'impressumDisputeTitle',
      desc: '',
      args: [],
    );
  }

  /// `The European Commission has discontinued the online dispute resolution (ODR) platform as of 31.12.2023.\n\nWe do not participate in dispute resolution proceedings before a consumer arbitration board.`
  String get impressumDisputeContent {
    return Intl.message(
      'The European Commission has discontinued the online dispute resolution (ODR) platform as of 31.12.2023.\n\nWe do not participate in dispute resolution proceedings before a consumer arbitration board.',
      name: 'impressumDisputeContent',
      desc: '',
      args: [],
    );
  }

  /// `Status: December 2025`
  String get impressumStand {
    return Intl.message(
      'Status: December 2025',
      name: 'impressumStand',
      desc: '',
      args: [],
    );
  }

  /// `Contact & Feedback`
  String get feedbackTitle {
    return Intl.message(
      'Contact & Feedback',
      name: 'feedbackTitle',
      desc: '',
      args: [],
    );
  }

  /// `We’re happy to hear from you! Do you have questions or would you like to share feedback? Then you’re in the right place.`
  String get feedbackIntro {
    return Intl.message(
      'We’re happy to hear from you! Do you have questions or would you like to share feedback? Then you’re in the right place.',
      name: 'feedbackIntro',
      desc: '',
      args: [],
    );
  }

  /// `Name *`
  String get feedbackLabelName {
    return Intl.message(
      'Name *',
      name: 'feedbackLabelName',
      desc: '',
      args: [],
    );
  }

  /// `Email *`
  String get feedbackLabelEmail {
    return Intl.message(
      'Email *',
      name: 'feedbackLabelEmail',
      desc: '',
      args: [],
    );
  }

  /// `Suggestions for improvement`
  String get feedbackLabelImprovement {
    return Intl.message(
      'Suggestions for improvement',
      name: 'feedbackLabelImprovement',
      desc: '',
      args: [],
    );
  }

  /// `App feature requests`
  String get feedbackLabelWishes {
    return Intl.message(
      'App feature requests',
      name: 'feedbackLabelWishes',
      desc: '',
      args: [],
    );
  }

  /// `Other questions`
  String get feedbackLabelQuestions {
    return Intl.message(
      'Other questions',
      name: 'feedbackLabelQuestions',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your name`
  String get feedbackValidatorName {
    return Intl.message(
      'Please enter your name',
      name: 'feedbackValidatorName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get feedbackValidatorEmail {
    return Intl.message(
      'Please enter your email',
      name: 'feedbackValidatorEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in at least one message field`
  String get feedbackFillAtLeastOne {
    return Intl.message(
      'Please fill in at least one message field',
      name: 'feedbackFillAtLeastOne',
      desc: '',
      args: [],
    );
  }

  /// `Feedback from`
  String get feedbackSubject {
    return Intl.message(
      'Feedback from',
      name: 'feedbackSubject',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get feedbackBodyName {
    return Intl.message('Name', name: 'feedbackBodyName', desc: '', args: []);
  }

  /// `Email`
  String get feedbackBodyEmail {
    return Intl.message('Email', name: 'feedbackBodyEmail', desc: '', args: []);
  }

  /// `Suggestions for improvement`
  String get feedbackBodyImprovement {
    return Intl.message(
      'Suggestions for improvement',
      name: 'feedbackBodyImprovement',
      desc: '',
      args: [],
    );
  }

  /// `Requests`
  String get feedbackBodyWishes {
    return Intl.message(
      'Requests',
      name: 'feedbackBodyWishes',
      desc: '',
      args: [],
    );
  }

  /// `Other questions`
  String get feedbackBodyQuestions {
    return Intl.message(
      'Other questions',
      name: 'feedbackBodyQuestions',
      desc: '',
      args: [],
    );
  }

  /// `Unable to open email app`
  String get feedbackCannotOpenEmail {
    return Intl.message(
      'Unable to open email app',
      name: 'feedbackCannotOpenEmail',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get feedbackButtonSubmit {
    return Intl.message(
      'Submit',
      name: 'feedbackButtonSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Feed`
  String get feed {
    return Intl.message('Feed', name: 'feed', desc: '', args: []);
  }

  /// `Diary`
  String get diary {
    return Intl.message('Diary', name: 'diary', desc: '', args: []);
  }

  /// `Guides`
  String get guides {
    return Intl.message('Guides', name: 'guides', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Create Post`
  String get createPost {
    return Intl.message('Create Post', name: 'createPost', desc: '', args: []);
  }

  /// `Write Diary`
  String get writeDiary {
    return Intl.message('Write Diary', name: 'writeDiary', desc: '', args: []);
  }

  /// `Create Story`
  String get createStory {
    return Intl.message(
      'Create Story',
      name: 'createStory',
      desc: '',
      args: [],
    );
  }

  /// `Add Trip`
  String get addTrip {
    return Intl.message('Add Trip', name: 'addTrip', desc: '', args: []);
  }

  /// `Ask a Question`
  String get askQuestion {
    return Intl.message(
      'Ask a Question',
      name: 'askQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Destination`
  String get tripDestination {
    return Intl.message(
      'Destination',
      name: 'tripDestination',
      desc: '',
      args: [],
    );
  }

  /// `Select Start Date`
  String get selectStartDate {
    return Intl.message(
      'Select Start Date',
      name: 'selectStartDate',
      desc: '',
      args: [],
    );
  }

  /// `Select End Date`
  String get selectEndDate {
    return Intl.message(
      'Select End Date',
      name: 'selectEndDate',
      desc: '',
      args: [],
    );
  }

  /// `Start date`
  String get startDate {
    return Intl.message('Start date', name: 'startDate', desc: '', args: []);
  }

  /// `End date`
  String get endDate {
    return Intl.message('End date', name: 'endDate', desc: '', args: []);
  }

  /// `Please fill out all fields`
  String get fillAllFields {
    return Intl.message(
      'Please fill out all fields',
      name: 'fillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `You have reached the limit of 2 trips. Tap here to unlock Premium ✨`
  String get tripLimitReached {
    return Intl.message(
      'You have reached the limit of 2 trips. Tap here to unlock Premium ✨',
      name: 'tripLimitReached',
      desc: '',
      args: [],
    );
  }

  /// `Create Trip`
  String get createTrip {
    return Intl.message('Create Trip', name: 'createTrip', desc: '', args: []);
  }

  /// `Ask a Question`
  String get askQuestionTitle {
    return Intl.message(
      'Ask a Question',
      name: 'askQuestionTitle',
      desc: '',
      args: [],
    );
  }

  /// `✈️ Do you have a question about your trip?\n💬 Feel free to ask it on the Q&A board so other users can help you! 😊`
  String get askQuestionSubtitle {
    return Intl.message(
      '✈️ Do you have a question about your trip?\n💬 Feel free to ask it on the Q&A board so other users can help you! 😊',
      name: 'askQuestionSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your question here…`
  String get askQuestionHint {
    return Intl.message(
      'Enter your question here…',
      name: 'askQuestionHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a question!`
  String get enterQuestion {
    return Intl.message(
      'Please enter a question!',
      name: 'enterQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Save Question`
  String get saveQuestion {
    return Intl.message(
      'Save Question',
      name: 'saveQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Saving…`
  String get saving {
    return Intl.message('Saving…', name: 'saving', desc: '', args: []);
  }

  /// `Error saving: {error}`
  String saveError(Object error) {
    return Intl.message(
      'Error saving: $error',
      name: 'saveError',
      desc: '',
      args: [error],
    );
  }

  /// `Report User`
  String get reportUser {
    return Intl.message('Report User', name: 'reportUser', desc: '', args: []);
  }

  /// `Reason for report`
  String get reportReason {
    return Intl.message(
      'Reason for report',
      name: 'reportReason',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `User has been reported`
  String get userReported {
    return Intl.message(
      'User has been reported',
      name: 'userReported',
      desc: '',
      args: [],
    );
  }

  /// `User has been blocked and unfollowed`
  String get userBlocked {
    return Intl.message(
      'User has been blocked and unfollowed',
      name: 'userBlocked',
      desc: '',
      args: [],
    );
  }

  /// `User has been unblocked`
  String get userUnblocked {
    return Intl.message(
      'User has been unblocked',
      name: 'userUnblocked',
      desc: '',
      args: [],
    );
  }

  /// `Error while following/unfollowing`
  String get followError {
    return Intl.message(
      'Error while following/unfollowing',
      name: 'followError',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get user {
    return Intl.message('User', name: 'user', desc: '', args: []);
  }

  /// `No biography`
  String get noBio {
    return Intl.message('No biography', name: 'noBio', desc: '', args: []);
  }

  /// `Posts`
  String get posts {
    return Intl.message('Posts', name: 'posts', desc: '', args: []);
  }

  /// `Followers`
  String get followers {
    return Intl.message('Followers', name: 'followers', desc: '', args: []);
  }

  /// `Following`
  String get following {
    return Intl.message('Following', name: 'following', desc: '', args: []);
  }

  /// `Follow`
  String get followBtn {
    return Intl.message('Follow', name: 'followBtn', desc: '', args: []);
  }

  /// `Following`
  String get followingBtn {
    return Intl.message('Following', name: 'followingBtn', desc: '', args: []);
  }

  /// `Report`
  String get report {
    return Intl.message('Report', name: 'report', desc: '', args: []);
  }

  /// `Block`
  String get block {
    return Intl.message('Block', name: 'block', desc: '', args: []);
  }

  /// `Unblock`
  String get unblock {
    return Intl.message('Unblock', name: 'unblock', desc: '', args: []);
  }

  /// `Beitrag hochladen`
  String get uploadPost {
    return Intl.message(
      'Beitrag hochladen',
      name: 'uploadPost',
      desc: '',
      args: [],
    );
  }

  /// `Ort hinzufügen`
  String get addLocation {
    return Intl.message(
      'Ort hinzufügen',
      name: 'addLocation',
      desc: '',
      args: [],
    );
  }

  /// `Beschreibung`
  String get description {
    return Intl.message(
      'Beschreibung',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Hashtags`
  String get hashtags {
    return Intl.message('Hashtags', name: 'hashtags', desc: '', args: []);
  }

  /// `Beitrag veröffentlichen`
  String get publishPost {
    return Intl.message(
      'Beitrag veröffentlichen',
      name: 'publishPost',
      desc: '',
      args: [],
    );
  }

  /// `Maximal 10 Medien pro Beitrag erlaubt`
  String get maxMedia {
    return Intl.message(
      'Maximal 10 Medien pro Beitrag erlaubt',
      name: 'maxMedia',
      desc: '',
      args: [],
    );
  }

  /// `Fehler beim Hochladen`
  String get uploadError {
    return Intl.message(
      'Fehler beim Hochladen',
      name: 'uploadError',
      desc: '',
      args: [],
    );
  }

  /// `Bild zuschneiden`
  String get cropImage {
    return Intl.message(
      'Bild zuschneiden',
      name: 'cropImage',
      desc: '',
      args: [],
    );
  }

  /// `Travel Diary`
  String get travelDiary {
    return Intl.message(
      'Travel Diary',
      name: 'travelDiary',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Confirm Deletion`
  String get confirmDeleteTitle {
    return Intl.message(
      'Confirm Deletion',
      name: 'confirmDeleteTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this travel diary?`
  String get confirmDeleteText {
    return Intl.message(
      'Are you sure you want to delete this travel diary?',
      name: 'confirmDeleteText',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `Travel diary deleted successfully`
  String get diaryDeleted {
    return Intl.message(
      'Travel diary deleted successfully',
      name: 'diaryDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Travel diary not found`
  String get diaryNotFound {
    return Intl.message(
      'Travel diary not found',
      name: 'diaryNotFound',
      desc: '',
      args: [],
    );
  }

  /// `No stories available`
  String get noStories {
    return Intl.message(
      'No stories available',
      name: 'noStories',
      desc: '',
      args: [],
    );
  }

  /// `just now`
  String get justNow {
    return Intl.message('just now', name: 'justNow', desc: '', args: []);
  }

  /// `{count} minutes ago`
  String minutesAgo(Object count) {
    return Intl.message(
      '$count minutes ago',
      name: 'minutesAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count} hours ago`
  String hoursAgo(Object count) {
    return Intl.message(
      '$count hours ago',
      name: 'hoursAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count} days ago`
  String daysAgo(Object count) {
    return Intl.message(
      '$count days ago',
      name: 'daysAgo',
      desc: '',
      args: [count],
    );
  }

  /// `Pick an image or video …`
  String get pickMedia {
    return Intl.message(
      'Pick an image or video …',
      name: 'pickMedia',
      desc: '',
      args: [],
    );
  }

  /// `Enter text`
  String get enterText {
    return Intl.message('Enter text', name: 'enterText', desc: '', args: []);
  }

  /// `Pick a color`
  String get pickColor {
    return Intl.message('Pick a color', name: 'pickColor', desc: '', args: []);
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Story saved!`
  String get storySaved {
    return Intl.message('Story saved!', name: 'storySaved', desc: '', args: []);
  }

  /// `New Text`
  String get newText {
    return Intl.message('New Text', name: 'newText', desc: '', args: []);
  }

  /// `My Profile`
  String get myProfile {
    return Intl.message('My Profile', name: 'myProfile', desc: '', args: []);
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Journals`
  String get journals {
    return Intl.message('Journals', name: 'journals', desc: '', args: []);
  }

  /// `Planning`
  String get planning {
    return Intl.message('Planning', name: 'planning', desc: '', args: []);
  }

  /// `Travels`
  String get travel {
    return Intl.message('Travels', name: 'travel', desc: '', args: []);
  }

  /// `Contributions`
  String get contributions {
    return Intl.message(
      'Contributions',
      name: 'contributions',
      desc: '',
      args: [],
    );
  }

  /// `No journal created yet`
  String get noJournal {
    return Intl.message(
      'No journal created yet',
      name: 'noJournal',
      desc: '',
      args: [],
    );
  }

  /// `Write your first travel diary ✍️\n\nCapture your best experiences – including photos & videos.`
  String get noJournalMessage {
    return Intl.message(
      'Write your first travel diary ✍️\n\nCapture your best experiences – including photos & videos.',
      name: 'noJournalMessage',
      desc: '',
      args: [],
    );
  }

  /// `No post uploaded yet`
  String get noPost {
    return Intl.message(
      'No post uploaded yet',
      name: 'noPost',
      desc: '',
      args: [],
    );
  }

  /// `Upload your first post 🌍✨\n\nInspire others with your travels and favorite moments.`
  String get noPostMessage {
    return Intl.message(
      'Upload your first post 🌍✨\n\nInspire others with your travels and favorite moments.',
      name: 'noPostMessage',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get comments {
    return Intl.message('Comments', name: 'comments', desc: '', args: []);
  }

  /// `No comments yet`
  String get noComments {
    return Intl.message(
      'No comments yet',
      name: 'noComments',
      desc: '',
      args: [],
    );
  }

  /// `Edit Comment`
  String get editComment {
    return Intl.message(
      'Edit Comment',
      name: 'editComment',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Delete Comment`
  String get deleteComment {
    return Intl.message(
      'Delete Comment',
      name: 'deleteComment',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to delete this comment?`
  String get deleteCommentConfirm {
    return Intl.message(
      'Do you really want to delete this comment?',
      name: 'deleteCommentConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Reply`
  String get reply {
    return Intl.message('Reply', name: 'reply', desc: '', args: []);
  }

  /// `Replying to`
  String get replyTo {
    return Intl.message('Replying to', name: 'replyTo', desc: '', args: []);
  }

  /// `Write a comment...`
  String get writeComment {
    return Intl.message(
      'Write a comment...',
      name: 'writeComment',
      desc: '',
      args: [],
    );
  }

  /// `Write a reply...`
  String get writeReply {
    return Intl.message(
      'Write a reply...',
      name: 'writeReply',
      desc: '',
      args: [],
    );
  }

  /// `Comment has been reported`
  String get commentReported {
    return Intl.message(
      'Comment has been reported',
      name: 'commentReported',
      desc: '',
      args: [],
    );
  }

  /// `Post Details`
  String get postDetails {
    return Intl.message(
      'Post Details',
      name: 'postDetails',
      desc: '',
      args: [],
    );
  }

  /// `Report post`
  String get reportPost {
    return Intl.message('Report post', name: 'reportPost', desc: '', args: []);
  }

  /// `Reason for reporting`
  String get reportReasonHint {
    return Intl.message(
      'Reason for reporting',
      name: 'reportReasonHint',
      desc: '',
      args: [],
    );
  }

  /// `Post has been reported`
  String get reportedSuccess {
    return Intl.message(
      'Post has been reported',
      name: 'reportedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `{firstUser} {othersCount, plural, =0{likes this post} one{and other like this} other{and others like this}}`
  String likesCount(Object firstUser, num othersCount) {
    return Intl.message(
      '$firstUser ${Intl.plural(othersCount, zero: 'likes this post', one: 'and other like this', other: 'and others like this')}',
      name: 'likesCount',
      desc: '',
      args: [firstUser, othersCount],
    );
  }

  /// `You are not a premium member and cannot save posts. Tap here to upgrade ✨`
  String get premiumMessage {
    return Intl.message(
      'You are not a premium member and cannot save posts. Tap here to upgrade ✨',
      name: 'premiumMessage',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get editPost {
    return Intl.message('Edit', name: 'editPost', desc: '', args: []);
  }

  /// `Delete Post`
  String get deletePost {
    return Intl.message('Delete Post', name: 'deletePost', desc: '', args: []);
  }

  /// `Do you really want to delete this post?`
  String get deletePostConfirm {
    return Intl.message(
      'Do you really want to delete this post?',
      name: 'deletePostConfirm',
      desc: '',
      args: [],
    );
  }

  /// `You are not a premium member and cannot save posts. Tap here to unlock Premium ✨`
  String get premiumSavePost {
    return Intl.message(
      'You are not a premium member and cannot save posts. Tap here to unlock Premium ✨',
      name: 'premiumSavePost',
      desc: '',
      args: [],
    );
  }

  /// `Post was been reported`
  String get postReported {
    return Intl.message(
      'Post was been reported',
      name: 'postReported',
      desc: '',
      args: [],
    );
  }

  /// `New Travel Diary`
  String get newTravelDiary {
    return Intl.message(
      'New Travel Diary',
      name: 'newTravelDiary',
      desc: '',
      args: [],
    );
  }

  /// `Trip Title`
  String get tripTitle {
    return Intl.message('Trip Title', name: 'tripTitle', desc: '', args: []);
  }

  /// `Diary Entry`
  String get diaryEntry {
    return Intl.message('Diary Entry', name: 'diaryEntry', desc: '', args: []);
  }

  /// `Select Image`
  String get selectImage {
    return Intl.message(
      'Select Image',
      name: 'selectImage',
      desc: '',
      args: [],
    );
  }

  /// `Select Video`
  String get selectVideo {
    return Intl.message(
      'Select Video',
      name: 'selectVideo',
      desc: '',
      args: [],
    );
  }

  /// `Save Travel Diary`
  String get saveDiary {
    return Intl.message(
      'Save Travel Diary',
      name: 'saveDiary',
      desc: '',
      args: [],
    );
  }

  /// `Our Mallorca Adventure ☀️`
  String get mallorcaHeroText {
    return Intl.message(
      'Our Mallorca Adventure ☀️',
      name: 'mallorcaHeroText',
      desc: '',
      args: [],
    );
  }

  /// `Mallorca Feed`
  String get mallorcaFeed {
    return Intl.message(
      'Mallorca Feed',
      name: 'mallorcaFeed',
      desc: '',
      args: [],
    );
  }

  /// `Our daily experiences`
  String get mallorcaFeedSubtitle {
    return Intl.message(
      'Our daily experiences',
      name: 'mallorcaFeedSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Insider Tips`
  String get insiderTips {
    return Intl.message(
      'Insider Tips',
      name: 'insiderTips',
      desc: '',
      args: [],
    );
  }

  /// `Our secret spots`
  String get insiderTipsSubtitle {
    return Intl.message(
      'Our secret spots',
      name: 'insiderTipsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Mallorca Map`
  String get mallorcaMap {
    return Intl.message(
      'Mallorca Map',
      name: 'mallorcaMap',
      desc: '',
      args: [],
    );
  }

  /// `All locations on a map`
  String get mallorcaMapSubtitle {
    return Intl.message(
      'All locations on a map',
      name: 'mallorcaMapSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Checklist`
  String get checklist {
    return Intl.message('Checklist', name: 'checklist', desc: '', args: []);
  }

  /// `Must-dos in Mallorca`
  String get checklistSubtitle {
    return Intl.message(
      'Must-dos in Mallorca',
      name: 'checklistSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Mini Guides`
  String get miniGuides {
    return Intl.message('Mini Guides', name: 'miniGuides', desc: '', args: []);
  }

  /// `Short travel guides`
  String get miniGuidesSubtitle {
    return Intl.message(
      'Short travel guides',
      name: 'miniGuidesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Our Story`
  String get ourStory {
    return Intl.message('Our Story', name: 'ourStory', desc: '', args: []);
  }

  /// `Experience our journey`
  String get ourStorySubtitle {
    return Intl.message(
      'Experience our journey',
      name: 'ourStorySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `This feature is coming soon!`
  String get comingSoon {
    return Intl.message(
      'This feature is coming soon!',
      name: 'comingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Error loading theme`
  String get themeLoadError {
    return Intl.message(
      'Error loading theme',
      name: 'themeLoadError',
      desc: '',
      args: [],
    );
  }

  /// `Edit Travel Diary`
  String get editTravelDiaryTitle {
    return Intl.message(
      'Edit Travel Diary',
      name: 'editTravelDiaryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Travel diary updated successfully`
  String get diaryUpdated {
    return Intl.message(
      'Travel diary updated successfully',
      name: 'diaryUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfileTitle {
    return Intl.message(
      'Edit Profile',
      name: 'editProfileTitle',
      desc: '',
      args: [],
    );
  }

  /// `Change Profile Picture`
  String get changeProfilePicture {
    return Intl.message(
      'Change Profile Picture',
      name: 'changeProfilePicture',
      desc: '',
      args: [],
    );
  }

  /// `Save Profile Picture`
  String get saveProfilePicture {
    return Intl.message(
      'Save Profile Picture',
      name: 'saveProfilePicture',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message('Username', name: 'username', desc: '', args: []);
  }

  /// `Your username`
  String get usernameHint {
    return Intl.message(
      'Your username',
      name: 'usernameHint',
      desc: '',
      args: [],
    );
  }

  /// `Save Username`
  String get saveUsername {
    return Intl.message(
      'Save Username',
      name: 'saveUsername',
      desc: '',
      args: [],
    );
  }

  /// `Bio`
  String get bio {
    return Intl.message('Bio', name: 'bio', desc: '', args: []);
  }

  /// `Your biography`
  String get bioHint {
    return Intl.message('Your biography', name: 'bioHint', desc: '', args: []);
  }

  /// `Save Bio`
  String get saveBio {
    return Intl.message('Save Bio', name: 'saveBio', desc: '', args: []);
  }

  /// `Profile picture saved successfully`
  String get profilePictureSaved {
    return Intl.message(
      'Profile picture saved successfully',
      name: 'profilePictureSaved',
      desc: '',
      args: [],
    );
  }

  /// `Error uploading profile picture`
  String get profilePictureUploadError {
    return Intl.message(
      'Error uploading profile picture',
      name: 'profilePictureUploadError',
      desc: '',
      args: [],
    );
  }

  /// `Username saved successfully`
  String get usernameSaved {
    return Intl.message(
      'Username saved successfully',
      name: 'usernameSaved',
      desc: '',
      args: [],
    );
  }

  /// `Error saving username`
  String get usernameSaveError {
    return Intl.message(
      'Error saving username',
      name: 'usernameSaveError',
      desc: '',
      args: [],
    );
  }

  /// `Bio saved successfully`
  String get bioSaved {
    return Intl.message(
      'Bio saved successfully',
      name: 'bioSaved',
      desc: '',
      args: [],
    );
  }

  /// `Error saving bio`
  String get bioSaveError {
    return Intl.message(
      'Error saving bio',
      name: 'bioSaveError',
      desc: '',
      args: [],
    );
  }

  /// `Error loading profile data`
  String get profileDataLoadError {
    return Intl.message(
      'Error loading profile data',
      name: 'profileDataLoadError',
      desc: '',
      args: [],
    );
  }

  /// `Edit Post`
  String get editPostTitle {
    return Intl.message('Edit Post', name: 'editPostTitle', desc: '', args: []);
  }

  /// `Caption`
  String get caption {
    return Intl.message('Caption', name: 'caption', desc: '', args: []);
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Crop Image`
  String get imageCropTitle {
    return Intl.message(
      'Crop Image',
      name: 'imageCropTitle',
      desc: '',
      args: [],
    );
  }

  /// `Post successfully updated`
  String get postUpdateSuccess {
    return Intl.message(
      'Post successfully updated',
      name: 'postUpdateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Error saving post`
  String get postUpdateError {
    return Intl.message(
      'Error saving post',
      name: 'postUpdateError',
      desc: '',
      args: [],
    );
  }

  /// `No trips planned yet ✈️`
  String get noTripsPlanned {
    return Intl.message(
      'No trips planned yet ✈️',
      name: 'noTripsPlanned',
      desc: '',
      args: [],
    );
  }

  /// `Years`
  String get years {
    return Intl.message('Years', name: 'years', desc: '', args: []);
  }

  /// `Days`
  String get days {
    return Intl.message('Days', name: 'days', desc: '', args: []);
  }

  /// `Hrs`
  String get hoursShort {
    return Intl.message('Hrs', name: 'hoursShort', desc: '', args: []);
  }

  /// `Min`
  String get minutesShort {
    return Intl.message('Min', name: 'minutesShort', desc: '', args: []);
  }

  /// `Sec`
  String get secondsShort {
    return Intl.message('Sec', name: 'secondsShort', desc: '', args: []);
  }

  /// `Edit trip`
  String get editTrip {
    return Intl.message('Edit trip', name: 'editTrip', desc: '', args: []);
  }

  /// `Trip name`
  String get tripName {
    return Intl.message('Trip name', name: 'tripName', desc: '', args: []);
  }

  /// `Delete trip?`
  String get deleteTripTitle {
    return Intl.message(
      'Delete trip?',
      name: 'deleteTripTitle',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to delete this trip? This cannot be undone.`
  String get deleteTripMessage {
    return Intl.message(
      'Do you really want to delete this trip? This cannot be undone.',
      name: 'deleteTripMessage',
      desc: '',
      args: [],
    );
  }

  /// `Trip not found`
  String get tripNotFound {
    return Intl.message(
      'Trip not found',
      name: 'tripNotFound',
      desc: '',
      args: [],
    );
  }

  /// `To-dos`
  String get todos {
    return Intl.message('To-dos', name: 'todos', desc: '', args: []);
  }

  /// `Packing list`
  String get packingList {
    return Intl.message(
      'Packing list',
      name: 'packingList',
      desc: '',
      args: [],
    );
  }

  /// `Budget`
  String get budget {
    return Intl.message('Budget', name: 'budget', desc: '', args: []);
  }

  /// `Notes`
  String get notes {
    return Intl.message('Notes', name: 'notes', desc: '', args: []);
  }

  /// `Contacts`
  String get contacts {
    return Intl.message('Contacts', name: 'contacts', desc: '', args: []);
  }

  /// `My packing list`
  String get myPackingList {
    return Intl.message(
      'My packing list',
      name: 'myPackingList',
      desc: '',
      args: [],
    );
  }

  /// `No title`
  String get noTitle {
    return Intl.message('No title', name: 'noTitle', desc: '', args: []);
  }

  /// `To-Do List`
  String get todoTitle {
    return Intl.message('To-Do List', name: 'todoTitle', desc: '', args: []);
  }

  /// `Enter item...`
  String get todoHint {
    return Intl.message('Enter item...', name: 'todoHint', desc: '', args: []);
  }

  /// `To-dos saved!`
  String get todosSaved {
    return Intl.message(
      'To-dos saved!',
      name: 'todosSaved',
      desc: '',
      args: [],
    );
  }

  /// `You are not a premium member and can only add up to 5 to-do items. Tap here to unlock premium ✨`
  String get premiumTodoLimit {
    return Intl.message(
      'You are not a premium member and can only add up to 5 to-do items. Tap here to unlock premium ✨',
      name: 'premiumTodoLimit',
      desc: '',
      args: [],
    );
  }

  /// `Error checking premium status: {error}`
  String premiumCheckError(Object error) {
    return Intl.message(
      'Error checking premium status: $error',
      name: 'premiumCheckError',
      desc: '',
      args: [error],
    );
  }

  /// `Error loading packing list: {error}`
  String packlistLoadError(Object error) {
    return Intl.message(
      'Error loading packing list: $error',
      name: 'packlistLoadError',
      desc: '',
      args: [error],
    );
  }

  /// `You can only add 5 items. Tap here to unlock premium! ✨`
  String get premiumItemLimit {
    return Intl.message(
      'You can only add 5 items. Tap here to unlock premium! ✨',
      name: 'premiumItemLimit',
      desc: '',
      args: [],
    );
  }

  /// `You can only add 2 categories. Tap here to unlock premium! ✨`
  String get premiumCategoryLimit {
    return Intl.message(
      'You can only add 2 categories. Tap here to unlock premium! ✨',
      name: 'premiumCategoryLimit',
      desc: '',
      args: [],
    );
  }

  /// `Add category`
  String get addCategoryTitle {
    return Intl.message(
      'Add category',
      name: 'addCategoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Category name`
  String get categoryNameHint {
    return Intl.message(
      'Category name',
      name: 'categoryNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Delete category`
  String get deleteCategoryTitle {
    return Intl.message(
      'Delete category',
      name: 'deleteCategoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this category?`
  String get deleteCategoryMessage {
    return Intl.message(
      'Are you sure you want to delete this category?',
      name: 'deleteCategoryMessage',
      desc: '',
      args: [],
    );
  }

  /// `You're fully packed, have a great trip! 🌍`
  String get packingDoneMessage {
    return Intl.message(
      'You\'re fully packed, have a great trip! 🌍',
      name: 'packingDoneMessage',
      desc: '',
      args: [],
    );
  }

  /// `{completed} of {total} items completed`
  String packingProgress(Object completed, Object total) {
    return Intl.message(
      '$completed of $total items completed',
      name: 'packingProgress',
      desc: '',
      args: [completed, total],
    );
  }

  /// `Rename category`
  String get editCategory {
    return Intl.message(
      'Rename category',
      name: 'editCategory',
      desc: '',
      args: [],
    );
  }

  /// `New name`
  String get newCategoryName {
    return Intl.message(
      'New name',
      name: 'newCategoryName',
      desc: '',
      args: [],
    );
  }

  /// `Add item...`
  String get itemHint {
    return Intl.message('Add item...', name: 'itemHint', desc: '', args: []);
  }

  /// `Add item`
  String get addItem {
    return Intl.message('Add item', name: 'addItem', desc: '', args: []);
  }

  /// `Add category`
  String get addCategory {
    return Intl.message(
      'Add category',
      name: 'addCategory',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get saveButton {
    return Intl.message('Save', name: 'saveButton', desc: '', args: []);
  }

  /// `Others`
  String get otherCategory {
    return Intl.message('Others', name: 'otherCategory', desc: '', args: []);
  }

  /// `Non-premium users can create only 2 notes. Tap here to unlock Premium!`
  String get noteLimitPremium {
    return Intl.message(
      'Non-premium users can create only 2 notes. Tap here to unlock Premium!',
      name: 'noteLimitPremium',
      desc: '',
      args: [],
    );
  }

  /// `Error saving note`
  String get noteSaveError {
    return Intl.message(
      'Error saving note',
      name: 'noteSaveError',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting note`
  String get noteDeleteError {
    return Intl.message(
      'Error deleting note',
      name: 'noteDeleteError',
      desc: '',
      args: [],
    );
  }

  /// `Please fill at least one field!`
  String get noteEmptyError {
    return Intl.message(
      'Please fill at least one field!',
      name: 'noteEmptyError',
      desc: '',
      args: [],
    );
  }

  /// `Trip Notes`
  String get tripNotesTitle {
    return Intl.message(
      'Trip Notes',
      name: 'tripNotesTitle',
      desc: '',
      args: [],
    );
  }

  /// `New Note`
  String get newNote {
    return Intl.message('New Note', name: 'newNote', desc: '', args: []);
  }

  /// `Edit Note`
  String get editNote {
    return Intl.message('Edit Note', name: 'editNote', desc: '', args: []);
  }

  /// `Title`
  String get titleLabel {
    return Intl.message('Title', name: 'titleLabel', desc: '', args: []);
  }

  /// `Content`
  String get contentLabel {
    return Intl.message('Content', name: 'contentLabel', desc: '', args: []);
  }

  /// `Delete`
  String get deleteButton {
    return Intl.message('Delete', name: 'deleteButton', desc: '', args: []);
  }

  /// `No notes yet 📝\n\nHere you can collect notes for your trip ✈️🏖️ – e.g. favorite restaurants, cool activities or ideas before and during your trip.`
  String get emptyNotesPlaceholder {
    return Intl.message(
      'No notes yet 📝\n\nHere you can collect notes for your trip ✈️🏖️ – e.g. favorite restaurants, cool activities or ideas before and during your trip.',
      name: 'emptyNotesPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Contacts`
  String get tripContactsTitle {
    return Intl.message(
      'Contacts',
      name: 'tripContactsTitle',
      desc: '',
      args: [],
    );
  }

  /// `New Contact`
  String get newContact {
    return Intl.message('New Contact', name: 'newContact', desc: '', args: []);
  }

  /// `Edit Contact`
  String get editContact {
    return Intl.message(
      'Edit Contact',
      name: 'editContact',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get nameLabel {
    return Intl.message('Name', name: 'nameLabel', desc: '', args: []);
  }

  /// `Phone Number`
  String get phoneLabel {
    return Intl.message('Phone Number', name: 'phoneLabel', desc: '', args: []);
  }

  /// `Category`
  String get categoryLabel {
    return Intl.message('Category', name: 'categoryLabel', desc: '', args: []);
  }

  /// `Please fill out all fields!`
  String get fillAllFieldsError {
    return Intl.message(
      'Please fill out all fields!',
      name: 'fillAllFieldsError',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelButton {
    return Intl.message('Cancel', name: 'cancelButton', desc: '', args: []);
  }

  /// `Delete Contact`
  String get deleteContactTitle {
    return Intl.message(
      'Delete Contact',
      name: 'deleteContactTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this contact?`
  String get deleteContactConfirmation {
    return Intl.message(
      'Are you sure you want to delete this contact?',
      name: 'deleteContactConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Could not start the call`
  String get callFailed {
    return Intl.message(
      'Could not start the call',
      name: 'callFailed',
      desc: '',
      args: [],
    );
  }

  /// `No contacts yet.`
  String get emptyContactsPlaceholder {
    return Intl.message(
      'No contacts yet.',
      name: 'emptyContactsPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Non-premium users can only create 2 budget categories. Tap here to unlock premium!`
  String get premiumLimitMessage {
    return Intl.message(
      'Non-premium users can only create 2 budget categories. Tap here to unlock premium!',
      name: 'premiumLimitMessage',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknownContact {
    return Intl.message('Unknown', name: 'unknownContact', desc: '', args: []);
  }

  /// `Emergency contact`
  String get emergencyContact {
    return Intl.message(
      'Emergency contact',
      name: 'emergencyContact',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get allFilter {
    return Intl.message('All', name: 'allFilter', desc: '', args: []);
  }

  /// `Error loading contacts`
  String get errorLoadingContacts {
    return Intl.message(
      'Error loading contacts',
      name: 'errorLoadingContacts',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get callAction {
    return Intl.message('Call', name: 'callAction', desc: '', args: []);
  }

  /// `Edit`
  String get editAction {
    return Intl.message('Edit', name: 'editAction', desc: '', args: []);
  }

  /// `Delete`
  String get deleteAction {
    return Intl.message('Delete', name: 'deleteAction', desc: '', args: []);
  }

  /// `Emergency`
  String get categoryEmergency {
    return Intl.message(
      'Emergency',
      name: 'categoryEmergency',
      desc: '',
      args: [],
    );
  }

  /// `Hotel`
  String get categoryHotel {
    return Intl.message('Hotel', name: 'categoryHotel', desc: '', args: []);
  }

  /// `Private`
  String get categoryPrivate {
    return Intl.message('Private', name: 'categoryPrivate', desc: '', args: []);
  }

  /// `Other`
  String get categoryOther {
    return Intl.message('Other', name: 'categoryOther', desc: '', args: []);
  }

  /// `Budget`
  String get budgetTitle {
    return Intl.message('Budget', name: 'budgetTitle', desc: '', args: []);
  }

  /// `You haven't created a budget yet.\nStart now and save for your dream vacation! 🏖️💰`
  String get noBudgetCreated {
    return Intl.message(
      'You haven\'t created a budget yet.\nStart now and save for your dream vacation! 🏖️💰',
      name: 'noBudgetCreated',
      desc: '',
      args: [],
    );
  }

  /// `Deposit – {category}`
  String addAmountDialogTitle(Object category) {
    return Intl.message(
      'Deposit – $category',
      name: 'addAmountDialogTitle',
      desc: '',
      args: [category],
    );
  }

  /// `Amount`
  String get amountLabel {
    return Intl.message('Amount', name: 'amountLabel', desc: '', args: []);
  }

  /// `Add`
  String get addButton {
    return Intl.message('Add', name: 'addButton', desc: '', args: []);
  }

  /// `Edit Deposit`
  String get editDepositTitle {
    return Intl.message(
      'Edit Deposit',
      name: 'editDepositTitle',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Input`
  String get invalidInputTitle {
    return Intl.message(
      'Invalid Input',
      name: 'invalidInputTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a category and a valid amount.`
  String get invalidInputMessage {
    return Intl.message(
      'Please enter a category and a valid amount.',
      name: 'invalidInputMessage',
      desc: '',
      args: [],
    );
  }

  /// `⚠️ Goal exceeded!\nYou deposited {diff} € too much.`
  String goalExceededMessage(Object diff) {
    return Intl.message(
      '⚠️ Goal exceeded!\nYou deposited $diff € too much.',
      name: 'goalExceededMessage',
      desc: '',
      args: [diff],
    );
  }

  /// `Delete`
  String get deleteMenuItem {
    return Intl.message('Delete', name: 'deleteMenuItem', desc: '', args: []);
  }

  /// `Edit`
  String get editMenuItem {
    return Intl.message('Edit', name: 'editMenuItem', desc: '', args: []);
  }

  /// `Deposits:`
  String get depositsLabel {
    return Intl.message('Deposits:', name: 'depositsLabel', desc: '', args: []);
  }

  /// `Add category to budget planner`
  String get addBudgetCategorySheetTitle {
    return Intl.message(
      'Add category to budget planner',
      name: 'addBudgetCategorySheetTitle',
      desc: '',
      args: [],
    );
  }

  /// `Target amount`
  String get targetAmountLabel {
    return Intl.message(
      'Target amount',
      name: 'targetAmountLabel',
      desc: '',
      args: [],
    );
  }

  /// `Saving…`
  String get savingIndicator {
    return Intl.message('Saving…', name: 'savingIndicator', desc: '', args: []);
  }

  /// `Add category`
  String get addCategoryButton {
    return Intl.message(
      'Add category',
      name: 'addCategoryButton',
      desc: '',
      args: [],
    );
  }

  /// `⚠️ Goal exceeded`
  String get goalExceeded {
    return Intl.message(
      '⚠️ Goal exceeded',
      name: 'goalExceeded',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get meldButton {
    return Intl.message('Report', name: 'meldButton', desc: '', args: []);
  }

  /// `Edit`
  String get editButton {
    return Intl.message('Edit', name: 'editButton', desc: '', args: []);
  }

  /// `Write a reply...`
  String get writeReplyHint {
    return Intl.message(
      'Write a reply...',
      name: 'writeReplyHint',
      desc: '',
      args: [],
    );
  }

  /// `Write a comment...`
  String get writeCommentHint {
    return Intl.message(
      'Write a comment...',
      name: 'writeCommentHint',
      desc: '',
      args: [],
    );
  }

  /// `Reply to {username}`
  String replyingTo(Object username) {
    return Intl.message(
      'Reply to $username',
      name: 'replyingTo',
      desc: '',
      args: [username],
    );
  }

  /// `Delete comment`
  String get deleteCommentTitle {
    return Intl.message(
      'Delete comment',
      name: 'deleteCommentTitle',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to delete this comment?`
  String get deleteCommentContent {
    return Intl.message(
      'Do you really want to delete this comment?',
      name: 'deleteCommentContent',
      desc: '',
      args: [],
    );
  }

  /// `You are not a premium member and cannot save posts. Tap here to unlock Premium ✨`
  String get premiumSaveWarning {
    return Intl.message(
      'You are not a premium member and cannot save posts. Tap here to unlock Premium ✨',
      name: 'premiumSaveWarning',
      desc: '',
      args: [],
    );
  }

  /// `{firstUsername} likes this post`
  String likesTextSingle(Object firstUsername) {
    return Intl.message(
      '$firstUsername likes this post',
      name: 'likesTextSingle',
      desc: '',
      args: [firstUsername],
    );
  }

  /// `{firstUsername} and {othersCount} others like this post`
  String likesTextMultiple(Object firstUsername, Object othersCount) {
    return Intl.message(
      '$firstUsername and $othersCount others like this post',
      name: 'likesTextMultiple',
      desc: '',
      args: [firstUsername, othersCount],
    );
  }

  /// `{count, plural, =0{No one likes this post} =1{{count} person likes this post} other{{count} people like this post}}`
  String likesCount2(int count) {
    return Intl.plural(
      count,
      zero: 'No one likes this post',
      one: '$count person likes this post',
      other: '$count people like this post',
      name: 'likesCount2',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{# day ago} other{# days ago}}`
  String timeAgoDays(num count) {
    return Intl.plural(
      count,
      one: '# day ago',
      other: '# days ago',
      name: 'timeAgoDays',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{# hour ago} other{# hours ago}}`
  String timeAgoHours(num count) {
    return Intl.plural(
      count,
      one: '# hour ago',
      other: '# hours ago',
      name: 'timeAgoHours',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{# minute ago} other{# minutes ago}}`
  String timeAgoMinutes(num count) {
    return Intl.plural(
      count,
      one: '# minute ago',
      other: '# minutes ago',
      name: 'timeAgoMinutes',
      desc: '',
      args: [count],
    );
  }

  /// `just now`
  String get timeAgoJustNow {
    return Intl.message('just now', name: 'timeAgoJustNow', desc: '', args: []);
  }

  /// `Enter new reply`
  String get enterNewReply {
    return Intl.message(
      'Enter new reply',
      name: 'enterNewReply',
      desc: '',
      args: [],
    );
  }

  /// `Edit reply`
  String get editReplyTitle {
    return Intl.message(
      'Edit reply',
      name: 'editReplyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter new question`
  String get enterNewQuestion {
    return Intl.message(
      'Enter new question',
      name: 'enterNewQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Edit question`
  String get editQuestion {
    return Intl.message(
      'Edit question',
      name: 'editQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Write an answer...`
  String get writeAnswer {
    return Intl.message(
      'Write an answer...',
      name: 'writeAnswer',
      desc: '',
      args: [],
    );
  }

  /// `💬 No questions have been asked yet.\nAsk the first question 😊`
  String get noQuestionsYet {
    return Intl.message(
      '💬 No questions have been asked yet.\nAsk the first question 😊',
      name: 'noQuestionsYet',
      desc: '',
      args: [],
    );
  }

  /// `Friends`
  String get feedFilterFriends {
    return Intl.message(
      'Friends',
      name: 'feedFilterFriends',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get feedFilterFavorites {
    return Intl.message(
      'Favorites',
      name: 'feedFilterFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Tips & Favorites`
  String get tipsAndFavorites {
    return Intl.message(
      'Tips & Favorites',
      name: 'tipsAndFavorites',
      desc: '',
      args: [],
    );
  }

  /// `No posts found`
  String get noPostsFound {
    return Intl.message(
      'No posts found',
      name: 'noPostsFound',
      desc: '',
      args: [],
    );
  }

  /// `Premium`
  String get premium {
    return Intl.message('Premium', name: 'premium', desc: '', args: []);
  }

  /// `Do you want to become a partner? Feel free to write us at {email}`
  String becomePartnerText(Object email) {
    return Intl.message(
      'Do you want to become a partner? Feel free to write us at $email',
      name: 'becomePartnerText',
      desc: 'Hint text for becoming a partner, with clickable email',
      args: [email],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
