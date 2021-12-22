import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/src/bloc/cart_bloc.dart';
import 'package:kasir_app/src/bloc/customer_bloc.dart';
import 'package:kasir_app/src/bloc/products_bloc.dart';
import 'package:kasir_app/src/bloc/supplier_bloc.dart';
import 'package:kasir_app/src/bloc/transaksi_bloc.dart';
import 'package:kasir_app/src/bloc/user_bloc.dart';
import 'package:kasir_app/src/resources/util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  initApp() async {
    context.read<CartBloc>().add(GetAllCart());
    context.read<ProductsBloc>().add(GetAllProduct());
    context.read<CustomerBloc>().add(GetAllCustomer());
    context.read<SupplierBloc>().add(GetAllSupplier());
    context.read<TransaksiBloc>().add(GetAllTransaksi());
    await Future.delayed(const Duration(seconds: 2));
    context.read<UserBloc>().add(IsAlreadyLogin());
  }

  @override
  void initState() {
    super.initState();
    initApp();
  }

  void navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void navigateToLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        top: true,
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is AlreadyLogin) {
              navigateToHome();
            } else  if (state is NotLoggedIn) {
              navigateToLogin();
            } else if (state is UserError) {
              Util.showSnackbar(context, state.message);
            }
          },
          child: Container(
            width: width,
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(
                  Icons.monetization_on_rounded,
                  size: 70,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Cashier App",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
