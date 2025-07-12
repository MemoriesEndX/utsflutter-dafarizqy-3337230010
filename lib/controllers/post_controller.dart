import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_main.dart';

Future<List<Post>> fetchPost() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Post.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load post');
  }
}
