import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/provider/session_provider.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

// 창고 관리자 (창고 관리자를 통해 창고에 접근 가능)
final postListPageProvider =
    StateNotifierProvider<PostListPageViewModel, PostListPageModel?>((ref) {
  // TODO PostListPageViewModel(ref, null)..notifyInit();
  // TODO 객체를 만들면 바로 실행해버리게 만드는 연산자 .. => 케스케이드
  return PostListPageViewModel(ref, null)..notifyInit();
});

// 2. 창고에 보관될 물건
class PostListPageModel {
  List<Post> posts; // 값이 언제 어떻게 변경이 될지 모르기 때문에 class로 만드는거야!
  PostListPageModel({required this.posts});
}

// 3. 창고(ViewModel 을 통해ㅔ서 창고 데이터를 다룰 수 있다)
// PostListPageModel? 얘가 출판사엿나 ?
class PostListPageViewModel extends StateNotifier<PostListPageModel?> {
  final mContext = navigatorKey.currentContext;
  final Ref ref;

  PostListPageViewModel(this.ref, super.state);

  Future<void> notifyInit() async {
    Logger().d("PostList notifyInit()");
    SessionUser sessionUser = ref.read(sessionProvider);
    ResponseDTO responseDTO =
        await PostRepositroy().fetchPostList(sessionUser.jwt!);
    state = PostListPageModel(posts: responseDTO.data);
  }
}
