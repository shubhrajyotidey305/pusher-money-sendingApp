import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'dart:io';
import 'package:http/http.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _earnings = 0;
  final List _history = [];
  final messageTextController = TextEditingController();
  String messageText = "0";
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  var channelName = 'private-my_channel';

  Future<void> _initPusher() async {
    try {
      await pusher.init(
        apiKey: "503c295a8c71896beade",
        cluster: "mt1",
        onConnectionStateChange: onConnectionStateChange,
        onAuthorizer: onAuthorizer,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onSubscriptionError: onSubscriptionError,
      );

      await pusher.subscribe(
          channelName: channelName,
          onEvent: (event) {
            if (mounted) {
              final data = jsonDecode(event.data);
              setState(() {
                _earnings += int.parse(data['rupee']);
              });
              _history.add({
                "rupee": int.parse(data['rupee']),
                "sender": data['sender'],
                "time": data['time']
              });
            }
            if (kDebugMode) {
              print("Event Received: ${event.data}");
            }
          });
      await pusher.connect();
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    if (kDebugMode) {
      print("onSubscriptionSucceeded: $channelName data: $data");
    }
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    if (kDebugMode) {
      print("Connection: $currentState");
    }
  }

  void onSubscriptionError(String message, dynamic e) {
    if (kDebugMode) {
      print("onSubscriptionError: $message Exception: $e");
    }
  }

  void onTriggerEventPressed(String _money) async {
    String json =
        '{"rupee": "$_money", "sender": "Me", "time": "${DateTime.now().toString().substring(11, 16)}"}';
    await pusher.trigger(PusherEvent(
      channelName: channelName,
      eventName: "client-my_event",
      data: json,
    ));
  }

  static const Map<String, String> headers = {
    "Content-type": "application/json"
  };

// access localhost from the emulator/simulator
  String _hostname() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    } else {
      return 'http://localhost:3000';
    }
  }

  // _makePostRequest(String amount) async {
  //   // set up POST request arguments
  //
  //   String json =
  //       '{"rupee": "$amount", "sender": "Me", "time": "${DateTime.now().toString().substring(11, 16)}"}';
  //   // make POST request
  //   Response response =
  //       await post(Uri.parse(_hostname()), headers: headers, body: json);
  //   int statusCode = response.statusCode;
  //   String body = response.body;
  //   if (kDebugMode) {
  //     print('Status: $statusCode, $body');
  //   }
  // }

  dynamic onAuthorizer(
      String channelName, String socketId, dynamic options) async {
    var authUrl = '${_hostname()}/pusher/user-auth';
    String json = '{"socket_id": "$socketId", "channel_name": "$channelName"}';
    var result = await post(
      Uri.parse(authUrl),
      headers: headers,
      body: json,
    );
    int statusCode = result.statusCode;
    String body = result.body;
    if (kDebugMode) {
      print('Status: $statusCode, $body');
    }
    return jsonDecode(result.body);
  }

  @override
  void initState() {
    super.initState();
    _initPusher();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    'My Name',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('My Wallet'),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              const Text('Rs:'),
                              const SizedBox(
                                height: 5.0,
                                width: 10.0,
                              ),
                              Text(
                                _earnings.toString(),
                                style: const TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Send Money'),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              const Text('Rs:'),
                              Expanded(
                                child: TextField(
                                  controller: messageTextController,
                                  onChanged: (value) {
                                    //Do something with the user input.
                                    messageText = value;
                                  },
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    hintText: 'Type your amount...',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  onTriggerEventPressed(messageText);
                                  // _makePostRequest(messageText);
                                  if (kDebugMode) {
                                    print(messageText);
                                  }
                                  messageText = "0";
                                  messageTextController.clear();
                                },
                                child: const Text(
                                  'Send',
                                  style: TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: const Text('Past Transactions'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Rs: ${_history[index]['rupee']}'),
                      subtitle: Text('Sender: ${_history[index]['sender']}'),
                      trailing: Text(_history[index]['time']),
                    );
                  },
                ),
                flex: 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
