// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de';

  static String m0(String category) => "Einzahlung – ${category}";

  static String m1(String version) => "App-Version ${version}";

  static String m2(String email) =>
      "Möchtest du auch Partner werden? Schreib uns gerne an ${email}";

  static String m3(String mode) => "Modus wurde auf ${mode} umgestellt";

  static String m4(String count) => "vor ${count} Tagen";

  static String m5(String error) => "Fehler beim Löschen";

  static String m6(String error) => "Fehler: ${error}";

  static String m7(String diff) =>
      "⚠️ Ziel überschritten!\nDu hast ${diff} € zu viel eingezahlt.";

  static String m8(String count) => "vor ${count} Stunden";

  static String m9(String firstUser, othersCount) =>
      "${firstUser} ${Intl.plural(othersCount, zero: 'gefällt der Beitrag', one: 'und weiteren gefällt der Beitrag', other: 'und weiteren gefällt der Beitrag')}";

  static String m10(int count) =>
      "${Intl.plural(count, zero: 'Niemandem gefällt dieser Beitrag', one: '${count} Person gefällt dieser Beitrag', other: '${count} Personen gefällt dieser Beitrag')}";

  static String m11(String firstUsername, othersCount) =>
      "${firstUsername} und ${othersCount} weiteren gefällt der Beitrag";

  static String m12(String firstUsername) =>
      "${firstUsername} gefällt der Beitrag";

  static String m13(String count) => "vor ${count} Minuten";

  static String m14(String completed, total) =>
      "${completed} von ${total} Items erledigt";

  static String m15(String error) =>
      "Fehler beim Laden der Packliste: ${error}";

  static String m16(String error) => "Fehler beim Prüfen von Premium: ${error}";

  static String m17(String username) => "Antwort an ${username}";

  static String m18(String error) => "Fehler beim Speichern: ${error}";

  static String m19(int count) =>
      "${Intl.plural(count, one: 'vor # Tag', other: 'vor # Tagen')}";

  static String m20(int count) =>
      "${Intl.plural(count, one: 'vor # Stunde', other: 'vor # Stunden')}";

  static String m21(int count) =>
      "${Intl.plural(count, one: 'vor # Minute', other: 'vor # Minuten')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accountSettings": MessageLookupByLibrary.simpleMessage(
      "Kontoeinstellungen",
    ),
    "add": MessageLookupByLibrary.simpleMessage("Hinzufügen"),
    "addAmountDialogTitle": m0,
    "addBudgetCategorySheetTitle": MessageLookupByLibrary.simpleMessage(
      "Kategorie zum Budgetplaner hinzufügen",
    ),
    "addButton": MessageLookupByLibrary.simpleMessage("Hinzufügen"),
    "addCategory": MessageLookupByLibrary.simpleMessage("Kategorie hinzufügen"),
    "addCategoryButton": MessageLookupByLibrary.simpleMessage(
      "Kategorie hinzufügen",
    ),
    "addCategoryTitle": MessageLookupByLibrary.simpleMessage(
      "Kategorie hinzufügen",
    ),
    "addItem": MessageLookupByLibrary.simpleMessage("Item hinzufügen"),
    "addLocation": MessageLookupByLibrary.simpleMessage("Ort hinzufügen"),
    "addTrip": MessageLookupByLibrary.simpleMessage("Reise hinzufügen"),
    "aidaCruisesSubtitle": MessageLookupByLibrary.simpleMessage(
      "Meeresabenteuer voller Magie 🌊💫",
    ),
    "aidaCruisesTitle": MessageLookupByLibrary.simpleMessage(
      "AIDA-Kreuzfahrten",
    ),
    "aidaDaenemarkSchweden": MessageLookupByLibrary.simpleMessage(
      "Dänemark & Schweden",
    ),
    "aidaDaenemarkSchwedenSubtitle": MessageLookupByLibrary.simpleMessage(
      "Fjorde & Küsten erleben",
    ),
    "aidaGridTitle": MessageLookupByLibrary.simpleMessage(
      "Unsere Kreuzfahrten",
    ),
    "aidaIntro": MessageLookupByLibrary.simpleMessage(
      "Unsere schönsten Erlebnisse auf hoher See ⛴️🌊\n\nWillkommen auf unserer Kreuzfahrt-Seite! Hier findest du all unsere besonderen Erinnerungen von unseren AIDA-Reisen, von der Karibik bis nach Norwegen. Jede Kreuzfahrt ist ein besonderes Abenteuer voller Entdeckungen, Genuss und Familienzeit auf dem Meer. ⚓",
    ),
    "aidaKaribik": MessageLookupByLibrary.simpleMessage("Karibische Inseln"),
    "aidaKaribikSubtitle": MessageLookupByLibrary.simpleMessage(
      "Unsere Highlights",
    ),
    "aidaMediterraneHighlights": MessageLookupByLibrary.simpleMessage(
      "Mediterrane Highlights",
    ),
    "aidaMediterraneHighlightsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Abenteuerliche Küsten",
    ),
    "aidaMediterraneMitKorsika": MessageLookupByLibrary.simpleMessage(
      "Mediterrane Schätze mit Korsika",
    ),
    "aidaMediterraneMitKorsikaSubtitle": MessageLookupByLibrary.simpleMessage(
      "Küste voller Wunder",
    ),
    "aidaMediterraneSchaetze": MessageLookupByLibrary.simpleMessage(
      "Mediterrane Schätze",
    ),
    "aidaMediterraneSchaetzeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Traumhafte Küsten erleben",
    ),
    "aidaMetropolen": MessageLookupByLibrary.simpleMessage("Metropolen"),
    "aidaMetropolenSubtitle": MessageLookupByLibrary.simpleMessage(
      "Unsere Highlights",
    ),
    "aidaNorwegensFjorde": MessageLookupByLibrary.simpleMessage(
      "Norwegens Fjorde",
    ),
    "aidaNorwegensFjordeGeiranger": MessageLookupByLibrary.simpleMessage(
      "Norwegens Fjorde mit Geiranger & Trondheim",
    ),
    "aidaNorwegensFjordeGeirangerSubtitle":
        MessageLookupByLibrary.simpleMessage("Majestätische Fjorde"),
    "aidaNorwegensFjordeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Magie des Nordens",
    ),
    "aidaOrient": MessageLookupByLibrary.simpleMessage("Orient"),
    "aidaOrientSubtitle": MessageLookupByLibrary.simpleMessage(
      "Abenteuer & Luxus",
    ),
    "aidaSpanienPortugal": MessageLookupByLibrary.simpleMessage(
      "Spanien & Portugal",
    ),
    "aidaSpanienPortugalSubtitle": MessageLookupByLibrary.simpleMessage(
      "Sonne & Kultur entdecken",
    ),
    "aidaTitle": MessageLookupByLibrary.simpleMessage("AIDA-Kreuzfahrten"),
    "allFilter": MessageLookupByLibrary.simpleMessage("Alle"),
    "amountLabel": MessageLookupByLibrary.simpleMessage("Betrag"),
    "appVersion": m1,
    "askQuestion": MessageLookupByLibrary.simpleMessage(
      "Frage zum Urlaub stellen",
    ),
    "askQuestionHint": MessageLookupByLibrary.simpleMessage(
      "Deine Frage hier eingeben…",
    ),
    "askQuestionSubtitle": MessageLookupByLibrary.simpleMessage(
      "✈️ Du hast eine Frage zu deiner Reise? \n💬 Stell deine Fragen gerne im Q&A-Board, damit andere Nutzer dir helfen können! 😊",
    ),
    "askQuestionTitle": MessageLookupByLibrary.simpleMessage("Frage stellen"),
    "auszeitenAmMeerIntro": MessageLookupByLibrary.simpleMessage(
      "Unsere schönsten Erlebnisse am Meer 🌊🌅💙\n\nSalzluft, Sonnenuntergänge und dieses Gefühl von Freiheit – das sind unsere liebsten Meeresmomente.",
    ),
    "auszeitenAmMeerTitle": MessageLookupByLibrary.simpleMessage(
      "Auszeiten am Meer",
    ),
    "becomePartnerText": m2,
    "berlinSubtitle": MessageLookupByLibrary.simpleMessage(
      "Hauptstadt & Geschichte",
    ),
    "berlinTitle": MessageLookupByLibrary.simpleMessage("Berlin"),
    "bio": MessageLookupByLibrary.simpleMessage("Biografie"),
    "bioHint": MessageLookupByLibrary.simpleMessage("Deine Biografie"),
    "bioSaveError": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Speichern der Biografie",
    ),
    "bioSaved": MessageLookupByLibrary.simpleMessage(
      "Biografie erfolgreich gespeichert",
    ),
    "block": MessageLookupByLibrary.simpleMessage("Blockieren"),
    "budget": MessageLookupByLibrary.simpleMessage("Budget"),
    "budgetTitle": MessageLookupByLibrary.simpleMessage("Budget"),
    "callAction": MessageLookupByLibrary.simpleMessage("Anrufen"),
    "callFailed": MessageLookupByLibrary.simpleMessage(
      "Anruf konnte nicht gestartet werden",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
    "cancelButton": MessageLookupByLibrary.simpleMessage("Abbrechen"),
    "caption": MessageLookupByLibrary.simpleMessage("Caption"),
    "categoryEmergency": MessageLookupByLibrary.simpleMessage("Notfall"),
    "categoryHotel": MessageLookupByLibrary.simpleMessage("Hotel"),
    "categoryLabel": MessageLookupByLibrary.simpleMessage("Kategorie"),
    "categoryNameHint": MessageLookupByLibrary.simpleMessage(
      "Name der Kategorie",
    ),
    "categoryOther": MessageLookupByLibrary.simpleMessage("Sonstiges"),
    "categoryPrivate": MessageLookupByLibrary.simpleMessage("Privat"),
    "changeProfilePicture": MessageLookupByLibrary.simpleMessage(
      "Profilbild ändern",
    ),
    "checklist": MessageLookupByLibrary.simpleMessage("Checkliste"),
    "checklistSubtitle": MessageLookupByLibrary.simpleMessage(
      "Must-Dos auf Mallorca",
    ),
    "cityGeiranger": MessageLookupByLibrary.simpleMessage("Geiranger"),
    "cityMallorca": MessageLookupByLibrary.simpleMessage("Mallorca"),
    "cityRome": MessageLookupByLibrary.simpleMessage("Rom"),
    "cityTripsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Zwischen Türmen, Cafés & Kopfsteinpflaster 🏰✨",
    ),
    "cityTripsTitle": MessageLookupByLibrary.simpleMessage("Städtereisen"),
    "comingSoon": MessageLookupByLibrary.simpleMessage(
      "Dieses Feature kommt bald!",
    ),
    "commentReported": MessageLookupByLibrary.simpleMessage(
      "Kommentar wurde gemeldet",
    ),
    "comments": MessageLookupByLibrary.simpleMessage("Kommentare"),
    "confirmDeleteText": MessageLookupByLibrary.simpleMessage(
      "Bist du dir sicher, dass du dieses Reisetagebuch löschen möchtest?",
    ),
    "confirmDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "Löschen bestätigen",
    ),
    "contactFeedback": MessageLookupByLibrary.simpleMessage(
      "Kontakt & Feedback",
    ),
    "contactTitle": MessageLookupByLibrary.simpleMessage("Kontakt & Beratung"),
    "contacts": MessageLookupByLibrary.simpleMessage("Kontakte"),
    "contentLabel": MessageLookupByLibrary.simpleMessage("Inhalt"),
    "contributions": MessageLookupByLibrary.simpleMessage("Beiträge"),
    "cotedazurSubtitle": MessageLookupByLibrary.simpleMessage(
      "Küste unserer Träume",
    ),
    "cotedazurTitle": MessageLookupByLibrary.simpleMessage("Côte d\'Azur"),
    "countryItaly": MessageLookupByLibrary.simpleMessage("Italien"),
    "countryNorway": MessageLookupByLibrary.simpleMessage("Norwegen"),
    "countrySpain": MessageLookupByLibrary.simpleMessage("Spanien"),
    "createPost": MessageLookupByLibrary.simpleMessage("Beitrag erstellen"),
    "createStory": MessageLookupByLibrary.simpleMessage("Story erstellen"),
    "createTrip": MessageLookupByLibrary.simpleMessage("Reise erstellen"),
    "cropImage": MessageLookupByLibrary.simpleMessage("Bild zuschneiden"),
    "darkMode": MessageLookupByLibrary.simpleMessage("Dark-Mode"),
    "darkModeChanged": m3,
    "days": MessageLookupByLibrary.simpleMessage("Tage"),
    "daysAgo": m4,
    "delete": MessageLookupByLibrary.simpleMessage("Löschen"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("Konto löschen"),
    "deleteAction": MessageLookupByLibrary.simpleMessage("Löschen"),
    "deleteButton": MessageLookupByLibrary.simpleMessage("Löschen"),
    "deleteCategoryMessage": MessageLookupByLibrary.simpleMessage(
      "Bist du sicher, dass du diese Kategorie löschen möchtest?",
    ),
    "deleteCategoryTitle": MessageLookupByLibrary.simpleMessage(
      "Kategorie löschen",
    ),
    "deleteComment": MessageLookupByLibrary.simpleMessage("Kommentar löschen"),
    "deleteCommentConfirm": MessageLookupByLibrary.simpleMessage(
      "Willst du diesen Kommentar wirklich löschen?",
    ),
    "deleteCommentContent": MessageLookupByLibrary.simpleMessage(
      "Willst du diesen Kommentar wirklich löschen?",
    ),
    "deleteCommentTitle": MessageLookupByLibrary.simpleMessage(
      "Kommentar löschen",
    ),
    "deleteConfirm": MessageLookupByLibrary.simpleMessage(
      "Willst du diesen Post wirklich löschen?",
    ),
    "deleteContactConfirmation": MessageLookupByLibrary.simpleMessage(
      "Bist du sicher, dass du diesen Kontakt löschen möchtest?",
    ),
    "deleteContactTitle": MessageLookupByLibrary.simpleMessage(
      "Kontakt löschen",
    ),
    "deleteError": m5,
    "deleteMenuItem": MessageLookupByLibrary.simpleMessage("Löschen"),
    "deletePost": MessageLookupByLibrary.simpleMessage("Post löschen"),
    "deletePostConfirm": MessageLookupByLibrary.simpleMessage(
      "Willst du diesen Post wirklich löschen?",
    ),
    "deleteTripMessage": MessageLookupByLibrary.simpleMessage(
      "Möchtest du diese Reise wirklich löschen? Dies kann nicht rückgängig gemacht werden.",
    ),
    "deleteTripTitle": MessageLookupByLibrary.simpleMessage("Reise löschen?"),
    "depositsLabel": MessageLookupByLibrary.simpleMessage("Einzahlungen:"),
    "descGeiranger": MessageLookupByLibrary.simpleMessage(
      "Spektakulärer Fjord, atemberaubende Wasserfälle und malerische Naturkulisse.",
    ),
    "descMallorca": MessageLookupByLibrary.simpleMessage(
      "Mediterrane Trauminsel mit weißen Sandstränden, imposanten Klippen, charmanten Dörfern und lebendigem Nachtleben.",
    ),
    "descRome": MessageLookupByLibrary.simpleMessage(
      "Historische Hauptstadt voller antiker Bauwerke, lebendiger Plätze, mediterraner Gassen und kulinarischer Genüsse.",
    ),
    "description": MessageLookupByLibrary.simpleMessage("Beschreibung"),
    "diary": MessageLookupByLibrary.simpleMessage("Tagebuch"),
    "diaryDeleted": MessageLookupByLibrary.simpleMessage(
      "Reisetagebuch erfolgreich gelöscht",
    ),
    "diaryEntry": MessageLookupByLibrary.simpleMessage("Tagebucheintrag"),
    "diaryNotFound": MessageLookupByLibrary.simpleMessage(
      "Reisetagebuch nicht gefunden",
    ),
    "diaryUpdated": MessageLookupByLibrary.simpleMessage(
      "Reisetagebuch erfolgreich aktualisiert",
    ),
    "disclaimer": MessageLookupByLibrary.simpleMessage(
      "Alle in dieser App gezeigten Inhalte und Bilder stammen entweder aus unseren privaten Reisen und persönlichen Erlebnissen oder aus ausdrücklich gekennzeichneten Kooperationen mit Partnerunternehmen.",
    ),
    "disclaimerPartner": MessageLookupByLibrary.simpleMessage(
      "Anzeige / Partnerreisebüro · Empfehlung von MamaTochterOnTour",
    ),
    "discoverAdventures": MessageLookupByLibrary.simpleMessage(
      "Entdecke unsere Abenteuer rund um die Welt",
    ),
    "dubaiSubtitle": MessageLookupByLibrary.simpleMessage(
      "Abenteuer zwischen Wüste & Skyline",
    ),
    "dubaiTitle": MessageLookupByLibrary.simpleMessage("Dubai"),
    "edit": MessageLookupByLibrary.simpleMessage("Bearbeiten"),
    "editAction": MessageLookupByLibrary.simpleMessage("Bearbeiten"),
    "editButton": MessageLookupByLibrary.simpleMessage("Bearbeiten"),
    "editCategory": MessageLookupByLibrary.simpleMessage(
      "Kategorie umbenennen",
    ),
    "editComment": MessageLookupByLibrary.simpleMessage("Kommentar bearbeiten"),
    "editContact": MessageLookupByLibrary.simpleMessage("Kontakt bearbeiten"),
    "editDepositTitle": MessageLookupByLibrary.simpleMessage(
      "Einzahlung bearbeiten",
    ),
    "editMenuItem": MessageLookupByLibrary.simpleMessage("Bearbeiten"),
    "editNote": MessageLookupByLibrary.simpleMessage("Notiz bearbeiten"),
    "editPost": MessageLookupByLibrary.simpleMessage("Bearbeiten"),
    "editPostTitle": MessageLookupByLibrary.simpleMessage("Beitrag bearbeiten"),
    "editProfile": MessageLookupByLibrary.simpleMessage("Profil bearbeiten"),
    "editProfileTitle": MessageLookupByLibrary.simpleMessage(
      "Profil bearbeiten",
    ),
    "editQuestion": MessageLookupByLibrary.simpleMessage("Frage bearbeiten"),
    "editReplyTitle": MessageLookupByLibrary.simpleMessage(
      "Antwort bearbeiten",
    ),
    "editTravelDiaryTitle": MessageLookupByLibrary.simpleMessage(
      "Reisetagebuch bearbeiten",
    ),
    "editTrip": MessageLookupByLibrary.simpleMessage("Reise bearbeiten"),
    "emailLabel": MessageLookupByLibrary.simpleMessage("E-Mail schreiben"),
    "emergencyContact": MessageLookupByLibrary.simpleMessage("Notfallkontakt"),
    "emptyContactsPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Noch keine Kontakte vorhanden.",
    ),
    "emptyNotesPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Noch keine Notizen vorhanden 📝\n\nHier kannst du Notizen zu deiner Reise\nsammeln ✈️🏖️ – z. B. Lieblingsrestaurants, coole Aktivitäten oder Ideen vor und während deiner Reise.",
    ),
    "endDate": MessageLookupByLibrary.simpleMessage("Enddatum"),
    "enterNewQuestion": MessageLookupByLibrary.simpleMessage(
      "Neue Frage eingeben",
    ),
    "enterNewReply": MessageLookupByLibrary.simpleMessage(
      "Neue Antwort eingeben",
    ),
    "enterQuestion": MessageLookupByLibrary.simpleMessage(
      "Bitte gib eine Frage ein!",
    ),
    "enterText": MessageLookupByLibrary.simpleMessage("Text eingeben"),
    "error": m6,
    "errorLoading": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Laden der Einstellungen",
    ),
    "errorLoadingContacts": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Laden der Kontakte",
    ),
    "featureCamper": MessageLookupByLibrary.simpleMessage("Camperreisen"),
    "featureCityTrips": MessageLookupByLibrary.simpleMessage("Städtetrips"),
    "featureClub": MessageLookupByLibrary.simpleMessage("Cluburlaub"),
    "featureCruises": MessageLookupByLibrary.simpleMessage("Kreuzfahrten"),
    "featureFamily": MessageLookupByLibrary.simpleMessage("Familienurlaub"),
    "featureHoneymoon": MessageLookupByLibrary.simpleMessage("Honeymoon"),
    "featureIndividual": MessageLookupByLibrary.simpleMessage(
      "Individualreisen",
    ),
    "featureLongHaul": MessageLookupByLibrary.simpleMessage("Fernreisen"),
    "featureLuxury": MessageLookupByLibrary.simpleMessage("Luxusurlaub"),
    "featurePackage": MessageLookupByLibrary.simpleMessage("Pauschalreisen"),
    "featureRoundTrips": MessageLookupByLibrary.simpleMessage("Rundreisen"),
    "featureWellness": MessageLookupByLibrary.simpleMessage("Wellnessurlaub"),
    "feed": MessageLookupByLibrary.simpleMessage("Feed"),
    "feedFilterFavorites": MessageLookupByLibrary.simpleMessage("Favoriten"),
    "feedFilterFriends": MessageLookupByLibrary.simpleMessage("Freunde"),
    "feedbackBodyEmail": MessageLookupByLibrary.simpleMessage("E-Mail"),
    "feedbackBodyImprovement": MessageLookupByLibrary.simpleMessage(
      "Verbesserungsvorschläge",
    ),
    "feedbackBodyName": MessageLookupByLibrary.simpleMessage("Name"),
    "feedbackBodyQuestions": MessageLookupByLibrary.simpleMessage(
      "Sonstige Fragen",
    ),
    "feedbackBodyWishes": MessageLookupByLibrary.simpleMessage("Wünsche"),
    "feedbackButtonSubmit": MessageLookupByLibrary.simpleMessage("Absenden"),
    "feedbackCannotOpenEmail": MessageLookupByLibrary.simpleMessage(
      "E-Mail konnte nicht geöffnet werden",
    ),
    "feedbackFillAtLeastOne": MessageLookupByLibrary.simpleMessage(
      "Bitte fülle mindestens ein Nachrichtenfeld aus",
    ),
    "feedbackIntro": MessageLookupByLibrary.simpleMessage(
      "Wir freuen uns auf dich! Du hast Fragen oder möchtest uns Feedback geben? Dann bist du hier genau richtig.",
    ),
    "feedbackLabelEmail": MessageLookupByLibrary.simpleMessage("E-Mail *"),
    "feedbackLabelImprovement": MessageLookupByLibrary.simpleMessage(
      "Verbesserungsvorschläge",
    ),
    "feedbackLabelName": MessageLookupByLibrary.simpleMessage("Name *"),
    "feedbackLabelQuestions": MessageLookupByLibrary.simpleMessage(
      "Sonstige Fragen",
    ),
    "feedbackLabelWishes": MessageLookupByLibrary.simpleMessage(
      "Wünsche für die App",
    ),
    "feedbackSubject": MessageLookupByLibrary.simpleMessage("Feedback von"),
    "feedbackTitle": MessageLookupByLibrary.simpleMessage("Kontakt & Feedback"),
    "feedbackValidatorEmail": MessageLookupByLibrary.simpleMessage(
      "Bitte E-Mail eingeben",
    ),
    "feedbackValidatorName": MessageLookupByLibrary.simpleMessage(
      "Bitte Name eingeben",
    ),
    "fernreisenGridTitle": MessageLookupByLibrary.simpleMessage(
      "Unsere Fernreisen",
    ),
    "fernreisenIntro": MessageLookupByLibrary.simpleMessage(
      "Unsere schönsten Erlebnisse in weiter Ferne ✈️🌍\nAbenteuer, Entdeckungen und unvergessliche Momente – lass dich inspirieren für deine nächste Reise!",
    ),
    "fernreisenTitle": MessageLookupByLibrary.simpleMessage("Fernreisen"),
    "fillAllFields": MessageLookupByLibrary.simpleMessage(
      "Bitte alle Felder ausfüllen",
    ),
    "fillAllFieldsError": MessageLookupByLibrary.simpleMessage(
      "Bitte alle Felder ausfüllen!",
    ),
    "floridaSubtitle": MessageLookupByLibrary.simpleMessage(
      "Roadtrip durchs Paradies",
    ),
    "floridaTitle": MessageLookupByLibrary.simpleMessage("Florida"),
    "followBtn": MessageLookupByLibrary.simpleMessage("Folgen"),
    "followError": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Folgen/Entfolgen",
    ),
    "followOurJourney": MessageLookupByLibrary.simpleMessage(
      "Begleite unsere Reise 🧭✨",
    ),
    "followers": MessageLookupByLibrary.simpleMessage("Follower"),
    "following": MessageLookupByLibrary.simpleMessage("Gefolgt"),
    "followingBtn": MessageLookupByLibrary.simpleMessage("Gefolgt"),
    "fullTextReisebuero": MessageLookupByLibrary.simpleMessage(
      "Die Welt ist groß – komm, wir zeigen sie dir!\n\nWir sind ein eingespieltes Team aus 15 leidenschaftlichen Reiseexperten, die seit vielen Jahren gemeinsam für unvergessliche Urlaubsmomente sorgen.\n\nEgal, wohin es gehen soll – bei uns findest du immer den passenden Ansprechpartner: kompetent, erfahren und mit einem offenen Ohr für all deine Wünsche.\n\nWas uns besonders macht? Wir lieben, was wir tun. Darum steckt in jeder Beratung nicht nur Fachwissen, sondern auch ganz viel Herzblut und echte Begeisterung.\n\nUnser Reisebüro gibt es schon viele Jahre – und aus Kollegen ist dabei längst unsere ganz eigene kleine TUI-Family geworden. Uns ist wichtig, dass ihr euch bei uns nicht nur professionell beraten, sondern vor allem rundum gut aufgehoben fühlt.\n\nVertraue uns deinen Urlaub an: Wir planen jede Reise so, als wäre es unsere eigene.\nDenn für uns zählt nicht nur Expertise, sondern vor allem Menschlichkeit, Leidenschaft und der Wunsch, aus jeder Reise etwas ganz Besonderes zu machen.",
    ),
    "genuaSubtitle": MessageLookupByLibrary.simpleMessage(
      "Hafenstadt & Ligurien",
    ),
    "genuaTitle": MessageLookupByLibrary.simpleMessage("Genua"),
    "goalExceeded": MessageLookupByLibrary.simpleMessage(
      "⚠️ Ziel überschritten",
    ),
    "goalExceededMessage": m7,
    "googleMapsLabel": MessageLookupByLibrary.simpleMessage(
      "Bei Google ansehen",
    ),
    "guides": MessageLookupByLibrary.simpleMessage("Guides"),
    "hamburgSubtitle": MessageLookupByLibrary.simpleMessage("Tor zur Welt"),
    "hamburgTitle": MessageLookupByLibrary.simpleMessage("Hamburg"),
    "hashtags": MessageLookupByLibrary.simpleMessage("Hashtags"),
    "headerTitleTUI": MessageLookupByLibrary.simpleMessage("TUI Aschaffenburg"),
    "hoursAgo": m8,
    "hoursShort": MessageLookupByLibrary.simpleMessage("Std"),
    "imageCropTitle": MessageLookupByLibrary.simpleMessage("Bild zuschneiden"),
    "impressum": MessageLookupByLibrary.simpleMessage("Impressum"),
    "impressumCopyrightContent": MessageLookupByLibrary.simpleMessage(
      "Die durch die App erstellten Inhalte und Werke unterliegen dem deutschen Urheberrecht. Die Vervielfältigung, Bearbeitung, Verbreitung und jede Art der Verwertung außerhalb der Grenzen des Urheberrechtes bedürfen der schriftlichen Zustimmung des jeweiligen Autors bzw. Erstellers.",
    ),
    "impressumCopyrightTitle": MessageLookupByLibrary.simpleMessage(
      "Urheberrecht",
    ),
    "impressumDisputeContent": MessageLookupByLibrary.simpleMessage(
      "Die Europäische Kommission hat die Plattform zur Online-Streitbeilegung (OS) zum 31.12.2023 eingestellt.\n\nWir nehmen nicht an Streitbeilegungsverfahren vor einer Verbraucherschlichtungsstelle teil.",
    ),
    "impressumDisputeTitle": MessageLookupByLibrary.simpleMessage(
      "Streitschlichtung",
    ),
    "impressumHeader": MessageLookupByLibrary.simpleMessage(
      "Angaben gemäß §5 TMG",
    ),
    "impressumLiabilityContentContent": MessageLookupByLibrary.simpleMessage(
      "Wir übernehmen keine Gewähr für die Aktualität, Korrektheit, Vollständigkeit oder Qualität der bereitgestellten Informationen.",
    ),
    "impressumLiabilityContentTitle": MessageLookupByLibrary.simpleMessage(
      "Haftung für Inhalte",
    ),
    "impressumLiabilityLinksContent": MessageLookupByLibrary.simpleMessage(
      "Unsere App enthält Links zu externen Websites Dritter, auf deren Inhalte wir keinen Einfluss haben. Für die Inhalte der verlinkten Seiten ist stets der jeweilige Anbieter oder Betreiber der Seiten verantwortlich.",
    ),
    "impressumLiabilityLinksTitle": MessageLookupByLibrary.simpleMessage(
      "Haftung für Links",
    ),
    "impressumResponsibleContent": MessageLookupByLibrary.simpleMessage(
      "Jenny Weinreich\nStettiner Straße 41\n35410 Hungen\nDeutschland\nE-Mail: mamatochterontour@outlook.de",
    ),
    "impressumResponsibleTitle": MessageLookupByLibrary.simpleMessage(
      "Verantwortlicher für den Inhalt dieser App:",
    ),
    "impressumStand": MessageLookupByLibrary.simpleMessage(
      "Stand: Dezember 2025",
    ),
    "impressumTitle": MessageLookupByLibrary.simpleMessage("Impressum"),
    "impressumVatContent": MessageLookupByLibrary.simpleMessage("DE441919331"),
    "impressumVatTitle": MessageLookupByLibrary.simpleMessage(
      "Umsatzsteuer-ID gemäß §27a Umsatzsteuergesetz:",
    ),
    "insiderTips": MessageLookupByLibrary.simpleMessage("Insider Tipps"),
    "insiderTipsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Unsere geheimen Spots",
    ),
    "insiderTitle": MessageLookupByLibrary.simpleMessage(
      "Unsere Insider-Tipps ✨",
    ),
    "instagramLabel": MessageLookupByLibrary.simpleMessage("Instagram"),
    "invalidInputMessage": MessageLookupByLibrary.simpleMessage(
      "Bitte gib eine Kategorie und einen gültigen Betrag ein.",
    ),
    "invalidInputTitle": MessageLookupByLibrary.simpleMessage(
      "Ungültige Eingabe",
    ),
    "italienSubtitle": MessageLookupByLibrary.simpleMessage(
      "Bella Italia entdecken",
    ),
    "italienTitle": MessageLookupByLibrary.simpleMessage("Italien"),
    "itemHint": MessageLookupByLibrary.simpleMessage("Item hinzufügen..."),
    "journals": MessageLookupByLibrary.simpleMessage("Tagebücher"),
    "justNow": MessageLookupByLibrary.simpleMessage("gerade eben"),
    "kalifornienSubtitle": MessageLookupByLibrary.simpleMessage(
      "Roadtrip durch den Golden State",
    ),
    "kalifornienTitle": MessageLookupByLibrary.simpleMessage("Kalifornien"),
    "koelnSubtitle": MessageLookupByLibrary.simpleMessage(
      "Hätz zwesche Dom un Rhing",
    ),
    "koelnTitle": MessageLookupByLibrary.simpleMessage("Köln"),
    "language": MessageLookupByLibrary.simpleMessage("Sprache"),
    "legalHelp": MessageLookupByLibrary.simpleMessage("Rechtliches & Hilfe"),
    "likesCount": m9,
    "likesCount2": m10,
    "likesTextMultiple": m11,
    "likesTextSingle": m12,
    "location": MessageLookupByLibrary.simpleMessage("Ort"),
    "londonSubtitle": MessageLookupByLibrary.simpleMessage(
      "Stadt der Royals & Kultur",
    ),
    "londonTitle": MessageLookupByLibrary.simpleMessage("London"),
    "longDistanceSubtitle": MessageLookupByLibrary.simpleMessage(
      "Weite Welten, große Träume 🌍❤️",
    ),
    "longDistanceTitle": MessageLookupByLibrary.simpleMessage("Fernreisen"),
    "mallorcaFeed": MessageLookupByLibrary.simpleMessage("Mallorca Feed"),
    "mallorcaFeedSubtitle": MessageLookupByLibrary.simpleMessage(
      "Unsere täglichen Erlebnisse",
    ),
    "mallorcaHeroText": MessageLookupByLibrary.simpleMessage(
      "Unser Mallorca Abenteuer ☀️",
    ),
    "mallorcaMap": MessageLookupByLibrary.simpleMessage("Mallorca Karte"),
    "mallorcaMapSubtitle": MessageLookupByLibrary.simpleMessage(
      "Alle Orte auf einer Map",
    ),
    "mallorcaSubtitle": MessageLookupByLibrary.simpleMessage(
      "Insel unserer Herzen",
    ),
    "mallorcaTitle": MessageLookupByLibrary.simpleMessage("Mallorca"),
    "maxMedia": MessageLookupByLibrary.simpleMessage(
      "Maximal 10 Mediendateien pro Beitrag",
    ),
    "meldButton": MessageLookupByLibrary.simpleMessage("Melden"),
    "miniGuides": MessageLookupByLibrary.simpleMessage("Mini Guides"),
    "miniGuidesSubtitle": MessageLookupByLibrary.simpleMessage(
      "Kurze Travel Guides",
    ),
    "minutesAgo": m13,
    "minutesShort": MessageLookupByLibrary.simpleMessage("Min"),
    "moreComing": MessageLookupByLibrary.simpleMessage(
      "Weitere Insider-Tipps für spannende Orte folgen bald! ✨",
    ),
    "myPackingList": MessageLookupByLibrary.simpleMessage("Meine Packliste"),
    "myProfile": MessageLookupByLibrary.simpleMessage("Mein Profil"),
    "nameLabel": MessageLookupByLibrary.simpleMessage("Name"),
    "newCategoryName": MessageLookupByLibrary.simpleMessage("Neuer Name"),
    "newContact": MessageLookupByLibrary.simpleMessage("Neuer Kontakt"),
    "newNote": MessageLookupByLibrary.simpleMessage("Neue Notiz"),
    "newText": MessageLookupByLibrary.simpleMessage("Neuer Text"),
    "newTravelDiary": MessageLookupByLibrary.simpleMessage(
      "Neues Reisetagebuch",
    ),
    "newyorkSubtitle": MessageLookupByLibrary.simpleMessage(
      "Magie zur Weihnachtszeit",
    ),
    "newyorkTitle": MessageLookupByLibrary.simpleMessage("New York"),
    "no": MessageLookupByLibrary.simpleMessage("Nein"),
    "noBio": MessageLookupByLibrary.simpleMessage("Keine Biografie"),
    "noBudgetCreated": MessageLookupByLibrary.simpleMessage(
      "Du hast noch keinen Budgetplan erstellt.\nStarte jetzt und spare auf deinen Traumurlaub hin! 🏖️💰",
    ),
    "noComments": MessageLookupByLibrary.simpleMessage("Noch keine Kommentare"),
    "noJournal": MessageLookupByLibrary.simpleMessage(
      "Noch kein Tagebuch erstellt",
    ),
    "noJournalMessage": MessageLookupByLibrary.simpleMessage(
      "Schreibe dein erstes Reisetagebuch ✍️\n\nHalte deine schönsten Erlebnisse fest – inklusive Bildern & Videos.",
    ),
    "noPost": MessageLookupByLibrary.simpleMessage(
      "Noch kein Post hochgeladen",
    ),
    "noPostMessage": MessageLookupByLibrary.simpleMessage(
      "Lade deinen ersten Post hoch 🌍✨\n\nInspiriere andere mit deinen Reisen und deinen schönsten Momenten.",
    ),
    "noPostsFound": MessageLookupByLibrary.simpleMessage(
      "Keine Beiträge gefunden",
    ),
    "noQuestionsYet": MessageLookupByLibrary.simpleMessage(
      "💬 Es wurden noch keine Fragen gestellt.\nStelle die erste Frage 😊",
    ),
    "noResults": MessageLookupByLibrary.simpleMessage("Keine Orte gefunden 😕"),
    "noStories": MessageLookupByLibrary.simpleMessage("Keine Storys vorhanden"),
    "noTitle": MessageLookupByLibrary.simpleMessage("Ohne Titel"),
    "noTripsPlanned": MessageLookupByLibrary.simpleMessage(
      "Noch keine Reisen geplant ✈️",
    ),
    "noordwijkSubtitle": MessageLookupByLibrary.simpleMessage(
      "Dünen, Ruhe & Nordseezauber",
    ),
    "noordwijkTitle": MessageLookupByLibrary.simpleMessage("Noordwijk"),
    "note": MessageLookupByLibrary.simpleMessage("Hinweis"),
    "noteDeleteError": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Löschen",
    ),
    "noteEmptyError": MessageLookupByLibrary.simpleMessage(
      "Bitte mindestens ein Feld ausfüllen!",
    ),
    "noteLimitPremium": MessageLookupByLibrary.simpleMessage(
      "Nicht-Premium-User können nur 2 Notizen erstellen. Tippe hier, um Premium freizuschalten!",
    ),
    "noteSaveError": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Speichern",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("Notizen"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "onlineConsultation": MessageLookupByLibrary.simpleMessage(
      "Online- & Videoberatung nach Vereinbarung möglich",
    ),
    "otherCategory": MessageLookupByLibrary.simpleMessage("Sonstiges"),
    "ourDestinations": MessageLookupByLibrary.simpleMessage(
      "Unsere Reiseziele 🌟",
    ),
    "ourStory": MessageLookupByLibrary.simpleMessage("Unsere Story"),
    "ourStorySubtitle": MessageLookupByLibrary.simpleMessage(
      "Unsere Reise erleben",
    ),
    "packingDoneMessage": MessageLookupByLibrary.simpleMessage(
      "Du hast fertig gepackt, wir wünschen dir eine schöne Reise! 🌍",
    ),
    "packingList": MessageLookupByLibrary.simpleMessage("Packliste"),
    "packingProgress": m14,
    "packlistLoadError": m15,
    "pageTitle": MessageLookupByLibrary.simpleMessage("Mama-Tochter-Tagebuch"),
    "pageTitleReisebueros": MessageLookupByLibrary.simpleMessage("Reisebüros"),
    "parisSubtitle": MessageLookupByLibrary.simpleMessage(
      "Flair der französischen Metropole",
    ),
    "parisTitle": MessageLookupByLibrary.simpleMessage("Paris"),
    "passwordDialogDescription": MessageLookupByLibrary.simpleMessage(
      "Bitte gib dein Passwort ein, um dein Konto endgültig zu löschen.",
    ),
    "passwordDialogLabel": MessageLookupByLibrary.simpleMessage("Passwort"),
    "passwordDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Konto endgültig löschen",
    ),
    "passwordReset": MessageLookupByLibrary.simpleMessage(
      "Passwort zurücksetzen",
    ),
    "passwordResetSuccess": MessageLookupByLibrary.simpleMessage(
      "Passwort-Zurücksetzungslink wurde per E-Mail gesendet!",
    ),
    "phoneLabel": MessageLookupByLibrary.simpleMessage("Telefonnummer"),
    "pickColor": MessageLookupByLibrary.simpleMessage("Farbe auswählen"),
    "pickMedia": MessageLookupByLibrary.simpleMessage(
      "Wähle ein Bild oder Video aus …",
    ),
    "planning": MessageLookupByLibrary.simpleMessage("Planung"),
    "postDetails": MessageLookupByLibrary.simpleMessage("Post Details"),
    "postReported": MessageLookupByLibrary.simpleMessage(
      "Beitrag wurde gemeldet",
    ),
    "postUpdateError": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Speichern",
    ),
    "postUpdateSuccess": MessageLookupByLibrary.simpleMessage(
      "Beitrag erfolgreich aktualisiert",
    ),
    "posts": MessageLookupByLibrary.simpleMessage("Beiträge"),
    "premium": MessageLookupByLibrary.simpleMessage("Premium"),
    "premiumBenefit1": MessageLookupByLibrary.simpleMessage(
      "Zugriff auf alle Reisetagebücher von MamaTochterOnTour",
    ),
    "premiumBenefit2": MessageLookupByLibrary.simpleMessage(
      "Inklusive Insider-Tipps zu den jeweiligen Orten",
    ),
    "premiumBenefit3": MessageLookupByLibrary.simpleMessage(
      "Packliste für deine Reisen erstellen",
    ),
    "premiumBenefit4": MessageLookupByLibrary.simpleMessage(
      "Reise-Countdown für deine nächste Reise",
    ),
    "premiumBenefit5": MessageLookupByLibrary.simpleMessage(
      "Beiträge speichern",
    ),
    "premiumBenefitsTitle": MessageLookupByLibrary.simpleMessage(
      "Deine Premium-Vorteile auf einen Blick",
    ),
    "premiumBestPrice": MessageLookupByLibrary.simpleMessage("Bester Preis"),
    "premiumBuyButton": MessageLookupByLibrary.simpleMessage("Kaufen"),
    "premiumCategoryLimit": MessageLookupByLibrary.simpleMessage(
      "Du kannst nur 2 Kategorien hinzufügen. Tippe hier, um Premium freizuschalten! ✨",
    ),
    "premiumCheckError": m16,
    "premiumComingSoon": MessageLookupByLibrary.simpleMessage(
      "✨Bald noch mehr!\nWir arbeiten ständig daran, deine Reiserlebnisse noch besser zu machen. Freue dich auf viele neue Features, exklusive Inhalte und spannende Extras – alles automatisch im Premium-Abo enthalten.",
    ),
    "premiumErrorText": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Laden des Premium-Status. Bitte versuche es erneut.",
    ),
    "premiumItemLimit": MessageLookupByLibrary.simpleMessage(
      "Du kannst nur 5 Items hinzufügen. Tippe hier, um Premium freizuschalten! ✨",
    ),
    "premiumLegalAnd": MessageLookupByLibrary.simpleMessage("und"),
    "premiumLegalDot": MessageLookupByLibrary.simpleMessage("zu."),
    "premiumLegalIntro": MessageLookupByLibrary.simpleMessage(
      "Mit dem Abonnieren stimmen Sie unseren",
    ),
    "premiumLimitMessage": MessageLookupByLibrary.simpleMessage(
      "Nicht-Premium-User können nur 2 Budget-Kategorien erstellen. Tippe hier, um Premium freizuschalten!",
    ),
    "premiumLocked": MessageLookupByLibrary.simpleMessage(
      "Insider nur für Premium-User verfügbar. Tippe hier, um Premium freizuschalten.",
    ),
    "premiumMessage": MessageLookupByLibrary.simpleMessage(
      "Du bist kein Premium-Mitglied und kannst keine Beiträge speichern. Tippe hier, um Premium freizuschalten ✨",
    ),
    "premiumMonthly": MessageLookupByLibrary.simpleMessage("Premium monatlich"),
    "premiumPrivacy": MessageLookupByLibrary.simpleMessage(
      "Datenschutzerklärung",
    ),
    "premiumPrivacyUrl": MessageLookupByLibrary.simpleMessage(
      "https://mamatochterontour.com/pages/datenschutzrichtlinie-von-momentry",
    ),
    "premiumRestoreButton": MessageLookupByLibrary.simpleMessage(
      "Kauf wiederherstellen",
    ),
    "premiumSavePost": MessageLookupByLibrary.simpleMessage(
      "Du bist kein Premium-Mitglied und kannst keine Beiträge speichern. Tippe hier, um Premium freizuschalten ✨",
    ),
    "premiumSaveWarning": MessageLookupByLibrary.simpleMessage(
      "Du bist kein Premium-Mitglied und kannst keine Beiträge speichern. Tippe hier, um Premium freizuschalten ✨",
    ),
    "premiumSnackbarText": MessageLookupByLibrary.simpleMessage(
      "Du bist kein Premium-Mitglied und kannst deswegen leider nicht unsere Tagebücher lesen. Tippe hier, um Premium freizuschalten ✨",
    ),
    "premiumStatusActive": MessageLookupByLibrary.simpleMessage(
      "Du bist jetzt Premium-Mitglied – alle Features freigeschaltet!",
    ),
    "premiumStatusInactive": MessageLookupByLibrary.simpleMessage(
      "Du nutzt momentan die kostenlose Version der App.",
    ),
    "premiumStatusTitle": MessageLookupByLibrary.simpleMessage(
      "Dein Abo-Status",
    ),
    "premiumTerms": MessageLookupByLibrary.simpleMessage("Nutzungsbedingungen"),
    "premiumTermsUrl": MessageLookupByLibrary.simpleMessage(
      "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/",
    ),
    "premiumTitle": MessageLookupByLibrary.simpleMessage("Premium verwalten"),
    "premiumTodoLimit": MessageLookupByLibrary.simpleMessage(
      "Du bist kein Premium-Mitglied und kannst maximal 5 To-Do-Einträge hinzufügen. Tippe hier, um Premium freizuschalten ✨",
    ),
    "premiumYearly": MessageLookupByLibrary.simpleMessage("Premium jährlich"),
    "previewTextReisebuero": MessageLookupByLibrary.simpleMessage(
      "Die Welt ist groß – komm, wir zeigen sie dir!\n\nWir sind ein eingespieltes Team aus 15 leidenschaftlichen Reiseexperten, die seit vielen Jahren gemeinsam für unvergessliche Urlaubsmomente sorgen.",
    ),
    "privacyIntro": MessageLookupByLibrary.simpleMessage(
      "Diese Datenschutzerklärung informiert Sie über die Verarbeitung Ihrer personenbezogenen Daten bei der Nutzung unserer App.",
    ),
    "privacyLastUpdated": MessageLookupByLibrary.simpleMessage(
      "Datenschutzerklärung – Stand Dezember 2025",
    ),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage(
      "Datenschutzrichtlinien",
    ),
    "privacySection10Content": MessageLookupByLibrary.simpleMessage(
      "Sie haben das Recht, sich bei einer Datenschutzaufsichtsbehörde über die Verarbeitung Ihrer Daten zu beschweren.",
    ),
    "privacySection10Title": MessageLookupByLibrary.simpleMessage(
      "10. Beschwerderecht",
    ),
    "privacySection11Content": MessageLookupByLibrary.simpleMessage(
      "Die Datenschutzerklärung kann bei Änderungen der App oder rechtlichen Anforderungen aktualisiert werden. Die aktuelle Version finden Sie immer in der App.",
    ),
    "privacySection11Title": MessageLookupByLibrary.simpleMessage(
      "11. Änderungen der Datenschutzerklärung",
    ),
    "privacySection1Content": MessageLookupByLibrary.simpleMessage(
      "Name: Jenny Weinreich\nAdresse: Stettiner Straße 41, 35410 Hungen\nE-Mail: mamatochterontour@outlook.de",
    ),
    "privacySection1Title": MessageLookupByLibrary.simpleMessage(
      "1. Verantwortlicher",
    ),
    "privacySection2Content": MessageLookupByLibrary.simpleMessage(
      "Wir erheben folgende Daten:\n• Name und E-Mail-Adresse\n• Profilbild\n• Ihre Beiträge und Tagebucheinträge\n• Gespeicherte Geheimtipps\n• Zeitstempel und Aktivitäten in der App",
    ),
    "privacySection2Title": MessageLookupByLibrary.simpleMessage(
      "2. Erhobene Daten",
    ),
    "privacySection3Content": MessageLookupByLibrary.simpleMessage(
      "Wir verarbeiten Ihre Daten für folgende Zwecke:\n• Kontoerstellung und Verwaltung\n• Bereitstellung der App-Funktionalitäten\n• Community-Funktionen und Teilen von Beiträgen\n• Premium-Funktionen innerhalb der App\n• Abwicklung von App-Käufen",
    ),
    "privacySection3Title": MessageLookupByLibrary.simpleMessage(
      "3. Zweck der Datenverarbeitung",
    ),
    "privacySection4Content": MessageLookupByLibrary.simpleMessage(
      "Die Verarbeitung erfolgt auf Grundlage Ihrer Einwilligung (Art. 6 Abs. 1 lit. a DSGVO) und zur Vertragserfüllung (Art. 6 Abs. 1 lit. b DSGVO).",
    ),
    "privacySection4Title": MessageLookupByLibrary.simpleMessage(
      "4. Rechtsgrundlage",
    ),
    "privacySection5Content": MessageLookupByLibrary.simpleMessage(
      "Wir nutzen Firebase-Dienste von Google (Firebase Authentication, Firestore, Storage, Analytics). Die Daten werden ausschließlich auf Servern in Deutschland verarbeitet.",
    ),
    "privacySection5Title": MessageLookupByLibrary.simpleMessage(
      "5. Datenübermittlung",
    ),
    "privacySection6Content": MessageLookupByLibrary.simpleMessage(
      "Ihre Daten werden gespeichert, solange Ihr Konto aktiv ist oder gesetzliche Aufbewahrungsfristen bestehen. Nach Löschung Ihres Kontos werden alle personenbezogenen Daten entfernt.",
    ),
    "privacySection6Title": MessageLookupByLibrary.simpleMessage(
      "6. Speicherdauer",
    ),
    "privacySection7Content": MessageLookupByLibrary.simpleMessage(
      "Sie haben folgende Rechte bezüglich Ihrer Daten:\n• Auskunft über gespeicherte Daten\n• Berichtigung unrichtiger Daten\n• Löschung Ihrer Daten\n• Datenübertragbarkeit\n• Widerruf Ihrer Einwilligung",
    ),
    "privacySection7Title": MessageLookupByLibrary.simpleMessage(
      "7. Ihre Rechte",
    ),
    "privacySection8Content": MessageLookupByLibrary.simpleMessage(
      "Premium-Funktionen werden über App-Käufe innerhalb der App abgewickelt. Für diese Transaktionen gelten die Datenschutzbestimmungen unserer App.",
    ),
    "privacySection8Title": MessageLookupByLibrary.simpleMessage(
      "8. Premium-Funktionen",
    ),
    "privacySection9Content": MessageLookupByLibrary.simpleMessage(
      "Bei Fragen zum Datenschutz erreichen Sie uns unter: mamatochterontour@outlook.de. Wir antworten innerhalb einer Woche.",
    ),
    "privacySection9Title": MessageLookupByLibrary.simpleMessage("9. Kontakt"),
    "privacyTitle": MessageLookupByLibrary.simpleMessage(
      "Datenschutzerklärung",
    ),
    "profile": MessageLookupByLibrary.simpleMessage("Profil"),
    "profileDataLoadError": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Laden der Profildaten",
    ),
    "profilePictureSaved": MessageLookupByLibrary.simpleMessage(
      "Profilbild erfolgreich gespeichert",
    ),
    "profilePictureUploadError": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Hochladen des Profilbildes",
    ),
    "publishPost": MessageLookupByLibrary.simpleMessage(
      "Beitrag veröffentlichen",
    ),
    "readLess": MessageLookupByLibrary.simpleMessage("Weniger anzeigen"),
    "readMore": MessageLookupByLibrary.simpleMessage("... read more"),
    "reauthOAuthError": MessageLookupByLibrary.simpleMessage(
      "Bitte melde dich erneut an, um dein Konto zu löschen.",
    ),
    "reply": MessageLookupByLibrary.simpleMessage("Antworten"),
    "replyTo": MessageLookupByLibrary.simpleMessage("Antwort an"),
    "replyingTo": m17,
    "report": MessageLookupByLibrary.simpleMessage("Melden"),
    "reportPost": MessageLookupByLibrary.simpleMessage("Beitrag melden"),
    "reportReason": MessageLookupByLibrary.simpleMessage("Grund der Meldung"),
    "reportReasonHint": MessageLookupByLibrary.simpleMessage(
      "Grund der Meldung",
    ),
    "reportUser": MessageLookupByLibrary.simpleMessage("User melden"),
    "reportedSuccess": MessageLookupByLibrary.simpleMessage(
      "Beitrag wurde gemeldet",
    ),
    "roadtripEuropaGridTitle": MessageLookupByLibrary.simpleMessage(
      "Roadtrips durch Europa",
    ),
    "roadtripEuropaIntro": MessageLookupByLibrary.simpleMessage(
      "Unsere schönsten Erlebnisse mit dem Auto 🚗✨\n\nRoadtrips quer durch Europa – Freiheit, Musik und unvergessliche Momente unterwegs.",
    ),
    "roadtripEuropaTitle": MessageLookupByLibrary.simpleMessage(
      "Roadtrip Europa",
    ),
    "roadtripEuropeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Mit dem Auto durch Europas Wunder 🚗💜",
    ),
    "roadtripEuropeTitle": MessageLookupByLibrary.simpleMessage(
      "Roadtrips Europa",
    ),
    "romSubtitle": MessageLookupByLibrary.simpleMessage(
      "Ewige Stadt & Geschichte",
    ),
    "romTitle": MessageLookupByLibrary.simpleMessage("Rom"),
    "save": MessageLookupByLibrary.simpleMessage("Speichern"),
    "saveBio": MessageLookupByLibrary.simpleMessage("Biografie speichern"),
    "saveButton": MessageLookupByLibrary.simpleMessage("Speichern"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("Änderungen speichern"),
    "saveDiary": MessageLookupByLibrary.simpleMessage(
      "Reisetagebuch speichern",
    ),
    "saveError": m18,
    "saveProfilePicture": MessageLookupByLibrary.simpleMessage(
      "Profilbild speichern",
    ),
    "saveQuestion": MessageLookupByLibrary.simpleMessage("Frage speichern"),
    "saveUsername": MessageLookupByLibrary.simpleMessage(
      "Benutzername speichern",
    ),
    "saving": MessageLookupByLibrary.simpleMessage("Speichere…"),
    "savingIndicator": MessageLookupByLibrary.simpleMessage("Speichere…"),
    "scheveningenSubtitle": MessageLookupByLibrary.simpleMessage(
      "Wind, Meer & Freiheitsgefühl",
    ),
    "scheveningenTitle": MessageLookupByLibrary.simpleMessage("Scheveningen"),
    "searchHint": MessageLookupByLibrary.simpleMessage("Suche…"),
    "seasideGetawaysSubtitle": MessageLookupByLibrary.simpleMessage(
      "Meer-Momente zum Träumen 🏖️✨",
    ),
    "seasideGetawaysTitle": MessageLookupByLibrary.simpleMessage(
      "Auszeiten am Meer",
    ),
    "secondsShort": MessageLookupByLibrary.simpleMessage("Sek"),
    "selectEndDate": MessageLookupByLibrary.simpleMessage("Enddatum wählen"),
    "selectImage": MessageLookupByLibrary.simpleMessage("Bild auswählen"),
    "selectStartDate": MessageLookupByLibrary.simpleMessage(
      "Startdatum wählen",
    ),
    "selectVideo": MessageLookupByLibrary.simpleMessage("Video auswählen"),
    "send": MessageLookupByLibrary.simpleMessage("Senden"),
    "serviceTravel": MessageLookupByLibrary.simpleMessage(
      "Reisen rund um die Welt – egal ob fern oder nah",
    ),
    "servicesTitle": MessageLookupByLibrary.simpleMessage("Leistungen"),
    "settingsTitle": MessageLookupByLibrary.simpleMessage("Einstellungen"),
    "signOut": MessageLookupByLibrary.simpleMessage("Abmelden"),
    "staedtereisenIntro": MessageLookupByLibrary.simpleMessage(
      "Unsere Städtereisen-Highlights 🏙️💜\n\nHier sammeln wir unsere schönsten Erlebnisse aus den Städten, die wir lieben.",
    ),
    "staedtereisenTitle": MessageLookupByLibrary.simpleMessage(
      "Unsere Städtereisen",
    ),
    "startDate": MessageLookupByLibrary.simpleMessage("Startdatum"),
    "storySaved": MessageLookupByLibrary.simpleMessage("Story gespeichert!"),
    "tabInsider": MessageLookupByLibrary.simpleMessage("Insider"),
    "tabTagebuecher": MessageLookupByLibrary.simpleMessage("Tagebücher"),
    "tabTipps": MessageLookupByLibrary.simpleMessage("Tipps"),
    "targetAmountLabel": MessageLookupByLibrary.simpleMessage("Zielbetrag"),
    "terms10Content": MessageLookupByLibrary.simpleMessage(
      "• Sie können Ihr Konto jederzeit in den Einstellungen löschen.\n• Wir können Konten bei Verstößen sperren oder löschen.\n• Nach Löschung werden Ihre Daten gemäß Datenschutzerklärung behandelt.",
    ),
    "terms10Title": MessageLookupByLibrary.simpleMessage("10. Kündigung"),
    "terms11Content": MessageLookupByLibrary.simpleMessage(
      "Wir können die Nutzungsbedingungen ändern. Sie werden über wichtige Änderungen in der App informiert. Bei Widerspruch können Sie Ihr Konto löschen.",
    ),
    "terms11Title": MessageLookupByLibrary.simpleMessage("11. Änderungen"),
    "terms12Content": MessageLookupByLibrary.simpleMessage(
      "Es gilt deutsches Recht. Gerichtsstand wie gesetzlich zulässig. Bei Unwirksamkeit einzelner Bestimmungen bleiben die übrigen gültig.",
    ),
    "terms12Title": MessageLookupByLibrary.simpleMessage(
      "12. Schlussbestimmungen",
    ),
    "terms13Content": MessageLookupByLibrary.simpleMessage(
      "Bei Fragen kontaktieren Sie uns gerne unter: mamatochterontour@outlook.de",
    ),
    "terms13Title": MessageLookupByLibrary.simpleMessage(
      "13. Kontakt bei Fragen",
    ),
    "terms1Content": MessageLookupByLibrary.simpleMessage(
      "Name: Jenny Weinreich\nAdresse: Stettiner Straße 41, 35410 Hungen\nE-Mail: mamatochterontour@outlook.de\nUmsatzsteuer-ID: DE441919331",
    ),
    "terms1Title": MessageLookupByLibrary.simpleMessage("1. Anbieter"),
    "terms2Content": MessageLookupByLibrary.simpleMessage(
      "Die Nutzungsbedingungen gelten für die Nutzung unserer Reise-Community-App. Mit der Registrierung akzeptieren Sie diese Bedingungen vollständig.",
    ),
    "terms2Title": MessageLookupByLibrary.simpleMessage("2. Geltungsbereich"),
    "terms3Content": MessageLookupByLibrary.simpleMessage(
      "• Die App ist nur mit Registrierung nutzbar.\n• Sie müssen wahrheitsgemäße Angaben machen.\n• Ihr Passwort ist geheim zu halten.\n• Sie sind für alle Aktivitäten in Ihrem Konto verantwortlich.",
    ),
    "terms3Title": MessageLookupByLibrary.simpleMessage(
      "3. Registrierung und Nutzerkonto",
    ),
    "terms4Content": MessageLookupByLibrary.simpleMessage(
      "• Sie dürfen Reisetagebücher und Beiträge erstellen.\n• Eigene Reisetipps teilen.\n• Die App für private, nicht kommerzielle Zwecke nutzen.",
    ),
    "terms4Title": MessageLookupByLibrary.simpleMessage("4. Erlaubte Nutzung"),
    "terms5Content": MessageLookupByLibrary.simpleMessage(
      "Folgende Inhalte sind nicht erlaubt:\n• Illegale, beleidigende oder diskriminierende Inhalte\n• Spam oder Werbung ohne Erlaubnis\n• Urheberrechtsverletzung\n• Falsche oder irreführende Informationen\n• Inhalte, die andere Nutzer gefährden könnten",
    ),
    "terms5Title": MessageLookupByLibrary.simpleMessage("5. Verbotene Inhalte"),
    "terms6Content": MessageLookupByLibrary.simpleMessage(
      "Premium-Funktionen innerhalb der App sind kostenpflichtig und können jederzeit gekündigt werden.",
    ),
    "terms6Title": MessageLookupByLibrary.simpleMessage(
      "6. Premium-Mitgliedschaft",
    ),
    "terms7Content": MessageLookupByLibrary.simpleMessage(
      "• Sie behalten die Rechte an Ihren Inhalten.\n• Sie gewähren uns das Recht, Ihre Inhalte in der App anzuzeigen.\n• Sie sind für die Rechtsmäßigkeit Ihrer Inhalte verantwortlich.\n• Rechtswidrige Inhalte können ohne Vorwarnung gelöscht werden.",
    ),
    "terms7Title": MessageLookupByLibrary.simpleMessage("7. Ihre Inhalte"),
    "terms8Content": MessageLookupByLibrary.simpleMessage(
      "Der Schutz Ihrer Daten ist uns wichtig. Details zur Datenverarbeitung finden Sie in unserer Datenschutzerklärung, die Sie in der App einsehen können.",
    ),
    "terms8Title": MessageLookupByLibrary.simpleMessage("8. Datenschutz"),
    "terms9Content": MessageLookupByLibrary.simpleMessage(
      "• Die App wird ohne Gewähr zur Verfügung gestellt.\n• Nutzerinformationen spiegeln nicht unsere Meinung wider.\n• Wir haften nicht für Schäden durch Nutzung der App.\n• Reiseinformationen sind ohne Gewähr, prüfen Sie diese selbst.\n• Bei Vorsatz oder grober Fahrlässigkeit haften wir unbeschränkt.",
    ),
    "terms9Title": MessageLookupByLibrary.simpleMessage(
      "9. Haftungsausschluss",
    ),
    "termsConditions": MessageLookupByLibrary.simpleMessage(
      "Nutzungsbedingungen",
    ),
    "termsImportantNotice": MessageLookupByLibrary.simpleMessage(
      "Wichtiger Hinweis: Die Nutzungsbedingungen sind rechtlich bindend. Bitte lesen Sie sie sorgfältig durch.",
    ),
    "termsLastUpdated": MessageLookupByLibrary.simpleMessage(
      "Nutzungsbedingungen – Stand Dezember 2025",
    ),
    "termsTitle": MessageLookupByLibrary.simpleMessage("Nutzungsbedingungen"),
    "themeLoadError": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Laden des Themes",
    ),
    "timeAgoDays": m19,
    "timeAgoHours": m20,
    "timeAgoJustNow": MessageLookupByLibrary.simpleMessage("gerade eben"),
    "timeAgoMinutes": m21,
    "tipsAndFavorites": MessageLookupByLibrary.simpleMessage(
      "Tipps & Lieblingsorte",
    ),
    "titleLabel": MessageLookupByLibrary.simpleMessage("Titel"),
    "todoHint": MessageLookupByLibrary.simpleMessage("Eintrag..."),
    "todoTitle": MessageLookupByLibrary.simpleMessage("To-Do-Liste"),
    "todos": MessageLookupByLibrary.simpleMessage("ToDos"),
    "todosSaved": MessageLookupByLibrary.simpleMessage("To-Dos gespeichert!"),
    "travel": MessageLookupByLibrary.simpleMessage("Reisen"),
    "travelDiary": MessageLookupByLibrary.simpleMessage("Reisetagebuch"),
    "tripContactsTitle": MessageLookupByLibrary.simpleMessage("Kontakte"),
    "tripDestination": MessageLookupByLibrary.simpleMessage("Reiseziel"),
    "tripLimitReached": MessageLookupByLibrary.simpleMessage(
      "Du hast das Limit von 2 Reisen erreicht. Tippe hier, um Premium freizuschalten ✨",
    ),
    "tripName": MessageLookupByLibrary.simpleMessage("Reisename"),
    "tripNotFound": MessageLookupByLibrary.simpleMessage(
      "Reise nicht gefunden",
    ),
    "tripNotesTitle": MessageLookupByLibrary.simpleMessage("Trip-Notizen"),
    "tripTitle": MessageLookupByLibrary.simpleMessage("Titel der Reise"),
    "tuiAschaffenburgSubtitle": MessageLookupByLibrary.simpleMessage(
      "Dein Ansprechpartner für unvergessliche Urlaube – persönlich, kompetent, herzlich.",
    ),
    "tuiAschaffenburgTitle": MessageLookupByLibrary.simpleMessage(
      "TUI Aschaffenburg (Reisebüro)",
    ),
    "unblock": MessageLookupByLibrary.simpleMessage("Freigeben"),
    "unknownContact": MessageLookupByLibrary.simpleMessage("Unbekannt"),
    "uploadError": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Hochladen des Beitrags",
    ),
    "uploadPost": MessageLookupByLibrary.simpleMessage("Beitrag hochladen"),
    "user": MessageLookupByLibrary.simpleMessage("User"),
    "userBlocked": MessageLookupByLibrary.simpleMessage(
      "User wurde blockiert und entfolgt",
    ),
    "userReported": MessageLookupByLibrary.simpleMessage("User wurde gemeldet"),
    "userUnblocked": MessageLookupByLibrary.simpleMessage(
      "User wurde freigegeben",
    ),
    "username": MessageLookupByLibrary.simpleMessage("Benutzername"),
    "usernameHint": MessageLookupByLibrary.simpleMessage("Dein Benutzername"),
    "usernameSaveError": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Speichern des Benutzernamens",
    ),
    "usernameSaved": MessageLookupByLibrary.simpleMessage(
      "Benutzername erfolgreich gespeichert",
    ),
    "welcomeText": MessageLookupByLibrary.simpleMessage(
      "Willkommen in unserem Reisetagebuch! Hier sammeln wir all unsere wundervollen Erinnerungen, kleine und große Abenteuer, spontane Erlebnisse und ganz besondere Herzensmomente, die wir als Mama und Tochter gemeinsam erlebt haben. 💖\n\nWir waren unter anderem in Norwegen, Italien, der Karibik, den UAE, USA, Spanien, Portugal, Frankreich und vieles mehr. 🌏\n\nZudem warten Hotelempfehlungen 🏨, Restauranttipps 🍽️ und exklusive Insider-Tipps 🔍 auf dich.",
    ),
    "whatsappLabel": MessageLookupByLibrary.simpleMessage("WhatsApp"),
    "wienSubtitle": MessageLookupByLibrary.simpleMessage(
      "Kultur & Kaffeehausflair",
    ),
    "wienTitle": MessageLookupByLibrary.simpleMessage("Wien"),
    "writeAnswer": MessageLookupByLibrary.simpleMessage("Antwort schreiben..."),
    "writeComment": MessageLookupByLibrary.simpleMessage(
      "Kommentar schreiben...",
    ),
    "writeCommentHint": MessageLookupByLibrary.simpleMessage(
      "Kommentar schreiben...",
    ),
    "writeDiary": MessageLookupByLibrary.simpleMessage("Tagebuch schreiben"),
    "writeReply": MessageLookupByLibrary.simpleMessage("Antwort schreiben..."),
    "writeReplyHint": MessageLookupByLibrary.simpleMessage(
      "Antwort schreiben...",
    ),
    "years": MessageLookupByLibrary.simpleMessage("Jahre"),
    "yes": MessageLookupByLibrary.simpleMessage("Ja"),
  };
}
