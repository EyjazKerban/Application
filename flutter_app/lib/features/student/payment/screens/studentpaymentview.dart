import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/features/student/payment/screens/studentmonthlypayments.dart';
import 'package:flutter_app/features/tutor/payment/services/payment_service.dart';
import 'package:flutter_app/models/payment.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_app/providers/payment_provider.dart';
import 'package:flutter_app/providers/user_provider.dart';

class StudentPaymentViewPage extends StatefulWidget {
  const StudentPaymentViewPage({Key? key}) : super(key: key);

  @override
  State<StudentPaymentViewPage> createState() => _StudentPaymentViewPageState();
}

class _StudentPaymentViewPageState extends State<StudentPaymentViewPage> {
  File? _selectedFile;
  bool _isLoading = false;
  PaymentSubmission? _paymentSubmission;

  @override
  void initState() {
    super.initState();
    _checkPaymentExistence();
  }

  Future<void> _checkPaymentExistence() async {
    setState(() => _isLoading = true);
    final paymentId =
        Provider.of<PaymentProvider>(context, listen: false).currentPayment!.id;
    final userId = Provider.of<UserProvider>(context, listen: false).user.id;

    _paymentSubmission =
        await PaymentService.fetchPaymentSubmission(context, paymentId, userId);

    setState(() => _isLoading = false);
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _paymentSubmission = null; // Reset the payment submission
        print('File selected: ${_selectedFile?.path}');
      });
    }
  }

  Future<void> _submitPaymentProof() async {
    if (_selectedFile == null) {
      print('No file selected to submit.');
      return;
    }

    _showSubmittingDialog();
    final paymentId =
        Provider.of<PaymentProvider>(context, listen: false).currentPayment!.id;
    final userId = Provider.of<UserProvider>(context, listen: false).user.id;

    try {
      final success = await PaymentService.submitPaymentProof(
        context: context,
        paymentId: paymentId,
        userId: userId,
        proofFile: _selectedFile!,
      );

      Navigator.of(context).pop(); // Close the submitting dialog

      if (success) {
        _showSuccessDialog();
      } else {
        _showFailureDialog();
      }
    } catch (e) {
      Navigator.of(context)
          .pop(); // Close the submitting dialog in case of error
      _showFailureDialog();
    }
  }

  void _showSubmittingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Submitting payment proof..."),
              SizedBox(height: 20),
              LinearProgressIndicator(),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Payment uploaded"),
        content: const Text("Payment proof submitted successfully."),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(); // Close the success dialog
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const StudentMonthlyPaymentsPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showFailureDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Payment failed"),
        content: const Text("Failed to submit payment proof."),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () =>
                Navigator.of(context).pop(), // Close the failure dialog
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${Provider.of<PaymentProvider>(context, listen: false).currentPayment!.month}'s payment"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const StudentMonthlyPaymentsPage()),
            (Route<dynamic> route) => false,
          ),
        ),
        actions: [
          if (_selectedFile != null)
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _submitPaymentProof,
            ),
        ],
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(8),
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
              child: _paymentSubmission == null
                  ? Center(
                      child: _selectedFile == null
                          ? const Text(
                              "No file selected!\nPlease select a payment proof to upload",
                              textAlign: TextAlign.center)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 50),
                                InkWell(
                                  child: Image.file(_selectedFile!,
                                      fit: BoxFit.cover,
                                      key: ValueKey(_selectedFile!.path)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      _selectedFile = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _paymentSubmission!.image.isNotEmpty
                            ? Image.network(_paymentSubmission!.image)
                            : const Text("No image provided."),
                        const SizedBox(height: 20),
                        Text(
                          'Payment Status: ${_paymentSubmission!.verified ? "Verified" : "Not Verified"}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickFile,
        backgroundColor: const Color.fromARGB(255, 42, 166, 254),
        child: const Icon(Icons.folder_open),
      ),
    );
  }
}
