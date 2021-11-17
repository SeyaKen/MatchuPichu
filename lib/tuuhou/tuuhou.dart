import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class tuuhouScreen extends StatefulWidget {
  const tuuhouScreen({Key? key}) : super(key: key);

  @override
  _tuuhouScreenState createState() => _tuuhouScreenState();
}

class _tuuhouScreenState extends State<tuuhouScreen> {
  late String ex = '';
  final _formKey = GlobalKey<FormState>();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Text(
                  '通報',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              ],
            )),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 150),
                  Row(
                    children: [
                      Text(
                        '通報理由',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: '通報理由を入力',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      initialValue: ex,
                      onChanged: (val) {
                        setState(() => ex = val);
                      },
                    ),
                  ),
                  SizedBox(height: 150),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 58,
                    child: InkWell(
                      onTap: () async {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFed1b24),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Center(
                          child: Text(
                            '通報する',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
