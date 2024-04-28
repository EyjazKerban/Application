import 'package:flutter/material.dart';
import 'package:flutter_app/features/tutor/payment/screens/recentpaymentsview.dart';
import 'package:flutter_app/features/tutor/payment/services/payment_service.dart';
import 'package:flutter_app/models/payment.dart';
import 'package:flutter_app/providers/payment_provider.dart';
import 'package:flutter_app/providers/selected_user_provider.dart';
import 'package:provider/provider.dart';

class TutorCheckPaymentPage extends StatefulWidget {
  const TutorCheckPaymentPage({Key? key}) : super(key: key);

  @override
  _TutorCheckPaymentPageState createState() => _TutorCheckPaymentPageState();
}

class _TutorCheckPaymentPageState extends State<TutorCheckPaymentPage> {
  void _verifyPayment(String paymentId, String userId) async {
    bool isVerified = await PaymentService.verifyPaymentSubmission(
      context,
      paymentId,
      userId,
    );

    if (isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment verified successfully'),
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const RecentPaymentsView()),
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to verify payment'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentId =
        Provider.of<PaymentProvider>(context, listen: false).currentPayment!.id;
    final selectedUser =
        Provider.of<SelectedUserProvider>(context, listen: false).selectedUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${selectedUser.firstname} ${selectedUser.lastname}",
          style: const TextStyle(
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
            MaterialPageRoute(builder: (context) => const RecentPaymentsView()),
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
        child: FutureBuilder<PaymentSubmission?>(
          future: PaymentService.fetchPaymentSubmission(
              context, paymentId, selectedUser.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Text('Error or no data');
            }
            final submission = snapshot.data!;
            final imageWidget = Image.network(
              submission.image,
              width: 350, // Set width to 330
              height: 600, // Set height to 550
              fit: BoxFit
                  .cover, // Cover to maintain aspect ratio within the bounds
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  width: 330,
                  height: 550,
                  child: Center(
                      child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null)),
                );
              },
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return const Text('Failed to load image');
              },
            );

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 70.0),
                  Expanded(child: Center(child: imageWidget)),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 201, 236, 255),
                      backgroundColor: const Color.fromARGB(255, 21, 74, 133),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    onPressed: () => _verifyPayment(paymentId, selectedUser.id),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text(
                        'Verify Payment',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
