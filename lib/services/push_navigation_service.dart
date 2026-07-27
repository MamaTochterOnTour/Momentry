import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../main.dart';

import '../erstellen_tab/post_detail_page.dart';
import '../profil_tab/other_user_profil_page.dart';
import '../community_tab/gruppen/group_chat_page.dart';
import '../community_tab/qanda/qa_tab.dart';
import '../reisen_tab/reiseplanung/reiseplanung_page.dart';

void handlePushNavigation(RemoteMessage message) {
  final data = message.data;

  switch (data["type"]) {
    // -----------------------------
    // Post
    // -----------------------------
    case "comment":
    case "like":
    case "reply":
    case "comment_like":
    case "reply_like":
      final postId = data["postId"];

      if (postId == null) return;

      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => PostDetailPage(postId: postId)),
      );
      break;

    // -----------------------------
    // Follow
    // -----------------------------
    case "follow":
      final userId = data["followerId"];

      if (userId == null) return;

      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => OtherUserProfilePage(userId: userId)),
      );
      break;

    // -----------------------------
    // Gruppenchat
    // -----------------------------
    case "group_message":
      final groupId = data["groupId"];

      if (groupId == null) return;

      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => GroupChatPage(groupId: groupId)),
      );
      break;

    // -----------------------------
    // Q&A Antwort
    // -----------------------------
    case "qa_answer":
      final questionId = data["questionId"];

      if (questionId == null) return;

      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => QATab(openQuestionId: questionId)),
      );
      break;

    // -----------------------------
    // Q&A Reply
    // -----------------------------
    case "qa_reply":
      final questionId = data["questionId"];

      if (questionId == null) return;

      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => QATab(openQuestionId: questionId)),
      );
      break;

    // -----------------------------
    // Reise startet
    // -----------------------------
    case "trip_start":
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const TripsOverviewPage()),
      );
      break;

    // -----------------------------
    // Countdown
    // -----------------------------
    case "countdown_end":
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const TripsOverviewPage()),
      );
      break;

    // -----------------------------
    // Broadcast
    // -----------------------------
    case "broadcast":
    case "update":
      break;
  }
}
