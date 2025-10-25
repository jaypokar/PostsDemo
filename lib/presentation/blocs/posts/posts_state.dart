import 'package:equatable/equatable.dart';
import '../../../data/models/post_model.dart';

abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object?> get props => [];
}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<PostModel> posts;

  const PostsLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

class PostsError extends PostsState {
  final String message;

  const PostsError({required this.message});

  @override
  List<Object> get props => [message];
}

class PostsCreating extends PostsState {}

class PostsCreated extends PostsState {}