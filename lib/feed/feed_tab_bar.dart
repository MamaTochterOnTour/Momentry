import 'package:flutter/material.dart';
import 'feed_filter.dart';

class FeedTabBar extends StatelessWidget {
  final FeedFilter currentFilter;
  final Function(FeedFilter) onFilterChanged;
  final VoidCallback onQATap;
  final String allText;
  final String friendsText;
  final String favoritesText;

  const FeedTabBar({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
    required this.onQATap,
    required this.allText,
    required this.friendsText,
    required this.favoritesText,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: Colors.blueAccent,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.blueAccent,
      tabs: [
        Builder(
          builder: (context) {
            return GestureDetector(
              onTapDown: (details) async {
                final selected = await showMenu<FeedFilter>(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                  ),
                  items: [
                    PopupMenuItem(value: FeedFilter.all, child: Text(allText)),
                    PopupMenuItem(
                      value: FeedFilter.friends,
                      child: Text(friendsText),
                    ),
                    PopupMenuItem(
                      value: FeedFilter.favorites,
                      child: Text(favoritesText),
                    ),
                  ],
                );

                if (selected != null) {
                  onFilterChanged(selected);
                }
              },
              child: Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () async {
                      final selected = await showModalBottomSheet<FeedFilter>(
                        context: context,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 10),
                              _buildOption(context, FeedFilter.all, allText),
                              _buildOption(
                                context,
                                FeedFilter.friends,
                                friendsText,
                              ),
                              _buildOption(
                                context,
                                FeedFilter.favorites,
                                favoritesText,
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        },
                      );

                      if (selected != null) {
                        onFilterChanged(selected);
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentFilter == FeedFilter.all
                              ? allText
                              : currentFilter == FeedFilter.friends
                              ? friendsText
                              : favoritesText,
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, size: 18),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),

        const Tab(text: 'Q&A'),
      ],
    );
  }

  Widget _buildOption(BuildContext context, FeedFilter filter, String text) {
    return ListTile(
      title: Text(text),
      onTap: () => Navigator.pop(context, filter),
    );
  }
}
