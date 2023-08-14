import 'dart:convert';
import 'dart:io';
import 'package:demo_input_toss/TableToss.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:mysql1/mysql1.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;

class InputTossData extends StatefulWidget {
  const InputTossData({super.key});

  @override
  State<InputTossData> createState() => _InputTossDataState();
}

class _InputTossDataState extends State<InputTossData> {
  final _formKey = GlobalKey<FormState>();
  final _observeDescController = TextEditingController();
  final _dateController = TextEditingController();
  final _departmentController = TextEditingController();
  final _locationBuildingController = TextEditingController();
  final _locationController = TextEditingController();
  final _categoryController =TextEditingController();
  final _severityyController =TextEditingController();
  final _probabilitiesController =TextEditingController();
  final _suggestionController = TextEditingController();
  final _rootCauseController = TextEditingController();
  final _immediateCorrectiveActionController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  void dispose() {
    _observeDescController.dispose();
    _dateController.dispose();
    _departmentController.dispose();
    _locationBuildingController.dispose();
    _locationController.dispose();
    _categoryController.dispose();
    _severityyController.dispose();
    _probabilitiesController.dispose();
    _suggestionController.dispose();
    _rootCauseController.dispose();
    _immediateCorrectiveActionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

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

  Future<List<String>> fetchTableLocation() async {
    MySqlConnection connection = await _getConnection();
    List<String> locationLists = [];

    var results = await connection.query('SELECT location_name FROM ssq_all_master_location ORDER BY location_id');
    connection.close();

    for (var row in results) {
      locationLists.add(row['location_name'].toString());
    }

    connection.close();
    return locationLists;
  }

  Future<List<String>> fetchKodeLocation() async {
    MySqlConnection connection = await _getConnection();
    List<String> locationKodeLists = [];

    var results = await connection.query('SELECT location_kode FROM ssq_all_master_location');
    connection.close();

    for (var row in results) {
      locationKodeLists.add(row['location_kode']);
    }

    connection.close();
    return locationKodeLists;
  }

  Future<List<String>> fetchTableLocationBuilding() async {
    MySqlConnection connection = await _getConnection();
    List<String> buildingLists = [];

    var results = await connection.query('SELECT building_name FROM ssq_all_master_location_building ORDER BY building_id');
    connection.close();

    for (var row in results) {
      buildingLists.add(row['building_name'].toString());
    }

    connection.close();
    return buildingLists;
  }

  Future<List<String>> fetchTableHazardLevel() async {
    MySqlConnection connection = await _getConnection();
    List<String> hazardLevelLists = [];

    var results = await connection.query('SELECT ket_hazard FROM ssq_hazard_level ORDER BY kode_hazard');
    connection.close();

    for (var row in results) {
      hazardLevelLists.add(row['ket_hazard'].toString());
    }

    connection.close();
    return hazardLevelLists;
  }

  Future<List<String>> fetchTableHazardProbability() async {
    MySqlConnection connection = await _getConnection();
    List<String> hazardProbabilityLists = [];

    var results = await connection.query('SELECT ket_probability FROM ssq_hazard_probability ORDER BY kode_probability');
    connection.close();

    for (var row in results) {
      hazardProbabilityLists.add(row['ket_probability'].toString());
    }

    connection.close();
    return hazardProbabilityLists;
  }

  Future<List<int>> fetchIDDepartment() async {
    MySqlConnection connection = await _getConnection();
    List<int> departmentIDLists = [];

    var results = await connection.query('SELECT department_id FROM ssq_hrga_master_department');
    connection.close();

    for (var row in results) {
      departmentIDLists.add(row['department_id']);
    }

    connection.close();
    return departmentIDLists;
  }

  Future<List<String>> fetchTableDepartment() async {
    MySqlConnection connection = await _getConnection();
    List<String> departmentLists = [];

    var results = await connection.query('SELECT department_name FROM ssq_hrga_master_department ORDER BY department_id');
    connection.close();

    for (var row in results) {
      departmentLists.add(row['department_name'].toString());
    }

    connection.close();
    return departmentLists;
  }

  Future<List<String>> fetchTableSafeCategory() async {
    MySqlConnection connection = await _getConnection();
    List<String> safeLists = [];

    final results = await connection.query('SELECT safe_name FROM ssq_master_safe_category ORDER BY safe_id');

    for (var row in results) {
      safeLists.add(row['safe_name'].toString());
    }

    connection.close();
    return safeLists;
  }

  List<String> dropdownLocationData = [];
  List<String> dropdownLocationBuildingData = [];
  List<String> dropdownHazardLevelData = [];
  List<String> dropdownHazardProbability = [];
  List<String> dropdownDepartment = [];
  List<String> dropdownCategory = [];
  List<int> listIDDepartment = [];
  List<String> listKodeLocation = [];

  Future<void> _fetchKodeLocation() async {
    fetchKodeLocation().then((locationKodeLists) {
      setState(() {
        listKodeLocation = locationKodeLists;
      });
    });
  }
  Future<void> _fetchIDDepartment() async {
    fetchIDDepartment().then((departmentIDLists) {
      setState(() {
        listIDDepartment = departmentIDLists;
      });
    });
  }

  Future<void> _fetchData() async {
    fetchTableLocation().then((locationLists) {
      setState(() {
        dropdownLocationData = locationLists;
      });
    });

    fetchTableLocationBuilding().then((buildingLists) {
      setState(() {
        dropdownLocationBuildingData = buildingLists;
      });
    });

    fetchTableHazardLevel().then((hazardLevelLists) {
      setState(() {
        dropdownHazardLevelData = hazardLevelLists;
      });
    });

    fetchTableHazardProbability().then((hazardProbabilityLists) {
      setState(() {
        dropdownHazardProbability = hazardProbabilityLists;
      });
    });

    fetchTableDepartment().then((departmentLists) {
      setState(() {
        dropdownDepartment = departmentLists;
      });
    });

    fetchTableSafeCategory().then((safeLists) {
      setState(() {
        dropdownCategory = safeLists;
      });
    });
    setState(() {});
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

  Future<void> sendDataToDatabase(
      String data1,
      DateTime data2,
      int data3,
      int data4,
      int data5,
      int data6,
      String data7,
      String data8,
      String data9,
      String data10,
      String data11,
      String data12) async {
    MySqlConnection connection = await _getConnection();

    try {
      final DateTime now = DateTime.now();
      final String currentMonth = '${now.month.toString().padLeft(2, '0')}';
      final String currentYear = now.year.toString();

      final Results existingRecords = await connection.query('SELECT COUNT(*) AS count FROM ssq_data_sor');
      final int nextAutoIncrement = existingRecords.first['count'] + 1;

      final String formattedTaskName = 'TOSS/${nextAutoIncrement.toString().padLeft(3, '0')}/$currentMonth/$currentYear';
      await connection.query('INSERT INTO ssq_data_sor (sor_observe_description, sor_date, sor_department_id, sor_location_building_id, sor_location_id, sor_safe_category_id, sor_hazard_level, sor_probabilities, sor_suggestion, sor_root_cause, sor_immediate_corrective_action, sor_evidence, created_at, sor_report_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          data1,
          data2.toLocal().toIso8601String().split('T').first,
          data3,
          data4,
          data5,
          data6,
          data7,
          data8,
          data9,
          data10,
          data11,
          data12,
          DateTime.now().toLocal().toIso8601String(),
          formattedTaskName,
        ],);
      print('Data sent successfully!');
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchKodeLocation();
    _fetchIDDepartment();
    // getImageServer();
  }

  FilePickerResult? result;
  String _imagePath = "";
  File? image;
  // String? departmentfirst;
  int? departmentIDfirst;
  String? locationbuildingfirst;
  // String? locationfirst;
  String? locationIDfirst;
  String? categoryfirst;
  String? severityfirst;
  String? probabilitiesfirst;
  DateTime datetime = DateTime.now();

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      _imageController.text = image.name;
      _imagePath = image.path;
    } on PlatformException catch(e) {
      _imageController.text = 'Failed to pick image: $e';
    }
  }

