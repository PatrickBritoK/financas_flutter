import 'package:flutter/material.dart';

class PageHome extends StatelessWidget {
  const PageHome({Key? key}) : super(key: key);

/////////////////////////////////Appbar///////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Center(
          child: Text(
            'Finanças',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body:const  EntryList(),
    );
  }
}

class Entry {
  final String name;
  final double amount;
  Entry({required this.name, required this.amount});
}

class EntryList extends StatefulWidget {
  const EntryList({Key? key}) : super(key: key);

  @override
  _EntryListState createState() => _EntryListState();
}
////////////////////////////////Parte logica///////////////////////////////////////
class _EntryListState extends State<EntryList> {
  String _selectedType = 'Entrada';
  final List<Entry> _entries = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final bool _isExpense = false;

  double get _total => _entries.fold(
        0,
        (previousValue, entry) =>
            previousValue + (entry.amount * (_isExpense ? -1 : 1)),
      );

  void _addEntry() {
    final String name = _nameController.text;
    final double amount = double.parse(_amountController.text) *
        (_selectedType == 'Saída' ? -1 : 1);
    final Entry entry = Entry(name: name, amount: amount);
    setState(() {
      _entries.add(entry);
    });
    _nameController.clear();
    _amountController.clear();
    Navigator.of(context).pop();
  }
////////////////////////////////////Modal do "Mostrar Total"///////////////////////////////////
  void _showTotal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Total'),
          content: Text('\$${_total.toStringAsFixed(2)}'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
///////////////////////////////////////Modal para Entradas e saidas//////////////////////////////////////
  void _showEntryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                  ),
                ),
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                  ),
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'Entrada',
                      child: Text('Entrada'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Saída',
                      child: Text('Saída'),
                    ),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: _addEntry,
                  child: const Text('Adicionar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

////////////////////////////////Parte do body/////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Entradas e Saídas',
            style: TextStyle(fontSize: 24),
          ),
        ),

        ////////////////////////////////logica para criar a lista conforme for colocando/////////////////////////////////////
        Expanded(
          child: ListView.builder(
            itemCount: _entries.length,
            itemBuilder: (BuildContext context, int index) {
              final Entry entry = _entries[index];
              return ListTile(
                leading: Icon(entry.amount > 0
                    ? Icons.arrow_upward
                    : Icons.arrow_downward),
                title: Text(entry.name),
                trailing: Text('${entry.amount.toStringAsFixed(2)}'),
              );
            },
          ),
        ),

        ///////////////////////Botão de adicionar Entradas e Saídas///////////////////////////////////////////
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _showEntryDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
                child: const Text('Adicionar'),
              ),
            ],
          ),
        ),

        ////////////////////////Botão para mostrar o total///////////////////////////
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton(
            onPressed: () => _showTotal(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            child: const Text('Mostrar Total'),
          ),
        ),
      ],
    );
  }
}
