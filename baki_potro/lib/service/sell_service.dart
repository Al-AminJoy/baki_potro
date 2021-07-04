import 'package:baki_potro/models/sell_item.dart';
import 'package:baki_potro/repository/repository.dart';

class SellService {
  Repository _repository;

  SellService() {
    _repository = Repository();
  }

  saveSell(Sell sell) async {
    return await _repository.insertData('sells', sell.sellMapping());
  }

  readSell() async {
    return await _repository.readData('sells');
  }

  readSellByID(sellId) async {
    return await _repository.readDatById('sells', 'sell_id', sellId);
  }

  readSellByColumn(column, columnValue) async {
    return await _repository.readDataByColumnName('sells', column, columnValue);
  }

  updateSell(Sell sell) async {
    return await _repository.update('sells', 'sell_id', sell.sellMapping());
  }

  deleteSell(sellId) async {
    return await _repository.deleteDatById('sells', 'sell_id', sellId);
  }
}
