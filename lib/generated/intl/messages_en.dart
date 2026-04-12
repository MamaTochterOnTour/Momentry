// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(String category) => "Deposit – ${category}";

  static String m1(String version) => "App Version ${version}";

  static String m2(String email) =>
      "Do you want to become a partner? Feel free to write us at ${email}";

  static String m3(String mode) => "Mode changed to ${mode}";

  static String m4(int count) => "${count} days ago";

  static String m5(String error) => "Error while deleting";

  static String m6(String error) => "Error: ${error}";

  static String m7(String diff) =>
      "⚠️ Goal exceeded!\nYou deposited ${diff} € too much.";

  static String m8(int count) => "${count} hours ago";

  static String m9(String firstUser, othersCount) =>
      "${firstUser} ${Intl.plural(othersCount, zero: 'likes this post', one: 'and other like this', other: 'and others like this')}";

  static String m10(int count) =>
      "${Intl.plural(count, zero: 'No one likes this post', one: '${count} person likes this post', other: '${count} people like this post')}";

  static String m11(String firstUsername, othersCount) =>
      "${firstUsername} and ${othersCount} others like this post";

  static String m12(String firstUsername) => "${firstUsername} likes this post";

  static String m13(int count) => "${count} minutes ago";

  static String m14(String completed, total) =>
      "${completed} of ${total} items completed";

  static String m15(String error) => "Error loading packing list: ${error}";

  static String m16(String error) => "Error checking premium status: ${error}";

  static String m17(String username) => "Reply to ${username}";

  static String m18(String error) => "Error saving: ${error}";

  static String m19(int count) =>
      "${Intl.plural(count, one: '# day ago', other: '# days ago')}";

  static String m20(int count) =>
      "${Intl.plural(count, one: '# hour ago', other: '# hours ago')}";

  static String m21(int count) =>
      "${Intl.plural(count, one: '# minute ago', other: '# minutes ago')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accountSettings": MessageLookupByLibrary.simpleMessage("Account Settings"),
    "add": MessageLookupByLibrary.simpleMessage("Add"),
    "addAmountDialogTitle": m0,
    "addBudgetCategorySheetTitle": MessageLookupByLibrary.simpleMessage(
      "Add category to budget planner",
    ),
    "addButton": MessageLookupByLibrary.simpleMessage("Add"),
    "addCategory": MessageLookupByLibrary.simpleMessage("Add category"),
    "addCategoryButton": MessageLookupByLibrary.simpleMessage("Add category"),
    "addCategoryTitle": MessageLookupByLibrary.simpleMessage("Add category"),
    "addItem": MessageLookupByLibrary.simpleMessage("Add item"),
    "addLocation": MessageLookupByLibrary.simpleMessage("Ort hinzufügen"),
    "addTrip": MessageLookupByLibrary.simpleMessage("Add Trip"),
    "aidaCruisesSubtitle": MessageLookupByLibrary.simpleMessage(
      "Ocean adventures full of magic 🌊💫",
    ),
    "aidaCruisesTitle": MessageLookupByLibrary.simpleMessage("AIDA Cruises"),
    "aidaDaenemarkSchweden": MessageLookupByLibrary.simpleMessage(
      "Denmark & Sweden",
    ),
    "aidaDaenemarkSchwedenSubtitle": MessageLookupByLibrary.simpleMessage(
      "Experience fjords & coasts",
    ),
    "aidaGridTitle": MessageLookupByLibrary.simpleMessage("Our Cruises"),
    "aidaIntro": MessageLookupByLibrary.simpleMessage(
      "Our best experiences on the high seas ⛴️🌊\n\nWelcome to our cruise page! Here you’ll find all our special memories from our AIDA trips, from the Caribbean to Norway. Every cruise is a unique adventure full of discovery, enjoyment, and family time at sea. ⚓",
    ),
    "aidaKaribik": MessageLookupByLibrary.simpleMessage("Caribbean Islands"),
    "aidaKaribikSubtitle": MessageLookupByLibrary.simpleMessage(
      "Our highlights",
    ),
    "aidaMediterraneHighlights": MessageLookupByLibrary.simpleMessage(
      "Mediterranean Highlights",
    ),
    "aidaMediterraneHighlightsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Adventurous coasts",
    ),
    "aidaMediterraneMitKorsika": MessageLookupByLibrary.simpleMessage(
      "Mediterranean Treasures with Corsica",
    ),
    "aidaMediterraneMitKorsikaSubtitle": MessageLookupByLibrary.simpleMessage(
      "Coast full of wonders",
    ),
    "aidaMediterraneSchaetze": MessageLookupByLibrary.simpleMessage(
      "Mediterranean Treasures",
    ),
    "aidaMediterraneSchaetzeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Experience dreamlike coasts",
    ),
    "aidaMetropolen": MessageLookupByLibrary.simpleMessage("Metropolises"),
    "aidaMetropolenSubtitle": MessageLookupByLibrary.simpleMessage(
      "Our highlights",
    ),
    "aidaNorwegensFjorde": MessageLookupByLibrary.simpleMessage(
      "Norwegian Fjords",
    ),
    "aidaNorwegensFjordeGeiranger": MessageLookupByLibrary.simpleMessage(
      "Norwegian Fjords with Geiranger & Trondheim",
    ),
    "aidaNorwegensFjordeGeirangerSubtitle":
        MessageLookupByLibrary.simpleMessage("Majestic fjords"),
    "aidaNorwegensFjordeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Magic of the North",
    ),
    "aidaOrient": MessageLookupByLibrary.simpleMessage("Orient"),
    "aidaOrientSubtitle": MessageLookupByLibrary.simpleMessage(
      "Adventure & luxury",
    ),
    "aidaSpanienPortugal": MessageLookupByLibrary.simpleMessage(
      "Spain & Portugal",
    ),
    "aidaSpanienPortugalSubtitle": MessageLookupByLibrary.simpleMessage(
      "Discover sun & culture",
    ),
    "aidaTitle": MessageLookupByLibrary.simpleMessage("AIDA Cruises"),
    "allFilter": MessageLookupByLibrary.simpleMessage("All"),
    "amountLabel": MessageLookupByLibrary.simpleMessage("Amount"),
    "appVersion": m1,
    "askQuestion": MessageLookupByLibrary.simpleMessage("Ask a Question"),
    "askQuestionHint": MessageLookupByLibrary.simpleMessage(
      "Enter your question here…",
    ),
    "askQuestionSubtitle": MessageLookupByLibrary.simpleMessage(
      "✈️ Do you have a question about your trip?\n💬 Feel free to ask it on the Q&A board so other users can help you! 😊",
    ),
    "askQuestionTitle": MessageLookupByLibrary.simpleMessage("Ask a Question"),
    "auszeitenAmMeerIntro": MessageLookupByLibrary.simpleMessage(
      "Our most beautiful seaside experiences 🌊🌅💙\n\nSalt air, sunsets and that feeling of freedom – these are our favorite sea moments.",
    ),
    "auszeitenAmMeerTitle": MessageLookupByLibrary.simpleMessage(
      "Seaside Getaways",
    ),
    "becomePartnerText": m2,
    "berlinSubtitle": MessageLookupByLibrary.simpleMessage("Capital & History"),
    "berlinTitle": MessageLookupByLibrary.simpleMessage("Berlin"),
    "bio": MessageLookupByLibrary.simpleMessage("Bio"),
    "bioHint": MessageLookupByLibrary.simpleMessage("Your biography"),
    "bioSaveError": MessageLookupByLibrary.simpleMessage("Error saving bio"),
    "bioSaved": MessageLookupByLibrary.simpleMessage("Bio saved successfully"),
    "block": MessageLookupByLibrary.simpleMessage("Block"),
    "budget": MessageLookupByLibrary.simpleMessage("Budget"),
    "budgetTitle": MessageLookupByLibrary.simpleMessage("Budget"),
    "callAction": MessageLookupByLibrary.simpleMessage("Call"),
    "callFailed": MessageLookupByLibrary.simpleMessage(
      "Could not start the call",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelButton": MessageLookupByLibrary.simpleMessage("Cancel"),
    "caption": MessageLookupByLibrary.simpleMessage("Caption"),
    "categoryEmergency": MessageLookupByLibrary.simpleMessage("Emergency"),
    "categoryHotel": MessageLookupByLibrary.simpleMessage("Hotel"),
    "categoryLabel": MessageLookupByLibrary.simpleMessage("Category"),
    "categoryNameHint": MessageLookupByLibrary.simpleMessage("Category name"),
    "categoryOther": MessageLookupByLibrary.simpleMessage("Other"),
    "categoryPrivate": MessageLookupByLibrary.simpleMessage("Private"),
    "changeProfilePicture": MessageLookupByLibrary.simpleMessage(
      "Change Profile Picture",
    ),
    "checklist": MessageLookupByLibrary.simpleMessage("Checklist"),
    "checklistSubtitle": MessageLookupByLibrary.simpleMessage(
      "Must-dos in Mallorca",
    ),
    "cityGeiranger": MessageLookupByLibrary.simpleMessage("Geiranger"),
    "cityMallorca": MessageLookupByLibrary.simpleMessage("Mallorca"),
    "cityRome": MessageLookupByLibrary.simpleMessage("Rome"),
    "cityTripsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Between towers, cafés & cobblestones 🏰✨",
    ),
    "cityTripsTitle": MessageLookupByLibrary.simpleMessage("City Trips"),
    "comingSoon": MessageLookupByLibrary.simpleMessage(
      "This feature is coming soon!",
    ),
    "commentReported": MessageLookupByLibrary.simpleMessage(
      "Comment has been reported",
    ),
    "comments": MessageLookupByLibrary.simpleMessage("Comments"),
    "confirmDeleteText": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this travel diary?",
    ),
    "confirmDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "Confirm Deletion",
    ),
    "contactFeedback": MessageLookupByLibrary.simpleMessage(
      "Contact & Feedback",
    ),
    "contactTitle": MessageLookupByLibrary.simpleMessage(
      "Contact & Consultation",
    ),
    "contacts": MessageLookupByLibrary.simpleMessage("Contacts"),
    "contentLabel": MessageLookupByLibrary.simpleMessage("Content"),
    "contributions": MessageLookupByLibrary.simpleMessage("Contributions"),
    "cotedazurSubtitle": MessageLookupByLibrary.simpleMessage(
      "Coast of our dreams",
    ),
    "cotedazurTitle": MessageLookupByLibrary.simpleMessage("Côte d\'Azur"),
    "countryItaly": MessageLookupByLibrary.simpleMessage("Italy"),
    "countryNorway": MessageLookupByLibrary.simpleMessage("Norway"),
    "countrySpain": MessageLookupByLibrary.simpleMessage("Spain"),
    "createPost": MessageLookupByLibrary.simpleMessage("Create Post"),
    "createStory": MessageLookupByLibrary.simpleMessage("Create Story"),
    "createTrip": MessageLookupByLibrary.simpleMessage("Create Trip"),
    "cropImage": MessageLookupByLibrary.simpleMessage("Bild zuschneiden"),
    "darkMode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
    "darkModeChanged": m3,
    "days": MessageLookupByLibrary.simpleMessage("Days"),
    "daysAgo": m4,
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete Account"),
    "deleteAction": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteButton": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteCategoryMessage": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this category?",
    ),
    "deleteCategoryTitle": MessageLookupByLibrary.simpleMessage(
      "Delete category",
    ),
    "deleteComment": MessageLookupByLibrary.simpleMessage("Delete Comment"),
    "deleteCommentConfirm": MessageLookupByLibrary.simpleMessage(
      "Do you really want to delete this comment?",
    ),
    "deleteCommentContent": MessageLookupByLibrary.simpleMessage(
      "Do you really want to delete this comment?",
    ),
    "deleteCommentTitle": MessageLookupByLibrary.simpleMessage(
      "Delete comment",
    ),
    "deleteConfirm": MessageLookupByLibrary.simpleMessage(
      "Do you really want to delete this post?",
    ),
    "deleteContactConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this contact?",
    ),
    "deleteContactTitle": MessageLookupByLibrary.simpleMessage(
      "Delete Contact",
    ),
    "deleteError": m5,
    "deleteMenuItem": MessageLookupByLibrary.simpleMessage("Delete"),
    "deletePost": MessageLookupByLibrary.simpleMessage("Delete Post"),
    "deletePostConfirm": MessageLookupByLibrary.simpleMessage(
      "Do you really want to delete this post?",
    ),
    "deleteTripMessage": MessageLookupByLibrary.simpleMessage(
      "Do you really want to delete this trip? This cannot be undone.",
    ),
    "deleteTripTitle": MessageLookupByLibrary.simpleMessage("Delete trip?"),
    "depositsLabel": MessageLookupByLibrary.simpleMessage("Deposits:"),
    "descGeiranger": MessageLookupByLibrary.simpleMessage(
      "Spectacular fjord with breathtaking waterfalls and stunning natural scenery.",
    ),
    "descMallorca": MessageLookupByLibrary.simpleMessage(
      "Mediterranean dream island with white sandy beaches, dramatic cliffs, charming villages and vibrant nightlife.",
    ),
    "descRome": MessageLookupByLibrary.simpleMessage(
      "Historic capital full of ancient architecture, vibrant squares, charming streets and amazing food.",
    ),
    "description": MessageLookupByLibrary.simpleMessage("Beschreibung"),
    "diary": MessageLookupByLibrary.simpleMessage("Diary"),
    "diaryDeleted": MessageLookupByLibrary.simpleMessage(
      "Travel diary deleted successfully",
    ),
    "diaryEntry": MessageLookupByLibrary.simpleMessage("Diary Entry"),
    "diaryNotFound": MessageLookupByLibrary.simpleMessage(
      "Travel diary not found",
    ),
    "diaryUpdated": MessageLookupByLibrary.simpleMessage(
      "Travel diary updated successfully",
    ),
    "disclaimer": MessageLookupByLibrary.simpleMessage(
      "All content and images shown in this app originate either from our private trips and personal experiences or from explicitly marked partnerships with partner companies.",
    ),
    "disclaimerPartner": MessageLookupByLibrary.simpleMessage(
      "Advertisement / Partner Travel Agency · Recommended by MamaTochterOnTour",
    ),
    "discoverAdventures": MessageLookupByLibrary.simpleMessage(
      "Discover our adventures around the world",
    ),
    "dubaiSubtitle": MessageLookupByLibrary.simpleMessage(
      "Adventure between desert & skyline",
    ),
    "dubaiTitle": MessageLookupByLibrary.simpleMessage("Dubai"),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "editAction": MessageLookupByLibrary.simpleMessage("Edit"),
    "editButton": MessageLookupByLibrary.simpleMessage("Edit"),
    "editCategory": MessageLookupByLibrary.simpleMessage("Rename category"),
    "editComment": MessageLookupByLibrary.simpleMessage("Edit Comment"),
    "editContact": MessageLookupByLibrary.simpleMessage("Edit Contact"),
    "editDepositTitle": MessageLookupByLibrary.simpleMessage("Edit Deposit"),
    "editMenuItem": MessageLookupByLibrary.simpleMessage("Edit"),
    "editNote": MessageLookupByLibrary.simpleMessage("Edit Note"),
    "editPost": MessageLookupByLibrary.simpleMessage("Edit"),
    "editPostTitle": MessageLookupByLibrary.simpleMessage("Edit Post"),
    "editProfile": MessageLookupByLibrary.simpleMessage("Edit Profile"),
    "editProfileTitle": MessageLookupByLibrary.simpleMessage("Edit Profile"),
    "editQuestion": MessageLookupByLibrary.simpleMessage("Edit question"),
    "editReplyTitle": MessageLookupByLibrary.simpleMessage("Edit reply"),
    "editTravelDiaryTitle": MessageLookupByLibrary.simpleMessage(
      "Edit Travel Diary",
    ),
    "editTrip": MessageLookupByLibrary.simpleMessage("Edit trip"),
    "emailLabel": MessageLookupByLibrary.simpleMessage("Send Email"),
    "emergencyContact": MessageLookupByLibrary.simpleMessage(
      "Emergency contact",
    ),
    "emptyContactsPlaceholder": MessageLookupByLibrary.simpleMessage(
      "No contacts yet.",
    ),
    "emptyNotesPlaceholder": MessageLookupByLibrary.simpleMessage(
      "No notes yet 📝\n\nHere you can collect notes for your trip ✈️🏖️ – e.g. favorite restaurants, cool activities or ideas before and during your trip.",
    ),
    "endDate": MessageLookupByLibrary.simpleMessage("End date"),
    "enterNewQuestion": MessageLookupByLibrary.simpleMessage(
      "Enter new question",
    ),
    "enterNewReply": MessageLookupByLibrary.simpleMessage("Enter new reply"),
    "enterQuestion": MessageLookupByLibrary.simpleMessage(
      "Please enter a question!",
    ),
    "enterText": MessageLookupByLibrary.simpleMessage("Enter text"),
    "error": m6,
    "errorLoading": MessageLookupByLibrary.simpleMessage(
      "Error loading settings",
    ),
    "errorLoadingContacts": MessageLookupByLibrary.simpleMessage(
      "Error loading contacts",
    ),
    "featureCamper": MessageLookupByLibrary.simpleMessage("Camper travel"),
    "featureCityTrips": MessageLookupByLibrary.simpleMessage("City trips"),
    "featureClub": MessageLookupByLibrary.simpleMessage("Club holidays"),
    "featureCruises": MessageLookupByLibrary.simpleMessage("Cruises"),
    "featureFamily": MessageLookupByLibrary.simpleMessage("Family vacations"),
    "featureHoneymoon": MessageLookupByLibrary.simpleMessage("Honeymoon"),
    "featureIndividual": MessageLookupByLibrary.simpleMessage(
      "Individual trips",
    ),
    "featureLongHaul": MessageLookupByLibrary.simpleMessage("Long-haul travel"),
    "featureLuxury": MessageLookupByLibrary.simpleMessage("Luxury travel"),
    "featurePackage": MessageLookupByLibrary.simpleMessage("Package holidays"),
    "featureRoundTrips": MessageLookupByLibrary.simpleMessage("Round trips"),
    "featureWellness": MessageLookupByLibrary.simpleMessage("Wellness & spa"),
    "feed": MessageLookupByLibrary.simpleMessage("Feed"),
    "feedFilterFavorites": MessageLookupByLibrary.simpleMessage("Favorites"),
    "feedFilterFriends": MessageLookupByLibrary.simpleMessage("Friends"),
    "feedbackBodyEmail": MessageLookupByLibrary.simpleMessage("Email"),
    "feedbackBodyImprovement": MessageLookupByLibrary.simpleMessage(
      "Suggestions for improvement",
    ),
    "feedbackBodyName": MessageLookupByLibrary.simpleMessage("Name"),
    "feedbackBodyQuestions": MessageLookupByLibrary.simpleMessage(
      "Other questions",
    ),
    "feedbackBodyWishes": MessageLookupByLibrary.simpleMessage("Requests"),
    "feedbackButtonSubmit": MessageLookupByLibrary.simpleMessage("Submit"),
    "feedbackCannotOpenEmail": MessageLookupByLibrary.simpleMessage(
      "Unable to open email app",
    ),
    "feedbackFillAtLeastOne": MessageLookupByLibrary.simpleMessage(
      "Please fill in at least one message field",
    ),
    "feedbackIntro": MessageLookupByLibrary.simpleMessage(
      "We’re happy to hear from you! Do you have questions or would you like to share feedback? Then you’re in the right place.",
    ),
    "feedbackLabelEmail": MessageLookupByLibrary.simpleMessage("Email *"),
    "feedbackLabelImprovement": MessageLookupByLibrary.simpleMessage(
      "Suggestions for improvement",
    ),
    "feedbackLabelName": MessageLookupByLibrary.simpleMessage("Name *"),
    "feedbackLabelQuestions": MessageLookupByLibrary.simpleMessage(
      "Other questions",
    ),
    "feedbackLabelWishes": MessageLookupByLibrary.simpleMessage(
      "App feature requests",
    ),
    "feedbackSubject": MessageLookupByLibrary.simpleMessage("Feedback from"),
    "feedbackTitle": MessageLookupByLibrary.simpleMessage("Contact & Feedback"),
    "feedbackValidatorEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter your email",
    ),
    "feedbackValidatorName": MessageLookupByLibrary.simpleMessage(
      "Please enter your name",
    ),
    "fernreisenGridTitle": MessageLookupByLibrary.simpleMessage(
      "Our Long-Haul Trips",
    ),
    "fernreisenIntro": MessageLookupByLibrary.simpleMessage(
      "Our best experiences far away ✈️🌍\nAdventures, discoveries, and unforgettable moments – get inspired for your next trip!",
    ),
    "fernreisenTitle": MessageLookupByLibrary.simpleMessage("Long-Haul Trips"),
    "fillAllFields": MessageLookupByLibrary.simpleMessage(
      "Please fill out all fields",
    ),
    "fillAllFieldsError": MessageLookupByLibrary.simpleMessage(
      "Please fill out all fields!",
    ),
    "floridaSubtitle": MessageLookupByLibrary.simpleMessage(
      "Roadtrip through paradise",
    ),
    "floridaTitle": MessageLookupByLibrary.simpleMessage("Florida"),
    "followBtn": MessageLookupByLibrary.simpleMessage("Follow"),
    "followError": MessageLookupByLibrary.simpleMessage(
      "Error while following/unfollowing",
    ),
    "followOurJourney": MessageLookupByLibrary.simpleMessage(
      "Join our journey 🧭✨",
    ),
    "followers": MessageLookupByLibrary.simpleMessage("Followers"),
    "following": MessageLookupByLibrary.simpleMessage("Following"),
    "followingBtn": MessageLookupByLibrary.simpleMessage("Following"),
    "fullTextReisebuero": MessageLookupByLibrary.simpleMessage(
      "The world is huge – come, we will show it to you!\n\nWe are a well-coordinated team of 15 passionate travel experts, who have been creating unforgettable vacation moments together for many years.\n\nNo matter where you want to go – with us, you\'ll always find the right contact person: competent, experienced, and attentive to all your wishes.\n\nWhat makes us special? We love what we do. That\'s why every consultation contains not only expertise but also a lot of heart and real enthusiasm.\n\nOur travel agency has existed for many years – and from colleagues, our very own little TUI family has long been formed. It is important to us that you feel not only professionally advised but also completely well taken care of.\n\nTrust us with your vacation: we plan every trip as if it were our own.\nFor us, not only expertise matters but above all humanity, passion, and the desire to make every trip something truly special.",
    ),
    "genuaSubtitle": MessageLookupByLibrary.simpleMessage(
      "Port city & Liguria",
    ),
    "genuaTitle": MessageLookupByLibrary.simpleMessage("Genoa"),
    "goalExceeded": MessageLookupByLibrary.simpleMessage("⚠️ Goal exceeded"),
    "goalExceededMessage": m7,
    "googleMapsLabel": MessageLookupByLibrary.simpleMessage("View on Google"),
    "guides": MessageLookupByLibrary.simpleMessage("Guides"),
    "hamburgSubtitle": MessageLookupByLibrary.simpleMessage(
      "Gateway to the world",
    ),
    "hamburgTitle": MessageLookupByLibrary.simpleMessage("Hamburg"),
    "hashtags": MessageLookupByLibrary.simpleMessage("Hashtags"),
    "headerTitleTUI": MessageLookupByLibrary.simpleMessage("TUI Aschaffenburg"),
    "hoursAgo": m8,
    "hoursShort": MessageLookupByLibrary.simpleMessage("Hrs"),
    "imageCropTitle": MessageLookupByLibrary.simpleMessage("Crop Image"),
    "impressum": MessageLookupByLibrary.simpleMessage("Imprint"),
    "impressumCopyrightContent": MessageLookupByLibrary.simpleMessage(
      "The content and works created through the app are subject to German copyright law. Reproduction, editing, distribution and any kind of use outside the limits of copyright require the written consent of the respective author or creator.",
    ),
    "impressumCopyrightTitle": MessageLookupByLibrary.simpleMessage(
      "Copyright",
    ),
    "impressumDisputeContent": MessageLookupByLibrary.simpleMessage(
      "The European Commission has discontinued the online dispute resolution (ODR) platform as of 31.12.2023.\n\nWe do not participate in dispute resolution proceedings before a consumer arbitration board.",
    ),
    "impressumDisputeTitle": MessageLookupByLibrary.simpleMessage(
      "Dispute resolution",
    ),
    "impressumHeader": MessageLookupByLibrary.simpleMessage(
      "Information according to §5 TMG",
    ),
    "impressumLiabilityContentContent": MessageLookupByLibrary.simpleMessage(
      "We do not guarantee the timeliness, correctness, completeness or quality of the information provided.",
    ),
    "impressumLiabilityContentTitle": MessageLookupByLibrary.simpleMessage(
      "Liability for content",
    ),
    "impressumLiabilityLinksContent": MessageLookupByLibrary.simpleMessage(
      "Our app contains links to external third-party websites, over whose content we have no influence. The respective provider or operator of the pages is always responsible for the content of the linked pages.",
    ),
    "impressumLiabilityLinksTitle": MessageLookupByLibrary.simpleMessage(
      "Liability for links",
    ),
    "impressumResponsibleContent": MessageLookupByLibrary.simpleMessage(
      "Jenny Weinreich\nStettiner Straße 41\n35410 Hungen\nGermany\nEmail: mamatochterontour@outlook.de",
    ),
    "impressumResponsibleTitle": MessageLookupByLibrary.simpleMessage(
      "Person responsible for the content of this app:",
    ),
    "impressumStand": MessageLookupByLibrary.simpleMessage(
      "Status: December 2025",
    ),
    "impressumTitle": MessageLookupByLibrary.simpleMessage("Imprint"),
    "impressumVatContent": MessageLookupByLibrary.simpleMessage("DE441919331"),
    "impressumVatTitle": MessageLookupByLibrary.simpleMessage(
      "VAT ID according to §27a of the German VAT Act:",
    ),
    "insiderTips": MessageLookupByLibrary.simpleMessage("Insider Tips"),
    "insiderTipsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Our secret spots",
    ),
    "insiderTitle": MessageLookupByLibrary.simpleMessage("Our Insider Tips ✨"),
    "instagramLabel": MessageLookupByLibrary.simpleMessage("Instagram"),
    "invalidInputMessage": MessageLookupByLibrary.simpleMessage(
      "Please enter a category and a valid amount.",
    ),
    "invalidInputTitle": MessageLookupByLibrary.simpleMessage("Invalid Input"),
    "italienSubtitle": MessageLookupByLibrary.simpleMessage(
      "Discover Bella Italia",
    ),
    "italienTitle": MessageLookupByLibrary.simpleMessage("Italy"),
    "itemHint": MessageLookupByLibrary.simpleMessage("Add item..."),
    "journals": MessageLookupByLibrary.simpleMessage("Journals"),
    "justNow": MessageLookupByLibrary.simpleMessage("just now"),
    "kalifornienSubtitle": MessageLookupByLibrary.simpleMessage(
      "Roadtrip through the Golden State",
    ),
    "kalifornienTitle": MessageLookupByLibrary.simpleMessage("California"),
    "koelnSubtitle": MessageLookupByLibrary.simpleMessage(
      "Heart between Cathedral and Rhine",
    ),
    "koelnTitle": MessageLookupByLibrary.simpleMessage("Cologne"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "legalHelp": MessageLookupByLibrary.simpleMessage("Legal & Help"),
    "likesCount": m9,
    "likesCount2": m10,
    "likesTextMultiple": m11,
    "likesTextSingle": m12,
    "location": MessageLookupByLibrary.simpleMessage("Location"),
    "londonSubtitle": MessageLookupByLibrary.simpleMessage(
      "City of Royals & Culture",
    ),
    "londonTitle": MessageLookupByLibrary.simpleMessage("London"),
    "longDistanceSubtitle": MessageLookupByLibrary.simpleMessage(
      "Wide worlds, big dreams 🌍❤️",
    ),
    "longDistanceTitle": MessageLookupByLibrary.simpleMessage(
      "Long-Distance Trips",
    ),
    "mallorcaFeed": MessageLookupByLibrary.simpleMessage("Mallorca Feed"),
    "mallorcaFeedSubtitle": MessageLookupByLibrary.simpleMessage(
      "Our daily experiences",
    ),
    "mallorcaHeroText": MessageLookupByLibrary.simpleMessage(
      "Our Mallorca Adventure ☀️",
    ),
    "mallorcaMap": MessageLookupByLibrary.simpleMessage("Mallorca Map"),
    "mallorcaMapSubtitle": MessageLookupByLibrary.simpleMessage(
      "All locations on a map",
    ),
    "mallorcaSubtitle": MessageLookupByLibrary.simpleMessage(
      "Island of our hearts",
    ),
    "mallorcaTitle": MessageLookupByLibrary.simpleMessage("Mallorca"),
    "maxMedia": MessageLookupByLibrary.simpleMessage(
      "Maximal 10 Medien pro Beitrag erlaubt",
    ),
    "meldButton": MessageLookupByLibrary.simpleMessage("Report"),
    "miniGuides": MessageLookupByLibrary.simpleMessage("Mini Guides"),
    "miniGuidesSubtitle": MessageLookupByLibrary.simpleMessage(
      "Short travel guides",
    ),
    "minutesAgo": m13,
    "minutesShort": MessageLookupByLibrary.simpleMessage("Min"),
    "moreComing": MessageLookupByLibrary.simpleMessage(
      "More insider tips for exciting destinations coming soon! ✨",
    ),
    "myPackingList": MessageLookupByLibrary.simpleMessage("My packing list"),
    "myProfile": MessageLookupByLibrary.simpleMessage("My Profile"),
    "nameLabel": MessageLookupByLibrary.simpleMessage("Name"),
    "newCategoryName": MessageLookupByLibrary.simpleMessage("New name"),
    "newContact": MessageLookupByLibrary.simpleMessage("New Contact"),
    "newNote": MessageLookupByLibrary.simpleMessage("New Note"),
    "newText": MessageLookupByLibrary.simpleMessage("New Text"),
    "newTravelDiary": MessageLookupByLibrary.simpleMessage("New Travel Diary"),
    "newyorkSubtitle": MessageLookupByLibrary.simpleMessage(
      "Magic at Christmas time",
    ),
    "newyorkTitle": MessageLookupByLibrary.simpleMessage("New York"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "noBio": MessageLookupByLibrary.simpleMessage("No biography"),
    "noBudgetCreated": MessageLookupByLibrary.simpleMessage(
      "You haven\'t created a budget yet.\nStart now and save for your dream vacation! 🏖️💰",
    ),
    "noComments": MessageLookupByLibrary.simpleMessage("No comments yet"),
    "noJournal": MessageLookupByLibrary.simpleMessage("No journal created yet"),
    "noJournalMessage": MessageLookupByLibrary.simpleMessage(
      "Write your first travel diary ✍️\n\nCapture your best experiences – including photos & videos.",
    ),
    "noPost": MessageLookupByLibrary.simpleMessage("No post uploaded yet"),
    "noPostMessage": MessageLookupByLibrary.simpleMessage(
      "Upload your first post 🌍✨\n\nInspire others with your travels and favorite moments.",
    ),
    "noPostsFound": MessageLookupByLibrary.simpleMessage("No posts found"),
    "noQuestionsYet": MessageLookupByLibrary.simpleMessage(
      "💬 No questions have been asked yet.\nAsk the first question 😊",
    ),
    "noResults": MessageLookupByLibrary.simpleMessage("No places found 😕"),
    "noStories": MessageLookupByLibrary.simpleMessage("No stories available"),
    "noTitle": MessageLookupByLibrary.simpleMessage("No title"),
    "noTripsPlanned": MessageLookupByLibrary.simpleMessage(
      "No trips planned yet ✈️",
    ),
    "noordwijkSubtitle": MessageLookupByLibrary.simpleMessage(
      "Dunes, calm & North Sea magic",
    ),
    "noordwijkTitle": MessageLookupByLibrary.simpleMessage("Noordwijk"),
    "note": MessageLookupByLibrary.simpleMessage("Note"),
    "noteDeleteError": MessageLookupByLibrary.simpleMessage(
      "Error deleting note",
    ),
    "noteEmptyError": MessageLookupByLibrary.simpleMessage(
      "Please fill at least one field!",
    ),
    "noteLimitPremium": MessageLookupByLibrary.simpleMessage(
      "Non-premium users can create only 2 notes. Tap here to unlock Premium!",
    ),
    "noteSaveError": MessageLookupByLibrary.simpleMessage("Error saving note"),
    "notes": MessageLookupByLibrary.simpleMessage("Notes"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "onlineConsultation": MessageLookupByLibrary.simpleMessage(
      "Online & video consultation available by appointment",
    ),
    "otherCategory": MessageLookupByLibrary.simpleMessage("Others"),
    "ourDestinations": MessageLookupByLibrary.simpleMessage(
      "Our Destinations 🌟",
    ),
    "ourStory": MessageLookupByLibrary.simpleMessage("Our Story"),
    "ourStorySubtitle": MessageLookupByLibrary.simpleMessage(
      "Experience our journey",
    ),
    "packingDoneMessage": MessageLookupByLibrary.simpleMessage(
      "You\'re fully packed, have a great trip! 🌍",
    ),
    "packingList": MessageLookupByLibrary.simpleMessage("Packing list"),
    "packingProgress": m14,
    "packlistLoadError": m15,
    "pageTitle": MessageLookupByLibrary.simpleMessage("Mom-Daughter Journal"),
    "pageTitleReisebueros": MessageLookupByLibrary.simpleMessage(
      "Travel Agencies",
    ),
    "parisSubtitle": MessageLookupByLibrary.simpleMessage(
      "Flair of the French metropolis",
    ),
    "parisTitle": MessageLookupByLibrary.simpleMessage("Paris"),
    "passwordDialogDescription": MessageLookupByLibrary.simpleMessage(
      "Please enter your password to permanently delete your account.",
    ),
    "passwordDialogLabel": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Delete Account Permanently",
    ),
    "passwordReset": MessageLookupByLibrary.simpleMessage("Reset Password"),
    "passwordResetSuccess": MessageLookupByLibrary.simpleMessage(
      "Password reset link sent via email!",
    ),
    "phoneLabel": MessageLookupByLibrary.simpleMessage("Phone Number"),
    "pickColor": MessageLookupByLibrary.simpleMessage("Pick a color"),
    "pickMedia": MessageLookupByLibrary.simpleMessage(
      "Pick an image or video …",
    ),
    "planning": MessageLookupByLibrary.simpleMessage("Planning"),
    "postDetails": MessageLookupByLibrary.simpleMessage("Post Details"),
    "postReported": MessageLookupByLibrary.simpleMessage(
      "Post was been reported",
    ),
    "postUpdateError": MessageLookupByLibrary.simpleMessage(
      "Error saving post",
    ),
    "postUpdateSuccess": MessageLookupByLibrary.simpleMessage(
      "Post successfully updated",
    ),
    "posts": MessageLookupByLibrary.simpleMessage("Posts"),
    "premium": MessageLookupByLibrary.simpleMessage("Premium"),
    "premiumBenefit1": MessageLookupByLibrary.simpleMessage(
      "Access to all travel journals from MamaTochterOnTour",
    ),
    "premiumBenefit2": MessageLookupByLibrary.simpleMessage(
      "Includes insider tips for each location",
    ),
    "premiumBenefit3": MessageLookupByLibrary.simpleMessage(
      "Create a packing list for your trips",
    ),
    "premiumBenefit4": MessageLookupByLibrary.simpleMessage(
      "Travel countdown for your next trip",
    ),
    "premiumBenefit5": MessageLookupByLibrary.simpleMessage("Save posts"),
    "premiumBenefitsTitle": MessageLookupByLibrary.simpleMessage(
      "Your Premium Benefits at a Glance",
    ),
    "premiumBestPrice": MessageLookupByLibrary.simpleMessage("Best Price"),
    "premiumBuyButton": MessageLookupByLibrary.simpleMessage("Buy"),
    "premiumCategoryLimit": MessageLookupByLibrary.simpleMessage(
      "You can only add 2 categories. Tap here to unlock premium! ✨",
    ),
    "premiumCheckError": m16,
    "premiumComingSoon": MessageLookupByLibrary.simpleMessage(
      "✨More coming soon!\nWe are constantly working to make your travel experiences even better. Look forward to many new features, exclusive content, and exciting extras – all automatically included in the Premium subscription.",
    ),
    "premiumErrorText": MessageLookupByLibrary.simpleMessage(
      "Error loading premium status. Please try again.",
    ),
    "premiumItemLimit": MessageLookupByLibrary.simpleMessage(
      "You can only add 5 items. Tap here to unlock premium! ✨",
    ),
    "premiumLegalAnd": MessageLookupByLibrary.simpleMessage("and"),
    "premiumLegalDot": MessageLookupByLibrary.simpleMessage("."),
    "premiumLegalIntro": MessageLookupByLibrary.simpleMessage(
      "By subscribing, you agree to our",
    ),
    "premiumLimitMessage": MessageLookupByLibrary.simpleMessage(
      "Non-premium users can only create 2 budget categories. Tap here to unlock premium!",
    ),
    "premiumLocked": MessageLookupByLibrary.simpleMessage(
      "Insider content is only available for premium users. Tap here to unlock premium.",
    ),
    "premiumMessage": MessageLookupByLibrary.simpleMessage(
      "You are not a premium member and cannot save posts. Tap here to upgrade ✨",
    ),
    "premiumMonthly": MessageLookupByLibrary.simpleMessage("Premium Monthly"),
    "premiumPrivacy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "premiumPrivacyUrl": MessageLookupByLibrary.simpleMessage(
      "https://mamatochterontour.com/pages/datenschutzrichtlinie-von-momentry",
    ),
    "premiumRestoreButton": MessageLookupByLibrary.simpleMessage(
      "Restore Purchase",
    ),
    "premiumSavePost": MessageLookupByLibrary.simpleMessage(
      "You are not a premium member and cannot save posts. Tap here to unlock Premium ✨",
    ),
    "premiumSaveWarning": MessageLookupByLibrary.simpleMessage(
      "You are not a premium member and cannot save posts. Tap here to unlock Premium ✨",
    ),
    "premiumSnackbarText": MessageLookupByLibrary.simpleMessage(
      "You are not a premium member and cannot read our journals. Tap here to unlock premium ✨",
    ),
    "premiumStatusActive": MessageLookupByLibrary.simpleMessage(
      "You are now a Premium member – all features unlocked!",
    ),
    "premiumStatusInactive": MessageLookupByLibrary.simpleMessage(
      "You are currently using the free version of the app.",
    ),
    "premiumStatusTitle": MessageLookupByLibrary.simpleMessage(
      "Your Subscription Status",
    ),
    "premiumTerms": MessageLookupByLibrary.simpleMessage("Terms of Service"),
    "premiumTermsUrl": MessageLookupByLibrary.simpleMessage(
      "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/",
    ),
    "premiumTitle": MessageLookupByLibrary.simpleMessage("Manage Premium"),
    "premiumTodoLimit": MessageLookupByLibrary.simpleMessage(
      "You are not a premium member and can only add up to 5 to-do items. Tap here to unlock premium ✨",
    ),
    "premiumYearly": MessageLookupByLibrary.simpleMessage("Premium Yearly"),
    "previewTextReisebuero": MessageLookupByLibrary.simpleMessage(
      "The world is huge – come, we will show it to you!\n\nWe are a well-coordinated team of 15 passionate travel experts, who have been creating unforgettable vacation moments together for many years.",
    ),
    "privacyIntro": MessageLookupByLibrary.simpleMessage(
      "This privacy policy informs you about the processing of your personal data when using our app.",
    ),
    "privacyLastUpdated": MessageLookupByLibrary.simpleMessage(
      "Privacy Policy – Updated December 2025",
    ),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "privacySection10Content": MessageLookupByLibrary.simpleMessage(
      "You have the right to lodge a complaint with a data protection supervisory authority regarding the processing of your data.",
    ),
    "privacySection10Title": MessageLookupByLibrary.simpleMessage(
      "10. Right to Complain",
    ),
    "privacySection11Content": MessageLookupByLibrary.simpleMessage(
      "The privacy policy may be updated due to app changes or legal requirements. The current version is always available in the app.",
    ),
    "privacySection11Title": MessageLookupByLibrary.simpleMessage(
      "11. Changes to Privacy Policy",
    ),
    "privacySection1Content": MessageLookupByLibrary.simpleMessage(
      "Name: Jenny Weinreich\nAddress: Stettiner Straße 41, 35410 Hungen\nEmail: mamatochterontour@outlook.de",
    ),
    "privacySection1Title": MessageLookupByLibrary.simpleMessage(
      "1. Controller",
    ),
    "privacySection2Content": MessageLookupByLibrary.simpleMessage(
      "We collect the following data:\n• Name and email address\n• Profile picture\n• Your posts and diary entries\n• Saved tips\n• Timestamps and activities within the app",
    ),
    "privacySection2Title": MessageLookupByLibrary.simpleMessage(
      "2. Collected Data",
    ),
    "privacySection3Content": MessageLookupByLibrary.simpleMessage(
      "We process your data for the following purposes:\n• Account creation and management\n• Provision of app functionalities\n• Community features and sharing posts\n• Premium features within the app\n• Handling of in-app purchases",
    ),
    "privacySection3Title": MessageLookupByLibrary.simpleMessage(
      "3. Purpose of Data Processing",
    ),
    "privacySection4Content": MessageLookupByLibrary.simpleMessage(
      "Processing is based on your consent (Art. 6(1)(a) GDPR) and for contract performance (Art. 6(1)(b) GDPR).",
    ),
    "privacySection4Title": MessageLookupByLibrary.simpleMessage(
      "4. Legal Basis",
    ),
    "privacySection5Content": MessageLookupByLibrary.simpleMessage(
      "We use Google Firebase services (Firebase Authentication, Firestore, Storage, Analytics). Data is processed exclusively on servers in Germany.",
    ),
    "privacySection5Title": MessageLookupByLibrary.simpleMessage(
      "5. Data Transfer",
    ),
    "privacySection6Content": MessageLookupByLibrary.simpleMessage(
      "Your data is stored as long as your account is active or statutory retention periods exist. After deletion of your account, all personal data is removed.",
    ),
    "privacySection6Title": MessageLookupByLibrary.simpleMessage(
      "6. Storage Duration",
    ),
    "privacySection7Content": MessageLookupByLibrary.simpleMessage(
      "You have the following rights regarding your data:\n• Access to stored data\n• Correction of incorrect data\n• Deletion of your data\n• Data portability\n• Withdrawal of your consent",
    ),
    "privacySection7Title": MessageLookupByLibrary.simpleMessage(
      "7. Your Rights",
    ),
    "privacySection8Content": MessageLookupByLibrary.simpleMessage(
      "Premium features are handled via in-app purchases. For these transactions, the app’s privacy policy applies.",
    ),
    "privacySection8Title": MessageLookupByLibrary.simpleMessage(
      "8. Premium Features",
    ),
    "privacySection9Content": MessageLookupByLibrary.simpleMessage(
      "For questions regarding data protection, reach us at: mamatochterontour@outlook.de. We respond within one week.",
    ),
    "privacySection9Title": MessageLookupByLibrary.simpleMessage("9. Contact"),
    "privacyTitle": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "profileDataLoadError": MessageLookupByLibrary.simpleMessage(
      "Error loading profile data",
    ),
    "profilePictureSaved": MessageLookupByLibrary.simpleMessage(
      "Profile picture saved successfully",
    ),
    "profilePictureUploadError": MessageLookupByLibrary.simpleMessage(
      "Error uploading profile picture",
    ),
    "publishPost": MessageLookupByLibrary.simpleMessage(
      "Beitrag veröffentlichen",
    ),
    "readLess": MessageLookupByLibrary.simpleMessage("Read less"),
    "readMore": MessageLookupByLibrary.simpleMessage("... read more"),
    "reauthOAuthError": MessageLookupByLibrary.simpleMessage(
      "Please sign in again to delete your account.",
    ),
    "reply": MessageLookupByLibrary.simpleMessage("Reply"),
    "replyTo": MessageLookupByLibrary.simpleMessage("Replying to"),
    "replyingTo": m17,
    "report": MessageLookupByLibrary.simpleMessage("Report"),
    "reportPost": MessageLookupByLibrary.simpleMessage("Report post"),
    "reportReason": MessageLookupByLibrary.simpleMessage("Reason for report"),
    "reportReasonHint": MessageLookupByLibrary.simpleMessage(
      "Reason for reporting",
    ),
    "reportUser": MessageLookupByLibrary.simpleMessage("Report User"),
    "reportedSuccess": MessageLookupByLibrary.simpleMessage(
      "Post has been reported",
    ),
    "roadtripEuropaGridTitle": MessageLookupByLibrary.simpleMessage(
      "Roadtrips across Europe",
    ),
    "roadtripEuropaIntro": MessageLookupByLibrary.simpleMessage(
      "Our best experiences by car 🚗✨\n\nRoadtrips across Europe – freedom, music, and unforgettable moments on the way.",
    ),
    "roadtripEuropaTitle": MessageLookupByLibrary.simpleMessage(
      "Europe Roadtrip",
    ),
    "roadtripEuropeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Driving through Europe\'s wonders 🚗💜",
    ),
    "roadtripEuropeTitle": MessageLookupByLibrary.simpleMessage(
      "Road Trips Europe",
    ),
    "romSubtitle": MessageLookupByLibrary.simpleMessage(
      "Eternal city & history",
    ),
    "romTitle": MessageLookupByLibrary.simpleMessage("Rome"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "saveBio": MessageLookupByLibrary.simpleMessage("Save Bio"),
    "saveButton": MessageLookupByLibrary.simpleMessage("Save"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("Save Changes"),
    "saveDiary": MessageLookupByLibrary.simpleMessage("Save Travel Diary"),
    "saveError": m18,
    "saveProfilePicture": MessageLookupByLibrary.simpleMessage(
      "Save Profile Picture",
    ),
    "saveQuestion": MessageLookupByLibrary.simpleMessage("Save Question"),
    "saveUsername": MessageLookupByLibrary.simpleMessage("Save Username"),
    "saving": MessageLookupByLibrary.simpleMessage("Saving…"),
    "savingIndicator": MessageLookupByLibrary.simpleMessage("Saving…"),
    "scheveningenSubtitle": MessageLookupByLibrary.simpleMessage(
      "Wind, sea & feeling of freedom",
    ),
    "scheveningenTitle": MessageLookupByLibrary.simpleMessage("Scheveningen"),
    "searchHint": MessageLookupByLibrary.simpleMessage("Search…"),
    "seasideGetawaysSubtitle": MessageLookupByLibrary.simpleMessage(
      "Sea moments to dream 🏖️✨",
    ),
    "seasideGetawaysTitle": MessageLookupByLibrary.simpleMessage(
      "Seaside Getaways",
    ),
    "secondsShort": MessageLookupByLibrary.simpleMessage("Sec"),
    "selectEndDate": MessageLookupByLibrary.simpleMessage("Select End Date"),
    "selectImage": MessageLookupByLibrary.simpleMessage("Select Image"),
    "selectStartDate": MessageLookupByLibrary.simpleMessage(
      "Select Start Date",
    ),
    "selectVideo": MessageLookupByLibrary.simpleMessage("Select Video"),
    "send": MessageLookupByLibrary.simpleMessage("Send"),
    "serviceTravel": MessageLookupByLibrary.simpleMessage(
      "Travel around the world – near or far",
    ),
    "servicesTitle": MessageLookupByLibrary.simpleMessage("Services"),
    "settingsTitle": MessageLookupByLibrary.simpleMessage("Settings"),
    "signOut": MessageLookupByLibrary.simpleMessage("Sign Out"),
    "staedtereisenIntro": MessageLookupByLibrary.simpleMessage(
      "Our city trip highlights 🏙️💜\n\nHere we collect our most beautiful experiences from the cities we love.",
    ),
    "staedtereisenTitle": MessageLookupByLibrary.simpleMessage("City Trips"),
    "startDate": MessageLookupByLibrary.simpleMessage("Start date"),
    "storySaved": MessageLookupByLibrary.simpleMessage("Story saved!"),
    "tabInsider": MessageLookupByLibrary.simpleMessage("Insider"),
    "tabTagebuecher": MessageLookupByLibrary.simpleMessage("Journals"),
    "tabTipps": MessageLookupByLibrary.simpleMessage("Tips"),
    "targetAmountLabel": MessageLookupByLibrary.simpleMessage("Target amount"),
    "terms10Content": MessageLookupByLibrary.simpleMessage(
      "• You can delete your account at any time in settings.\n• We may suspend or delete accounts in case of violations.\n• After deletion, your data will be handled according to the Privacy Policy.",
    ),
    "terms10Title": MessageLookupByLibrary.simpleMessage("10. Termination"),
    "terms11Content": MessageLookupByLibrary.simpleMessage(
      "We may change the terms and conditions. You will be informed about important changes in the app. In case of objection, you can delete your account.",
    ),
    "terms11Title": MessageLookupByLibrary.simpleMessage("11. Changes"),
    "terms12Content": MessageLookupByLibrary.simpleMessage(
      "German law applies. Jurisdiction as legally permitted. If individual provisions are invalid, the remaining provisions remain valid.",
    ),
    "terms12Title": MessageLookupByLibrary.simpleMessage(
      "12. Final Provisions",
    ),
    "terms13Content": MessageLookupByLibrary.simpleMessage(
      "For questions, please contact us at: mamatochterontour@outlook.de",
    ),
    "terms13Title": MessageLookupByLibrary.simpleMessage("13. Contact"),
    "terms1Content": MessageLookupByLibrary.simpleMessage(
      "Name: Jenny Weinreich\nAddress: Stettiner Straße 41, 35410 Hungen\nEmail: mamatochterontour@outlook.de\nVAT ID: DE441919331",
    ),
    "terms1Title": MessageLookupByLibrary.simpleMessage("1. Provider"),
    "terms2Content": MessageLookupByLibrary.simpleMessage(
      "These terms and conditions apply to the use of our travel community app. By registering, you fully accept these terms.",
    ),
    "terms2Title": MessageLookupByLibrary.simpleMessage("2. Scope"),
    "terms3Content": MessageLookupByLibrary.simpleMessage(
      "• The app is only usable with registration.\n• You must provide truthful information.\n• Keep your password confidential.\n• You are responsible for all activities in your account.",
    ),
    "terms3Title": MessageLookupByLibrary.simpleMessage(
      "3. Registration and User Account",
    ),
    "terms4Content": MessageLookupByLibrary.simpleMessage(
      "• You may create travel diaries and posts.\n• Share your own travel tips.\n• Use the app for private, non-commercial purposes.",
    ),
    "terms4Title": MessageLookupByLibrary.simpleMessage("4. Permitted Use"),
    "terms5Content": MessageLookupByLibrary.simpleMessage(
      "The following content is not allowed:\n• Illegal, offensive, or discriminatory content\n• Spam or advertising without permission\n• Copyright infringement\n• False or misleading information\n• Content that could endanger other users",
    ),
    "terms5Title": MessageLookupByLibrary.simpleMessage(
      "5. Prohibited Content",
    ),
    "terms6Content": MessageLookupByLibrary.simpleMessage(
      "Premium features within the app are paid and can be cancelled at any time.",
    ),
    "terms6Title": MessageLookupByLibrary.simpleMessage(
      "6. Premium Membership",
    ),
    "terms7Content": MessageLookupByLibrary.simpleMessage(
      "• You retain rights to your content.\n• You grant us the right to display your content in the app.\n• You are responsible for the legality of your content.\n• Illegal content may be deleted without notice.",
    ),
    "terms7Title": MessageLookupByLibrary.simpleMessage("7. Your Content"),
    "terms8Content": MessageLookupByLibrary.simpleMessage(
      "Protecting your data is important to us. Details on data processing can be found in our Privacy Policy available in the app.",
    ),
    "terms8Title": MessageLookupByLibrary.simpleMessage("8. Data Protection"),
    "terms9Content": MessageLookupByLibrary.simpleMessage(
      "• The app is provided without warranty.\n• User information does not reflect our opinion.\n• We are not liable for damages from app usage.\n• Travel information is without guarantee; verify it yourself.\n• We are fully liable in cases of intent or gross negligence.",
    ),
    "terms9Title": MessageLookupByLibrary.simpleMessage("9. Disclaimer"),
    "termsConditions": MessageLookupByLibrary.simpleMessage(
      "Terms & Conditions",
    ),
    "termsImportantNotice": MessageLookupByLibrary.simpleMessage(
      "Important notice: The terms and conditions are legally binding. Please read them carefully.",
    ),
    "termsLastUpdated": MessageLookupByLibrary.simpleMessage(
      "Terms and Conditions – Updated December 2025",
    ),
    "termsTitle": MessageLookupByLibrary.simpleMessage("Terms and Conditions"),
    "themeLoadError": MessageLookupByLibrary.simpleMessage(
      "Error loading theme",
    ),
    "timeAgoDays": m19,
    "timeAgoHours": m20,
    "timeAgoJustNow": MessageLookupByLibrary.simpleMessage("just now"),
    "timeAgoMinutes": m21,
    "tipsAndFavorites": MessageLookupByLibrary.simpleMessage(
      "Tips & Favorites",
    ),
    "titleLabel": MessageLookupByLibrary.simpleMessage("Title"),
    "todoHint": MessageLookupByLibrary.simpleMessage("Enter item..."),
    "todoTitle": MessageLookupByLibrary.simpleMessage("To-Do List"),
    "todos": MessageLookupByLibrary.simpleMessage("To-dos"),
    "todosSaved": MessageLookupByLibrary.simpleMessage("To-dos saved!"),
    "travel": MessageLookupByLibrary.simpleMessage("Travels"),
    "travelDiary": MessageLookupByLibrary.simpleMessage("Travel Diary"),
    "tripContactsTitle": MessageLookupByLibrary.simpleMessage("Contacts"),
    "tripDestination": MessageLookupByLibrary.simpleMessage("Destination"),
    "tripLimitReached": MessageLookupByLibrary.simpleMessage(
      "You have reached the limit of 2 trips. Tap here to unlock Premium ✨",
    ),
    "tripName": MessageLookupByLibrary.simpleMessage("Trip name"),
    "tripNotFound": MessageLookupByLibrary.simpleMessage("Trip not found"),
    "tripNotesTitle": MessageLookupByLibrary.simpleMessage("Trip Notes"),
    "tripTitle": MessageLookupByLibrary.simpleMessage("Trip Title"),
    "tuiAschaffenburgSubtitle": MessageLookupByLibrary.simpleMessage(
      "Your contact for unforgettable vacations – personal, competent, warm-hearted.",
    ),
    "tuiAschaffenburgTitle": MessageLookupByLibrary.simpleMessage(
      "TUI Aschaffenburg (Travel Agency)",
    ),
    "unblock": MessageLookupByLibrary.simpleMessage("Unblock"),
    "unknownContact": MessageLookupByLibrary.simpleMessage("Unknown"),
    "uploadError": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Hochladen",
    ),
    "uploadPost": MessageLookupByLibrary.simpleMessage("Beitrag hochladen"),
    "user": MessageLookupByLibrary.simpleMessage("User"),
    "userBlocked": MessageLookupByLibrary.simpleMessage(
      "User has been blocked and unfollowed",
    ),
    "userReported": MessageLookupByLibrary.simpleMessage(
      "User has been reported",
    ),
    "userUnblocked": MessageLookupByLibrary.simpleMessage(
      "User has been unblocked",
    ),
    "username": MessageLookupByLibrary.simpleMessage("Username"),
    "usernameHint": MessageLookupByLibrary.simpleMessage("Your username"),
    "usernameSaveError": MessageLookupByLibrary.simpleMessage(
      "Error saving username",
    ),
    "usernameSaved": MessageLookupByLibrary.simpleMessage(
      "Username saved successfully",
    ),
    "welcomeText": MessageLookupByLibrary.simpleMessage(
      "Welcome to our travel journal! Here we collect all our wonderful memories, big and small adventures, spontaneous experiences, and very special moments we shared as mom and daughter. 💖\n\nWe traveled to Norway, Italy, the Caribbean, UAE, USA, Spain, Portugal, France, and much more. 🌏\n\nYou will also find hotel recommendations 🏨, restaurant tips 🍽️, and exclusive insider tips 🔍.",
    ),
    "whatsappLabel": MessageLookupByLibrary.simpleMessage("WhatsApp"),
    "wienSubtitle": MessageLookupByLibrary.simpleMessage(
      "Culture & coffeehouse charm",
    ),
    "wienTitle": MessageLookupByLibrary.simpleMessage("Vienna"),
    "writeAnswer": MessageLookupByLibrary.simpleMessage("Write an answer..."),
    "writeComment": MessageLookupByLibrary.simpleMessage("Write a comment..."),
    "writeCommentHint": MessageLookupByLibrary.simpleMessage(
      "Write a comment...",
    ),
    "writeDiary": MessageLookupByLibrary.simpleMessage("Write Diary"),
    "writeReply": MessageLookupByLibrary.simpleMessage("Write a reply..."),
    "writeReplyHint": MessageLookupByLibrary.simpleMessage("Write a reply..."),
    "years": MessageLookupByLibrary.simpleMessage("Years"),
    "yes": MessageLookupByLibrary.simpleMessage("Yes"),
  };
}
