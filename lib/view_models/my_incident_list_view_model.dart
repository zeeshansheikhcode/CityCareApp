
// import 'package:city_care/models/incident.dart';
// import 'package:city_care/view_models/incident_list_view_model.dart';
import 'package:city_care_app/models/incident.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'incident_list_view_model.dart';

class MyIncidentListViewModel {

  Future<List<IncidentViewModel>> getMyIncidents() async {
    List<IncidentViewModel> errorchecking = [];
    final userId = FirebaseAuth.instance.currentUser!.uid; 
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("incidents")
      .where("userId", isEqualTo: userId)
      //.orderBy("incidentDate", descending: true)
      .get(); 
      if(snapshot.docs == null)
      {
        return errorchecking;
      }
    final incidents = snapshot.docs.map((doc) => Incident.fromDocument(doc)).toList();
    return  incidents.map((incident) => IncidentViewModel(incident: incident)).toList();

  }

}