  Future<void> sendImage() async {
    var img = image;
    var uri = "https://10.0.2.2/upload_image_toss/create.php"; // Remove extra slashes
    var request = http.MultipartRequest('POST', Uri.parse(uri));

    if (img != null) {
      var pic = await http.MultipartFile.fromPath("sor_evidence", img.path);
      request.files.add(pic);

      // Create an IOClient with a custom HttpClient that ignores SSL verification
      var ioClient = http.IOClient(
        HttpClient()..badCertificateCallback = (cert, host, port) => true,
      );

      try {
        var response = await ioClient.send(request);
        var responseBody = await response.stream.bytesToString();
        var message = jsonDecode(responseBody);

        // Pass the decoded message directly to printResponse
        printResponse(message);

      } catch (e) {
        print(e);
      } finally {
        ioClient.close(); // Close the IOClient to release resources
      }
    }
  }

  void printResponse(Map<String, dynamic> response) {
    // Assuming 'message' is a key in the response map
    if (response.containsKey('message')) {
      var message = response['message'];
      print('Response message: $message');
    } else {
      print('Response does not contain a valid message.');
    }
  }

  // Future<void> getImageServer() async {
  //   late http.IOClient ioClient;
  //
  //   try {
  //     ioClient = http.IOClient(
  //       HttpClient()..badCertificateCallback = (cert, host, port) => true,
  //     );
  //
  //     final response = await ioClient.get(Uri.parse('https://10.0.2.2/upload_image_toss/list.php'));
  //
  //     if (response.statusCode == 200) {
  //       if (response.body.isNotEmpty) {
  //         final data = jsonDecode(response.body);
  //         setState(() {
  //           _images = data;
  //         });
  //
  //         // Print the response body only once
  //         print('Get Image Server Response:');
  //         print(response.body);
  //       } else {
  //         print('Response body is empty.');
  //       }
  //     } else {
  //       print('Request failed with status: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   } finally {
  //     if (ioClient != null) {
  //       ioClient.close();
  //     }
  //   }
  // }


