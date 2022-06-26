
class IncidentViewState {

  final String userId; 
  final String title; 
  final String description; 
  final String photoURL; 
  final DateTime incidentDate;

  IncidentViewState({
    required this.userId,
    required this.title,
    required this.description,
    required this.photoURL,
    required this.incidentDate}); 

}