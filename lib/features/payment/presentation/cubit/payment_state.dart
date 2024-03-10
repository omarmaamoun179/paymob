part of 'payment_cubit.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}
class GetAuthkeyLoaidng extends PaymentState {}
class GetAuthkeySuccess extends PaymentState {}
class GetAuthkeyFailure extends PaymentState {}

class GetOrderIdLoading extends PaymentState {}
class GetOrderIdSuccess extends PaymentState {}
class GetOrderIdFailure extends PaymentState {}

class GetPaymentKeyLoading extends PaymentState {}
class GetPaymentKeySuccess extends PaymentState {}
class GetPaymentKeyFailure extends PaymentState {}

class PayWithCardLoading extends PaymentState {}
class PayWithCardSuccess extends PaymentState {}
class PayWithCardFailure extends PaymentState {}

