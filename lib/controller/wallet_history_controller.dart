import 'package:get/get.dart';
import 'package:top_up_bd/networkCaller/NetworkCaller.dart';
import '../data/models/wallet_history_model.dart';

class WalletHistoryController extends GetxController {
  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  RxList<Datum> historyList = <Datum>[].obs;
  int currentPage = 1;
  bool hasMoreData = true; // Flag to indicate if there are more pages to load.
  int perPage = 10; // Set a default value, it can be updated from the response

  Future<void> loadFullHistory({int page = 1}) async {
    if (_isLoading.value) return; // Prevent multiple requests at the same time.

    _isLoading.value = true;
    update();

    final response = await NetworkCaller.getRequest("https://app.codmshopbd.com/api/deposit-history?page=$page");

    _isLoading.value = false;
    update();

    if (response.isSuccess) {
      try {
        final walletHistoryModel = WalletHistoryModel.fromJson(response.responseBody);
        if (walletHistoryModel.status) {
          // Extract data from the 'data' field of the response.
          final data = walletHistoryModel.data.data; // Access the nested 'data' list
          final total = walletHistoryModel.data.total;
          final perPageFromServer = walletHistoryModel.data.perPage;

          if (page == 1) {
            // Clear the list when loading the first page
            historyList.value = data;
          } else {
            // Append new data to the existing list
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
