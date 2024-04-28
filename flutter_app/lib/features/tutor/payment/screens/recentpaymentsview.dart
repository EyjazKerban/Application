import 'package:flutter/material.dart';
import 'package:flutter_app/features/tutor/payment/screens/recentpayments.dart';
import 'package:flutter_app/features/tutor/payment/screens/tutorcheckpayment.dart';
import 'package:flutter_app/features/tutor/payment/services/payment_service.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/providers/payment_provider.dart';
import 'package:flutter_app/providers/selected_user_provider.dart';
import 'package:provider/provider.dart';

class RecentPaymentsView extends StatefulWidget {
  const RecentPaymentsView({Key? key}) : super(key: key);

  @override
  State<RecentPaymentsView> createState() => _RecentPaymentsViewState();
}

class _RecentPaymentsViewState extends State<RecentPaymentsView> {
  late Future<List<User>> _unverifiedUsersFuture;

  @override
  void initState() {
    super.initState();
    String paymentId =
        Provider.of<PaymentProvider>(context, listen: false).currentPayment!.id;
    _unverifiedUsersFuture =
        PaymentService.fetchUnverifiedPaymentUsers(context, paymentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pending payments',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const RecentPaymentsPage()),
                  (Route<dynamic> route) => false,
                )),
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
        child: FutureBuilder<List<User>>(
          future: _unverifiedUsersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final user = snapshot.data![index];
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
                          Provider.of<SelectedUserProvider>(context,
                                  listen: false)
                              .setSelectedUser(user);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const TutorCheckPaymentPage()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          child: Text(
                            '${user.firstname} ${user.lastname}',
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
              return const Center(
                  child: Text('No unverified payment submissions found.'));
            }
          },
        ),
      ),
    );
  }
}
