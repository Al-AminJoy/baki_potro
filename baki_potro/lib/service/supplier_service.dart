import 'package:baki_potro/models/supplier.dart';
import 'package:baki_potro/repository/repository.dart';

class SupplierService {
  Repository _repository;

  SupplierService() {
    _repository = Repository();
  }

  saveSupplier(Supplier supplier) async {
    return await _repository.insertData('suppliers', supplier.supplierMap());
  }

  readSupplier() async {
    return await _repository.readData('suppliers');
  }

  readSupplierByID(supplierId) async {
    return await _repository.readDatById(
        'suppliers', 'supplier_id', supplierId);
  }

  updateSupplier(Supplier supplier) async {
    return await _repository.update(
        'suppliers', 'supplier_id', supplier.supplierMap());
  }

  deleteSupplier(supplierId) async {
    return await _repository.deleteDatById(
        'suppliers', 'supplier_id', supplierId);
  }
}
