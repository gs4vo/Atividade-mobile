import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';
import '../widgets/product_form_field.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key, this.product});

  final Product? product;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageController;
  late final TextEditingController _categoryController;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final product = widget.product;

    _nameController = TextEditingController(text: product?.name ?? '');
    _priceController = TextEditingController(
      text: product != null ? product.price.toStringAsFixed(2) : '',
    );
    _descriptionController =
        TextEditingController(text: product?.description ?? '');
    _imageController = TextEditingController(text: product?.image ?? '');
    _categoryController = TextEditingController(text: product?.category ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final parsedPrice =
        double.parse(_priceController.text.replaceAll(',', '.'));
    final draftProduct = Product(
      id: widget.product?.id,
      name: _nameController.text.trim(),
      price: parsedPrice,
      description: _descriptionController.text.trim(),
      image: _imageController.text.trim(),
      category: _categoryController.text.trim(),
    );

    final provider = context.read<ProductProvider>();
    final success = _isEditing
        ? await provider.updateProduct(draftProduct)
        : await provider.addProduct(draftProduct);

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.pop(context, true);
      return;
    }

    final message =
        provider.errorMessage ?? 'Nao foi possivel salvar o produto.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<ProductProvider>().isSaving;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar produto' : 'Cadastrar produto'),
      ),
      body: AbsorbPointer(
        absorbing: isSaving,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ProductFormField(
                key: const Key('name_field'),
                controller: _nameController,
                label: 'Nome',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o nome do produto.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ProductFormField(
                key: const Key('price_field'),
                controller: _priceController,
                label: 'Preco',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o preco.';
                  }

                  final parsed = double.tryParse(value.replaceAll(',', '.'));
                  if (parsed == null || parsed <= 0) {
                    return 'Informe um preco valido.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              ProductFormField(
                key: const Key('category_field'),
                controller: _categoryController,
                label: 'Categoria',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a categoria.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ProductFormField(
                key: const Key('image_field'),
                controller: _imageController,
                label: 'URL da imagem',
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a URL da imagem.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ProductFormField(
                key: const Key('description_field'),
                controller: _descriptionController,
                label: 'Descricao',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a descricao.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                key: const Key('save_product_button'),
                onPressed: _submitForm,
                icon: isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(isSaving ? 'Salvando...' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
