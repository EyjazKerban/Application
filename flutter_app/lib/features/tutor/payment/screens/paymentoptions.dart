import 'package:flutter/material.dart';
import 'package:flutter_app/features/tutor/home/screens/tutorhome.dart';
import 'package:flutter_app/features/tutor/payment/screens/tutormonthlypayments.dart';
import 'package:flutter_app/features/tutor/payment/screens/recentpayments.dart';

class PaymentOptionsPage extends StatelessWidget {
  const PaymentOptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Payments',
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
            MaterialPageRoute(builder: (context) => const TutorHome()),
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
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOptionContainer(
                context,
                'Recent Payments',
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const RecentPaymentsPage()),
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionContainer(
                context,
                'Monthly Payments',
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const TutorMonthlyPaymentsPage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionContainer(
    BuildContext context,
    String title,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 400,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Colors.white,
                Color.fromARGB(255, 201, 236, 255),
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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
