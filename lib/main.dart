import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//I'm not able to get this package here in Zapp but it works perfectly fine in VS Code
enum Category { smartphone, smartwatch, computer, other }

void main() {
  runApp(const MaterialApp(
    home: MyForm(),
  ));
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});
  @override
  State<StatefulWidget> createState() {
    return MyFormState();
  }
}

class MyFormState extends State<MyForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ratingController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _modelController = TextEditingController();

  final _myFormKey = GlobalKey<FormState>();

  Category _selectedCategory = Category.smartphone;

  void postData() async {
    if (_myFormKey.currentState!.validate()) {
      final url = Uri.parse("https://dummyjson.com/products/add");

      // I am not able to check the post request using above dummyjson url but it works prefectly fine with firebase realtime database as I did in the code below

      // final url = Uri.https(
      //   'add-product-to-catalogue-default-rtdb.firebaseio.com',
      //   'catalogue.json',
      // );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'rating': _ratingController.text,
          'price': _priceController.text,
          'discount': _discountController.text,
          'model': _modelController.text,
          'category': _selectedCategory.toString(),
        }),
      );

      if (response.statusCode == 200) {
        print("Data posted successfully");
        print("Response: ${response.body}");
      } else {
        print("Failed to post data: ${response.statusCode}");
        print("Error: ${response.body}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product to Catalogue"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        child: Form(
          key: _myFormKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _titleController,
                    validator: (String? msg) {
                      if (msg!.isEmpty) {
                        return "Please enter title";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Title",
                      hintText: "Enter title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _descriptionController,
                    validator: (String? msg) {
                      if (msg!.isEmpty) {
                        return "Please enter description of product";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Description",
                      hintText: "Enter description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: _ratingController,
                          keyboardType: TextInputType.number,
                          validator: (String? msg) {
                            if (msg!.isEmpty) {
                              return "Please enter rating";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Rating",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.phone,
                          validator: (String? msg) {
                            if (msg!.isEmpty) {
                              return "Please enter name";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixText: "\$ ",
                            labelText: "Price",
                            //hintText: "Enter your name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: _discountController,
                          validator: (String? msg) {
                            if (msg!.isEmpty) {
                              return "Please enter name";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Discount %",
                            //hintText: "Enter your name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: _modelController,
                          validator: (String? msg) {
                            if (msg!.isEmpty) {
                              return "Please enter name";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Model",
                            //hintText: "Enter your name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: postData,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(18),
                      fixedSize: const Size(200, 60),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: const Text('Submit Form'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
