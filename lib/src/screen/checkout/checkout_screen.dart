import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasir_app/src/bloc/cart_bloc.dart';
import 'package:kasir_app/src/bloc/customer_bloc.dart';
import 'package:kasir_app/src/bloc/transaksi_bloc.dart';
import 'package:kasir_app/src/models/customer_model.dart';
import 'package:kasir_app/src/resources/util.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({Key? key}) : super(key: key);

  late final formatter = NumberFormat();
  final _searchController = TextEditingController();
  final _keteranganController = TextEditingController();
  CustomerModel? _customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: BlocConsumer<TransaksiBloc, TransaksiState>(
          listener: (context, state) {
            if (state is PaymentTransaksiSuccess) {
              Util.showSnackbar(context, "Transaksi berhasil");
              Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => true);
            }
          },
          builder: (context, state) {
            if (state is TransaksiLoadSuccess) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'Pembeli',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocConsumer<CustomerBloc, CustomerState>(
                    listener: (context, state) {
                      if (state is CustomerError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)));
                      }
                    },
                    builder: (context, state) {
                      List<CustomerModel> allCustomer = [];
                      if (state is CustomerLoadSuccess) {
                        allCustomer.addAll(state.allCustomer);
                      }
                      return DropdownSearch<CustomerModel>(
                        searchFieldProps: TextFieldProps(
                          controller: _searchController,
                          decoration: InputDecoration(
                              suffix: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )),
                        ),
                        onChanged: (customer) {
                          _customer = customer;
                        },
                        showSearchBox: true,
                        items: allCustomer,
                        mode: Mode.BOTTOM_SHEET,
                        itemAsString: (customer) => customer?.nama ?? '',
                        isFilteredOnline: false,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _keteranganController,
                    decoration: InputDecoration(
                      suffix: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _keteranganController.clear();
                        },
                      ),
                      hintText: 'Keterangan',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    textAlignVertical: TextAlignVertical.top,
                    maxLines: 3,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Pesanan',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      if (state is CartFetched) {
                        return Column(
                          children: [
                            for (var cart in state.order)
                              Card(
                                margin: const EdgeInsets.only(top: 5),
                                child: ListTile(
                                  title: Text(cart.produk.nama),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Rp ${formatter.format(cart.produk.harga)} - ${cart.quantity} pcs',
                                          ),
                                          Text(
                                            'Rp ${formatter.format(cart.produk.harga * cart.quantity)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      }
                      return const Text('Pesanan kosong');
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Subtotal',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Jumlah yang harus dibayarkan',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          int total = 0;
                          if (state is CartFetched) {
                            for (var order in state.order) {
                              total += order.quantity * order.produk.harga;
                            }
                          }
                          return Text(
                            'Rp ${formatter.format(total)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              );
            } else if (state is TransaksiLoading) {
              return const CircularProgressIndicator();
            } else if (state is TransaksiError) {
              return Text(state.message);
            }

            return const SizedBox();
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            bool _isOrderNotEmpty = false;
            if (state is CartFetched) {
              _isOrderNotEmpty = state.order.isNotEmpty;
            }
            return ElevatedButton(
              child: const Text('Bayar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    _isOrderNotEmpty ? Colors.blue : Colors.grey),
              ),
              onPressed: () {
                if (_isOrderNotEmpty && _customer != null) {
                  context.read<TransaksiBloc>().add(AddTransaksi(
                        customer: _customer!,
                        // orders: ,
                        keterangan: _keteranganController.text,
                      ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Keranjang masih kosong')));
                }
              },
            );
          },
        ),
      ),
    );
  }
}
