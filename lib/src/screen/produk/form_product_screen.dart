import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/src/bloc/products_bloc.dart';
import 'package:kasir_app/src/bloc/supplier_bloc.dart';
import 'package:kasir_app/src/models/produk_model.dart';
import 'package:kasir_app/src/models/supplier_model.dart';

class FormProductScreen extends StatefulWidget {
  final ProdukModel? produk;
  const FormProductScreen({
    Key? key,
    this.produk,
  }) : super(key: key);

  @override
  _FormProductScreenState createState() => _FormProductScreenState();
}

class _FormProductScreenState extends State<FormProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String namaErrorMessage = '';
  String hargaErrorMessage = '';
  String stokErrorMessage = '';

  @override
  void initState() {
    if (widget.produk != null) {
      _nama.text = widget.produk!.nama;
      _harga.text = widget.produk!.harga.toString();
      _stok.text = widget.produk!.stok.toString();
      _supplier = widget.produk!.supplier;
    }
    super.initState();
  }

  final TextEditingController _nama = TextEditingController();
  final TextEditingController _harga = TextEditingController();
  final TextEditingController _stok = TextEditingController();
  final _supplierController = TextEditingController();
  SupplierModel? _supplier;

  Widget _widgetForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
        children: [
          TextFormField(
            controller: _nama,
            decoration: const InputDecoration(
              hintText: 'Nama Produk',
            ),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Nama produk tidak boleh kosong';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _harga,
            decoration: const InputDecoration(
              hintText: 'Harga',
            ),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Harga produk tidak boleh kosong';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _stok,
            decoration: const InputDecoration(
              hintText: 'Stok',
            ),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Stok produk tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          BlocBuilder<SupplierBloc, SupplierState>(
            builder: (context, state) {
              List<SupplierModel> allSupplier = [];
              if (state is SupplierLoadSuccess) {
                allSupplier.addAll(state.allSupplier);
              }
              return DropdownSearch<SupplierModel>(
                mode: Mode.BOTTOM_SHEET,
                searchFieldProps: TextFieldProps(
                  controller: _supplierController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Nama Supplier',
                    suffix: IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _supplierController.clear();
                      },
                    ),
                  ),
                ),
                dropdownSearchDecoration: const InputDecoration(
                  hintText: 'Supplier',
                  border: OutlineInputBorder(),
                ),
                onChanged: (supplier) {
                  _supplier = supplier;
                },
                selectedItem: _supplier,
                itemAsString: (supplier) => supplier?.nama ?? '',
                items: allSupplier,
                showSearchBox: true,
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.produk == null) {
                      _nama.clear();
                      _harga.clear();
                      _stok.clear();
                    } else {
                      _nama.text = widget.produk!.nama;
                      _harga.text = widget.produk!.harga.toString();
                      _stok.text = widget.produk!.stok.toString();
                      _supplier = widget.produk!.supplier;
                    }
                  },
                  child: const Text(
                    'RESET',
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.produk == null) {
                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate() &&
                          _supplier != null) {
                        context.read<ProductsBloc>().add(AddProduct(
                              nama: _nama.text,
                              harga: _harga.text,
                              stok: _stok.text,
                              supplier: _supplier!,
                            ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Form produk tidak boleh ada yang kosong !'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    } else {
                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate() &&
                          _supplier != null) {
                        ProdukModel newProduk = widget.produk!.copyWith(
                          harga: int.parse(_harga.text),
                          nama: _nama.text,
                          stok: int.parse(_stok.text),
                          supplier: _supplier,
                        );
                        context.read<ProductsBloc>().add(EditProduct(
                              produk: newProduk,
                            ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Form produk tidak boleh ada yang kosong !'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    widget.produk == null ? 'TAMBAH' : 'SIMPAN',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mapStateToScreen(ProductsState state) {
    switch (state.runtimeType) {
      case ProductsLoading:
        return Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
          ),
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: const CircularProgressIndicator(),
          ),
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.produk == null ? 'Tambah Produk' : 'Edit Produk',
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            _widgetForm(),
            BlocConsumer<ProductsBloc, ProductsState>(
              listener: (context, state) {
                if (state is ProductsMessage) {
                  if (state is ProductsNotifSuccess) {
                    Navigator.of(context).pop();
                  } 
                }
              },
              builder: (context, state) {
                return _mapStateToScreen(state);
              },
            ),
          ],
        ),
      ),
    );
  }
}
