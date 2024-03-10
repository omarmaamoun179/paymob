import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_paymob/core/api_service.dart';
import 'package:payment_paymob/core/constance.dart';
import 'package:payment_paymob/core/my_bloc_observe.dart';
import 'package:payment_paymob/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  DioHelper.initDio();
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentCubit(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is GetPaymentKeySuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreenWithCard(),
            ),
          );
        } else if (state is GetPaymentKeyFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('There is an error '),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Payment', style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: Colors.blueAccent,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: PaymentCubit.get(context).fnameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'enter your first name',
                      hintText: 'enter your first name',
                    ),
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: PaymentCubit.get(context).lnameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'enter your lname',
                      hintText: 'enter your lname',
                    ),
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: PaymentCubit.get(context).emailController,
                    decoration: InputDecoration(
                      labelText: 'enter your email',
                      hintText: 'enter your email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: PaymentCubit.get(context).phoneController,
                    decoration: InputDecoration(
                      labelText: 'phone number',
                      hintText: 'phone number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    controller: PaymentCubit.get(context).amountController,
                    decoration: InputDecoration(
                      labelText: 'enter the amount',
                      hintText: 'enter the amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  state is GetAuthkeyLoaidng
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                          ),
                        )
                      : MaterialButton(
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(10),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          // style: ElevatedButton.styleFrom(
                          //   // backgroundColor: Colors.blueAccent,
                          //   textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                          //   padding: const EdgeInsets.all(10),
                          // ),
                          onPressed: () {
                            PaymentCubit.get(context).getAuthToken(
                              PaymentCubit.get(context).fnameController.text,
                              PaymentCubit.get(context).lnameController.text,
                              PaymentCubit.get(context).emailController.text,
                              PaymentCubit.get(context).phoneController.text,
                              double.parse(PaymentCubit.get(context)
                                  .amountController
                                  .text),
                            );
                          },
                          child: const Text("go to payment screen with card"),
                        ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PaymentScreenWithCard extends StatelessWidget {
  PaymentScreenWithCard({super.key});
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith(
              'https://accept.paymobsolutions.com/api/acceptance/iframes/831061?payment_token=${Constance.paymentKey}')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(
        'https://accept.paymobsolutions.com/api/acceptance/iframes/831061?payment_token=${Constance.paymentKey}'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Simple Example')),
      body: WebViewWidget(controller: controller),
    );
  }
}
