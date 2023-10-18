import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/_core/constants/move.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/dto/user_request.dart';
import 'package:flutter_blog/data/model/user.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

// TODO Provider -> 전역변수를 위한 창고 | 창고데이터와 창고관리자
// 유저의 정보를 저장하고 관리하는 클래스  - 여러 화면에서 사용될 데이터 이기때문에 전역 프로바이더로 설정
final sessionProvider = Provider<SessionUser>((ref) {
  return SessionUser();
});

class SessionUser {
  final mContext = navigatorKey.currentContext;
  // 어떤 계층에서 context가 없어서 그림을 못그린다 했는데 그래서 이거를 적는다 했는데.
  // 어떤 계층에서 이 코드를 이용하는지 지켜보면 어디서 상태값이 없는지 알수 있겠다. => 메인임!

  User? user;
  String? jwt;
  bool? isLogin;

  SessionUser();

  // 로그인
  Future<void> login(LoginReqDTO loginReqDTO) async {
    Logger().d("login");

    // 1. Repository 메소드를 호출하여 응답 결과 및 데이터 받음.
    ResponseDTO responseDTO = await UserRepository().fetchLogin(loginReqDTO);

    // 응답 결과 값이 1일 경우
    if (responseDTO.code == 1) {
      // 2. 토큰을 휴대폰에 저장
      await secureStorage.write(key: "jwt", value: responseDTO.token);

      // 3. 로그인 상태 등록
      this.user = responseDTO.data;
      this.jwt = responseDTO.token!;
      this.isLogin = true;

      // 4. 페이지 이동
      Navigator.popAndPushNamed(mContext!, Move.postListPage);
    } else {
      // 실패 시 스낵바
      ScaffoldMessenger.of(mContext!)
          .showSnackBar(SnackBar(content: Text("로그인 실패 : ${responseDTO.msg}")));
    }
  }

  // 회원 가입
  Future<void> join(JoinReqDTO reqDTO) async {
    Logger().d("join");

    // 1. Repository 메소드를 호출하여 응답 결과 및 데이터 받음.
    ResponseDTO responseDTO = await UserRepository().fetchJoin(reqDTO);

    // 응답 결과 값이 1일 경우
    if (responseDTO.code == 1) {
      // 2. 페이지 이동
      Navigator.pushNamed(mContext!, Move.loginPage);
    } else {
      // 실패 시 스낵바
      ScaffoldMessenger.of(mContext!)
          .showSnackBar(SnackBar(content: Text("회원가입 실패")));
    }
  }

  // 로그아웃
  Future<void> logout() async {
    this.user = null;
    this.jwt = null;
    this.isLogin = false;
    await secureStorage.delete(key: "jwt");
    Logger().d("세션 종료 및 디바이스 JWT 삭제");
  }
}
