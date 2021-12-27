import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasir_app/src/bloc/cart_bloc.dart';
import 'package:kasir_app/src/bloc/transaksi_bloc.dart';
import 'package:kasir_app/src/models/order_model.dart';
import 'package:kasir_app/src/resources/util.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key? key}) : super(key: key);
  final formatter = NumberFormat();

  Future<void> _onRefreshCart(BuildContext context) async {
    context.read<CartBloc>().add(GetAllCart());
  }

  Widget _mapStateToWidget(BuildContext context, CartState state, Size size) {
    switch (state.runtimeType) {
      case CartFetched:
        List<OrderModel> allOrder = (state as CartFetched).order;

        return RefreshIndicator(
          onRefresh: () async {
            await _onRefreshCart(context);
          },
          child: allOrder.isEmpty
              ? ListView(
                  children: const [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Keranjang Kosong',
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: allOrder.length,
                  itemBuilder: (context, i) {
                    OrderModel order = allOrder[i];
                    return Card(
                      elevation: 3,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.produk.nama,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Rp ' + formatter.format(order.produk.hargaJual),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Sisa ' + order.produk.stok.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black54,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        autofocus: true,
                                        canRequestFocus: true,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          child: const Icon(
                                            Icons.remove,
                                            size: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        onTap: () {
                                          int newQty = order.quantity - 1;
                                          if (newQty > 0) {
                                            context
                                                .read<CartBloc>()
                                                .add(EditOrder(
                                                  order: order.copyWith(
                                                      quantity: newQty),
                                                ));
                                          } else {
                                            Util.showDialogAlert(
                                                context,
                                                'Menghapus Pesanan',
                                                'Anda yakin ingin menghapus pesanan ini ?',
                                                () {
                                              context.read<CartBloc>().add(
                                                  DeleteOrder(order: order));
                                              Navigator.of(context).pop();
                                            });
                                          }
                                        },
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 2, 10, 2),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                              color: Colors.black54,
                                            ),
                                            right: BorderSide(
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          order.quantity.toString(),
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        autofocus: true,
                                        canRequestFocus: true,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          child: const Icon(
                                            Icons.add,
                                            size: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        onTap: () {
                                          int newQty = order.quantity + 1;
                                          if (newQty <= order.produk.stok) {
                                            context
                                                .read<CartBloc>()
                                                .add(EditOrder(
                                                  order: order.copyWith(
                                                      quantity: newQty),
                                                ));
                                            // _quantity.text = newQty.toString();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        autofocus: true,
                                        canRequestFocus: true,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          elevation: 0,
                                          child: const Icon(
                                            Icons.delete,
                                            size: 28,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        onTap: () {
                                          Util.showDialogAlert(
                                              context,
                                              'Menghapus Pesanan',
                                              'Anda yakin ingin menghapus pesanan ini ?',
                                              () {
                                            context
                                                .read<CartBloc>()
                                                .add(DeleteOrder(order: order));
                                            Navigator.of(context).pop();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      case CartLoading:
        return const CircularProgressIndicator();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keranjang',
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return _mapStateToWidget(context, state, size);
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            bool _isOrderNotEmpty = false;
            int priceTotal = 0;
            if (state is CartFetched) {
              for (var order in state.order) {
                priceTotal += (order.produk.hargaJual * order.quantity);
              }
              _isOrderNotEmpty = state.order.isNotEmpty;
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TOTAL',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      _isOrderNotEmpty
                          ? 'Rp ' + formatter.format(priceTotal)
                          : 'Rp 0',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: const Text('Lanjutkan Pembayaran'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              _isOrderNotEmpty ? Colors.blue : Colors.grey),
                        ),
                        onPressed: () {
                          if (_isOrderNotEmpty) {
                            context
                                .read<TransaksiBloc>()
                                .add(GetAllTransaksi());
                            Navigator.of(context).pushNamed('/checkout');
                          } else {
                            Util.showSnackbar(
                                context, 'Keranjang masih kosong');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
