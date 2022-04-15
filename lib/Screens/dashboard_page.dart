import 'package:electrum_task/Modal/api_userModal.dart';
import 'package:electrum_task/Repository/user_repo.dart';
import 'package:electrum_task/utils/sidemenu_widget.dart';
import 'package:electrum_task/utils/validate_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/gentextfield.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  UserRepository userRepository = UserRepository();
  final _conEmail = TextEditingController();
  final _conFirstName = TextEditingController();
  final _conLastName = TextEditingController();
  String? username;
  var usersFuture;

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      username = sp.getString("user_id")!;
    });
  }

  @override
  void initState() {
    getUserData();
    setState(() {
      usersFuture = getData(2);
    });
    // TODO: implement initState
    super.initState();
  }

  Future<ApiUser> getData(int index) {
    return userRepository.getUsers(index).then((value) {
      return value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(
            Icons.add_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            _conEmail.clear();
            _conFirstName.clear();
            _conLastName.clear();
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Add User',
                            style: TextStyle(color: Colors.black, fontSize: 25),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        getTextFormField(
                            controller: _conEmail,
                            icon: Icons.person,
                            hintName: 'Email'),
                        SizedBox(height: 20.0),
                        getTextFormField(
                          controller: _conFirstName,
                          icon: Icons.person,
                          hintName: 'First Name',
                          isObscureText: false,
                        ),
                        SizedBox(height: 20.0),
                        getTextFormField(
                          controller: _conLastName,
                          icon: Icons.person,
                          hintName: 'Last Name',
                          isObscureText: false,
                        ),
                        SizedBox(height: 30.0),
                        Container(
                          margin: EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            onPressed: () async {
                              if (_conFirstName.text.trim().isEmpty ||
                                  _conEmail.text.trim().isEmpty ||
                                  _conLastName.text.trim().isEmpty) {
                                alertDialog(context, 'Please fill all details');
                              } else {
                                await userRepository
                                    .addUser(_conEmail.text, _conFirstName.text,
                                        _conLastName.text)
                                    .then((value) {
                                  if (value) {
                                    alertDialog(context, 'Added Successfully');
                                    setState(() {
                                      usersFuture = getData(2);
                                    });
                                    Navigator.pop(context);
                                  } else {
                                    alertDialog(context, 'Try again');
                                  }
                                });
                              }
                            },
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Add",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  letterSpacing: 0.168,
                                  fontWeight: FontWeight.w500),
                            ),
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }),
      drawer: NavDrawer(username: username!),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [],
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: usersFuture,
        builder: (context, AsyncSnapshot<ApiUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.data!.length,
                  itemBuilder: ((context, index) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: ListTile(
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Delete'),
                                    content: new Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            "Are you sure you want to delete it?"),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                        ),
                                        // ignore: deprecated_member_use
                                        child: RaisedButton(
                                          onPressed: () async {
                                            await userRepository
                                                .deleteUser(snapshot
                                                    .data!.data![index].id!
                                                    .toString())
                                                .then((value) {
                                              if (value) {
                                                alertDialog(context,
                                                    'Deleted Successfully');
                                                setState(() {
                                                  usersFuture = getData(2);
                                                });
                                                Navigator.pop(context);
                                              } else {
                                                alertDialog(
                                                    context, 'Try again');
                                              }
                                            });
                                          },
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                letterSpacing: 0.168,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                        onTap: () {
                          _conEmail.text = snapshot.data!.data![index].email!;
                          _conFirstName.text =
                              snapshot.data!.data![index].firstName!;
                          _conLastName.text =
                              snapshot.data!.data![index].lastName!;
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Update User',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Colors.grey.withOpacity(0.2),
                                      ),
                                      getTextFormField(
                                          controller: _conEmail,
                                          icon: Icons.person,
                                          hintName: 'Email'),
                                      SizedBox(height: 20.0),
                                      getTextFormField(
                                        controller: _conFirstName,
                                        icon: Icons.person,
                                        hintName: 'First Name',
                                        isObscureText: false,
                                      ),
                                      SizedBox(height: 20.0),
                                      getTextFormField(
                                        controller: _conLastName,
                                        icon: Icons.person,
                                        hintName: 'Last Name',
                                        isObscureText: false,
                                      ),
                                      SizedBox(height: 30.0),
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                        ),
                                        // ignore: deprecated_member_use
                                        child: RaisedButton(
                                          onPressed: () async {
                                            if (_conFirstName.text
                                                    .trim()
                                                    .isEmpty ||
                                                _conEmail.text.trim().isEmpty ||
                                                _conLastName.text
                                                    .trim()
                                                    .isEmpty) {
                                              alertDialog(context,
                                                  'Please fill all details');
                                            } else {
                                              await userRepository
                                                  .updateUser(
                                                      _conEmail.text,
                                                      _conFirstName.text,
                                                      _conLastName.text,
                                                      snapshot.data!
                                                          .data![index].id!
                                                          .toString())
                                                  .then((value) {
                                                if (value) {
                                                  alertDialog(context,
                                                      'Updated Successfully');
                                                  setState(() {
                                                    usersFuture = getData(2);
                                                  });
                                                  Navigator.pop(context);
                                                } else {
                                                  alertDialog(
                                                      context, 'Try again');
                                                }
                                              });
                                            }
                                          },
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Text(
                                            "Update",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                letterSpacing: 0.168,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              snapshot.data!.data![index].avatar!,
                              width: 50,
                            )),
                        title: Text(snapshot.data!.data![index].firstName! +
                            ' ' +
                            snapshot.data!.data![index].lastName!),
                        subtitle: Text(snapshot.data!.data![index].email!),
                      ),
                    );
                  }));
            } else {
              return Center(
                child: Text('No data available'),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          } else {
            return Center(
              child: Text('No data available'),
            );
          }
        },
      ),
    );
  }
}
