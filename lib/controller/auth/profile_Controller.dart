import 'package:get/get.dart';
import 'package:top_up_bd/controller/auth/user_auth_controller.dart';
import '../../networkCaller/NetworkCaller.dart';

class ProfileController extends GetxController {

  RxString walletBalance = '0'.obs;

  void showBalance()async{
    String? token = await AuthController.getUserToken();

    if(token != null){
      var response = await NetworkCaller.getRequest('https://app.codmshopbd.com/api/profile');
      if(response.isSuccess){
        walletBalance.value = response.responseBody['balance'].toString();
      }
    }

  }
}