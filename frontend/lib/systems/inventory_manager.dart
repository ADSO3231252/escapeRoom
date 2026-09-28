import '../models/item.dart';

class InventoryManager {
  final List<Item> _items = [];

  List<Item> get items => List.unmodifiable(_items);

  void addItem(Item item) {
    if (!_items.any((existingItem) => existingItem.id == item.id)) {
      _items.add(item);
    }
  }

  void removeItem(int itemId) {
    _items.removeWhere(
      (item) => item.id == itemId,
    );
  }

  bool hasItem(int itemId) {
    return _items.any(
      (item) => item.id == itemId,
    );
  }

  void clear() {
    _items.clear();
  }
}