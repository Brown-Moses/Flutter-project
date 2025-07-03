import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../models/item.dart';
import '../providers/auth_provider.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  static List<String> _categories = [
    'Electronics',
    'Office',
    'Grocery',
  ];

  void _showAddCategoryDialog(BuildContext context, void Function(String) onCategoryAdded) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Category Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newCategory = controller.text.trim();
              if (newCategory.isNotEmpty && !_categories.contains(newCategory)) {
                _categories.add(newCategory);
                onCategoryAdded(newCategory);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Item item, int index) {
    final nameController = TextEditingController(text: item.name);
    final quantityController = TextEditingController(text: item.quantity.toString());
    String selectedCategory = item.category;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: [
                  ..._categories.map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      )),
                  const DropdownMenuItem(
                    value: '__add_new__',
                    child: Text('Add new category...'),
                  ),
                ],
                onChanged: (val) {
                  if (val == '__add_new__') {
                    _showAddCategoryDialog(context, (newCat) {
                      setState(() {
                        selectedCategory = newCat;
                      });
                    });
                  } else if (val != null) {
                    setState(() {
                      selectedCategory = val;
                    });
                  }
                },
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = nameController.text.trim();
                final newQuantity = int.tryParse(quantityController.text.trim()) ?? 0;
                if (newName.isNotEmpty && selectedCategory.isNotEmpty && newQuantity > 0) {
                  Provider.of<InventoryProvider>(context, listen: false).editItem(
                    index,
                    item.copyWith(name: newName, quantity: newQuantity, category: selectedCategory),
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item updated!')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Provider.of<InventoryProvider>(context, listen: false).deleteItem(index);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item deleted!')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    String selectedCategory = _categories[0];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: [
                  ..._categories.map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      )),
                  const DropdownMenuItem(
                    value: '__add_new__',
                    child: Text('Add new category...'),
                  ),
                ],
                onChanged: (val) {
                  if (val == '__add_new__') {
                    _showAddCategoryDialog(context, (newCat) {
                      setState(() {
                        selectedCategory = newCat;
                      });
                    });
                  } else if (val != null) {
                    setState(() {
                      selectedCategory = val;
                    });
                  }
                },
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final quantity = int.tryParse(quantityController.text.trim()) ?? 0;
                if (name.isNotEmpty && selectedCategory.isNotEmpty && quantity > 0) {
                  final newItem = Item(
                    id: DateTime.now().millisecondsSinceEpoch,
                    name: name,
                    quantity: quantity,
                    category: selectedCategory,
                  );
                  Provider.of<InventoryProvider>(context, listen: false).addItem(newItem);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item added!')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) => _SearchSheet(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<InventoryProvider>(
          builder: (context, inventory, child) {
            if (inventory.items.isEmpty) {
              return const Center(child: Text('No items in inventory.'));
            }
            final categories = ['All', ...{
              ...inventory.items.map((e) => e.category)
            }];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final selected = inventory.selectedCategory == categories[i];
                      return FilterChip(
                        label: Text(categories[i]),
                        selected: selected,
                        onSelected: (_) {
                          inventory.setCategory(categories[i]);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: inventory.filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = inventory.filteredItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal[100],
                            child: Icon(Icons.inventory_2, color: Colors.teal[800]),
                          ),
                          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${item.category} • Quantity: ${item.quantity}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.teal),
                                onPressed: () => _showEditDialog(context, item, inventory.items.indexOf(item)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () => _showDeleteDialog(context, inventory.items.indexOf(item)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[800],
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Modern search modal bottom sheet
class _SearchSheet extends StatefulWidget {
  @override
  State<_SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<_SearchSheet> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final inventory = Provider.of<InventoryProvider>(context);
    final results = inventory.items.where((item) =>
      item.name.toLowerCase().contains(query.toLowerCase()) ||
      item.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
    return Padding(
      padding: EdgeInsets.only(
        left: 24, right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search items or categories...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (val) => setState(() => query = val),
          ),
          const SizedBox(height: 16),
          if (results.isEmpty)
            const Text('No results found.'),
          if (results.isNotEmpty)
            SizedBox(
              height: 300,
              child: ListView(
                children: results.map((item) => ListTile(
                  title: Text(item.name),
                  subtitle: Text('${item.category} • Quantity: ${item.quantity}'),
                )).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
