import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/src/bloc/supplier_bloc.dart';
import 'package:kasir_app/src/models/supplier_model.dart';
import 'package:kasir_app/src/widget/cart_button.dart';

class FormSupplierScreen extends StatefulWidget {
  final SupplierModel? supplier;
  const FormSupplierScreen({
    Key? key,
    this.supplier,
  }) : super(key: key);

  @override
  _FormSupplierScreenState createState() => _FormSupplierScreenState();
}

class _FormSupplierScreenState extends State<FormSupplierScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _noTelpController = TextEditingController();
  final _alamatController = TextEditingController();

  _actionButtonSimpanTambah() {
    if (widget.supplier == null) {
      if (_formKey.currentState != null && _formKey.currentState!.validate()) {
        context.read<SupplierBloc>().add(AddSupplier(
              nama: _namaController.text,
              noTelp: _noTelpController.text,
              alamat: _alamatController.text,
            ));
      }
    } else {
      if (_formKey.currentState != null && _formKey.currentState!.validate()) {
        SupplierModel newSupplier = widget.supplier!.copyWith(
          nama: _namaController.text,
          noTelp: _noTelpController.text,
          alamat: _alamatController.text,
        );
        context.read<SupplierBloc>().add(EditSupplier(supplier: newSupplier));
      }
    }
  }

  @override
  void initState() {
    if (widget.supplier != null) {
      _namaController.text = widget.supplier!.nama;
      _noTelpController.text = widget.supplier!.noTelp;
      _alamatController.text = widget.supplier!.alamat;
    }
    super.initState();
  }

  Widget _mapSupplierStateToWidget(SupplierState state) {
    if (state is SupplierLoadSuccess) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
              ),
              onPressed: () {
                _formKey.currentState!.reset();
              },
              child: Text(
                'Reset',
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: _actionButtonSimpanTambah,
              child: Text(
                widget.supplier == null ? 'Tambah' : 'Simpan',
              ),
            ),
          ),
        ],
      );
    } else if (state is SupplierLoading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.supplier == null ? 'Tambah Supplier' : 'Edit Supplier',
        ),
        actions: const [
          CartButton(),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  hintText: 'Nama',
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Nama Supplier tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _noTelpController,
                decoration: const InputDecoration(
                  hintText: 'No Telepon',
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'No telepon tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _alamatController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Alamat',
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
        child: BlocConsumer<SupplierBloc, SupplierState>(
          listener: (context, state) {
            if (state is SupplierNotifSuccess) {
              if (widget.supplier != null) {
                Navigator.of(context).pop();
              }
            }
          },
          builder: (context, state) {
            return _mapSupplierStateToWidget(state);
          },
        ),
      ),
    );
  }
}
