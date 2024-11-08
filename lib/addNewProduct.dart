import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({super.key});

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _productCodeTEController =
      TextEditingController();
  final TextEditingController _priceTEController = TextEditingController();

  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();

  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  void addProduct() async {
    Response response =
        await post(Uri.parse('http://35.73.30.144:2008/api/v1/CreateProduct'),
            headers: {'Content-type': 'application/json'},
            body: jsonEncode({
              "ProductName": _nameTEController.text.trim(),
              "ProductCode": int.parse(_productCodeTEController.text.trim()),
              "Img": _imageTEController.text.trim(),
              "Qty": int.parse(_quantityTEController.text.trim()),
              "UnitPrice": int.parse(_priceTEController.text.trim()),
              "TotalPrice": int.parse(_totalPriceTEController.text.trim()),
            }));
    if (response.statusCode == 200) {
      final decodeBody = jsonDecode(response.body);
      print(decodeBody); // Print response body for debugging

      if (decodeBody['status'] == 'success') {
        // Clear fields and show success Snackbar
        _nameTEController.clear();
        _productCodeTEController.clear();
        _priceTEController.clear();
        _quantityTEController.clear();
        _totalPriceTEController.clear();
        _imageTEController.clear();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('New Product Added Successfully')),
          );
        }
      } else {
        // Show failure message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add product')),
          );
        }
      }
    } else {
      // Handle API call failure (non-200 status code)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Unable to add product')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formState,
          child: Column(
            children: [
              TextFormField(
                controller: _nameTEController,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return 'Enter your Name';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _productCodeTEController,
                decoration: InputDecoration(hintText: 'Product Code'),
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return 'Enter your product code';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _priceTEController,
                decoration: InputDecoration(hintText: 'Price '),
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return 'Enter your price?';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _quantityTEController,
                decoration: InputDecoration(hintText: 'Quantity'),
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return 'Enter your quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _totalPriceTEController,
                decoration: InputDecoration(hintText: ' Total Price '),
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return 'Enter your total Price';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _imageTEController,
                decoration: const InputDecoration(hintText: ' Image url '),
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return 'Enter your image url';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 197, 138, 11),
                        fixedSize: const Size.fromWidth(double.infinity),
                        padding: const EdgeInsets.all(15)),
                    onPressed: () {
                      if (_formState.currentState!.validate()) {
                        addProduct();
                      }
                    },
                    child: const Text('Add')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
