

import 'package:flutter_from_zero/app/data/services/remote/http_services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  HttpHandlerServices handlerServices = HttpHandlerServices();

  // === EXEMPLE POUR FAIR DES REQUESTTE ===
  getListOfProduct() async {
    var response = await  handlerServices.doGetRequest('/products-list');
  }

  addNewProduct() async {
    var response = await  handlerServices.doPostRequest('/products-add', {"name": "Lait", "description": "description ........"});
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
