import 'package:flutter/material.dart';

class AppointmentBookingProvider with ChangeNotifier {
  // Date and Time
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isDatePicked = false;
  bool _isTimePicked = false;

  // Add-ons
  final List<Map<String, dynamic>> _addOns = [
    {'title': 'Nail Trimming (\$8)', 'price': 8.0, 'selected': false},
    {'title': 'Ear Cleaning (\$6)', 'price': 6.0, 'selected': false},
    {'title': 'Teeth Cleaning (\$12)', 'price': 12.0, 'selected': false},
    {'title': 'Flea Treatment (\$15)', 'price': 15.0, 'selected': false},
  ];

  // Coupon and Notes
  String _couponCode = '';
  String _notes = '';
  bool _isCouponApplied = false;
  double _couponDiscount = 0.0;

  // Pricing
  final double _basePrice = 80.0;
  final double _taxRate = 0.25; // 25%

  // Loading state
  bool _isLoading = false;

  // Getters
  DateTime get selectedDate => _selectedDate;
  TimeOfDay get selectedTime => _selectedTime;
  bool get isDatePicked => _isDatePicked;
  bool get isTimePicked => _isTimePicked;
  List<Map<String, dynamic>> get addOns => List.unmodifiable(_addOns);
  String get couponCode => _couponCode;
  String get notes => _notes;
  bool get isCouponApplied => _isCouponApplied;
  double get couponDiscount => _couponDiscount;
  double get basePrice => _basePrice;
  bool get isLoading => _isLoading;

  // Calculated values
  double get addOnsTotal {
    return _addOns
        .where((addon) => addon['selected'] == true)
        .fold(0.0, (sum, addon) => sum + addon['price']);
  }

  double get subtotal => _basePrice + addOnsTotal;
  
  double get discountAmount => _isCouponApplied ? _couponDiscount : 0.0;
  
  double get subtotalAfterDiscount => subtotal - discountAmount;
  
  double get taxAmount => subtotalAfterDiscount * _taxRate;
  
  double get total => subtotalAfterDiscount + taxAmount;

  // Selected add-ons for API
  List<Map<String, dynamic>> get selectedAddOns {
    return _addOns
        .where((addon) => addon['selected'] == true)
        .map((addon) => {
              'name': addon['title'].split(' (')[0], // Remove price from title
              'price': addon['price']
            })
        .toList();
  }

  // Validation
  bool get isFormValid {
    return _isDatePicked && _isTimePicked;
  }

  String? get validationError {
    if (!_isDatePicked) return 'Please select a date';
    if (!_isTimePicked) return 'Please select a time';
    return null;
  }

  // Date and Time methods
  void setDate(DateTime date) {
    _selectedDate = date;
    _isDatePicked = true;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    _selectedTime = time;
    _isTimePicked = true;
    notifyListeners();
  }

  // Add-ons methods
  void toggleAddOn(int index) {
    if (index >= 0 && index < _addOns.length) {
      _addOns[index]['selected'] = !_addOns[index]['selected'];
      notifyListeners();
    }
  }

  // Coupon methods
  void setCouponCode(String code) {
    _couponCode = code;
    notifyListeners();
  }

  void applyCoupon() {
    if (_couponCode.trim().isEmpty) return;

    // Simple coupon validation (you can enhance this)
    switch (_couponCode.toUpperCase()) {
      case 'SAVE10':
        _couponDiscount = subtotal * 0.10; // 10% discount
        _isCouponApplied = true;
        break;
      case 'SAVE20':
        _couponDiscount = subtotal * 0.20; // 20% discount
        _isCouponApplied = true;
        break;
      case 'FIRST15':
        _couponDiscount = 15.0; // $15 off
        _isCouponApplied = true;
        break;
      default:
        _couponDiscount = 0.0;
        _isCouponApplied = false;
        break;
    }
    notifyListeners();
  }

  void removeCoupon() {
    _couponCode = '';
    _couponDiscount = 0.0;
    _isCouponApplied = false;
    notifyListeners();
  }

  // Notes method
  void setNotes(String notes) {
    _notes = notes;
    notifyListeners();
  }

  // Loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Get appointment data for API submission
  Map<String, dynamic> getAppointmentData({
    required String businessId,
    required String serviceId,
    required String petId,
  }) {
    return {
      'businessId': businessId,
      'serviceId': serviceId,
      'petId': petId,
      'appointmentDate': _selectedDate.toIso8601String(),
      'appointmentTime': '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
      'addOnServices': selectedAddOns,
      'subtotal': subtotalAfterDiscount,
      'tax': taxAmount,
      'total': total,
      'notes': _notes.trim(),
      'couponCode': _isCouponApplied ? _couponCode : null,
    };
  }

  // Reset form
  void resetForm() {
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    _isDatePicked = false;
    _isTimePicked = false;
    
    for (var addon in _addOns) {
      addon['selected'] = false;
    }
    
    _couponCode = '';
    _notes = '';
    _isCouponApplied = false;
    _couponDiscount = 0.0;
    _isLoading = false;
    
    notifyListeners();
  }
}
