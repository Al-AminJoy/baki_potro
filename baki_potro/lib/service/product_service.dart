import 'package:baki_potro/models/product.dart';
import 'package:baki_potro/repository/repository.dart';

class ProductService {
  Repository _repository;

  ProductService() {
    _repository = Repository();
  }

  saveProduct(Product product) async {
    return await _repository.insertData('products', product.productMapping());
  }

  readProducts() async {
    return await _repository.readData('products');
  }

  readProductByID(productId) async {
    return await _repository.readDatById('products', 'product_id', productId);
  }

  updateProduct(Product product) async {
    return await _repository.update(
        'products', 'product_id', product.productMapping());
  }

  deleteProcuct(productId) async {
    return await _repository.deleteDatById('products', 'product_id', productId);
  }
}
