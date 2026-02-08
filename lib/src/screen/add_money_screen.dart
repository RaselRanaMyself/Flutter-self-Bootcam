import 'package:flutter/material.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final TextEditingController amountControler = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    amountControler.dispose();
    super.dispose();
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      // print("Deposit amount: ${amountControler.text}");
      double amount = double.parse(amountControler.text);
      Navigator.pop(context, amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Deposit Money"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: amountControler,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  label: Text("Enter amount"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  //value can't be null or empty
                  if (value == null || value.isEmpty) {
                    return "Enter an amount";
                  }
                  //value can't be abc or anything else except number
                  if (double.tryParse(value) == null) {
                    return "Enter a valid amount";
                  }
                  //value can't be less than 500
                  if (double.parse(value) < 500) {
                    return "minimum deposit amount is 500";
                  }
                  //everything is ok
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.indigo,
                ),
                child: Text(
                  "Deposit Now",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
