import 'package:get/get.dart';
import 'package:top_up_bd/networkCaller/NetworkCaller.dart';
import '../data/models/wallet_history_model.dart';
import 'auth/user_auth_controller.dart';

class WalletHistoryController extends GetxController {
  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  RxList<Datum> historyList = <Datum>[].obs;
  int currentPage = 1;
  bool hasMoreData = true;
  int perPage = 10;

  Future<void> loadFullHistory({int page = 1}) async {
    String? token = await AuthController.getUserToken();

    if(token == null){
      return;
    }

    if (_isLoading.value) return;

    _isLoading.value = true;
    update();

    final response = await NetworkCaller.getRequest("https://app.codmshopbd.com/api/deposit-history?page=$page");

    _isLoading.value = false;
    update();

    if (response.isSuccess) {
      try {
        final walletHistoryModel = WalletHistoryModel.fromJson(response.responseBody);
        if (walletHistoryModel.status) {

          final data = walletHistoryModel.data.data;
          final total = walletHistoryModel.data.total;
          final perPageFromServer = walletHistoryModel.data.perPage;

          if (page == 1) {
            historyList.value = data;
          } else {
            historyList.addAll(data);
          }

          currentPage = walletHistoryModel.data.currentPage;
          hasMoreData = historyList.length < total; // Determine if there are more pages to load
          if (perPageFromServer != null) {
            perPage = perPageFromServer;
          }

        } else {
          Get.snackbar("Error", "Failed to load wallet history.");
          print('API Request failed: ${response.statusCode}');
        }
      } catch (e) {
        Get.snackbar("Error", "Failed to parse wallet history data.");
        print('JSON parsing error: $e');
      }
    } else {
      Get.snackbar("Error", "Network request failed.");
      print('Network request failed: ${response.statusCode}');
    }
  }

  Future<void> loadNextPage() async {
    if (hasMoreData && !_isLoading.value) {
      await loadFullHistory(page: currentPage + 1);
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadFullHistory();
  }
}
