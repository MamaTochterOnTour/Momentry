import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../profile/profile_tabs.dart';
import '../profile/profile_app_bar.dart';
import '../profile/followers_bottom_sheet.dart'; // <<< WICHTIG: anpassen falls anderer Name
import '../l10n/s.dart';
import '../profile/profile_header.dart';
import '../profile/profile_service.dart';

class ProfilePage extends StatefulWidget {
  final int initialTabIndex; // <<< NEU

  const ProfilePage({
    super.key,
    this.initialTabIndex = 0,
  }); // default = 0 = erster Tab

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with RouteAware {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProfileService _profileService = ProfileService();

  User? _user;
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _reisen = [];
  List<Map<String, dynamic>> _beitraege = [];

  bool _isLoading = true;

  int _followerCount = 0;
  int _followingCount = 0;
  List<String> _followerIds = [];
  List<String> _followingIds = [];

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _fetchUserData();

    // TabController später im DefaultTabController init
    // Wird weiter unten beim DefaultTabController benutzt
  }

  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);

    try {
      final data = await _profileService.fetchProfileData();

      _userData = data['userData'];
      _reisen = List<Map<String, dynamic>>.from(data['reisen']);
      _beitraege = List<Map<String, dynamic>>.from(data['beitraege']);

      _followerCount = data['followerCount'];
      _followingCount = data['followingCount'];
      _followerIds = List<String>.from(data['followerIds']);
      _followingIds = List<String>.from(data['followingIds']);
    } catch (e) {
      debugPrint('Fehler beim Laden: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final purple = const Color(0xFF8C77FF);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,

      appBar: ProfileAppBar(
        user: _user,
        isDarkMode: isDarkMode,
        username: _userData?['username'] ?? '',
      ),

      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: purple))
          : RefreshIndicator(
              color: purple,
              onRefresh: _fetchUserData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height:
                          kToolbarHeight + MediaQuery.of(context).padding.top,
                    ),

                    // Profil Header
                    ProfileHeader(
                      userData: _userData,
                      reisenCount: _reisen.length,
                      beitraegeCount: _beitraege.length,
                      followerCount: _followerCount,
                      followingCount: _followingCount,

                      onFollowersTap: () => openUserListSheet(
                        context: context,
                        title: S.of(context)!.followers,
                        userIds: _followerIds,
                        isFollowerList: true,
                      ),

                      onFollowingTap: () => openUserListSheet(
                        context: context,
                        title: S.of(context)!.following,
                        userIds: _followingIds,
                        isFollowerList: false,
                      ),

                      isDarkMode: isDarkMode,
                    ),

                    const SizedBox(height: 16),

                    ProfileTabs(
                      reisen: _reisen,
                      beitraege: _beitraege,
                      isDarkMode: isDarkMode,
                      purple: purple,
                      initialTabIndex: widget.initialTabIndex,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
