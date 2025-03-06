import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';


class PayemntStripeController extends GetxController {
 
 @override
  void onInit() { 
    // TODO: implement onInit    
    super.onInit();
                          
  }


 Future<Map<String, dynamic>> attachPaymentMethod(
      String paymentMethodId, String customerId) async {
    try {
      Map<String, dynamic> body = {
         'customer': customerId,
      };  

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_methods/$paymentMethodId/attach'),
        headers: {
          'Authorization':'Bearer  sk_test_51OA471SAreHXvlwhHCIbGBQhRs1s2KM5sJsZaNd5V40D6RTspiaVwMPruWyU45Lvvd101znzsrtLxZDsiIAsy8AW00ySJHS6Uw',
          //${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      if (response.statusCode != 200) {
        throw 'Failed to attach PaymentMethod: ${response.statusCode}';
      }
      print("customerresponse${response.body}");
      return jsonDecode(response.body);
    } catch (err) {
      print('Error creating payment intent: $err');
      rethrow;
    }
  }





 Future<Map<String, dynamic>> createSubscriptions(String customerId) async {
   

    Map<String, dynamic> body = {
      'customer': customerId,
        'items[0][price]':"price_1OuYw5SAreHXvlwhmoz2PT6O",
    };

    var response =
       await http.post(
        Uri.parse('https://api.stripe.com/v1/subscriptions'),  headers: {
          'Authorization':'Bearer  sk_test_51OA471SAreHXvlwhHCIbGBQhRs1s2KM5sJsZaNd5V40D6RTspiaVwMPruWyU45Lvvd101znzsrtLxZDsiIAsy8AW00ySJHS6Uw',
          'Content-Type': 'application/x-www-form-urlencoded'
        }, body: body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw 'Failed to register as a subscriber.';
    }
  }


   
}
