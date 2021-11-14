import 'package:flutter/material.dart';

class OsiraseDetail extends StatefulWidget {
  String title, naiyou;
  OsiraseDetail(this.title, this.naiyou);

  @override
  State<OsiraseDetail> createState() => _OsiraseDetailState();
}

class _OsiraseDetailState extends State<OsiraseDetail> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Color(0xFFed1b24).withOpacity(0.77),
              elevation: 0,
              toolbarHeight: 60,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 30,
                    ),
                  ),
                  Text(widget.title),
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 30,
                    color: Colors.transparent,
                  ),
                ],
              )),
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                  ),
                  SizedBox(height: 20),
                  Text(
                    '''${widget.naiyou.trim()}''',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
