import 'package:demo_input_toss/TableToss.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

Future<MySqlConnection> _getConnection() async {
  final settings = ConnectionSettings(
    host: '10.0.2.2',
    port: 3306,
    user: 'root',
    password: null,
    db: 'db_pas',
  );

  return await MySqlConnection.connect(settings);
}

Future<void> cleanUpOldDeletedData() async {
  MySqlConnection connection = await _getConnection();

  await connection.query(
      'DELETE FROM deleted_sor_data WHERE deleted_at < NOW() - INTERVAL 30 DAY'
  );

  await connection.close();
}

class DeletedDataPage extends StatefulWidget {
  const DeletedDataPage({Key? key}) : super(key: key);

  @override
  _DeletedDataPageState createState() => _DeletedDataPageState();
}

class _DeletedDataPageState extends State<DeletedDataPage> {
  List<List<String>> deletedDataRows = [];

  @override
  void initState() {
    super.initState();
    fetchDeletedDataFromDatabase();
    cleanUpOldDeletedData();
  }

  Future<void> fetchDeletedDataFromDatabase() async {
    MySqlConnection connection = await _getConnection();

    final results = await connection.query(
        'SELECT sor_id, sor_report_id, sor_observe_description, sor_date, sor_department_id, '
            'sor_location_building_id, sor_location_id, sor_safe_category_id, sor_hazard_level, '
            'sor_probabilities, sor_suggestion, sor_root_cause, sor_immediate_corrective_action, '
            'sor_evidence, created_at, deleted_at '
            'FROM deleted_sor_data'
    );

    for (var row in results) {
      deletedDataRows.add([
        row['sor_id'].toString(),
        row['sor_report_id'].toString(),
        row['sor_observe_description'].toString(),
        row['sor_date'].toIso8601String().split('T').first,
        row['sor_department_id'].toString(),
        row['sor_location_building_id'].toString(),
        row['sor_location_id'].toString(),
        row['sor_safe_category_id'].toString(),
        row['sor_hazard_level'].toString(),
        row['sor_probabilities'].toString(),
        row['sor_suggestion'].toString(),
        row['sor_root_cause'].toString(),
        row['sor_immediate_corrective_action'].toString(),
        row['sor_evidence'].toString(),
        row['created_at'].toLocal().toIso8601String().split(RegExp(r"[T.]")).toString(),
        row['deleted_at'].toLocal().toIso8601String().split(RegExp(r"[T.]")).toString(),
      ]);
    }

    await connection.close();
    setState(() {});
  }

  Future<void> restoreDeletedRow(int rowIndex) async {
    MySqlConnection connection = await _getConnection();
    var row = deletedDataRows[rowIndex];

    DateTime sorDate;
    DateTime createdAt;

    try {
      sorDate = DateTime.parse(row[3].replaceAll('[', '').replaceAll(']', '').split(',')[0].trim());
    } catch (e) {
      print('Error parsing sor_date: $e');
      return;
    }

    try {
      createdAt = DateTime.parse(row[14].replaceAll('[', '').replaceAll(']', '').split(',')[0].trim());
    } catch (e) {
      print('Error parsing created_at: $e');
      return;
    }

    await connection.query(
        'INSERT INTO ssq_data_sor (sor_id, sor_report_id, sor_observe_description, sor_date, sor_department_id, '
            'sor_location_building_id, sor_location_id, sor_safe_category_id, sor_hazard_level, sor_probabilities, '
            'sor_suggestion, sor_root_cause, sor_immediate_corrective_action, sor_evidence, created_at) '
            'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          row[0],
          row[1],
          row[2],
          sorDate.toUtc(),
          row[4],
          row[5],
          row[6],
          row[7],
          row[8],
          row[9],
          row[10],
          row[11],
          row[12],
          row[13],
          createdAt.toUtc()
        ]
    );

    await connection.query(
        'DELETE FROM deleted_sor_data WHERE sor_id = ?',
        [int.parse(row[0])]
    );

    await connection.close();
    setState(() {
      deletedDataRows.removeAt(rowIndex);
    });
  }


  Future<void> permanentlyDeleteRow(int rowIndex) async {
    MySqlConnection connection = await _getConnection();
    var row = deletedDataRows[rowIndex];

    await connection.query(
        'DELETE FROM deleted_sor_data WHERE sor_id = ?',
        [int.parse(row[0])]
    );

    await connection.close();
    setState(() {
      deletedDataRows.removeAt(rowIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: IconButton(
        onPressed: (){
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const TableToss()));
        },
        icon: const Icon(Icons.home),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Center(
          child: Row(
              children:[
                Image(
                  image : AssetImage('assets/splash.png'),
                  width : 130,
                  height: 130,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Tabel Deleted Data TOSS',
                  style: TextStyle(color: Colors.black),
                ),
              ]
          ),
        ),
        leading: null,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Column(
            children: [
              DataTable(
                columns: [
                  const DataColumn(label: Text('Restore or Delete')),
                  const DataColumn(label: Text('ID')),
                  const DataColumn(label: Text('Report ID')),
                  const DataColumn(label: Text('Observe Description')),
                  const DataColumn(label: Text('Date')),
                  const DataColumn(label: Text('Department')),
                  const DataColumn(label: Text('Location Building')),
                  const DataColumn(label: Text('Location')),
                  const DataColumn(label: Text('Safe Category ID')),
                  const DataColumn(label: Text('Hazard Level')),
                  const DataColumn(label: Text('Hazard Probabilities')),
                  const DataColumn(label: Text('Suggestion')),
                  const DataColumn(label: Text('Root Cause')),
                  const DataColumn(label: Text('Immediate Corrective Action')),
                  const DataColumn(label: Text('Evidence')),
                  const DataColumn(label: Text('Created At')),
                  const DataColumn(label: Text('Deleted At')),
                ],
                rows: deletedDataRows.asMap().entries.map((entry) {
                  int rowIndex = entry.key;
                  List<String> row = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.restore),
                            onPressed: () {
                              restoreDeletedRow(rowIndex);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_forever),
                            onPressed: () {
                              permanentlyDeleteRow(rowIndex);
                            },
                          ),
                        ],
                      )),
                      ...row.map((cell) {
                        return DataCell(Text(cell));
                      }).toList(),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
