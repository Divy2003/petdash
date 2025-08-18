import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare/services/api_service.dart';

import '../../../../../../common/widgets/appbar/appbar.dart';

class AppoinmentsDetails extends StatefulWidget {
  final String appointmentId;
  const AppoinmentsDetails({super.key, required this.appointmentId});

  @override
  State<AppoinmentsDetails> createState() => _AppoinmentsDetailsState();
}

class _AppoinmentsDetailsState extends State<AppoinmentsDetails> {
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      final res = await ApiService.get('/appointment/${widget.appointmentId}',
          requireAuth: true);
      setState(() {
        data = res;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointment = data?['appointment'] ?? {};
    final customerAddress = data?['customerPrimaryAddress'];
    final businessAddress = data?['businessPrimaryAddress'];

    return Scaffold(
      appBar: CustomAppBar(title: 'Appointment Details'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _section('Booking ID', appointment['bookingId'] ?? ''),
                      _section(
                          'Status',
                          (appointment['status'] ?? '')
                              .toString()
                              .toUpperCase()),
                      const SizedBox(height: 12),
                      _section(
                          'Service', appointment['service']?['title'] ?? ''),
                      _section(
                          'Provider', appointment['business']?['name'] ?? ''),
                      _section('Pet', appointment['pet']?['name'] ?? ''),
                      const SizedBox(height: 12),
                      _section(
                          'Date',
                          (appointment['appointmentDate'] ?? '')
                              .toString()
                              .split('T')
                              .first),
                      _section('Time', appointment['appointmentTime'] ?? ''),
                      const SizedBox(height: 12),
                      _section('Subtotal', '\$${appointment['subtotal']}'),
                      _section('Tax', '\$${appointment['tax']}'),
                      _section('Total', '\$${appointment['total']}'),
                      const SizedBox(height: 12),
                      if (appointment['notes'] != null &&
                          appointment['notes'].toString().isNotEmpty)
                        _section('Notes', appointment['notes']),
                      const SizedBox(height: 12),
                      if (customerAddress != null)
                        _section('Customer Address',
                            _formatAddress(customerAddress)),
                      if (businessAddress != null)
                        _section('Business Address',
                            _formatAddress(businessAddress)),
                    ],
                  ),
                ),
      backgroundColor: Colors.grey.shade50,
    );
  }

  Widget _section(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 120,
                child:
                    Text(label, style: const TextStyle(color: Colors.black54))),
            const SizedBox(width: 8),
            Expanded(
                child: Text(value,
                    style: const TextStyle(fontWeight: FontWeight.w600))),
          ],
        ),
      );

  String _formatAddress(Map<String, dynamic> addr) {
    final parts = [
      addr['addressLine1'],
      addr['addressLine2'],
      addr['city'],
      addr['state'],
      addr['zipCode'],
      addr['country'],
    ];
    return parts
        .whereType<String>()
        .where((e) => e.trim().isNotEmpty)
        .join(', ');
  }
}
