import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaikaiDetail extends StatefulWidget {
  const TaikaiDetail({Key? key}) : super(key: key);

  @override
  _TaikaiDetailState createState() => _TaikaiDetailState();
}

class _TaikaiDetailState extends State<TaikaiDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 30,
                  color: Colors.black,
                ),
              ),
              Text('退会', style: TextStyle(color: Colors.black)),
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 30,
                color: Colors.white,
              ),
            ],
          )),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    '注意事項',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    '※注1',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                '一度退会してしまうと過去のやり取りや、メッセージは全て削除され、二度とアクセスすることはできません。',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    '※注2',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                '再登録しても、過去のデータを引き継ぐことはできません。',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
              ),
              SizedBox(height: 50),
              Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFed1b24),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 58,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Center(
                                    child: Text(
                                      '退会する',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
            ],
          )),
        ),
      ),
    );
  }
}
