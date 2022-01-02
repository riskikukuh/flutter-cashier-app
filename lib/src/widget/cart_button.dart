import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/src/bloc/cart_bloc.dart';
import 'package:kasir_app/src/resources/util.dart';

class CartButton extends StatelessWidget {
  final bool showNotif;
  const CartButton({
    Key? key,
    this.showNotif = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            IconButton(
              tooltip: 'Keranjang',
              onPressed: () {
                context.read<CartBloc>().add(GetAllCart());
                Navigator.of(context).pushNamed('/cart');
              },
              icon: const Icon(Icons.shopping_cart),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  shape: BoxShape.circle,
                ),
                child: BlocConsumer<CartBloc, CartState>(
                  listener: (context, state) {
                    if (showNotif) {
                      if (state is CartMessage) {
                        Util.showSnackbar(context, state.message);
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is CartFetched) {
                      int count = state.order.length;
                      return Text(
                        count.toString(),
                      );
                    }
                    if (state is CartError) {
                      return const Text(
                        '-1',
                      );
                    }
                    return const Text(
                      '0',
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 5,
        ),
      ],
    );
  }
}
