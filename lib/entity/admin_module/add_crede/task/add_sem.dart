import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class add_sem extends StatefulWidget {
  const add_sem({super.key});

  @override
  State<add_sem> createState() => _add_semState();
}

class _add_semState extends State<add_sem> {
  final samname = TextEditingController(); //for subject text
  final _formKey4 = GlobalKey<FormState>();
  var yearsam;
  var coursesam;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        backgroundColor: Colors.deepPurple,
        title: Text('Add Course and Division'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey4,
              child: Column(
                children: [
                  SizedBox(
                    height: 23,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Course",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 23,
                  ),
                  Container(
                      width: 300,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('A_Course')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          return DropdownButtonFormField<String>(
                            value: coursesam,
                            items: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              return DropdownMenuItem<String>(
                                value: document.get('course_name'),
                                child: Text(document.get('course_name')),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                coursesam = value;
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.book),
                              hintText: 'Select Course',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              filled: true,
                            ),
                          );
                        },
                      )),
                  SizedBox(
                    height: 23,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Year",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 23,
                  ),
                  Container(
                    width: 300,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('A_Year')
                          //.where('year', isEqualTo: )
                          .where('course', isEqualTo: coursesam)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        final itemList = snapshot.data!.docs
                            .map((doc) => doc['year'] as String)
                            .toList();

                        itemList.sort();

                        return DropdownButtonFormField<String>(
                          value: yearsam,
                          onChanged: (value) {
                            setState(() {
                              yearsam = value;
                            });
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.book),
                            hintText: 'Select Year',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            filled: true,
                          ),
                          items: itemList
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  ))
                              .toList(),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 23,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Add Semester ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 23,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      controller: samname,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        icon: Icon(
                          Icons.book,
                          color: Colors.purple[800],
                        ),
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 8.0),
                        hintText: 'Enter Semester',
                        hintStyle: TextStyle(color: Colors.grey),
                        //labelText: 'Add Div',
                        labelStyle: TextStyle(color: Colors.purple[800]),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (value) => samname.text = value!,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('Submit'),
                    onPressed: () {
                      if (_formKey4.currentState!.validate()) {
                        final snackBar = SnackBar(
                          content: const Text(
                              'Your data has been sent to the database'),
                        );
                        _formKey4.currentState!.save();
                        FirebaseFirestore.instance
                            .collection("A_Sem")
                            .doc()
                            .set({
                              'course': coursesam,
                              'year': yearsam,
                              'sem': samname.text,
                            })
                            .then((value) => print('Data added to Firestore'))
                            .catchError((error) => print(
                                'Error adding data to Firestore: $error'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
