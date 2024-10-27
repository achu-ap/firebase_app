import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/screens/authenticate/authenticate.dart';
import 'package:firebase_app/screens/authenticate/signin.dart';
import 'package:firebase_app/screens/authenticate/signup.dart';
import 'package:firebase_app/screens/authenticate/user.dart';
import 'package:firebase_app/utils/firestore.dart';
import 'package:firebase_app/utils/models/todomodel.dart';
import 'package:firebase_app/utils/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _authService = AuthService();
  final _firestoreServices = FirestoreServices();
  final _todoTitleController = TextEditingController();
  final _desController = TextEditingController();

  @override
  void dispose() {
    _todoTitleController.dispose();
    super.dispose();
  }

  void _showEditDialog(DocumentSnapshot doc,User user) {
    final _editTitleController = TextEditingController(text: doc['title']);
    final _editDesController = TextEditingController(text: doc['des']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editTitleController,
                decoration: InputDecoration(
                  labelText: "Title",
                ),
              ),
              TextField(
                controller: _editDesController,
                decoration: InputDecoration(
                  labelText: "Description",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await _firestoreServices.update(
                  doc.id,
                  TodoModel(
                    Userid: user.uid,
                    title: _editTitleController.text,
                    des: _editDesController.text,
                    time: DateTime.now().toString(),
                  ),
                );
                Navigator.pop(context); 
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    user?.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        leading: user != null
            ? Container(
                margin: EdgeInsets.all(5),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: GestureDetector(
                  onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Userdetails( isUser: true,)));
                  },
                  child: Image.network(user.photoURL!),
                )
              )
            : SizedBox(),
        title: Text(user?.displayName ?? "Home"),
        actions: [
          IconButton(
              onPressed: () async {
                await _authService.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Authenticate()));
              },
              icon: Icon(Icons.person))
        ],
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Column(children: [
                  Padding(padding: EdgeInsets.all(10),
                  child: TextField(
                  controller: _todoTitleController,
                  decoration: InputDecoration(
                    hintText: "Enter todo title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),),
                Padding(padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _desController,
                  decoration: InputDecoration(
                    hintText: "Enter todo des",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),)
                
                ],)
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_todoTitleController.text.isNotEmpty) {
                    await _firestoreServices.write(TodoModel(
                     Userid: user!.uid,
                      title: _todoTitleController.text,
                      des: _desController.text, 
                      time: DateTime.now().toString(),
                    ));
                    _todoTitleController.text = ""; 
                    _desController.text="";
                  } 
                },
                child: Text("Add"),
              ),
            ],
          ),),
          Expanded(
              child: StreamBuilder(
                  stream: _firestoreServices.read(user!.uid),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final data = snapshot.data!;
                    return ListView.builder(
                      itemCount: data.docs.length,
                      itemBuilder: (context, index) {
                        final doc = data.docs[index];
                        return ListTile(
                          title: Text(doc["title"]),
                          subtitle: Text(doc["des"]),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _showEditDialog(doc,user);
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await _firestoreServices.delete(
                                      doc.id,
                                    );
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  })),
        ],
      ),
    );
  }
}
