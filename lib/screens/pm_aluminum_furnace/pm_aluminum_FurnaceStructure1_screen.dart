import 'dart:convert';
import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/report_model.dart';
import 'package:engineer/models/sintering_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/screens/2_coil/coilcementshowdata_screen.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/services/form_all_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:engineer/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FurnaceStructure1 extends StatefulWidget {
  const FurnaceStructure1({super.key});

  @override
  State<FurnaceStructure1> createState() => _FurnaceStructure1State();
}

class _FurnaceStructure1State extends State<FurnaceStructure1> {
  UserModel user = UserModel();
  AuthenticateApi authenticateApi = AuthenticateApi();
  final ApiService _apiService = ApiService();
  late Future<List<ListItem>> _sinteringItems;
  List<TextEditingController> _groupControllers = [];
  List<bool> _isFieldEmpty = [];
  String? _selectedGroupName;
  int _currentPageStep = 1;
  List<List<XFile?>> thermoImages = [];
  List<List<XFile?>> normalImages = [];
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    getUser();

    _sinteringItems = _apiService.fetchListItem('15');

    _sinteringItems.then((items) {
      setState(() {
        final groupNames = items.map((item) => item.groupName).toSet().toList();
        print('Total group names: ${groupNames.length}');
        _groupControllers =
            List.generate(groupNames.length, (_) => TextEditingController());
        _isFieldEmpty = List.generate(groupNames.length, (_) => false);
        _focusNodes
            .addAll(List.generate(groupNames.length, (_) => FocusNode()));

        print('Total controllers: ${_groupControllers.length}');
        print('Total focus nodes: ${_focusNodes.length}');

        thermoImages = List.generate(items.length, (_) => []);
        normalImages = List.generate(items.length, (_) => []);

        if (items.isNotEmpty) {
          _selectedGroupName = items.first.groupName;
        }

        // Debugging specific pages
        print('Items: ${items.length}');
        for (var item in items) {
          print(
              'Item PageStep: ${item.pageStep}, GroupName: ${item.groupName}');
        }

        if (_currentPageStep == 9 || _currentPageStep == 10) {
          print('Page $_currentPageStep has ${groupNames.length} groups');
        }
      });

      // Attach listeners to each focus node
      for (int i = 0; i < _focusNodes.length; i++) {
        _focusNodes[i].addListener(() {
          if (_focusNodes[i].hasFocus) {
            void _scrollToField(int index) {}
          }
        });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _groupControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage(
      ImageSource source, bool isThermo, int itemIndex, int imgIndex) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          if (isThermo) {
            if (thermoImages[itemIndex].length < 3) {
              thermoImages[itemIndex].add(image);
            }
          } else {
            if (normalImages[itemIndex].length < 3) {
              normalImages[itemIndex].add(image);
            }
          }
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void _navigateToPageStep(int step) {
    setState(() {
      _currentPageStep = step;
    });
  }

  Future<void> getUser() async {
    user = await authenticateApi.getUser();
    setState(() {});
  }

  int _getGroupNumber(List<ListItem> items, String groupName, int index) {
    int count = 1;

    // Iterate over the items up to the current index within the current page step
    for (int i = 0; i < index; i++) {
      if (items[i].groupName == groupName &&
          items[i].pageStep == _currentPageStep) {
        count++;
      }
    }
    return count;
  }

  Widget _buildGroupTextField(List<ListItem> items, Color iconColor) {
    int groupIndex = items.first.pageStep - 1;
    print(
        'Building TextField for Page: $_currentPageStep, Group Index: $groupIndex');

    // Check that the groupIndex is within the bounds of the controllers
    if (groupIndex < 0 || groupIndex >= _groupControllers.length) {
      print('Invalid groupIndex $groupIndex for page $_currentPageStep');
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _groupControllers[groupIndex],
        focusNode: _focusNodes[groupIndex],
        style: TextStyle(color: iconColor), // Set the color of the typed text
        minLines: 1, // Start with a single line
        maxLines: null, // Allow the field to expand vertically as needed
        decoration: InputDecoration(
          hintText: 'Enter value for',
          hintStyle: TextStyle(color: iconColor), // Set the hint text color
          errorText:
              _isFieldEmpty[groupIndex] ? 'This field is required' : null,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: iconColor), // Set the border color
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: iconColor), // Set the enabled border color
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: iconColor), // Set the focused border color
          ),
        ),
      ),
    );
  }

  bool _validateFields() {
    bool allValid = true;

    for (int index = 0; index < _groupControllers.length; index++) {
      if (_groupControllers[index].text.isEmpty) {
        setState(() {
          _isFieldEmpty[index] = true;
        });
        allValid = false;
      } else {
        setState(() {
          _isFieldEmpty[index] = false;
        });
      }
    }

    if (!allValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields.'),
        ),
      );
    }

    return allValid;
  }

  Future<void> _postData(List<ListItem> items, String repairId,
      {String? username}) async {
    Map<String, dynamic> jsonData = {
      "RepairID": repairId,
      "CheckID": 0,
      "FromID": 15,
      "DateTime": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      "StratTime": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      "EndTime": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      "EngineerBy": username ?? 'Unknown',
      "CusCompanyName": username ?? 'Unknown',
      "TypeDetail": "Coil Cement",
      "FurnaceNo": 2,
      "HFT": "2 T",
      "Note": "ทดสอบ App",
      "Details": List.generate(_groupControllers.length, (index) {
        TextEditingController textController = _groupControllers[index];

        // แปลงรูปภาพเป็น Base64 string
        List<String> base64ThermoImages = thermoImages[index]
            .map((image) => base64Encode(File(image!.path).readAsBytesSync()))
            .toList();

        List<String> base64NormalImages = normalImages[index]
            .map((image) => base64Encode(File(image!.path).readAsBytesSync()))
            .toList();

        // รวมรูปภาพทั้งหมดเป็น string เดียว
        String valuedetail =
            base64ThermoImages.join(',') + ';' + base64NormalImages.join(',');

        return {
          "CheckID": 0,
          "GroupID": index + 1,
          "TypeNo": 1,
          "ValueBit": 1,
          "Value": textController.text,
          "valuedetail": valuedetail,
        };
      })
    };

    try {
      final response = await http.post(
        Uri.parse(AppConstantPost.urlAPIPostDataByFormID),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data saved successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to save data: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ReportModel r = ModalRoute.of(context)!.settings.arguments as ReportModel;

    return Scaffold(
      backgroundColor: primarytitle,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                ComponentHeader(user: user, isHome: false),
                //_buildHeader(r),
                FutureBuilder<List<ListItem>>(
                  future: _sinteringItems,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No items found');
                    } else {
                      Map<int, List<ListItem>> groupedItems = {};
                      for (var item in snapshot.data!) {
                        groupedItems
                            .putIfAbsent(item.pageStep, () => [])
                            .add(item);
                      }

                      return Column(
                        children: [
                          _buildGroupNameHeader(
                              groupedItems[_currentPageStep]!),
                          ...groupedItems[_currentPageStep]!.map((item) {
                            return _buildCard(item,
                                snapshot.data!.indexOf(item), snapshot.data!);
                          }).toList(),
                          _buildGroupTextField(
                              groupedItems[_currentPageStep]!, icons),
                          _buildPaginationControls(groupedItems),
                        ],
                      );
                    }
                  },
                ),
                //const SizedBox(height: 15),
                _buildNextButton(r),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupNameHeader(List<ListItem> items) {
    String groupName = items.first.groupName;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        groupName,
        style: TextStyle(
          fontSize: 18,
          color: icons,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  //

  Widget _buildPaginationControls(Map<int, List<ListItem>> groupedItems) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: icons,
          ),
          onPressed: _currentPageStep > 1
              ? () => _navigateToPageStep(_currentPageStep - 1)
              : null,
        ),
        Text(
          'Page $_currentPageStep of ${groupedItems.length}',
          style: TextStyle(color: icons, fontSize: 16),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_forward,
            color: icons,
          ),
          onPressed: _currentPageStep < groupedItems.length
              ? () => _navigateToPageStep(_currentPageStep + 1)
              : null,
        ),
      ],
    );
  }

  Widget _buildHeader(ReportModel r) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: background,
          boxShadow: [
            BoxShadow(
              blurRadius: 0,
              color: divider,
              offset: Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Surface temperature measurement.',
                      style: TextStyle(
                        letterSpacing: 0,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (r.repairid != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => coilcementshowdata(
                              repairID: r.repairid!,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Repair ID is missing')),
                        );
                      }
                    },
                    child: const Text('Go to Coil Cement'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Date: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(ListItem item, int index, List<ListItem> items) {
    int groupIndex = _getGroupNumber(items, item.groupName, index);
    print(
        'Page: $_currentPageStep, Item Index: $index, Group Index: $groupIndex');

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 5, 16, 8),
      child: Card(
        color: secondaryText,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 5, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Item $index - ${item.typeName}',
                style: const TextStyle(
                  fontSize: 16,
                  color: icons,
                  //fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Render images or image placeholders
              if (groupIndex == 1)
                _buildImageContainer(
                  index,
                  thermoImages,
                  true,
                )
              else if (groupIndex == 2)
                _buildImageContainer(
                  index,
                  normalImages,
                  false,
                ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer(
      int index, List<List<XFile?>> imageLists, bool isThermo) {
    List<XFile?> images = imageLists[index];
    return Container(
      height: 150,
      width: double.infinity,
      color: Colors.grey[300],
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length + (images.length < 3 ? 1 : 0),
              itemBuilder: (context, imgIndex) {
                if (imgIndex == images.length) {
                  return GestureDetector(
                    onTap: () => _pickImage(
                        ImageSource.camera, isThermo, index, imgIndex),
                    child: Container(
                      width: 100,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      color: Colors.grey[400],
                      child: Center(child: Text('Add Image')),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () => _showImageDialog(images[imgIndex]!),
                    child: Container(
                      width: 100,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(File(images[imgIndex]!.path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDialog(XFile image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(image.path)),
                fit: BoxFit.contain,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 10,
                  top: 10,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNextButton(ReportModel r) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
      child: ElevatedButton(
        onPressed: () async {
          if (_validateFields()) {
            List<ListItem> items = await _sinteringItems;
            _postData(items, r.repairid ?? 'Unknown', username: user.username);
          }
        },
        child: const Text('Save'),
      ),
    );
  }
}
