import 'package:baki_potro/models/customer.dart';
import 'package:baki_potro/repository/repository.dart';

class CustomerService {
  Repository _repository;

  CustomerService() {
    _repository = Repository();
  }

  saveCustomer(Customer customer) async {
    return await _repository.insertData('customers', customer.customerMap());
  }

  readCustomer() async {
    return await _repository.readData('customers');
  }

  readCustomerByID(customerId) async {
    return await _repository.readDatById(
        'customers', 'customer_id', customerId);
  }

  updateCustomer(Customer customer) async {
    return await _repository.update(
        'customers', 'customer_id', customer.customerMap());
  }

  deleteCustomer(customerId) async {
    return await _repository.deleteDatById(
        'customers', 'customer_id', customerId);
  }
}
