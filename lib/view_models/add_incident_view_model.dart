import 'dart:io';
import 'package:city_care_app/models/incident.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'incident_view_state.dart';

class AddIncidentViewModel extends ChangeNotifier {

  String message = ""; 

  Future<bool> saveIncident(IncidentViewState incidentVS) async {
    print('saving here');
    bool isSaved = false; 
    final incident = Incident.fromIncidentViewState(incidentVS);
    try {
      print('saving here 1');
      FirebaseFirestore.instance.collection("incidents")
      .add(incident.toMap());
      isSaved = true; 
      print('saving here 2');
    } catch(e) {
      print('saving here 3');
      message = "Unable to save incident"; 
    }
   print('saving here 4');
    notifyListeners(); 
    print('saving here 5');
    return isSaved; 
  }

  Future<String> uploadFile(File file) async {
    
    String downloadURL=""; 
    const uuid =  Uuid();
    final filePath = "/images/${uuid.v4()}.jpg"; 
    final storage = FirebaseStorage.instance.ref(filePath); 
    final uploadTask = await storage.putFile(file); 
    if(uploadTask.state == TaskState.success) {
      downloadURL = await FirebaseStorage.instance.ref(filePath).getDownloadURL(); 
    }
    return downloadURL; 
  }

}