import 'package:flutter/material.dart';
import 'package:flutter_app/features/student/home/screens/studenthome.dart';
import 'package:flutter_app/features/student/payment/screens/studentpaymentview.dart';
import 'package:flutter_app/features/tutor/payment/services/payment_service.dart';
import 'package:flutter_app/models/payment.dart';
import 'package:flutter_app/providers/payment_provider.dart';
import 'package:provider/provider.dart';

class StudentMonthlyPaymentsPage extends StatefulWidget {
  const StudentMonthlyPaymentsPage({Key? key}) : super(key: key);

  @override
  _StudentMonthlyPaymentsPageState createState() =>
      _StudentMonthlyPaymentsPageState();
}

class _StudentMonthlyPaymentsPageState
    extends State<StudentMonthlyPaymentsPage> {
  late Future<List<Payment>> _paymentFuture;

  @override
  void initState() {
    super.initState();
    _paymentFuture = PaymentService.fetchPayments(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payments',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 42, 166, 254),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const StudentHome()),
            (Route<dynamic> route) => false,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 42, 166, 254),
              Color.fromARGB(255, 147, 223, 255),
              Color.fromARGB(255, 201, 236, 255),
            ],
          ),
        ),
        child: FutureBuilder<List<Payment>>(
          future: _paymentFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final paymentList = snapshot.data!;
              return ListView.builder(
                itemCount: paymentList.length,
                itemBuilder: (context, index) {
                  final payment = paymentList[index];
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.white,
                          Color.fromARGB(255, 201, 236, 255)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          Provider.of<PaymentProvider>(context, listen: false)
                              .setCurrentPayment(payment);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const StudentPaymentViewPage()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          alignment: Alignment.center,
                          child: Text(
                            payment.month,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('Loading...'));
            }
          },
        ),
      ),
    );
  }
}
