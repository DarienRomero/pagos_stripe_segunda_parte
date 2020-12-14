import 'package:stripe_payment/stripe_payment.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:stripe_app/models/stripe_custom_response.dart';
import 'package:stripe_app/models/payment_intent_response.dart';

class StripeService{
  StripeService._privateConstructor();
  static final StripeService _intance = StripeService._privateConstructor();
  factory StripeService() => _intance;

  final String _paymentApiUrl = "https://api.stripe.com/v1/payment_intents";
  static final String _secretKey = "sk_test_51HuiX5Hzr4HkjUcHRMveT3wrKcruThrEczxx5gYBVL7aHxsW0BNXwc1faxmpYQgAyrZXknQyMPbI127pDfsCZLFv00UQ1Bgriv";
  final String _apiKey = "pk_test_51HuiX5Hzr4HkjUcHqYpS7jXVKuwKJ9GjBYzU3Q574PraxzvLaGC4AEgAizPK6CDC40ResNmWR6JFp1vRFlDzI5FS002avlvr2H";

  final headerOptions = new Options(
    contentType: Headers.formUrlEncodedContentType,
    headers: {
      'Authorization': 'Bearer ${ StripeService._secretKey }'
    }
  );


  void init(){
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: this._apiKey,
        androidPayMode: 'test',
        merchantId: 'test'
      )
    );
  }
  Future pagarApplePayGooglePay({
    @required String amount,
    @required String currecy
  }) async {

  }
  Future<StripeCustomResponse> pagarConNuevaTarjeta({
    @required String amount,
    @required String currency
  }) async {
    try {

      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest()
      );
      final resp = await this._realizarPago(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod
      );
      return resp;
    } catch (e) {
      return StripeCustomResponse(
        exito: false,
        mensaje: e.toString()
      );
    }
  
  }
  Future pagarConTarjetaExiste({
    @required String amount,
    @required String currecy
  }) async {
    
  }
  Future<PaymentIntentResponse> _crearPaymentIntent({
    @required String amount,
    @required String currency
  }) async {
    try{
      final dio = new Dio();
      final data = {
        'amount': amount,
        'currency': currency
      };
      final resp = await dio.post(
        _paymentApiUrl,
        data: data,
        options: headerOptions
      );
      return PaymentIntentResponse.fromJson(resp.data);
    }catch(e){
      print("Ocurrió un error con el payment intent response");
    }
  }
  
  Future<StripeCustomResponse> _realizarPago({
    @required String amount,
    @required String currency,
    @required PaymentMethod paymentMethod
  }) async {

    try {
      // Crear el intent
      final paymentIntent = await this._crearPaymentIntent(
        amount: amount,
        currency: currency
      );

      final paymentResult = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent.clientSecret,
          paymentMethodId: paymentMethod.id
        )
      );

      if( paymentResult.status == 'succeeded' ){
        return StripeCustomResponse( exito: true );
      } else {
        return StripeCustomResponse( 
          exito: false,
          mensaje: 'Fallo: ${ paymentResult.status }'
        );
      }
    } catch (e) {
      print(e.toString());
      return StripeCustomResponse(
        exito: false,
        mensaje: e.toString()
      );

    }
  }
}