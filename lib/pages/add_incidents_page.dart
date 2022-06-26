import 'dart:io';
import 'package:city_care_app/view_models/add_incident_view_model.dart';
import 'package:city_care_app/view_models/incident_view_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

enum PhotoOptions { camera, library }

class AddIncidentsPage extends StatefulWidget {
  @override
  _AddIncidentsPage createState() => _AddIncidentsPage();
}

class _AddIncidentsPage extends State<AddIncidentsPage> {
  
  File? _image;
  final _formKey = GlobalKey<FormState>();
  AddIncidentViewModel? _addIncidentVM; 

  final _titleController = TextEditingController(); 
  final _descriptionController = TextEditingController();
    
@override
void initState() {
  super.initState();
//  image_picker = ImagePicker();
}
  void _selectPhotoFromPhotoLibrary() async {
    final imagePicker = ImagePicker(); 
     XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
      _pickedimage = File(pickedFile.path);
    });

  }
  File? _pickedimage;
  void _selectPhotoFromCamera() async {
    final imagePicker = ImagePicker(); 
      XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile!.path);
      _pickedimage = File(pickedFile.path);
    });

  }

  void _optionSelected(PhotoOptions option) {
    switch (option) {
      case PhotoOptions.camera:
        _selectPhotoFromCamera();
        break;
      case PhotoOptions.library:
        _selectPhotoFromPhotoLibrary();
        break;
    }
  }

  void _saveIncident(BuildContext context) async {

    final userId = FirebaseAuth.instance.currentUser!.uid; 
    if (_formKey.currentState!.validate()) {
      
      final filePath = await _addIncidentVM!.uploadFile(_image!);
      if(filePath.isNotEmpty) {
       
        final title = _titleController.text; 
        final description = _descriptionController.text; 
        final incidentVS = IncidentViewState(userId: userId, title: title, description: description, photoURL: filePath, incidentDate: DateTime.now()); 
        final isSaved = await _addIncidentVM!.saveIncident(incidentVS);       
        if(isSaved) {
          Navigator.pop(context, true); 
        }
      }
    }

  }

  Widget _buildLoadingWidget() {
    return const Text("Loading...");
  }

  @override
  Widget build(BuildContext context) {
    _addIncidentVM = Provider.of<AddIncidentViewModel>(context); 
    return Scaffold(
        appBar: AppBar(
          title:const Text("Add Incident"), 
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(children: [
                  SizedBox(
                    child: _image == null 
                    ?
                    const Icon(Icons.picture_in_picture) 
                    : 
                     Image.file(_pickedimage!),
                    
                    width: 300, 
                    height: 300
                  ),
                 Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child:  FlatButton(
                      color: Colors.blue,
                      onPressed: () {},
                      textColor: Colors.white,
                      child: PopupMenuButton<PhotoOptions>(
                        child:const Text("Add Photo"),
                        onSelected: _optionSelected,
                        itemBuilder: (context) =>const [
                          PopupMenuItem(
                            child: Text("Take a picture"),
                            value: PhotoOptions.camera,
                          ),
                          PopupMenuItem(
                              child: Text("Select from photo library"),
                              value: PhotoOptions.library)
                        ],
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _titleController, 
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Title is required!";
                      }
                      return null;
                    },
                    decoration:
                       const InputDecoration(hintText: "Enter incident title"),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Description is required!";
                      }
                      return null;
                    },
                    maxLines: null,
                    decoration:
                       const InputDecoration(hintText: "Enter incident description"),
                  ),
                  FlatButton(
                    child:const Text("Submit"),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _saveIncident(context);
                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                  ), 
                 const Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: Text("Message"),
                  ), 
                  _buildLoadingWidget() 
                 ]
                ),
              ),
            ),
          ),
        )
      );
   }
}
