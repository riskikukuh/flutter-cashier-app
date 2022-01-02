import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasir_app/src/bloc/cart_bloc.dart';
import 'package:kasir_app/src/bloc/cartstok_bloc.dart';
import 'package:kasir_app/src/bloc/products_bloc.dart';
import 'package:kasir_app/src/models/order_model.dart';
import 'package:kasir_app/src/models/produk_model.dart';
import 'package:kasir_app/src/resources/enums.dart';
import 'package:kasir_app/src/resources/util.dart';
import 'package:kasir_app/src/screen/produk/form_product_screen.dart';
import 'package:kasir_app/src/widget/cart_button.dart';
import 'package:kasir_app/src/widget/cart_stok_button.dart';

class DetailProductScreen extends StatelessWidget {
  final ProdukModel produk;
  final ProductsPriceType priceType;
  DetailProductScreen({
    Key? key,
    required this.produk,
    this.priceType = ProductsPriceType.jual,
  }) : super(key: key);

  final _formatter = NumberFormat();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Produk',
        ),
        actions: isPriceJual() ? [
          const CartButton(showNotif: true),
          PopupMenuButton(
            onSelected: (item) {
              if (item == 0) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FormProductScreen(
                          produk: produk,
                        )));
              } else if (item == 1) {
                Util.showDialogAlert(context, 'Menghapus Produk',
                    'Anda yakin ingin menghapus produk ini ?', () {
                  context.read<ProductsBloc>().add(DeleteProduct(
                        produk: produk,
                      ));
                  Navigator.popUntil(context, ModalRoute.withName('/produk'));
                });
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text('Delete'),
              ),
            ],
          ),
        ] : [
          const CartStokButton(showNotif: true),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: size.height * .4,
                    color: Colors.black12,
                    child: Row(
                      children: const [
                        Expanded(
                          child: Icon(Icons.shopping_bag),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Rp' +
                        _formatter.format(isPriceJual()
                            ? produk.hargaJual
                            : produk.hargaStok),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    produk.nama,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Sisa ' + produk.stok.toString(),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.black12,
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.business,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            produk.supplier?.nama ?? 'Unknown',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          const Text(
                            'Online',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: ElevatedButton(
          child: Text('Tambah ke Keranjang ${isPriceJual() ? '' : 'Stok'}'),
          onPressed: () {
            if (isPriceJual()) {
              context.read<CartBloc>().add(AddOrder(
                      order: OrderModel(
                    id: -1,
                    quantity: 1,
                    date: DateTime.now().millisecondsSinceEpoch,
                    produk: produk,
                  )));
            } else {
              context.read<CartstokBloc>().add(AddCartStok(
                    produk: produk,
                    quantity: 1,
                  ));
            }
          },
        ),
      ),
    );
  }

  bool isPriceJual() => priceType == ProductsPriceType.jual;
}
