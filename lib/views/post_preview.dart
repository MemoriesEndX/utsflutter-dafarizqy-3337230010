// post_view.dart
import 'package:flutter/material.dart';
import 'package:uts/controllers/post_controller.dart';
import 'package:uts/models/post_main.dart';
import 'package:uts/views/detail_post_preview.dart';
import 'package:get/get.dart';
import 'dart:math'; // Import for Random

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  // Generate a unique seed for this session/run to get different random images
  final int _uniqueSeed = DateTime.now().millisecondsSinceEpoch % 1000 + Random().nextInt(100);

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Berita Terbaru'), // Changed title to "Berita Terbaru"
        leading: const Icon(Icons.menu), // Changed icon to a menu icon for news app style
      ),
      body: FutureBuilder<List<Post>>(
        future: fetchPost(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: colorScheme.secondary,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      color: colorScheme.error,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada berita tersedia', // Changed text
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(0), // No overall padding for list
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final post = snapshot.data![index];
              return Column( // Use Column to add a Divider below each item
                children: [
                  InkWell( // Make the entire item tappable
                    onTap: () {
                      print('Berita ${post.id} di-klik');
                      Get.to(() => DetailPostingan(post: post));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align top for news style
                        children: [
                          // Left Text Section (Title and Category/Time)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: colorScheme.onSurface,
                                  ),
                                  maxLines: 3, // Allow more lines for news titles
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Kategori: ${post.userId} | ${DateTime.now().subtract(Duration(hours: index)).hour} jam lalu', // Placeholder for time/category
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Right Image Thumbnail
                          Container(
                            width: 100, // Fixed width for thumbnail
                            height: 70, // Fixed height for thumbnail
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: colorScheme.secondaryContainer.withOpacity(0.3),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                // Using Unsplash for random images
                                'https://source.unsplash.com/random/100x70?sig=${_uniqueSeed + index}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: colorScheme.secondary.withOpacity(0.2),
                                    child: Icon(
                                      Icons.image, // Generic image icon for error
                                      size: 30,
                                      color: colorScheme.primary.withOpacity(0.6),
                                    ),
                                  );
                                },
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
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
                                      strokeWidth: 2, // Thinner loading indicator
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider( // Separator line for each news item
                    color: colorScheme.onSurface.withOpacity(0.1),
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}