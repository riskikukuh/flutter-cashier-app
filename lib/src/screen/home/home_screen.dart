import 'package:flutter/material.dart';
import 'package:kasir_app/src/widget/cart_button.dart';
import 'package:kasir_app/src/widget/drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
        ),
        actions: const [
          CartButton(),
        ],
      ),
      drawer: const CashierDrawer(),
      body: Container(
        alignment: Alignment.center,
        child: const Text(
          'Hello Cashier',
        ),
      ),
    );
  }
}
