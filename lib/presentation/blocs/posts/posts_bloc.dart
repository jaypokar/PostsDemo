import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/posts_repository.dart';
import '../../../data/models/post_model.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository _postsRepository;
  StreamSubscription? _postsSubscription;

  PostsBloc({required PostsRepository postsRepository})
      : _postsRepository = postsRepository,
        super(PostsInitial()) {
    on<PostsStarted>(_onPostsStarted);
    on<PostsCreatePost>(_onCreatePost);
    on<PostsDeletePost>(_onDeletePost);
    on<PostsUpdatePost>(_onUpdatePost);
    on<PostsReceived>(_onPostsReceived);
    on<PostsStreamError>(_onPostsStreamError);
  }

  Future<void> _onPostsStarted(PostsStarted event, Emitter<PostsState> emit) async {
    print('🔄 PostsBloc - Starting to load posts');
    
    emit(PostsLoading());
    
    try {
      await _postsSubscription?.cancel();
      
      // Set up stream subscription that adds events instead of emitting directly
      _postsSubscription = _postsRepository.getPosts().listen(
        (posts) {
          print('📱 Posts loaded: ${posts.length} posts');
          if (!isClosed) {
            add(PostsReceived(posts: posts));
          }
        },
        onError: (error) {
          print('❌ Posts stream error: $error');
          if (!isClosed) {
            add(PostsStreamError(message: 'Failed to load posts: ${error.toString()}'));
          }
        },
      );
      
    } catch (e) {
      print('❌ Posts bloc error: $e');
      emit(PostsError(message: 'Failed to load posts: ${e.toString()}'));
    }
  }

  void _onPostsReceived(PostsReceived event, Emitter<PostsState> emit) {
    emit(PostsLoaded(posts: event.posts));
  }

  void _onPostsStreamError(PostsStreamError event, Emitter<PostsState> emit) {
    emit(PostsError(message: event.message));
  }

  Future<void> _onCreatePost(PostsCreatePost event, Emitter<PostsState> emit) async {
    try {
      print('🔄 Creating post: "${event.content}" by ${event.user.username}');
      await _postsRepository.createPost(event.content, event.user);
      print('✅ Post created successfully');
      
      // Don't emit any state - let the stream handle the update
      // The Firestore stream will automatically emit the new posts
    } catch (e) {
      print('❌ Failed to create post: $e');
      emit(PostsError(message: 'Failed to create post: ${e.toString()}'));
    }
  }

  Future<void> _onDeletePost(PostsDeletePost event, Emitter<PostsState> emit) async {
    try {
      await _postsRepository.deletePost(event.postId);
    } catch (e) {
      emit(PostsError(message: e.toString()));
    }
  }

  Future<void> _onUpdatePost(PostsUpdatePost event, Emitter<PostsState> emit) async {
    try {
      await _postsRepository.updatePost(event.postId, event.content);
    } catch (e) {
      emit(PostsError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }
}