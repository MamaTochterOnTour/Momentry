import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../l10n/s.dart';
import '../feed/video_post_payer.dart';

const String fixedProfileImageUrl =
    "https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorcaProfilBild.JPG?alt=media&token=7c64167f-dd7c-49d2-bb16-252834a602d4";
const String fixedUsername = "MamaTochterOnTour";

// ---------------- PostCard mit Herz-Animation und korrektem Premium Save ----------------
class MallorcaPostCard extends StatefulWidget {
  final Map<String, dynamic> post;
  final bool isDarkMode;

  const MallorcaPostCard({
    super.key,
    required this.post,
    required this.isDarkMode,
  });

  @override
  State<MallorcaPostCard> createState() => _MallorcaPostCardState();
}

class _MallorcaPostCardState extends State<MallorcaPostCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false; // NEU: steuert Caption/Hashtags einklappen

  PageController? _pageController;
  int _currentPage = 0;

  bool _shouldLoadMedia = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  Widget _buildMedia() {
    final mediaUrls = widget.post['media'] as List<dynamic>?;
    final mediaTypes = widget.post['mediaTypes'] as List<dynamic>?;

    // Wrap the media rendering with VisibilityDetector
    return VisibilityDetector(
      key: Key(
        'post_media_${widget.post['uid']}_${widget.post['createdAt']}',
      ), // Eindeutiger Schlüssel für jeden Post
      onVisibilityChanged: (info) {
        // Laden, wenn mindestens 50% sichtbar sind
        if (info.visibleFraction >= 0.5 && !_shouldLoadMedia) {
          setState(() {
            _shouldLoadMedia = true;
          });
        }
      },
      child: _shouldLoadMedia
          ? AspectRatio(
              aspectRatio: 3 / 4,
              child: GestureDetector(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // EIN MEDIUM
                    if (mediaUrls != null && mediaUrls.length == 1)
                      _buildSingleMediaContent(
                        mediaUrls[0],
                        mediaTypes != null && mediaTypes.isNotEmpty
                            ? mediaTypes[0]
                            : 'image',
                      ),

                    // MEHRERE MEDIEN (Carousel)
                    if (mediaUrls != null && mediaUrls.length > 1)
                      _buildMultiMediaContent(mediaUrls, mediaTypes),
                  ],
                ),
              ),
            )
          : const SizedBox(
              height: 300, // Platzhalterhöhe, kann angepasst werden
              child: Center(
                child: CircularProgressIndicator(),
              ), // Ladeindikator oder leeres Widget
            ),
    );
  }

  // Helper method for single media content
  Widget _buildSingleMediaContent(String url, String type) {
    return type == 'video'
        ? VideoPostPlayer(videoUrl: url)
        : Image.network(url, fit: BoxFit.cover);
  }

  // Helper method for multiple media content (PageView)
  Widget _buildMultiMediaContent(
    List<dynamic> mediaUrls,
    List<dynamic>? mediaTypes,
  ) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: mediaUrls.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final url = mediaUrls[index];
              final type = mediaTypes != null && index < mediaTypes.length
                  ? mediaTypes[index]
                  : 'image';
              return _buildSingleMediaContent(
                url,
                type,
              ); // Wiederverwendung des Single Media Builders
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(mediaUrls.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.purple : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }

  // NEU: Text kürzen ohne Wort zu schneiden
  // ignore: unused_element
  String _shortenText(String text, {int limit = 50}) {
    if (text.length <= limit) return text;
    final truncated = text.substring(0, limit);
    final lastSpace = truncated.lastIndexOf(' ');
    if (lastSpace == -1) return truncated;
    return truncated.substring(0, lastSpace);
  }

  String _getShortCaption(String caption, {int limit = 50}) {
    if (caption.length <= limit) return caption;
    final truncated = caption.substring(0, limit);
    final lastSpace = truncated.lastIndexOf(' ');
    return lastSpace == -1 ? truncated : truncated.substring(0, lastSpace);
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final secondaryColor = widget.isDarkMode ? Colors.white70 : Colors.black54;
    final strings = S.of(context)!;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('mallorca_liveboard')
          .doc(widget.post['id'])
          .snapshots(),
      builder: (context, snapshot) {
        return Card(
          color: widget.isDarkMode ? Colors.grey[900] : Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profil + Username + Location
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: const NetworkImage(fixedProfileImageUrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: Text(
                              fixedUsername,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          if (widget.post['location'] != null)
                            Text(
                              widget.post['location'],
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Post Image mit Herz-Animation
                // Alte und neue Posts
                if (widget.post['media'] != null &&
                    (widget.post['media'] as List).isNotEmpty)
                  GestureDetector(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _buildMedia(),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),

                // Caption + Hashtags
                if (widget.post['caption'] != null &&
                    (widget.post['caption'] as String).isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded; // einklappen/aufklappen
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: textColor, fontSize: 16),
                            children: [
                              TextSpan(
                                text: _isExpanded
                                    ? widget.post['caption']
                                    : _getShortCaption(widget.post['caption']),
                              ),
                              if (!_isExpanded &&
                                  widget.post['caption'].length > 50)
                                TextSpan(
                                  text: strings.readMore,
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                            ],
                          ),
                        ),
                        if (widget.post['hashtags'] != null &&
                            (widget.post['hashtags'] as List).isNotEmpty &&
                            _isExpanded) // oder immer anzeigen, je nach Wunsch
                          Wrap(
                            spacing: 8,
                            children: (widget.post['hashtags'] as List)
                                .map<Widget>((tag) {
                                  return Text(
                                    '$tag',
                                    style: TextStyle(color: Colors.blueAccent),
                                  );
                                })
                                .toList(),
                          ),
                      ],
                    ),
                  ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
