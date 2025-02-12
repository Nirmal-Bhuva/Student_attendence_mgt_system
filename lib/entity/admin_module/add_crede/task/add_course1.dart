import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class add_course1 extends StatefulWidget {
  const add_course1({super.key});

  @override
  State<add_course1> createState() => _add_course1State();
}

class _add_course1State extends State<add_course1> {
  final _formKey = GlobalKey<FormState>();
  final coursename = TextEditingController(); //for course text

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
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 23,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Add Course",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 23,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                      child: TextFormField(
                        controller: coursename,
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
                            Icons.account_circle,
                            color: Colors.purple[800],
                          ),
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          hintText: 'Add Course',
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: 'Enter Course Name',
                          labelStyle: TextStyle(color: Colors.purple[800]),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (value) => coursename.text = value!,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text('Submit'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final snackBar = SnackBar(
                            content: const Text(
                                'Your data has been sent to the database'),
                          );
                          _formKey.currentState!.save();
                          FirebaseFirestore.instance
                              .collection("A_Course")
                              .doc(coursename.text)
                              .set({'course_name': coursename.text})
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
                )),
          ],
        ),
      ),
    );
  }
}
