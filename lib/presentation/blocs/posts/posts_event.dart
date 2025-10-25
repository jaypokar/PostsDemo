import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/post_model.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object?> get props => [];
}

class PostsStarted extends PostsEvent {}

class PostsCreatePost extends PostsEvent {
  final String content;
  final UserModel user;

  const PostsCreatePost({
    required this.content,
    required this.user,
  });

  @override
  List<Object> get props => [content, user];
}

class PostsDeletePost extends PostsEvent {
  final String postId;

  const PostsDeletePost({required this.postId});

  @override
  List<Object> get props => [postId];
}

class PostsUpdatePost extends PostsEvent {
  final String postId;
  final String content;

  const PostsUpdatePost({
    required this.postId,
    required this.content,
  });

  @override
  List<Object> get props => [postId, content];
}

class PostsReceived extends PostsEvent {
  final List<PostModel> posts;

  const PostsReceived({required this.posts});

  @override
  List<Object> get props => [posts];
}

class PostsStreamError extends PostsEvent {
  final String message;

  const PostsStreamError({required this.message});

  @override
  List<Object> get props => [message];
}