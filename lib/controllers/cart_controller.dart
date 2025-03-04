import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import '../consts/consts.dart';

class CartController extends GetxController {
  var totalP = 0.obs;
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalController = TextEditingController();
  var phoneController = TextEditingController();
  var paymentIndex = 0.obs;
  var placingOrder = false.obs;
  var products = [];
  late dynamic productSnapshot;

  calculate(data) {
    totalP.value = 0;
    for (int i = 0; i < data.length; i++) {
      totalP.value = totalP.value + int.parse(data[i]['tprice'].toString());
    }
  }

  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  placeMyOrder({required orderPaymentmethod, required totalAmount}) async {
    placingOrder.value = true;
    await getProductDetails();

    await firestore.collection(orderCollection).doc().set({
      'order_code': "12232423",
      'order_date': FieldValue.serverTimestamp(),
      'order_by': currentUser!.uid,
      'order_by_name': Get.find<HomeController>().userName,
      'order_by_email': currentUser!.email,
      'order_by_address': addressController!.text,
      'order_by_state': stateController.text,
      'order_by_city': cityController!.text,
      'order_by_phone': phoneController.text,
      'order_by_postalCode': postalController!.text,
      'Shipping_method': "Home Delivery",
      'payment_method': orderPaymentmethod,
      'order_placed': true,
      'order_confirmed': false,
      'order_delivered': false,
      'order_on_delivery': false,
      'total_amount': totalAmount,
      'orders': FieldValue.arrayUnion(products)
    });
    placingOrder.value = false;
  }

  getProductDetails() {
    products.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'color': productSnapshot[i]['color'],
        'img': productSnapshot[i]['img'],
        'vendor_id': productSnapshot[i]['vendor_id'],
        'tprice': productSnapshot[i]['tprice'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title'],
      });
    }
  }

  clearCart() {
    for (var i = 0; i < productSnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }
}
