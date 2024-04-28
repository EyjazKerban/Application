import 'package:flutter/material.dart';
import 'package:flutter_app/features/tutor/payment/screens/paymentoptions.dart';
import 'package:flutter_app/features/tutor/payment/screens/recentpaymentsview.dart';
import 'package:flutter_app/features/tutor/payment/services/payment_service.dart';
import 'package:flutter_app/models/payment.dart';
import 'package:flutter_app/providers/payment_provider.dart';
import 'package:provider/provider.dart';

class RecentPaymentsPage extends StatefulWidget {
  const RecentPaymentsPage({Key? key}) : super(key: key);

  @override
  State<RecentPaymentsPage> createState() => _RecentPaymentsPageState();
}

class _RecentPaymentsPageState extends State<RecentPaymentsPage> {
  Future<List<Payment>>? _unverifiedPayments;

  @override
  void initState() {
    super.initState();
    _unverifiedPayments = PaymentService.fetchUnverifiedPayments(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Month',
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
            MaterialPageRoute(builder: (context) => const PaymentOptionsPage()),
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
          future: _unverifiedPayments,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text("No unverified payments found!"));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Payment payment = snapshot.data![index];
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
                          // Set the current payment in PaymentProvider
                          Provider.of<PaymentProvider>(context, listen: false)
                              .setCurrentPayment(payment);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RecentPaymentsView()),
                          );
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
            }
          },
        ),
      ),
    );
  }
}
