import 'package:flutter/material.dart';

class AddNewCardScreen extends StatefulWidget {
  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final expiryMonthController = TextEditingController();
  final expiryYearController = TextEditingController();
  final cvvController = TextEditingController();

  String selectedType = 'Visa';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Payment Method"),
        leading: BackButton(),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card Preview
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: [Colors.blue.shade900, Colors.blue]),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text("Default", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                  Spacer(),
                  Text(nameController.text.isEmpty ? "Name here" : nameController.text, style: TextStyle(color: Colors.white)),
                  Text(
                    numberController.text.isEmpty
                        ? "xxxx-xxxx-xxxx-xxxx"
                        : '**** **** **** ${numberController.text.substring(numberController.text.length - 4)}',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Card Holder Name"),
              onChanged: (_) => setState(() {}),
            ),
            TextField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Card Number"),
              onChanged: (_) => setState(() {}),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expiryMonthController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "MM"),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: expiryYearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "YY"),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: cvvController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "CVV"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                cardTypeButton("Visa"),
                cardTypeButton("MasterCard"),
                cardTypeButton("Amex"),
              ],
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Add validation and backend call here
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Card Added Successfully")));
                  Navigator.pop(context);
                },
                child: Text("Verify"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardTypeButton(String type) {
    bool isSelected = selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedType = type),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.white,
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            type,
            style: TextStyle(color: isSelected ? Colors.white : Colors.blue),
          ),
        ),
      ),
    );
  }
}
