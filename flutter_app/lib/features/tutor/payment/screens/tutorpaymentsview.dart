import 'package:flutter/material.dart';
import 'package:flutter_app/features/tutor/payment/screens/tutormonthlypayments.dart';
import 'package:flutter_app/features/tutor/payment/services/payment_service.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/providers/payment_provider.dart';
import 'package:provider/provider.dart';

class TutorPaymentsView extends StatefulWidget {
  const TutorPaymentsView({Key? key}) : super(key: key);

  @override
  _TutorPaymentsViewState createState() => _TutorPaymentsViewState();
}

class _TutorPaymentsViewState extends State<TutorPaymentsView> {
  late Future<List<User>> _paidFuture;
  late Future<List<User>> _notPaidFuture;

  @override
  void initState() {
    super.initState();
    String paymentId =
        Provider.of<PaymentProvider>(context, listen: false).currentPayment!.id;
    _paidFuture = PaymentService.fetchPaidStudents(context, paymentId);
    _notPaidFuture = PaymentService.fetchNotPaidStudents(context, paymentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Status',
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
                  MaterialPageRoute(
                      builder: (context) => const TutorMonthlyPaymentsPage()),
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
        child: ListView(
          children: [
            FutureBuilderSection(
              future: _paidFuture,
              title: 'Paid',
            ),
            FutureBuilderSection(
              future: _notPaidFuture,
              title: 'Unpaid',
            ),
          ],
        ),
      ),
    );
  }
}

class FutureBuilderSection extends StatelessWidget {
  final Future<List<User>> future;
  final String title;

  const FutureBuilderSection({
    Key? key,
    required this.future,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If waiting for data, show a progress indicator.
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          // If there's an error, display an error message.
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Error: ${snapshot.error.toString()}'),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          // If data is available and not empty, display the section.
          return _buildUserSection(context, title, snapshot.data!);
        } else {
          // If there's no data, return an empty container to omit the section.
          return Container();
        }
      },
    );
  }

  Widget _buildUserSection(
      BuildContext context, String title, List<User> users) {
    // This function builds the section when users are available.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.black)),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            // Build each user item.
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.white, Color.fromARGB(255, 201, 236, 255)],
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
                  onTap: () {},
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
        ),
      ],
    );
  }
}
