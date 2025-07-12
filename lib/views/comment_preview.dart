// comment_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uts/controllers/comment_controller.dart';
import 'package:uts/models/post_main.dart';
import 'dart:math'; // Import for Random

class CommentView extends StatelessWidget {
  final Post post;

  const CommentView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final CommentController commentController = Get.put(
      CommentController(),
      tag: 'post_${post.id}',
    );

    commentController.fetchComments(post.id);
    final colorScheme = Theme.of(context).colorScheme;

    // Generate a unique seed for this session/run for comment avatars
    final int uniqueCommentAvatarSeed =
        DateTime.now().millisecondsSinceEpoch % 1000 + Random().nextInt(100);

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text('Komentar untuk Post #${post.id}'),
        leading: const BackButton(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: double.infinity,
                height: 200,
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              post.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
          Divider(
            color: colorScheme.primary.withOpacity(0.3),
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
          Expanded(
            child: Obx(() {
              if (commentController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: colorScheme.secondary,
                  ),
                );
              }

              if (commentController.error.value != null) {
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
                        'Error: ${commentController.error.value}',
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

              if (commentController.comments.isEmpty) {
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
                        'Tidak ada komentar tersedia',
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
                padding: const EdgeInsets.all(16),
                itemCount: commentController.comments.length,
                itemBuilder: (context, index) {
                  final comment = commentController.comments[index];
                  // Use a combination of comment.id and uniqueCommentAvatarSeed for avatar variation
                  final String commentAvatarUrl =
                      'https://i.pravatar.cc/150?img=${(comment.id + uniqueCommentAvatarSeed) % 20 + 1}';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16, // Lebih kecil
                                backgroundImage: NetworkImage(commentAvatarUrl),
                                onBackgroundImageError: (exception, stackTrace) {
                                  // Fallback to an icon if image fails to load
                                  return;
                                },
                                child: Builder(
                                  builder: (context) {
                                    if (commentAvatarUrl.isEmpty ||
                                        !Uri.parse(
                                          commentAvatarUrl,
                                        ).isAbsolute) {
                                      return Text(
                                        comment.name.isNotEmpty
                                            ? comment.name[0].toUpperCase()
                                            : '?',
                                        style: TextStyle(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink(); // Hide child if image loads
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment.name,
                                      style: TextStyle(
                                        fontSize: 14, // Lebih kecil
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                    Text(
                                      comment.email,
                                      style: TextStyle(
                                        fontSize: 10, // Lebih kecil
                                        color: colorScheme.onSurface
                                            .withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8), // Sedikit lebih kecil
                          Text(
                            comment.body,
                            style: TextStyle(
                              fontSize: 12, // Lebih kecil
                              color: colorScheme.onSurface.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 8), // Spasi untuk ikon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.thumb_up_alt_outlined,
                                size: 16,
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.reply_outlined,
                                size: 16,
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.share_outlined,
                                size: 16,
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.more_horiz,
                                size: 16,
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
