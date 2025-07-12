import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uts/models/comment_main.dart';

class CommentController extends GetxController {
  final comments = <Comment>[].obs;
  final isLoading = true.obs;
  final error = Rxn<String>();

  Future<void> fetchComments(int postId) async {
    try {
      isLoading(true);
      comments.clear();
      final response = await http.get(
        Uri.parse(
          'https://jsonplaceholder.typicode.com/posts/$postId/comments',
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        comments.assignAll(data.map((json) => Comment.fromJson(json)).toList());
      } else {
        throw Exception('Failed to fetch comments: ${response.statusCode}');
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading(false);
    }
  }
}
