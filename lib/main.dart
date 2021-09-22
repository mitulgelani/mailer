import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'MG Mailer',
            style: TextStyle(fontSize: 30),
          ),
          backgroundColor: Colors.redAccent[400],
          centerTitle: true,
        ),
        body: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController txcontroller = TextEditingController();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController subcontroller = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  final snackBar =
      SnackBar(content: Text(' Sent to All Email Addresses Successfully!'));
  String username = 'joganigems7@gmail.com';
  String password = 'Bhagyesh76@';

  @override
  Widget build(BuildContext context) {
    showAlertDialog(BuildContext context) {
      // set up the buttons
      // ignore: deprecated_member_use
      Widget cancelButton = FlatButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      // ignore: deprecated_member_use
      Widget continueButton = FlatButton(
        child: Text("Submit"),
        onPressed: () {
          username = usernamecontroller.text;
          password = passwordcontroller.text;
          Navigator.of(context).pop();
        },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Column(
          children: [
            Text("Gmail Details"),
            TextField(
              controller: usernamecontroller,
              decoration: const InputDecoration(
                icon: Icon(Icons.person_sharp),
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: passwordcontroller,
              decoration: const InputDecoration(
                icon: Icon(Icons.lock),
                labelText: 'Password',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              ': : : NOTE : : :',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Enable "Less Secure Apps" from "acount.google.com"',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            Image(image: AssetImage('Assets/tmp.png'))
          ],
        ),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(child: alert);
        },
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_box, color: Colors.orange),
                Text(
                  'Gmail Details',
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            onTap: () {
              showAlertDialog(context);
            },
          ),
          SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: namecontroller,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'Your Name',
            ),
            maxLines: null,
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: subcontroller,
            decoration: const InputDecoration(
              icon: Icon(Icons.subject),
              labelText: 'Subject',
            ),
            maxLines: null,
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: titlecontroller,
            decoration: const InputDecoration(
              icon: Icon(Icons.title),
              labelText: 'Title',
            ),
            maxLines: null,
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: txcontroller,
            decoration: const InputDecoration(
              icon: Icon(Icons.description),
              labelText: 'Description',
            ),
            maxLines: null,
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: emailcontroller,
            decoration: const InputDecoration(
              icon: Icon(Icons.email),
              labelText: 'All Emails',
            ),
            maxLines: null,
          ),
          SizedBox(
            height: 20,
          ),
         
          // ignore: deprecated_member_use
          RaisedButton(
              child: Text(
                "Send",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.redAccent[200],
              onPressed: () async {
                // ignore: deprecated_member_use
                List<String> emails = List<String>();
                String tmp = emailcontroller.text, tmp2;
                int j = 0, start = 0, end;
                tmp.runes.forEach((int rune) {
                  var c = new String.fromCharCode(rune);
                  if (c == '\n' || j == tmp.length - 1) {
                    if (j == tmp.length - 1)
                      end = j + 1;
                    else
                      end = j;
                    tmp2 = tmp.substring(start, end);
                    emails.add(tmp2);
                    start = end + 1;
                  }
                  j++;
                });
                print(emails);
                // ignore: deprecated_member_use
                if (username != null && password != null) {
                  final smtpServer = gmail(username, password);
                  final message = Message()
                    ..from = Address(username, namecontroller.text)
                    ..bccRecipients.addAll(emails)
                    ..subject = '${subcontroller.text} '
                    ..text = '//'
                    ..html =
                        "<h1>${titlecontroller.text}</h1>\n<p>${txcontroller.text}</p>";
                  var connection = PersistentConnection(smtpServer);
                  await connection.send(message);
                  await connection.close();
                  // ignore: deprecated_member_use
                  Scaffold.of(context).showSnackBar(snackBar);
                } else if (emails != null) {
                  Fluttertoast.showToast(
                      msg: "Fill up the All Emails Field",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  Fluttertoast.showToast(
                      msg: "Add Gmail Details First!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0))),
        ],
      ),
    ); 
  }
}
