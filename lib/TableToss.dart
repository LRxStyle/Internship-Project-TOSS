import 'dart:io';
import 'package:demo_input_toss/DeletedDataPage.dart';
import 'package:demo_input_toss/EditTossData.dart';
import 'package:demo_input_toss/InputTossData.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

class TableToss extends StatefulWidget {
  const TableToss({super.key});

  @override
  _TableTossState createState() => _TableTossState();
}

class _TableTossState extends State<TableToss> {
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

  List<List<String>> dataRows = [];
  List<List<String>> originalDataRows = []; // Store the original data
  TextEditingController searchController = TextEditingController();
  late String departmentname; // Example column index for department
  late String buildingname;
  late String locationname;
  late String safename;
  late String severityname;
  late String probabilityname;//

  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
    cleanUpOldDeletedData();
  }

  Future<void> deleteSelectedRow(int rowIndex) async {
    MySqlConnection connection = await _getConnection();
    int idToDelete = int.parse(dataRows[rowIndex][0]); // Assuming ID is in the first column

    // Fetch the row data to be deleted
    var result = await connection.query(
        'SELECT * FROM ssq_data_sor WHERE sor_id = ?',
        [idToDelete]
    );

    if (result.isNotEmpty) {
      var row = result.first;
      await connection.query(
          'INSERT INTO deleted_sor_data (sor_id, sor_report_id, sor_current_status, sor_observe_description, sor_date, sor_department_id, '
              'sor_location_building_id, sor_location_id, sor_safe_category_id, sor_hazard_level, sor_probabilities, '
              'sor_suggestion, sor_root_cause, sor_immediate_corrective_action, sor_evidence, created_at, deleted_at) '
              'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            row['sor_id'],
            row['sor_report_id'],
            row['sor_current_status'],
            row['sor_observe_description'],
            row['sor_date'].toUtc(),
            row['sor_department_id'],
            row['sor_location_building_id'],
            row['sor_location_id'],
            row['sor_safe_category_id'],
            row['sor_hazard_level'],
            row['sor_probabilities'],
            row['sor_suggestion'],
            row['sor_root_cause'],
            row['sor_immediate_corrective_action'],
            row['sor_evidence'],
            row['created_at'].toUtc(),
            DateTime.now().toUtc()
          ]
      );

      await connection.query(
          'DELETE FROM ssq_data_sor WHERE sor_id = ?',
          [idToDelete]
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil dihapus')),
      );

      setState(() {
        dataRows.removeAt(rowIndex);
      });
    }

    await connection.close();
  }



  Future<void> fetchDataFromDatabase() async {
    MySqlConnection connection = await _getConnection();

    final results = await connection.query(
        'SELECT sor.sor_id, sor.sor_report_id, sor.sor_observe_description, sor.sor_date, sor.sor_department_id, '
            'sor.sor_location_building_id, sor.sor_location_id, sor.sor_safe_category_id, sor.sor_hazard_level, '
            'sor.sor_probabilities, sor.sor_suggestion, sor.sor_root_cause, sor.sor_immediate_corrective_action, '
            'sor.sor_evidence, sor.created_at, status.status_description '
            'FROM ssq_data_sor as sor '
            'LEFT JOIN ssq_all_master_status as status ON sor.sor_current_status = status.status_id');

    print('Fetched data: $results');


    for (var row in results) {
      dataRows.add([
        row['sor_id'].toString(),
        row['sor_report_id'].toString(),
        row['status_description'].toString(),
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
      ]);
    }
    originalDataRows=dataRows;
    print('Original Data Rows: $originalDataRows');
    await connection.close();
    setState(() {});
  }

  Future<void> refreshData() async {
    dataRows.clear(); // Clear the existing data
    await fetchDataFromDatabase(); // Fetch data again
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data berhasil direfresh')),
    );
  }

  Future getSourceIdFromText<T>(String sourceTable, String columnName, String columnName2, String text) async {
    final connection  = await _getConnection();

    // Replace 'source_table' and 'text_column' with the actual table name and text column in your source table
    final sourceTableName = sourceTable;
    final textColumnName = columnName;
    final idColumnName = columnName2;

    try {
      final result = await connection.query(
        'SELECT * FROM $sourceTableName WHERE $textColumnName = ?',
        [text],
      );

      print('SQL Query: SELECT * FROM $sourceTableName WHERE $textColumnName = $text');
      print('Query Result: $result');

      if (result.isNotEmpty) {
        return result.first[idColumnName] as T;
      } else {
        return -1; // Return a negative value or null to indicate that the text was not found in the source table
      }
    } catch (e) {
      print('Error fetching source data: $e');
      return -1;
    } finally {
      await connection.close();
    }
  }

  Future _editRow(int rowIndex) async {
    String departmentName = dataRows[rowIndex][5]; // Example column index for department
    String buildingName = dataRows[rowIndex][6];
    String locationName = dataRows[rowIndex][7];
    String safeName = dataRows[rowIndex][8];
    String severityName = dataRows[rowIndex][9];
    String probabilityName = dataRows[rowIndex][10];// Example column index for building

    departmentname = await getSourceIdFromText<String>(
      'ssq_hrga_master_department',
      'department_id',
      'department_name',
      departmentName,
    );

     buildingname = await getSourceIdFromText<String>(
      'ssq_all_master_location_building',
      'building_id',
      'building_name',
      buildingName,
    );

     locationname = await getSourceIdFromText<String>(
      'ssq_all_master_location',
      'location_id',
      'location_kode',
      locationName,
    );

     safename = await getSourceIdFromText<String>(
      'ssq_master_safe_category',
      'safe_id',
      'safe_name',
      safeName,
    );

     severityname = await getSourceIdFromText<String>(
      'ssq_hazard_level',
      'kode_hazard',
      'ket_hazard',
      severityName,
    );

     probabilityname = await getSourceIdFromText<String>(
      'ssq_hazard_probability',
      'kode_probability',
      'ket_probability',
      probabilityName,
    );
  }

  void _performSearch(String query) {
    query = query.trim();
    setState(() {
      if (query.isEmpty) {
        refreshData();
      } else {
        dataRows = originalDataRows.where((row) {
          return row[0].toLowerCase().contains(query.toLowerCase()); // Only search the first cell (ID)
        }).toList();
      }
    });
  }


  Future<void> exportToExcel() async {
    // Get the device's documents directory
    Directory? documentsDirectory = await getExternalStorageDirectory();
    if (documentsDirectory != null) {
      String filePath = '${documentsDirectory.path}/toss_data.xlsx';
      // Create Excel workbook and sheet
      var excel = Excel.createExcel();
      var sheet = excel['TossData'];

      // Add headers to the sheet
      sheet.appendRow([
        'ID', 'Report ID', 'Status', 'Observe Description', 'Date',
        'Department', 'Location Building', 'Location', 'Safe Category ID',
        'Hazard Level', 'Hazard Probabilities', 'Suggestion', 'Root Cause',
        'Immediate Corrective Action', 'Evidence', 'Created At'
      ]);

      // Add data rows to the sheet
      for (var row in dataRows) {
        sheet.appendRow(row);
      }


      // Save the Excel file
      List<int>? excelBytes = excel.encode();
      if (excelBytes != null) {
        File excelFile = File(filePath);
        excelFile.writeAsBytesSync(excelBytes);


        // Show a dialog with a download link
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Export Complete'),
              content: Text('Toss data has been exported to $filePath'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    print('Toss data has been exported to $filePath');
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }



  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search'),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Masukkan ID laporan TOSS...',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _performSearch(searchController.text);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Search'),
            ),
            TextButton(
              onPressed: () {
                searchController.clear();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
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
                  'Tabel Data TOSS',
                  style: TextStyle(color: Colors.black),
                ),
              ]
          ),
        ),
        leading: null,
        automaticallyImplyLeading: false,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child :
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: Stack(
                      children: [
                        Opacity(
                          opacity: 0.15,
                          child: Image.asset(
                            'assets/splash.png',
                            width: 900,
                            height: 800,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DataTable(
                              columnSpacing: 30,
                              sortAscending: true,
                              columns: [
                                   const DataColumn(label: Text('Edit or Delete')),
                                   const DataColumn(label: Text('ID')),
                                   const DataColumn(label: Text('Report ID')),
                                   const DataColumn(label: Text('Status')),
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
                                 ],
                                 rows: dataRows.asMap().entries.map((entry) {
                                   int rowIndex = entry.key;
                                   List<String> row = entry.value;
                                   return DataRow(
                                     cells: [
                                       DataCell(Row(
                                         children: [
                                           IconButton(
                                             icon: const Icon(Icons.edit),
                                             onPressed: () async {
                                               await _editRow(rowIndex);
                                               Navigator.push(
                                                 context,
                                                 MaterialPageRoute(
                                                   builder: (context) => EditDataPage(
                                                       data: dataRows[rowIndex],
                                                       departmentname : departmentname,
                                                       buildingname : buildingname,
                                                       locationname : locationname,
                                                       safename : safename,
                                                       severityname : severityname,
                                                       probabilityname : probabilityname,
                                                   ),
                                                 ),
                                               );
                                             },
                                           ),
                                           IconButton(
                                             icon: const Icon(Icons.delete_forever),
                                             onPressed: () {
                                               deleteSelectedRow(rowIndex);
                                             },
                                           ),
                                         ],
                                       )),
                                       ...row.map((cell) { return DataCell(Text(cell));
                                       }).toList(),
                                     ],
                                   );
                                 }).toList(),
                               ),
                               const SizedBox(height: 20,),
                               Row(
                                 children: <Widget>[
                                   FloatingActionButton(
                                     heroTag: "refreshButton",
                                     onPressed: () {
                                       refreshData();
                                       },
                                     backgroundColor: Colors.cyan,
                                     child: const Icon(Icons.refresh),
                                   ),
                                   const SizedBox(width: 15,),
                                   FloatingActionButton(
                                     heroTag: "searchButton",
                                     onPressed: () {
                                       _showSearchDialog();
                                     },
                                     backgroundColor: Colors.green,
                                     child: const Icon(Icons.search),
                                   ),
                                   const SizedBox(width: 15,),
                                   FloatingActionButton(
                                     heroTag: "printExcel",
                                     onPressed: () {
                                       exportToExcel();
                                     },
                                     backgroundColor: Colors.orange,
                                     child: const Icon(Icons.file_download),
                                   ),
                                   const SizedBox(width: 15,),
                                   FloatingActionButton(
                                     heroTag: "goToDeletedPage",
                                     onPressed: () {
                                       Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => const DeletedDataPage()),
                                       );
                                     },
                                     backgroundColor: Colors.greenAccent,
                                     child: const Icon(Icons.restore_from_trash_outlined),
                                   )
                                 ],
                               ),
                          ],
                        ),
                      ]
                  ),
                )
            ),
      ),

      floatingActionButton: FloatingActionButton(
        heroTag: "addButton",
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const InputTossData()));
        },
        backgroundColor: Colors.cyan,
        child: const Icon(Icons.add),
      ),
    );
  }
}