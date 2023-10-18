// 통신과 파싱을 담당하는 레이어 : Repository

import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dto/post_request.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:logger/logger.dart';

// TODO SINGLETON에 대하여 공부해보기! - 메타코딩 싱글톤 패턴
/*
*
*  싱글톤 패턴은 애플리케이션 전체에서 단 하나의 인스턴스만을 생성하여 공유하고자 할 때 사용됨
*
*/
class PostRepositroy {
  static final PostRepositroy _instance = PostRepositroy
      ._single(); // (1) _instance -> 클래스의 유일한 인스턴스를 저장하기 위한 정적 멤버 변수 | 외부접근 불가

  factory PostRepositroy() {
    // (2) PostRepository
    return _instance;
  }

  PostRepositroy._single(); // (3) PostRepository._single()

  // 목적 : 통신 + 파싱
  Future<ResponseDTO> fetchPostList(String jwt) async {
    // TODO GPT에게 이 문법 물어보기!
    // TODO  Logger().d("fetchPostList");
    // TODO  내용 : Logger() 로그 찍는거임 .디버그 레벨을 의미
    Logger().d("fetchPostList");

    try {
      // 통신
      Response response = await dio.get("/post",
          options: Options(headers: {"Authorization": "$jwt"}));

      // 응답 받은 데이터 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

      // 전달받은 데이터의 값을 mapList라는 변수에 List<dynamic> 타입으로 저장합니다.
      List<dynamic> mapList = responseDTO.data as List<dynamic>;

      // mapList의 각 아이템을 Post 객체로 변환하여 postList 변수에 할당합니다.
      List<Post> postList = mapList.map((e) => Post.fromJson(e)).toList();

      // 그리고 변환된 데이터를 다시 공통 DTO 에 덮어 씌웁니다.
      responseDTO.data = postList;

      return responseDTO;
    } catch (e) {
      return ResponseDTO(code: -1, msg: "실패 : ${e}");
    }
  }

  Future<ResponseDTO> fetchPost(String jwt, int id) async {
    try {
      // 통신
      Response response = await dio.get("/post/$id",
          options: Options(headers: {"Authorization": "$jwt"}));

      // 응답 받은 데이터 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      responseDTO.data = Post.fromJson(responseDTO.data);
      return responseDTO;
    } catch (e) {
      return ResponseDTO(code: -1, msg: "실패:${e}");
    }
  }

  Future<ResponseDTO> savePost(
      String jwt, PostSaveReqDTO postSaveReqDTO) async {
    try {
      // 통신
      Response response = await dio.post("/post",
          options: Options(headers: {"Authorizaion": "$jwt"}),
          data: postSaveReqDTO.toJson());

      // 응답 받은 데이터 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      responseDTO.data = Post.fromJson(responseDTO.data);

      return responseDTO;
    } catch (e) {
      return ResponseDTO(code: -1, msg: "실패 : ${e}");
    }
  }

  Future<ResponseDTO> updatePost(
      String jwt, int id, PostUpdateReqDTO postUpdateReqDTO) async {
    try {
      Response response = await dio.put("/post/$id",
          options: Options(headers: {"Authorization": "$jwt"}),
          data: postUpdateReqDTO);

      // 응답 받은 데이터 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      responseDTO.data = Post.fromJson(responseDTO.data);

      return responseDTO;
    } catch (e) {
      return ResponseDTO(code: -1, msg: "실패 : ${e}");
    }
  }

  Future<ResponseDTO> fetchDelete(String jwt, int id) async {
    try {
      // 통신
      Response response = await dio.delete("/post/$id",
          options: Options(headers: {"Authorization": "$jwt"}));

      // 응답 받은 데이터 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

      return responseDTO;
    } catch (e) {
      return ResponseDTO(code: -1, msg: "실패 : ${e}");
    }
  }
}
