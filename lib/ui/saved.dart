import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:market_survey/core/core.dart';

class SavedData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Collected'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('Collector')
            .document(Manager.collector)
            .snapshots(),
        builder: (inCtx, snapshot) {
          // print(snapshot.data);
          while (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasError ||
              snapshot.data == null ||
              !snapshot.hasData) {
            print("snapsht: => " + snapshot.data.toString());

            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (xt, i) {
                return Padding(
                    padding: EdgeInsets.all(25),
                    child: Divider(
                      thickness: 1.5,
                    ));
              },
            );
          }
          print("snapsht: => " + snapshot.data.toString());
          try {
            return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data['data_collected'].length,
                itemBuilder: (ctx, index) {
                  return DataEntry(
                    name: snapshot.data['data_collected'][index]['name'],
                    collector: Manager.collector,
                    gender: snapshot.data['data_collected'][index]['gender'],
                    line: snapshot.data['data_collected'][index]['line'],
                    market: snapshot.data['data_collected'][index]['market'],
                    operation: snapshot.data['data_collected'][index]
                        ['operation'],
                    store: snapshot.data['data_collected'][index]['store'],
                    phone: snapshot.data['data_collected'][index]['phone'],
                    products: snapshot.data['data_collected'][index]
                        ['products'],
                    time: snapshot.data['data_collected'][index]['time'],
                  );
                });
          } catch (e) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (xt, i) {
                return Padding(
                    padding: EdgeInsets.all(25),
                    child: Divider(
                      thickness: 1.5,
                    ));
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class DataEntry extends StatelessWidget {
  final String name;
  final String phone;
  final String market;
  final String gender;
  final String line;
  final String store;
  final String operation;
  final String products;
  final String collector;
  final String time;

  DataEntry(
      {this.name,
      this.phone,
      this.market,
      this.gender,
      this.line,
      this.store,
      this.operation,
      this.products,
      this.collector,
      this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "$name",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("$phone", style: TextStyle(fontSize: 17)),
                Text("$gender",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  children: <Widget>[
                    Text("Market: ", style: TextStyle(color: Colors.grey)),
                    Text("$market", style: TextStyle(fontSize: 17))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("Line: ", style: TextStyle(color: Colors.grey)),
                    Text("$line", style: TextStyle(fontSize: 17))
                  ],
                )
              ]),
              Row(
                children: <Widget>[
                  Text("Operation: ", style: TextStyle(color: Colors.grey)),
                  Text("$operation", style: TextStyle(fontSize: 17))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text("Products: ", style: TextStyle(color: Colors.grey)),
                Row(children: <Widget>[
                  Text('store: ',
                      style: TextStyle(
                        color: Colors.grey,
                      )),
                  Text(
                    "$store",
                    style: TextStyle(fontSize: 17),
                  )
                ]),
              ]),
              Container(
                  child: Text(
                "$products",
                style: TextStyle(fontSize: 17),
                maxLines: 5,
              )),
              Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text("Collected by $collector at $time",
                      style: TextStyle(color: Theme.of(context).accentColor)))
            ],
          ))),
    );
  }
}
