import 'package:baki_potro/models/buy_items.dart';
import 'package:baki_potro/repository/repository.dart';

class BuyService {
  Repository _repository;

  BuyService() {
    _repository = Repository();
  }

  saveBuy(Buy buy) async {
    return await _repository.insertData('buys', buy.buyMapping());
  }

  readBuy() async {
    return await _repository.readData('buys');
  }

  readBuyByID(buyId) async {
    return await _repository.readDatById('buys', 'buy_id', buyId);
  }

  readBuyByColumn(column, columnValue) async {
    return await _repository.readDataByColumnName('buys', column, columnValue);
  }

  updateBuy(Buy buy) async {
    return await _repository.update('buys', 'buy_id', buy.buyMapping());
  }

  deleteBuy(buyId) async {
    return await _repository.deleteDatById('buys', 'buy_id', buyId);
  }
}
