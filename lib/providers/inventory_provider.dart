import 'package:flutter/material.dart';
import '../models/item.dart';

class InventoryProvider extends ChangeNotifier {
  List<Item> _items = [];
  String _selectedCategory = 'All';

  List<Item> get items => _items;
  String get selectedCategory => _selectedCategory;

  List<Item> get filteredItems {
    if (_selectedCategory == 'All') return _items;
    return _items.where((item) => item.category == _selectedCategory).toList();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void addItem(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void editItem(int index, Item newItem) {
    _items[index] = newItem;
    notifyListeners();
  }

  void deleteItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
} 