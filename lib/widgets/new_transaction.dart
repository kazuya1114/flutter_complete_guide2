import 'package:flutter/material.dart';
import 'package:flutter_complete_guide2/widgets/adaptive_text_button.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  const NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  _NewTransactionState() {
    print('Constructor New Transaction State');
  }

  // ウィジェット生成時に呼び出される(データベースからデータを取得する際等に使用)
  @override
  void initState() {
    super.initState();
  }

  // ウィジェットに対して何らかの変更があった際に呼び出される(情報の更新を行う際に使用)
  @override
  void didUpdateWidget(covariant NewTransaction oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  // ウィジェットが不要になった際に呼び出される(データのクリーンアップに使用)
  @override
  void dispose() {
    super.dispose();
  }

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(enteredTitle, enteredAmount, _selectedDate);

    // ModalSheetを閉じる(Navigator：画面遷移にも利用する関数)
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(), // ピッカーを開いた際の初期値日付
      firstDate: DateTime(2019), // ピッカーで選択可能な日付(今回は2019年まで)
      lastDate: DateTime.now(), // ピッカーで選択可能な最終日
    ).then((value) {
      // ユーザーがアクションを起こした際に実行される
      if (value == null) {
        return; // valueがnullなら処理を中断
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    controller: _titleController, // 入力された値を変数に格納する
                    onSubmitted: (_) => _submitData(),
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Amount'),
                    controller: _amountController, // 入力された値を変数に格納する
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _submitData(),
                  ),
                  Container(
                    height: 70,
                    child: Row(children: <Widget>[
                      Expanded(
                        child: Text(_selectedDate == null
                            ? 'No Date Chosen!'
                            : DateFormat('yyyy/MM/dd').format(_selectedDate!)),
                      ),
                      AdaptiveTextButton('Choose Date', _presentDatePicker),
                    ]),
                  ),
                  ElevatedButton(
                    child: const Text('Add Transaction'),
                    onPressed: () => _submitData(),
                  )
                ])),
      ),
    );
  }
}
