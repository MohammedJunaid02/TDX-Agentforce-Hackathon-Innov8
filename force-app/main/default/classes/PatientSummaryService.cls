public with sharing class PatientSummaryService {

    // This method will be invocable in a Flow, receiving a list of Patient IDs
    @InvocableMethod(label='Get Patient Summary' description='Fetches summary for given Patient IDs')
    public static List<PatientSummaryResponse> getPatientSummary(List<PatientSummaryRequest> requestList) {
        List<PatientSummaryResponse> responseList = new List<PatientSummaryResponse>();

        // Iterate over the list of request objects (can handle multiple requests at once)
        for (PatientSummaryRequest request : requestList) {
            // Fetch the patient record based on the provided Patient ID
            Patient__c patient = [SELECT Name, Age__c, AI_Value__c, Final_Predicted_Risk_Label__c, Oxygen_Saturation__c
                                  FROM Patient__c
                                  WHERE Patient_ID__c = :request.patientId
                                  LIMIT 1];

            // Create response object and set the summary
            PatientSummaryResponse response = new PatientSummaryResponse();

            if (patient != null) {
                // Construct a summary string
                response.patientSummary = 'Patient Name: ' + patient.Name + '\n' +
                                          'Age: ' + patient.Age__c + '\n' +
                                          'AI Value (Risk Score): ' + patient.AI_Value__c + '\n' +
                                          'Diagnosis: ' + patient.Final_Predicted_Risk_Label__c + '\n' +
                                          'Oxygen Saturation: ' + patient.Oxygen_Saturation__c;
            } else {
                response.patientSummary = 'Patient record not found for ID: ' + request.patientId;
            }

            responseList.add(response);
        }

        return responseList;
    }

    // Request object for Flow input (Patient ID)
    public class PatientSummaryRequest {
        @InvocableVariable(label='Patient ID' description='The ID of the Patient whose summary we are fetching')
        public String patientId;
    }

    // Response object to return from the Flow (Patient Summary)
    public class PatientSummaryResponse {
        @InvocableVariable(label='Patient Summary' description='The summary of the Patient')
        public String patientSummary;
    }
}