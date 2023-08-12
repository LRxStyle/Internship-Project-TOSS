import 'dart:io';
import 'package:demo_input_toss/TableToss.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';

class EditDataPage extends StatefulWidget {
  final List<String> data;
  String departmentname;
  String buildingname;
  String locationname;
  String safename;
  String severityname;
  String probabilityname;

  EditDataPage({required this.data,
    required this.departmentname,
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
  TextEditingController _reportIDController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  TextEditingController _observeDescController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _departmentController = TextEditingController();
  TextEditingController _locationBuildingController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _categoryController =TextEditingController();
  TextEditingController _severityyController =TextEditingController();
  TextEditingController _probabilitiesController =TextEditingController();
  TextEditingController _suggestionController = TextEditingController();
  TextEditingController _rootCauseController = TextEditingController();
  TextEditingController _immediateCorrectiveActionController = TextEditingController();
  TextEditingController _imageController = TextEditingController();

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
    _severityyController.text = widget.severityname;
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
      String imageUrl = 'http://10.0.2.2/upload_image_toss/image_toss/' + _imageController.text;
      return Column(
        children: [
          Image.network(
            imageUrl, // URL from the database
          ),
        ],
      );
    } else {
      return Text('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: IconButton(
        onPressed: (){
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TableToss()));
        },
        icon: Icon(Icons.home),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Center(
          child: Row(
              children:[
                Image(
                  image : AssetImage('assets/logo.jpg'),
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
          padding: EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: _reportIDController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    hintText: 'Report ID',
                    labelText: 'Report ID',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
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
                SizedBox(height: 10,),
                TextFormField(
                  controller: _statusController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    hintText: 'Status',
                    labelText: 'Status',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
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
                SizedBox(height: 10,),
                TextFormField(
                  controller: _observeDescController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    hintText: 'Observe Description(Observasi Deskripsi)',
                    labelText: 'Observe Description',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
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
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _dateController,
                  showCursor: false,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.calendar_month),
                    hintText: 'Date',
                    labelText: 'Date',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
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
                SizedBox(
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
                    prefixIcon: Icon(Icons.location_city),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
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
                      decoration: InputDecoration(
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
                SizedBox(
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
                    prefixIcon: Icon(Icons.streetview_outlined),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
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
                        decoration: InputDecoration(
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
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _locationController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.map_outlined),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
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
                      decoration: InputDecoration(
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
                SizedBox(
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
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
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
                      decoration: InputDecoration(
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
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _severityyController,
                  showCursor: false,
                  readOnly: true,
                  onChanged: (newValue) {
                    setState(() {
                      _severityyController.text = newValue.toString();
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.warning_amber),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
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
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB (50, 5, 10, 15),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: InputBorder.none,
                          labelText: 'Severity '
                      ),
                      onChanged: (newValue) {
                        setState(() {
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
                SizedBox(
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
                    prefixIcon: Icon(Icons.percent),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
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
                      decoration: InputDecoration(
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
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _suggestionController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.message_outlined),
                    hintText: 'Suggestion',
                    labelText: 'Suggestion',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
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
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _rootCauseController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.question_mark_outlined),
                    hintText: 'Root Cause',
                    labelText: 'Root Cause (Penyebab Utama)',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
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
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _immediateCorrectiveActionController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.construction_outlined),
                    hintText: 'Immediate Corrective Action',
                    labelText: 'Immediate Corrective Action (Rencana Perbaikan Segera)',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      borderRadius : const BorderRadius.all(Radius.circular(30.0)),
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
                SizedBox(
                  height: 20,
                ),
                _buildImagePreview(),
                SizedBox(
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
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                        borderRadius : const BorderRadius.all(Radius.circular(30.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                        borderRadius : const BorderRadius.all(Radius.circular(30.0)),
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
                      prefixIcon: Icon(Icons.image_search),
                      hintText: 'Upload Bukti',
                      labelText: 'Upload Evidence'),
                  onTap: (){},
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue.shade900,
                      minimumSize: Size.fromHeight(50)
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Data berhasil diinput')
                      ),
                      );
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => TableToss()));
                    } else {
                      // The form has some validation errors.
                      // Do Something...
                    };
                  },
                  child: Text('Submit',
                    style: TextStyle(color: Colors.white,
                    ),
                  ),
                ),
              ],
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