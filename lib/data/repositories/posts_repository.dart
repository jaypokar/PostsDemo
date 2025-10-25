import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

class PostsRepository {
  final FirebaseFirestore _firestore;

  PostsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<PostModel>> getPosts() {
    return _firestore
        .collection(AppConstants.postsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PostModel.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> createPost(String content, UserModel user) async {
    try {
      final postId = _firestore.collection(AppConstants.postsCollection).doc().id;
      final now = DateTime.now();

      final post = PostModel(
        id: postId,
        userId: user.id,
        username: user.username,
        userPhotoUrl: user.photoUrl,
        content: content,
        createdAt: now,
        updatedAt: now,
      );

      await _firestore
          .collection(AppConstants.postsCollection)
          .doc(postId)
          .set(post.toMap());
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore
          .collection(AppConstants.postsCollection)
          .doc(postId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  Future<void> updatePost(String postId, String content) async {
    try {
      await _firestore
          .collection(AppConstants.postsCollection)
          .doc(postId)
          .update({
        'content': content,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }
}