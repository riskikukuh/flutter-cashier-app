import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/src/bloc/cartstok_bloc.dart';

class CartStokButton extends StatelessWidget {
  const CartStokButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            IconButton(
              onPressed: () {
                context.read<CartstokBloc>().add(GetAllCartStok());
                Navigator.of(context).pushNamed('/cartStok', arguments: { "asd" : 1});
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
                child: BlocBuilder<CartstokBloc, CartstokState>(
                  builder: (context, state) {
                    if (state is CartStokLoadSuccess) {
                      int count = state.cartStok.length;
                      return Text(
                        count.toString(),
                      );
                    }
                    if (state is CartStokError) {
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
