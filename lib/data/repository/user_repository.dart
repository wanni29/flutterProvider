import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/dto/user_request.dart';

import '../model/user.dart';

// 맵객체가 오브젝트타입에 들어갔다.
// 파싱과 통신만 오직 처리
// V -> Provider(전역 프로바이더, 뷰모델) -> Repository | MVVM 패턴
class UserRepository {
  // TODO 코드##################################################
  static final UserRepository _instance = UserRepository._single();

  // TODO factory 코드는 기존에 있는 객체를 그대로 사용한다는 의미다.
  factory UserRepository() {
    return _instance;
  }

  // TODO _ => private 표시임 _single() 외부에서는 건들수 없구
  UserRepository._single();

  // TODO 코드##################################################

  Future<ResponseDTO> fetchLogin(LoginReqDTO requestDTO) async {
    // Dio 는 내부적으로 터질수 있기때문에 TryCatch로 묶어야 한다. - 통신 실패 때문임
    try {
      final response = await dio.post(
        "/Login",
        data: requestDTO.toJson(),
      );
      // response => header + body [json]
      // response.data - body

      // 2. DTO 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      responseDTO.data = User.fromJson(responseDTO.data);

      // 3. 토큰 받기
      final authorization = response.headers["authorization"];
      if (authorization != null) {
        responseDTO.token = authorization.first;
      }
      return responseDTO;
    } catch (e) {
      // 200이 아니면 catch로 감
      return ResponseDTO(code: -1, msg: "유저네임 혹은 비밀번호가 틀렸습니다.");
    }
  }

  Future<ResponseDTO> fetchJoin(JoinReqDTO requestDTO) async {
    // Dio 는 내부적으로 터질수 있기때문에 TryCatch로 묶어야 한다.
    try {
      final response = await dio.post("/join", data: requestDTO.toJson());
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      responseDTO.data = User.fromJson(responseDTO.data);
      return responseDTO;
    } catch (e) {
      // 200이 아니면 catch로 감
      return ResponseDTO(code: -1, msg: "중복되는 유저명입니다.");
    }
  }
}
