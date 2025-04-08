import 'package:get/get.dart';
import 'package:top_up_bd/controller/wallet_history_controller.dart';


class Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(WalletHistoryController());
  }

}