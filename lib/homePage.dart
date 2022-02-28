import 'package:flutter/material.dart';
import 'package:satsang_attendance/scan.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dropdownvalue = 'Regular Branch Satsang';
  // List of items in our dropdown menu
  var items = [
    'Regular Branch Satsang',
    'Special Events',
    'Aarti',
    'Bhandara',
    'Basant',
    'Holi',
    'Others'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "Baroda Branch Satsang Attendance",
                      style: TextStyle(fontSize: 20),
                      
                  ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Image(image: NetworkImage("https://drsae.org/wp-content/uploads/2021/07/cropped-RSLOGO_Yellow-300x225.png")),
            SizedBox(height: 20.0,),
            Image(image: AssetImage('graphics/rs_logo.png'), height: 200, width: 200),
            SizedBox(height: 60.0,),
            DropdownButton(
              // Initial Value
              value: dropdownvalue,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                });
              },
            ),
            SizedBox(height: 70.0,),
            flatButton("    Scan QR CODE    ", ScanPage(dropDownValue: dropdownvalue)),
            // SizedBox(height: 30.0,),
            // flatButton("Generate QR CODE", GeneratePage()),
          ],
        ),
      ),
    );
  }

  Widget flatButton(String text, Widget widget) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => widget));
        },
        child: Text(
          text,
          style: TextStyle(color: Color.fromARGB(255, 254, 255, 255),fontWeight: FontWeight.bold),
        ),
        // shape: RoundedRectangleBorder(
        //     side: BorderSide(color: Colors.blue,width: 3.0),
        //     borderRadius: BorderRadius.circular(20.0)),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            Color.fromRGBO(73, 131, 255, 1),
          ),
          elevation: MaterialStateProperty.all(0.0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}
