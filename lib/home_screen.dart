import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:untitled/product.dart';
import './addNewProduct.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  bool inProgress = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProduct();
  }

  void getProduct() async {
    products.clear();
    inProgress = true;
    setState(() {});
    Response response =
        await get(Uri.parse('http://35.73.30.144:2008/api/v1/ReadProduct'));
    final Map<String, dynamic> decodedResponse = jsonDecode(response.body);

    if (response.statusCode == 200 && decodedResponse["status"] == "success") {
      for (var x in decodedResponse["data"]) {
        print(decodedResponse['data']);
        products.add(Product.toJson(x));
      }
      inProgress = false;
      setState(() {});
    }
  }

  void deleteProduct(String id) async {
    products.clear();
    inProgress = true;
    setState(() {});
    Response response = await get(
        Uri.parse('http://35.73.30.144:2008/api/v1/DeleteProduct/$id'));
    final Map<String, dynamic> decodedResponse = jsonDecode(response.body);

    if (response.statusCode == 200 && decodedResponse["status"] == "success") {
      getProduct();
    } else {
      inProgress = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  getProduct();
                },
                icon: Icon(Icons.refresh))
          ],
          title: const Text('Home Screen'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewProduct(),
                ));
          },
          child: const Icon(Icons.add),
        ),
        body: inProgress
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                itemBuilder: (context, index) => ListTile(
                      onLongPress: () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Row(
                            children: [
                              Text('Choose Action'),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.close))
                            ],
                          ),
                          content:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit'),
                            ),
                            ListTile(
                              onTap: () {
                                deleteProduct(products[index].id);
                                Navigator.pop(context);
                              },
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                            )
                          ]),
                        ),
                      ),
                      leading: Image.network(
                        products[index].img,
                        width: 150,
                        height: 100,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.image,
                          size: 52,
                        ),
                      ),
                      title: Text(products[index].productName),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Product Code: ${products[index].productCode}'),
                          Text('Unit Price : ${products[index].unitPrice}')
                        ],
                      ),
                      trailing:
                          Text('Total Price : ${products[index].totalPrice}'),
                    ),
                separatorBuilder: (context, index) => Divider(),
                itemCount: products.length));
  }
}
