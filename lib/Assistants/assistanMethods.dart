import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/Assistants/requestAssistant.dart';
import 'package:rider_app/DataHandler/appData.dart';
import 'package:rider_app/Models/address.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = '';
    String st1, st2, st3, st4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyDC3STsdd7grCda9xS9p_1uRJlNJRYdT2s";

    var response = await RequestAssistant.getRequest(url);

    if (response != 'Failed, to fetch location') {
      // placeAddress = response["results"][0]["formatted_address"];
      st1 = response["results"][0]["address_components"][1]['long_name'];
      st2 = response["results"][0]["address_components"][2]['long_name'];
      st3 = response["results"][0]["address_components"][4]['long_name'];
      st4 = response["results"][0]["address_components"][5]['long_name'];
      

      placeAddress = st1 + ", " +st2 +  ", " +st3 +  ", " +st4;

      Address userPickUpAddress = new Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }
}
