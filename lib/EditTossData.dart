import 'dart:io';
import 'package:demo_input_toss/TableToss.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';

// ignore: must_be_immutable
class EditDataPage extends StatefulWidget {
  final List<String> data;
  String departmentname;
  String buildingname;
  String locationname;
  String safename;
  String severityname;
  String probabilityname;

  EditDataPage({super.key, required this.data,
    required  this.departmentname,
    required  this.buildingname,
    required  this.locationname,
    required  this.safename,
    required  this.severityname,
    required  this.probabilityname});


  @override
  _EditDataPageState createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportIDController = TextEditingController();
  final _statusController = TextEditingController();
  final _observeDescController = TextEditingController();
  final _dateController = TextEditingController();
  final _departmentController = TextEditingController();
  final _locationBuildingController = TextEditingController();
  final _locationController = TextEditingController();
  final _categoryController =TextEditingController();
  final _severityController =TextEditingController();
  final _probabilitiesController =TextEditingController();
  final _suggestionController = TextEditingController();
  final _rootCauseController = TextEditingController();
  final _immediateCorrectiveActionController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  void dispose() {
    _reportIDController.dispose();
    _statusController.dispose();
    _observeDescController.dispose();
    _dateController.dispose();
    _departmentController.dispose();
    _locationBuildingController.dispose();
    _locationController.dispose();
    _categoryController.dispose();
    _severityController.dispose();
    _probabilitiesController.dispose();
    _suggestionController.dispose();
    _rootCauseController.dispose();
    _immediateCorrectiveActionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  FilePickerResult? result;
  File? image;
  String? departmentfirst;
  int? departmentIDfirst;
  String? locationbuildingfirst;
  String? locationIDfirst;
  String? categoryfirst;
  String? severityfirst;
  String? probabilitiesfirst;
  DateTime datetime = DateTime.now();

  List<String> dropdownStatusData = [];
  List<String> dropdownLocationData = [];
  List<String> dropdownLocationBuildingData = [];
  List<String> dropdownHazardLevelData = [];
  List<String> dropdownHazardProbability = [];
  List<String> dropdownDepartment = [];
  List<String> dropdownCategory = [];
  List<int> listIDDepartment = [];
  List<String> listKodeLocation = [];

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

  Future<List<String>> fetchTableStatus() async {
    MySqlConnection connection = await _getConnection();
    List<String> statusLists = [];

    var results = await connection.query('SELECT status_description FROM ssq_all_master_status ORDER BY status_id');
    connection.close();

    for (var row in results) {
      statusLists.add(row['status_description'].toString());
    }

    connection.close();
    return statusLists;
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
    fetchTableStatus().then((statusLists) {
      setState(() {
        dropdownStatusData = statusLists;
      });
    });

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

  Future<void> updateDataInDatabase() async {
    MySqlConnection connection = await _getConnection();

    try {
      final statusData = await getSourceIdFromText<int>(
          'ssq_all_master_status',
          'status_description',
          'status_id',
          _statusController.text.toString()
      );

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
          _severityController.text.toString()
      );

      final probabilityData = await getSourceIdFromText<String>(
          'ssq_hazard_probability',
          'ket_probability',
          'kode_probability',
          _probabilitiesController.text.toString()
      );
      await connection.query(
        'UPDATE ssq_data_sor SET '
            'sor_report_id = ?, '
            'sor_current_status = ?, '
            'sor_observe_description = ?, '
            'sor_date = ?, '
            'sor_department_id = ?, '
            'sor_location_building_id = ?, '
            'sor_location_id = ?, '
            'sor_safe_category_id = ?, '
            'sor_hazard_level = ?, '
            'sor_probabilities = ?, '
            'sor_suggestion = ?, '
            'sor_root_cause = ?, '
            'sor_immediate_corrective_action = ?, '
            'sor_evidence = ? '
            'WHERE sor_id = ?',
        [
          _reportIDController.text,
          statusData,
          _observeDescController.text,
          _dateController.text,
          departmentData,
          locationBuildingData,
          locationData,
          categoryData,
          severityData,
          probabilityData,
          _suggestionController.text,
          _rootCauseController.text,
          _immediateCorrectiveActionController.text,
          _imageController.text,
          widget.data[0], // ID of the row to update
        ],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data updated successfully')),
      );

      // Navigate back to the previous screen after successful update
      Navigator.pop(context);
    } catch (e) {
      print('Error updating data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while updating data')),
      );
    } finally {
      await connection.close();
    }
  }

  @override
  void initState() {
    super.initState();
    _reportIDController.text = widget.data[1];
    _statusController.text = widget.data[2];
    _observeDescController.text = widget.data[3];
    _dateController.text = widget.data[4];
    _departmentController.text = widget.data[5];
    _locationBuildingController.text = widget.buildingname;
    _locationController.text = widget.locationname;
    _categoryController.text = widget.safename;
    _severityController.text = widget.severityname;
    _probabilitiesController.text = widget.probabilityname;
    _suggestionController.text = widget.data[11];
    _rootCauseController.text = widget.data[12];
    _immediateCorrectiveActionController.text = widget.data[13];
    _imageController.text = widget.data[14];
    _fetchData();
    _fetchKodeLocation();
    _fetchIDDepartment();
  }

  Widget _buildImagePreview() {
    if (_imageController.text.isNotEmpty) {
      String imageUrl = 'http://10.0.2.2/upload_image_toss/image_toss/${_imageController.text}';
      return Column(
        children: [
          Image.network(
            imageUrl, // URL from the database
          ),
        ],
      );
    } else {
      return const Text('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Edit Data TOSS',
                  style: TextStyle(color: Colors.black),
                ),
              ]
          ),
        ),
        leading: null,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Stack(
                children: [
                Opacity(
                opacity: 0.15,
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
                        controller: _reportIDController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.description),
                          hintText: 'Report ID',
                          labelText: 'Report ID',
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
                      const SizedBox(height: 10,),
                      TextFormField(
                        controller: _statusController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.description),
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
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB (50, 5, 10, 15),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: InputBorder.none,
                              labelText: 'Status',
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                _statusController.text = newValue.toString();
                              });
                            },
                            items: dropdownStatusData.map<DropdownMenuItem<String>>((statusDesc) {
                              return DropdownMenuItem<String>(
                                value: statusDesc,
                                child: Text(statusDesc),
                              );
                            }).toList(),
                            dropdownSearchData: DropdownSearchData(
                              searchController: _statusController,
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
                                  controller: _statusController,
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
                                _statusController.clear();
                              }
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill this field';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10,),
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
                            _departmentController.text = newValue.toString();
                          });
                        },
                        decoration: InputDecoration(
                          isDense: true,
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
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB (50, 5, 10, 15),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: InputBorder.none,
                              labelText: 'Department',
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                _departmentController.text = newValue.toString();
                              });
                            },
                            items: zip(listIDDepartment, dropdownDepartment, (id, text) {
                              final combinedValue = '$id - $text';
                              return DropdownMenuItem<int>(
                                value: id,
                                child: Text(combinedValue),
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
                              isExpanded: true,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB (50, 5, 10, 15),
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                border: InputBorder.none,
                                labelText: 'Location Building',
                              ),
                              onChanged: (newValue) {
                                setState(() {
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
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB (50, 5, 10, 15),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: InputBorder.none,
                              labelText: 'Location',
                            ),
                            onChanged: (newValue) {
                              setState(() {
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
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB (50, 5, 10, 15),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: InputBorder.none,
                              labelText: 'Category',
                            ),
                            onChanged: (newValue) {
                              setState(() {
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
                        controller: _severityController,
                        showCursor: false,
                        readOnly: true,
                        onChanged: (newValue) {
                          setState(() {
                            _severityController.text = newValue.toString();
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
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB (50, 5, 10, 15),
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                border: InputBorder.none,
                                labelText: 'Severity '
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                _severityController.text = newValue.toString();
                              });
                            },
                            items: dropdownHazardLevelData.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            dropdownSearchData: DropdownSearchData(
                              searchController: _severityController,
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
                                  controller: _severityController,
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
                                _severityController.clear();
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
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB (50, 5, 10, 15),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: InputBorder.none,
                              labelText: 'Probabilities',
                            ),
                            onChanged: (newValue) {
                              setState(() {
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
                        onTap: (){},
                      ),
                      const SizedBox(height: 20,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue.shade900,
                            minimumSize: const Size.fromHeight(50)
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            updateDataInDatabase();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data berhasil diupdate')
                              ),
                            );
                            Navigator.pop(context);
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
    );
  }
}

List<R> zip<T, U, R>(List<T> list1, List<U> list2, R Function(T, U) combiner) {
  final length = (list1.length < list2.length) ? list1.length : list2.length;
  final List<R> result = [];
  for (int i = 0; i < length; i++) {
    result.add(combiner(list1[i], list2[i]));
  }
  return result;
}