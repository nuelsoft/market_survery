import 'package:flutter/material.dart';
import 'package:market_survey/core/core.dart';
import 'package:market_survey/ui/saved.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Market Survey'),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.insert_drive_file),
                tooltip: "Saved Files",
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return SavedData();
                  }));
                },
              )
            ]),
        body: FormBody());
  }
}

class FormBody extends StatefulWidget {
  @override
  _FormBodyState createState() => _FormBodyState();
}

class _FormBodyState extends State<FormBody> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final lineController = TextEditingController();
  final storeController = TextEditingController();

  final productController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final fstore = Firestore.instance;

  String selectedGender = "Male";
  String selectedMarket = "Ariaria";
  String selectedOperation = "Retail";

  void _clear() {
    nameController.clear();
    lineController.clear();
    productController.clear();
    selectedGender = "Male";
    selectedMarket = "Ariaria";
    selectedOperation = "Retail";
    phoneController.clear();
    setState(() {});
  }

  Future uploadData() async {
    String now =
        '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';
    fstore.collection("Daily").document(now).setData({
      'data_collected': FieldValue.arrayUnion([
        {
          'name': nameController.text,
          'phone': phoneController.text,
          'line': lineController.text,
          'store': storeController.text,
          'products': productController.text,
          'gender': selectedGender,
          'market': selectedMarket,
          'operation': selectedOperation,
          'time': '$now ~ ${DateTime.now().hour}:${DateTime.now().minute}',
          'collector': Manager.collector,
        }
      ]),
    }, merge: true);
    fstore.collection("Collector").document(Manager.collector).setData({
      'data_collected': FieldValue.arrayUnion([
        {
          'name': nameController.text,
          'phone': phoneController.text,
          'line': lineController.text,
          'store': storeController.text,
          'products': productController.text,
          'gender': selectedGender,
          'market': selectedMarket,
          'operation': selectedOperation,
          'time': '$now ~ ${DateTime.now().hour}:${DateTime.now().minute}',
          'collector': Manager.collector,
        }
      ]),
    }, merge: true);
    fstore.collection("Market").document(selectedMarket).setData({
      'data_collected': FieldValue.arrayUnion([
        {
          'name': nameController.text,
          'phone': phoneController.text,
          'line': lineController.text,
          'store': storeController.text,
          'products': productController.text,
          'gender': selectedGender,
          'market': selectedMarket,
          'operation': selectedOperation,
          'time': '$now ~ ${DateTime.now().hour}:${DateTime.now().minute}',
          'collector': Manager.collector,
        }
      ]),
    }, merge: true);
  }

  void _validateAndSave() {
    if (_formKey.currentState.validate()) {
      uploadData().whenComplete(() {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Data added"),
            duration: Duration(milliseconds: 1500)));
        _clear();
      });
    }
  }

  Widget NuelSelectGender(String param, BuildContext context) {
    return FlatButton(
        padding: EdgeInsets.all(5),
        onPressed: () {
          selectedGender = param;
          setState(() {});
        },
        color: (selectedGender == param)
            ? Theme.of(context).accentColor
            : Colors.white,
        child: Row(
          children: <Widget>[
            Icon(Icons.check,
                size: 30,
                color: (selectedGender == param)
                    ? Colors.white
                    : Color.fromRGBO(212, 212, 212, 1)),
            Text(
              param,
              style: TextStyle(
                  fontWeight: (selectedGender == param)
                      ? FontWeight.w500
                      : FontWeight.w300,
                  color: (selectedGender == param)
                      ? Colors.white
                      : Color.fromRGBO(112, 112, 112, 1)),
            )
          ],
        ));
  }

  Widget NuelSelectOperation(String param, BuildContext context) {
    return FlatButton(
        padding: EdgeInsets.all(5),
        onPressed: () {
          selectedOperation = param;
          setState(() {});
        },
        color: (selectedOperation == param)
            ? Theme.of(context).accentColor
            : Colors.white,
        child: Row(
          children: <Widget>[
            Icon(Icons.check,
                size: 30,
                color: (selectedOperation == param)
                    ? Colors.white
                    : Color.fromRGBO(212, 212, 212, 1)),
            Text(
              param,
              style: TextStyle(
                  fontWeight: (selectedOperation == param)
                      ? FontWeight.w500
                      : FontWeight.w300,
                  color: (selectedOperation == param)
                      ? Colors.white
                      : Color.fromRGBO(112, 112, 112, 1)),
            )
          ],
        ));
  }

  Widget NuelSelectMarket(String param, BuildContext context) {
    return FlatButton(
        onPressed: () {
          selectedMarket = param;
          setState(() {});
        },
        padding: EdgeInsets.all(5),
        color: (selectedMarket == param)
            ? Theme.of(context).accentColor
            : Colors.white,
        child: Row(
          children: <Widget>[
            Icon(Icons.check,
                size: 30,
                color: (selectedMarket == param)
                    ? Colors.white
                    : Color.fromRGBO(212, 212, 212, 1)),
            Text(
              param,
              style: TextStyle(
                  fontWeight: (selectedMarket == param)
                      ? FontWeight.w500
                      : FontWeight.w300,
                  color: (selectedMarket == param)
                      ? Colors.white
                      : Color.fromRGBO(112, 112, 112, 1)),
            )
          ],
        ));
  }

  Widget validateCollector() {
    if (Manager.prefs.get('collector') == null ||
        Manager.prefs.get('collector') == '') {
      return ListView(children: [
        Form(
          child: Padding(
              padding: EdgeInsets.only(top: 70, right: 10, left: 10),
              child: TextFormField(
                controller: nameController,
                validator: (val) {
                  return (val.isEmpty) ? "your name can't be empty" : null;
                },
                // textInputAction: TextInputAction.go,
                decoration: InputDecoration(
                  labelText: "Your Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              )),
        ),
        Padding(
            padding: EdgeInsets.all(15),
            child: RaisedButton(
                onPressed: () {
                  Manager.prefs.setString('collector', nameController.text);
                  Manager.collector = Manager.prefs.getString('collector');
                  nameController.clear();
                  setState(() {});
                },
                child: Text('Save and Proceed'))),
      ]);
    } else {
      return ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 8, right: 8),
        children: <Widget>[
          Text(
            "Please fill out the form. All Fields are compulsory",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          ),
          Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: TextFormField(
                        controller: nameController,
                        validator: (val) {
                          return (val.isEmpty) ? "name can't be empty" : null;
                        },
                        // textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: phoneController,
                        validator: (val) {
                          return (val.isEmpty)
                              ? "phone can't be empty"
                              : (val.length != 11 && val.length != 13)
                                  ? "phone number is incorrect"
                                  : null;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Phone (WhatsApp)",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      )),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "Gender",
                            style: TextStyle(fontSize: 20),
                          ))),
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          NuelSelectGender("Male", context),
                          NuelSelectGender("Female", context)
                        ],
                      )),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "Market",
                            style: TextStyle(fontSize: 20),
                          ))),
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Card(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          NuelSelectMarket("Ariaria", context),
                          NuelSelectMarket("Shopping Center", context),
                          NuelSelectMarket("Ahia Ohuru", context),
                          NuelSelectMarket("Cemetry", context),
                          NuelSelectMarket("Ala Oji", context),
                        ],
                      ))),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "Operation",
                            style: TextStyle(fontSize: 20),
                          ))),
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Card(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          NuelSelectOperation("Retail", context),
                          NuelSelectOperation("Wholesale", context),
                          NuelSelectOperation("Manufacturer", context)
                        ],
                      ))),
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: lineController,
                        validator: (val) {
                          return (val.isEmpty) ? "line can't be empty" : null;
                        },
                        decoration: InputDecoration(
                          labelText: "Line Number",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: storeController,
                        validator: (val) {
                          return (val.isEmpty)
                              ? "store number can't be empty"
                              : null;
                        },
                        decoration: InputDecoration(
                          labelText: "Store Number",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: productController,
                        validator: (val) {
                          return (val.isEmpty)
                              ? "products can't be empty"
                              : null;
                        },
                        maxLines: 4,
                        minLines: 2,
                        decoration: InputDecoration(
                          labelText: "Product(s)",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      )),
                ],
              )),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                    padding: EdgeInsets.all(15),
                    onPressed: _clear,
                    child: Text("Clear"),
                    color: Color.fromRGBO(212, 212, 212, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(0)),
                    )),
                RaisedButton(
                    padding: EdgeInsets.all(15),
                    onPressed: _validateAndSave,
                    child: Text("Save Entry > ",
                        style: TextStyle(color: Colors.white)),
                    color: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(10)),
                    ))
              ],
            ),
          ),
          Center(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Rad5 Tech Hub Aba",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w700),
                  )))
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (ctx, snapshot) {
      return validateCollector();
    });
  }
}
