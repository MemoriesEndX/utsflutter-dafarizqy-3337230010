// detailpost_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uts/models/post_main.dart';
import 'package:uts/views/comment_preview.dart';
import 'dart:math'; // Import for Random

class DetailPostingan extends StatelessWidget {
  final Post post;

  const DetailPostingan({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Generate a unique seed for this session/run for avatar variation
    final int uniqueAvatarSeed =
        DateTime.now().millisecondsSinceEpoch % 1000 + Random().nextInt(100);

    // Placeholder for publisher info - you might get this from another API call or a more complex Post model
    final String publisherName = 'User_${post.userId}'; // Example username
    final String publisherAvatarUrl =
        'https://i.pravatar.cc/150?img=${uniqueAvatarSeed % 20 + 1}'; // Random avatar based on unique seed

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text('Detail Postingan #${post.id}'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ), // Reduced vertical padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User/Publisher Info Section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  ClipOval(
                    // Use ClipOval to make the image circular
                    child: SizedBox(
                      width: 40, // Match radius * 2 for CircleAvatar
                      height: 40,
                      child: Image.network(
                        publisherAvatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: colorScheme.primary.withOpacity(
                              0.2,
                            ), // Light background for fallback
                            child: Icon(
                              Icons.person,
                              color: colorScheme.primary, // Themed icon color
                              size: 30,
                            ),
                          );
                        },
                        loadingBuilder:
                            (
                              BuildContext context,
                              Widget child,
                              ImageChunkEvent? loadingProgress,
                            ) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: colorScheme.secondary,
                                ),
                              );
                            },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      publisherName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    color: colorScheme.onSurface,
                    onPressed: () {
                      // Handle more options
                      print('More options for user $publisherName');
                    },
                  ),
                ],
              ),
            ),

            // Post Image
            Card(
              margin: EdgeInsets.zero, // Remove margin to make it full width
              clipBehavior: Clip.antiAlias,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius
                    .zero, // No rounded corners for full-width image
              ),
              elevation: 0, // No shadow for the image card
              child: SizedBox(
                width: double.infinity,
                height: 280, // Slightly increased height for the image
                child: Image.network(
                  'https://boringapi.com/api/v1/static/photos/${post.id}.jpeg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: colorScheme.secondaryContainer,
                      child: Icon(
                        Icons.broken_image,
                        size: 64,
                        color: colorScheme.primary,
                      ),
                    );
                  },
                  loadingBuilder:
                      (
                        BuildContext context,
                        Widget child,
                        ImageChunkEvent? loadingProgress,
                      ) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                            color: colorScheme.secondary,
                          ),
                        );
                      },
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Interaction Icons (Like, Comment, Share)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    color: colorScheme.onSurface,
                    onPressed: () {
                      print('Like button pressed for post ${post.id}');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline),
                    color: colorScheme.onSurface,
                    onPressed: () {
                      print('Comment button pressed for post ${post.id}');
                      Get.to(
                        () => CommentView(post: post),
                      ); // Navigate to comments
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: colorScheme.onSurface,
                    onPressed: () {
                      print('Share button pressed for post ${post.id}');
                    },
                  ),
                  const Spacer(), // Pushes icons to the left
                  IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    color: colorScheme.onSurface,
                    onPressed: () {
                      print('Save button pressed for post ${post.id}');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Post Title and Body (as description)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        publisherName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          post.title, // Using title as the main description text
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 2, // Limit lines to keep it concise
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.body, // Additional body text if needed
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Lihat Komentar Button (Optional, as comments usually are listed below)
            Center(
              child: ElevatedButton(
                onPressed: () {
                  print('Lihat Komentar di-klik untuk postingan ${post.id}');
                  Get.to(() => CommentView(post: post));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.comment), // Added comment icon
                    const SizedBox(width: 8),
                    const Text(
                      'Lihat Komentar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16), // Padding at the bottom
          ],
        ),
      ),
    );
  }
}
