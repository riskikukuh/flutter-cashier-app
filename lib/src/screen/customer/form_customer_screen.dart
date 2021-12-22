import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/src/bloc/customer_bloc.dart';
import 'package:kasir_app/src/models/customer_model.dart';
import 'package:kasir_app/src/widget/cart_button.dart';

class FormCustomerScreen extends StatefulWidget {
  final CustomerModel? customer;
  const FormCustomerScreen({
    Key? key,
    this.customer,
  }) : super(key: key);

  @override
  _FormCustomerScreenState createState() => _FormCustomerScreenState();
}

class _FormCustomerScreenState extends State<FormCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _noTelpController = TextEditingController();
  final _alamatController = TextEditingController();
  String? jk;

  @override
  initState() {
    if (widget.customer != null) {
      _namaController.text = widget.customer!.nama;
      _noTelpController.text = widget.customer!.noTelp;
      _alamatController.text = widget.customer!.alamat;
      jk = widget.customer!.jk;
    }
    super.initState();
  }

  _resetForm() {
    if (widget.customer == null) {
      _formKey.currentState!.reset();
    } else {
      _namaController.text = widget.customer!.nama;
      _noTelpController.text = widget.customer!.noTelp;
      _alamatController.text = widget.customer!.alamat;
      setState(() {
        jk = widget.customer!.jk;
      });
    }
  }

  _actionButtonTambahSimpan() {
    if (widget.customer == null) {
      if (_formKey.currentState != null && _formKey.currentState!.validate()) {
        context.read<CustomerBloc>().add(AddCustomer(
              nama: _namaController.text,
              jk: jk!,
              noTelp: _noTelpController.text,
              alamat: _alamatController.text,
            ));
      }
    } else {
      if (_formKey.currentState != null && _formKey.currentState!.validate()) {
        CustomerModel newCustomerModel = widget.customer!.copyWith(
          nama: _namaController.text,
          jk: jk!,
          noTelp: _noTelpController.text,
          alamat: _alamatController.text,
        );
        context
            .read<CustomerBloc>()
            .add(EditCustomer(customer: newCustomerModel));
      }
    }
  }

  Widget _mapCustomerStateToWidget(CustomerState state) {
    if (state is CustomerLoadSuccess) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
              ),
              onPressed: _resetForm,
              child: const Text(
                'Reset',
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: _actionButtonTambahSimpan,
              child: Text(
                widget.customer == null ? 'Tambah' : 'Simpan',
              ),
            ),
          ),
        ],
      );
    } else if (state is CustomerLoading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.customer == null ? 'Tambah Customer' : 'Edit Customer',
        ),
        actions: const [
          CartButton(),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    return 'Nama customer tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Jenis Kelamin',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              DropdownButtonFormField(
                hint: const Text('Jenis Kelamin'),
                items: const [
                  DropdownMenuItem(
                    value: 'P',
                    child: Text(
                      'Pria',
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'W',
                    child: Text(
                      'Wanita',
                    ),
                  ),
                ],
                value: jk,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      jk = value.toString();
                    });
                  }
                },
                validator: (text) {
                  if (text == null) {
                    return 'Jenis kelamin tidak boleh kosong';
                  }
                  return null;
                },
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
        child: BlocConsumer<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (state is CustomerMessage) {
              if (state is CustomerNotifSuccess) {
                Navigator.of(context).pop();
              }
            }
          },
          builder: (context, state) {
            return _mapCustomerStateToWidget(state);
          },
        ),
      ),
    );
  }
}
