import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_paymob/core/api_service.dart';
import 'package:payment_paymob/core/constance.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());
  static PaymentCubit get(context) => BlocProvider.of(context);
  var fnameController = TextEditingController();
  var lnameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var amountController = TextEditingController();
  getAuthToken(
    String fname,
    String lname,
    String email,
    String phone,
    double amount,
  ) {
    emit(GetAuthkeyLoaidng());
    DioHelper.postData(
      endPoiont: 'auth/tokens',
      data: {
        "api_key":
            "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2T1RZME9EVTFMQ0p1WVcxbElqb2lhVzVwZEdsaGJDSjkuZW1ESUNsNmVPejhWZnBwSEd2ZTNfdzBaUF9VSDU5T09FYVpIdC1QX1BkUkI0NUttSHRyLUY5d2dkSl9WellWdm91dVJUTjQ4dkJqcXZ0eUROaUd0TGc=",
      },
    ).then((value) {
      Constance.token = value.data['token'];
      getOrderId(fname, lname, email, phone, amount);
      emit(GetAuthkeySuccess());

      // log('toekn: ${Constance.token}');
    }).catchError((error) {
      print(error.toString());

      emit(GetAuthkeyFailure());
    });
  }

  getOrderId(
    String fname,
    String lname,
    String email,
    String phone,
    double amount,
  ) {
    emit(GetOrderIdLoading());
      int amountCents = (amount * 100).toInt();

    DioHelper.postData(
      endPoiont: 'ecommerce/orders',
      data: {
        "auth_token": Constance.token,
        "delivery_needed": "false",
        "amount_cents": amountCents,
        "currency": "EGP",
      },
    ).then((value) {
      Constance.orderId = value.data['id'].toString();
      getPaymentKey(fname, lname, email, phone, amount);
      emit(GetOrderIdSuccess());

      log('OrderID: ${Constance.orderId}');
      log('amount: ${value.data['amount_cents']}');
    }).catchError((error) {
      print(error.toString());
      emit(GetOrderIdFailure());
    });
  }

  getPaymentKey(
    String fname,
    String lname,
    String email,
    String phone,
    double amount,
  ) {
    emit(GetPaymentKeyLoading());
      int amountCents = (amount * 100).toInt();

    DioHelper.postData(endPoiont: 'acceptance/payment_keys', data: {
      "auth_token": Constance.token, // "d0d1
      "amount_cents": amountCents,
      "expiration": 3600,
      "order_id": Constance.orderId,
      "billing_data": {
        "apartment": "803",
        "email": email,
        "floor": "42",
        "first_name": fname,
        "street": "Ethan Land",
        "building": "8028",
        "phone_number": phone,
        "shipping_method": "PKG",
        "postal_code": "01898",
        "city": "cairo",
        "country": "CR",
        "last_name": lname,
        "state": "Utah"
      },
      "currency": "EGP",
      "integration_id": 4536132,
      "lock_order_when_paid": "false"
    }).then((value) {
      emit(GetPaymentKeySuccess());
      Constance.paymentKey = value.data['token'];
      // log('Payment Key: ${Constance.paymentKey}');
      // log('amount: ${value.data['amount_cents']}');
    }).catchError((error) {
      print(error.toString());
      emit(GetPaymentKeyFailure());
    });
  }
}