  Widget _buildImagePreview() {
    if (_imageController.text.isNotEmpty) {
      File image = File(_imagePath);
      return Column(
        children: [
          Image.file(image),
          ElevatedButton(
            onPressed: _clearImageSelection,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      );
    } else {
      return const Text('No image selected');
    }
  }

  void _clearImageSelection() {
    setState(() {
      _imageController.clear();
      _imagePath="";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
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
                        'Input Data TOSS',
                        style: TextStyle(color: Colors.black),
                      ),
                    ]
                ),
              ),
              leading: null,
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Stack(
                      children: [
                          Opacity(
                            opacity: 0.3,
                            child: Image.asset(
                              'assets/splash.png',
                              width: 500,
                              height: 680,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Column(
                            children: [
                              TextFormField(
                                controller: _observeDescController,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.description),
                                  hintText: 'Observe Description(Observasi Deskripsi)',
                                  labelText: 'Observe Description',
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedErrorBorder : OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please fill this field';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _dateController,
                                showCursor: false,
                                readOnly: true,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.calendar_month),
                                  hintText: 'Date',
                                  labelText: 'Date',
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedErrorBorder : OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                ),
                                onTap: ()
                                async{
                                  DateTime date = DateTime(1900);
                                  // TimeOfDay time = TimeOfDay.now();
                                  FocusScope.of(context).requestFocus(new FocusNode());

                                  date = (await showDatePicker(
                                      context: context,
                                      initialDate:DateTime.now(),
                                      firstDate:DateTime(1900),
                                      lastDate: DateTime(2100)
                                  )
                                  )!;

                                  // time = (await showTimePicker(
                                  //     context: context,
                                  //     initialTime: TimeOfDay.now(),
                                  //   )
                                  // )!;

                                  // DateTime datetime = DateTime(date.year, date.month, date.day, time.hour, time.minute);

                                  datetime = DateTime(date.year, date.month, date.day);

                                  // _dateController.text = DateFormat('dd/MM/yyyy hh:mm').format(datetime).toString();},
                                  DateFormat('dd/MM/yyyy').format(datetime);
                                  _dateController.text = DateFormat('dd/MM/yyyy').format(datetime).toString();},

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please fill this field';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _departmentController,
                                keyboardType: TextInputType.text,
                                onChanged: (newValue) {
                                  setState(() {
                                    departmentIDfirst = newValue as int?;
                                    _departmentController.text = newValue.toString();
                                  });
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.location_city),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedErrorBorder : OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  suffixIcon: DropdownButtonFormField2(
                                    value: departmentIDfirst,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB (50, 5, 10, 15),
                                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                                      border: InputBorder.none,
                                      labelText: 'Department',
                                    ),
                                    onChanged: (newValue) {
                                      setState(() {
                                        departmentIDfirst = newValue as int?;
                                        _departmentController.text = newValue.toString();
                                      });
                                    },
                                    items: zip(listIDDepartment, dropdownDepartment, (id, text) {
                                      return DropdownMenuItem<int>(
                                        value: id,
                                        child: Text(text),
                                      );
                                    }).toList(),
                                    dropdownSearchData: DropdownSearchData(
                                      searchController: _departmentController,
                                      searchInnerWidgetHeight: 50,
                                      searchInnerWidget: Container(
                                        height: 50,
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 4,
                                          right: 8,
                                          left: 8,
                                        ),
                                        child: TextFormField(
                                          expands: true,
                                          maxLines: null,
                                          controller: _departmentController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                            hintText: 'Search...',
                                            hintStyle: const TextStyle(fontSize: 12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      searchMatchFn: (item, searchValue) {
                                        return item.value.toString().contains(searchValue) || item.value.toString().toLowerCase().contains(searchValue) || item.value.toString().toUpperCase().contains(searchValue);
                                      },
                                    ),
                                    //This to clear the search value when you close the menu
                                    onMenuStateChange: (isOpen) {
                                      if (!isOpen) {
                                        _departmentController.clear();
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please fill this field';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _locationBuildingController,
                                keyboardType: TextInputType.streetAddress,
                                onChanged: (newValue) {
                                  setState(() {
                                    locationbuildingfirst = newValue.toString();
                                    _locationBuildingController.text = newValue.toString();
                                  });
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.streetview_outlined),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedErrorBorder : OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  suffixIcon: DropdownButtonFormField2(
                                      value: locationbuildingfirst,
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB (50, 5, 10, 15),
                                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                                        border: InputBorder.none,
                                        labelText: 'Location Building',
                                      ),
                                      onChanged: (newValue) {
                                        setState(() {
                                          locationbuildingfirst = newValue.toString();
                                          _locationBuildingController.text = newValue.toString();
                                        });
                                      },
                                      items: dropdownLocationBuildingData.map<DropdownMenuItem<String>>((safe_name) {
                                        return DropdownMenuItem<String>(
                                          value: safe_name,
                                          child: Text(safe_name),
                                        );
                                      }).toList(),
                                      dropdownSearchData: DropdownSearchData(
                                        searchController: _locationBuildingController,
                                        searchInnerWidgetHeight: 50,
                                        searchInnerWidget: Container(
                                          height: 50,
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 4,
                                            right: 8,
                                            left: 8,
                                          ),
                                          child: TextFormField(
                                            expands: true,
                                            maxLines: null,
                                            controller: _locationBuildingController,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 8,
                                              ),
                                              hintText: 'Search...',
                                              hintStyle: const TextStyle(fontSize: 12),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        searchMatchFn: (item, searchValue) {
                                          return item.value.toString().contains(searchValue) || item.value.toString().toLowerCase().contains(searchValue) || item.value.toString().toUpperCase().contains(searchValue);
                                        },
                                      ),
                                      //This to clear the search value when you close the menu
                                      onMenuStateChange: (isOpen) {
                                        if (!isOpen) {
                                          _locationBuildingController.clear();
                                        }
                                      }
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _locationController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.map_outlined),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedErrorBorder : OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  suffixIcon: DropdownButtonFormField2<String>(
                                    value: locationIDfirst,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB (50, 5, 10, 15),
                                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                                      border: InputBorder.none,
                                      labelText: 'Location',
                                    ),
                                    onChanged: (newValue) {
                                      setState(() {
                                        locationIDfirst = newValue;
                                        _locationController.text = newValue!;
                                      });
                                    },
                                    items: zip(listKodeLocation, dropdownLocationData, (id, text) {
                                      final combinedValue = '$id - $text';
                                      return DropdownMenuItem<String>(
                                        value: id,
                                        child: Text(combinedValue),
                                      );
                                    }).toList(),
                                    dropdownSearchData: DropdownSearchData(
                                      searchController: _locationController,
                                      searchInnerWidgetHeight: 50,
                                      searchInnerWidget: Container(
                                        height: 50,
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 4,
                                          right: 8,
                                          left: 8,
                                        ),
                                        child: TextFormField(
                                          expands: true,
                                          maxLines: null,
                                          controller: _locationController,
                                          onChanged: (value) {
                                            // Listen to the text changes and update the _locationController.text accordingly
                                          },
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                            hintText: 'Search...',
                                            hintStyle: const TextStyle(fontSize: 12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      searchMatchFn: (item, searchValue) {
                                        return item.value.toString().contains(searchValue) || item.value.toString().toLowerCase().contains(searchValue) || item.value.toString().toUpperCase().contains(searchValue);
                                      },
                                    ),
                                    //This to clear the search value when you close the menu
                                    onMenuStateChange: (isOpen) {
                                      if (!isOpen) {
                                        _locationController.clear();
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please fill this field';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _categoryController,
                                showCursor: false,
                                readOnly: true,
                                onChanged: (newValue) {
                                  setState(() {
                                    categoryfirst = newValue.toString();
                                    _categoryController.text = newValue.toString();
                                  });
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.category_outlined),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedErrorBorder : OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  suffixIcon: DropdownButtonFormField2(
                                    value: categoryfirst,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB (50, 5, 10, 15),
                                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                                      border: InputBorder.none,
                                      labelText: 'Category',
                                    ),
                                    onChanged: (newValue) {
                                      setState(() {
                                        categoryfirst = newValue.toString();
                                        _categoryController.text = newValue.toString();
                                      });
                                    },
                                    items: dropdownCategory.map<DropdownMenuItem<String>>((safe_name) {
                                      return DropdownMenuItem<String>(
                                        value: safe_name,
                                        child: Text(safe_name),
                                      );
                                    }).toList(),
                                    dropdownSearchData: DropdownSearchData(
                                      searchController: _categoryController,
                                      searchInnerWidgetHeight: 50,
                                      searchInnerWidget: Container(
                                        height: 50,
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 4,
                                          right: 8,
                                          left: 8,
                                        ),
                                        child: TextFormField(
                                          expands: true,
                                          maxLines: null,
                                          controller: _categoryController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                            hintText: 'Search...',
                                            hintStyle: const TextStyle(fontSize: 12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      searchMatchFn: (item, searchValue) {
                                        return item.value.toString().contains(searchValue) || item.value.toString().toLowerCase().contains(searchValue) || item.value.toString().toUpperCase().contains(searchValue);
                                      },
                                    ),
                                    //This to clear the search value when you close the menu
                                    onMenuStateChange: (isOpen) {
                                      if (!isOpen) {
                                        _categoryController.clear();
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please fill this field';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _severityyController,
                                showCursor: false,
                                readOnly: true,
                                onChanged: (newValue) {
                                  setState(() {
                                    severityfirst = newValue.toString();
                                    _severityyController.text = newValue.toString();
                                  });
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.warning_amber),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedErrorBorder : OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  border: InputBorder.none,
                                  suffixIcon: DropdownButtonFormField2(
                                    value: severityfirst,
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB (50, 5, 10, 15),
                                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                                        border: InputBorder.none,
                                        labelText: 'Severity '
                                    ),
                                    onChanged: (newValue) {
                                      setState(() {
                                        severityfirst = newValue.toString();
                                        _severityyController.text = newValue.toString();
                                      });
                                    },
                                    items: dropdownHazardLevelData.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    dropdownSearchData: DropdownSearchData(
                                      searchController: _severityyController,
                                      searchInnerWidgetHeight: 50,
                                      searchInnerWidget: Container(
                                        height: 50,
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 4,
                                          right: 8,
                                          left: 8,
                                        ),
                                        child: TextFormField(
                                          expands: true,
                                          maxLines: null,
                                          controller: _severityyController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                            hintText: 'Search...',
                                            hintStyle: const TextStyle(fontSize: 12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      searchMatchFn: (item, searchValue) {
                                        return item.value.toString().contains(searchValue) || item.value.toString().toLowerCase().contains(searchValue) || item.value.toString().toUpperCase().contains(searchValue);
                                      },
                                    ),
                                    //This to clear the search value when you close the menu
                                    onMenuStateChange: (isOpen) {
                                      if (!isOpen) {
                                        _severityyController.clear();
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please fill this field';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _probabilitiesController,
                                showCursor: false,
                                readOnly: true,
                                onChanged: (newValue) {
                                  setState(() {
                                    probabilitiesfirst = newValue.toString();
                                    _probabilitiesController.text = newValue.toString();
                                  });
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.percent),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedErrorBorder : OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  border: InputBorder.none,
                                  suffixIcon: DropdownButtonFormField2(
                                    value: probabilitiesfirst,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB (50, 5, 10, 15),
                                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                                      border: InputBorder.none,
                                      labelText: 'Probabilities',
                                    ),
                                    onChanged: (newValue) {
                                      setState(() {
                                        probabilitiesfirst = newValue.toString();
                                        _probabilitiesController.text = newValue.toString();
                                      });
                                    },
                                    items: dropdownHazardProbability.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    dropdownSearchData: DropdownSearchData(
                                      searchController: _probabilitiesController,
                                      searchInnerWidgetHeight: 50,
                                      searchInnerWidget: Container(
                                        height: 50,
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 4,
                                          right: 8,
                                          left: 8,
                                        ),
                                        child: TextFormField(
                                          expands: true,
                                          maxLines: null,
                                          controller: _probabilitiesController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                            hintText: 'Search...',
                                            hintStyle: const TextStyle(fontSize: 12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      searchMatchFn: (item, searchValue) {
                                        return item.value.toString().contains(searchValue) || item.value.toString().toLowerCase().contains(searchValue) || item.value.toString().toUpperCase().contains(searchValue);
                                      },
                                    ),
                                    //This to clear the search value when you close the menu
                                    onMenuStateChange: (isOpen) {
                                      if (!isOpen) {
                                        _probabilitiesController.clear();
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please fill this field';
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _suggestionController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.message_outlined),
                                  hintText: 'Suggestion',
                                  labelText: 'Suggestion',
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedErrorBorder : OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _rootCauseController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.question_mark_outlined),
                                  hintText: 'Root Cause',
                                  labelText: 'Root Cause (Penyebab Utama)',
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedErrorBorder : OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _immediateCorrectiveActionController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.construction_outlined),
                                  hintText: 'Immediate Corrective Action',
                                  labelText: 'Immediate Corrective Action (Rencana Perbaikan Segera)',
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                    borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  focusedErrorBorder : OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.1, color: Colors.red.shade700),
                                    borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              _buildImagePreview(),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _imageController,
                                showCursor: false,
                                readOnly: true,
                                keyboardType: TextInputType.none,
                                maxLines: 100,
                                minLines: 1,
                                decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                      borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                                      borderRadius : BorderRadius.all(Radius.circular(30.0)),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1.1, color: Colors.red.shade700),
                                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                    ),
                                    focusedErrorBorder : OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.1, color: Colors.red.shade700),
                                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                                    ),
                                    border: InputBorder.none,
                                    prefixIcon: const Icon(Icons.image_search),
                                    hintText: 'Upload Bukti',
                                    labelText: 'Upload Evidence'),
                                onTap: (pickImage),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue.shade900,
                                    minimumSize: const Size.fromHeight(50)
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final departmentData = await getSourceIdFromText<int>(
                                      'ssq_hrga_master_department',
                                      'department_id',
                                      'department_id',
                                      _departmentController.text.toString()
                                    );

                                    final locationBuildingData = await getSourceIdFromText<int>(
                                        'ssq_all_master_location_building',
                                        'building_name',
                                        'building_id',
                                        _locationBuildingController.text.toString()
                                    );

                                    final locationData = await getSourceIdFromText<int>(
                                        'ssq_all_master_location',
                                        'location_kode',
                                        'location_id',
                                        _locationController.text.toString()
                                    );

                                    final categoryData = await getSourceIdFromText<int>(
                                        'ssq_master_safe_category',
                                        'safe_name',
                                        'safe_id',
                                        _categoryController.text.toString()
                                    );

                                    final severityData = await getSourceIdFromText<String>(
                                        'ssq_hazard_level',
                                        'ket_hazard',
                                        'kode_hazard',
                                        _severityyController.text.toString()
                                    );

                                    final probabilityData = await getSourceIdFromText<String>(
                                        'ssq_hazard_probability',
                                        'ket_probability',
                                        'kode_probability',
                                        _probabilitiesController.text.toString()
                                    );

                                    sendDataToDatabase(_observeDescController.text, datetime, departmentData, locationBuildingData, locationData, categoryData, severityData, probabilityData, _suggestionController.text, _rootCauseController.text, _immediateCorrectiveActionController.text, _imageController.text);
                                    sendImage();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Data berhasil diinput')
                                      ),
                                    );
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => const TableToss()));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Tolong datanya dilengkapi')
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Submit',
                                  style: TextStyle(color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        )
    );
  }

  InputDecoration inputDecoration({
    InputBorder? enabledBorder,
    InputBorder? border,
    Color? fillColor,
    bool? filled,
    Widget? prefixIcon,
    String? hintText,
    String? labelText,
  }) =>
      InputDecoration(
          enabledBorder: enabledBorder ??
              const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 2.0)),
          border: border ?? const OutlineInputBorder(borderSide: BorderSide()),
          fillColor: fillColor ?? Colors.white,
          filled: filled ?? true,
          prefixIcon: prefixIcon,
          hintText: hintText,
          labelText: labelText);
}


List<R> zip<T, U, R>(List<T> list1, List<U> list2, R Function(T, U) combiner) {
  final length = (list1.length < list2.length) ? list1.length : list2.length;
  final List<R> result = [];
  for (int i = 0; i < length; i++) {
    result.add(combiner(list1[i], list2[i]));
  }
  return result;
}
