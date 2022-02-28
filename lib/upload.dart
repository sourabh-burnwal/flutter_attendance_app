import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:satsang_attendance/homePage.dart';
import 'package:satsang_attendance/scan.dart';

/// Your google auth credentials
class UploadToGoogleSheet{
  static const _credentials = r'''
      <your google auth credentials>
    ''';

  /// Your spreadsheet id
  static const _spreadsheetId = '<your spreadsheet id>';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  Future init() async {
    final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = spreadsheet.worksheetByTitle('<your sheet name>');
    // _worksheet = await _getWorkSheet(spreadsheet, title: 'test');
  }

  static Future<Worksheet> _getWorkSheet(
      Spreadsheet spreadsheet, {
        required String title,
      }) async {
          try {
              return await spreadsheet.addWorksheet(title);
          } catch (e) {
              return spreadsheet.worksheetByTitle(title)!;
          }
      }

  // insert a new transaction
  static Future insert(String data, String dropDownValue) async {
    List<String> listOfData = data.split('_');
    if(listOfData.length >= 3) {
      String uid = listOfData[0];
      String name = listOfData[1];
      String category = listOfData[2];
      String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String time = DateFormat('hh:mm a').format(DateTime.now());
      String satsangType = dropDownValue;

      if (_worksheet == null) {
        // print('Connection Failed');
        return;
      }
      // print('Data pushed');
      await _worksheet!.values.appendRow([
        uid,
        name,
        category,
        date,
        time,
        satsangType,
      ]);
    }
  }
}
