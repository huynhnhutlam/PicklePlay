import 'package:dio/dio.dart';

class UnauthorizedInterceptor extends Interceptor {
  // Flag để tránh vòng lặp refresh token vô hạn
  // static bool _isRefreshing = false;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      print('UnauthorizedInterceptor: Lỗi 401 Unauthorized! Đang xử lý...');
    }
    if (err.response?.statusCode == 401) {
      // Nếu bạn muốn quay lại màn hình đăng nhập
      // AppRouter.instance.pushNamedAndRemoveUntil(AppRouter.login);
    }
    handler.next(err); // Chuyển lỗi cho interceptor tiếp theo hoặc cho Dio
  }

  // Phương thức giả định để làm mới token
  // Trong thực tế, bạn sẽ gọi một API để làm mới token.
  Future<String> _refreshToken() async {
    // Đảm bảo request làm mới token không đi qua AuthorizedInterceptor này
    // hoặc có cơ chế bỏ qua xác thực cho riêng request refresh token.
    // Ví dụ: tạo một Dio instance mới hoặc dùng cờ trong extra cho request refresh
    // final refreshDio = Dio(BaseOptions(baseUrl: AppEnv().apiUrl));
    // final refreshResponse = await refreshDio.post('/auth/refresh-token', data: {'refreshToken': currentRefreshToken});
    // return refreshResponse.data['accessToken'];
    await Future.delayed(const Duration(seconds: 1)); // Giả lập độ trễ mạng
    return 'new_refreshed_token_xyz_from_server';
  }
}
