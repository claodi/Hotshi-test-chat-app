import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hotshi/config.dart';
import 'package:hotshi/repositories/message_repository.dart';
import '../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:toastification/toastification.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  String messages = '';
  var messagesData = [];
  var imgCount = 1;
  var userImg = '';
  var user_id = 0;
  bool loading = false;

  final TextEditingController _inputController = TextEditingController();

  // Send message
  void _sendMsg(val) async {
    setState(() {
      loading = true;
    });

    _inputController.clear();
    var newMessage = await MessageRepository().createMessaeResponse(val);

    if (newMessage?['data'] != null) {
      messagesData.insert(0, newMessage?['data']);
      setState(() {});
      storeStorageMessage();
    } else {
      toastification.show(
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: const Text('Message cannot be sent'),
        autoCloseDuration: const Duration(seconds: 5),
        showProgressBar: false,
      );
    }

    setState(() {
      loading = false;
    });
  }

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  void _initPusher() async {
    try {
      await pusher.init(
        apiKey: AppConfig.PUSHER_API_KEY,
        cluster: AppConfig.PUSHER_API_CLUSTER,
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
      );
      await pusher.subscribe(channelName: 'chat');
      await pusher.connect();
    } catch (e) {
      //
    }
  }

  // Store in local storage
  storeStorageMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('messages_liste', jsonEncode(messagesData));
  }

  // Pusher onEvent
  void onEvent(PusherEvent event) {
    print("onEvent: $event");

    var jsonData = jsonDecode(event.data);
    if (jsonData['user_id'] != user_id) {
      messagesData.insert(0, {
        'id': jsonData['id'],
        'user_id': jsonData['user_id'],
        'user_name': jsonData['user_name'],
        'content': jsonData['content'],
        "created_at": jsonData['created_at'],
        "updated_at": jsonData['updated_at'],
      });
      setState(() {});
      storeStorageMessage();
    }
  }

  // Pusher onSubscriptionSucceeded
  void onSubscriptionSucceeded(String channelName, dynamic data) {
    print("onSubscriptionSucceeded: $channelName data: $data");
  }

  // Pusher onSubscriptionError
  void onSubscriptionError(String message, dynamic e) {
    print("onSubscriptionError: $message Exception: $e");
  }

  // Pusher onDecryptionFailure
  void onDecryptionFailure(String event, String reason) {
    print("onDecryptionFailure: $event reason: $reason");
  }

  // Pusher onMemberAdded
  void onMemberAdded(String channelName, PusherMember member) {
    print("onMemberAdded: $channelName member: $member");
  }

  // Pusher onMemberRemoved
  void onMemberRemoved(String channelName, PusherMember member) {
    print("onMemberRemoved: $channelName member: $member");
  }

  // Pusher onConnectionStateChange
  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print("Connection: $currentState");
  }

  // Pusher onError
  void onError(String message, int? code, dynamic e) {
    print("onError: $message code: $code exception: $e");
  }

  // Get all messages from api
  void _getMessages() async {
    var messagesResponse = await MessageRepository().getMessageResponse();
  }

  // Get storage message
  void _getSharedMessage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    messages = prefs.getString('messages_liste') ?? '';

    if (messages != '') {
      messagesData = jsonDecode(messages);
      setState(() {});
    }
  }

  // Get user
  _getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getInt('user_id') ?? 0;
  }

  @override
  void initState() {
    _getUser();
    _initPusher();
    // _getMessages();
    _getSharedMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/bg.png"),
          ),
          SizedBox(width: defaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Public Group",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Created 3m ago",
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.local_phone),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () {},
        ),
        const SizedBox(width: defaultPadding / 2),
      ],
    );
  }

  // Body
  Widget Body() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: messagesData != null
                ? ListView.builder(
                    reverse: true,
                    itemCount: messagesData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Messages(context, index);
                    })
                : const Text(''),
          ),
        ),
        if (loading)
          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: primaryColor,
              strokeWidth: 2.0,
              semanticsLabel: 'Circular progress indicator',
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        ChatInputField(),
      ],
    );
  }

  Widget ChatInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 32,
            color: const Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            const Icon(Icons.mic, color: primaryColor),
            const SizedBox(width: defaultPadding),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding * 0.75,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sentiment_satisfied_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.64),
                    ),
                    const SizedBox(width: defaultPadding / 4),
                    Expanded(
                      child: Form(
                        child: TextFormField(
                          onFieldSubmitted: (val) {
                            if (val.isNotEmpty) {
                              _sendMsg(val);
                            }
                          },
                          controller: _inputController,
                          decoration: const InputDecoration(
                            hintText: "Type message",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.attach_file,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.64),
                    ),
                    const SizedBox(width: defaultPadding / 4),
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.64),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Messages(BuildContext context, int index) {
    userImg = 'assets/images/$imgCount.png';
    if (imgCount == 5) {
      imgCount = 0;
    }
    imgCount += 1;
    return Padding(
      padding: const EdgeInsets.only(top: defaultPadding),
      child: Row(
        mainAxisAlignment: (messagesData?[index]?['user_id'] == user_id)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (messagesData?[index]?['user_id'] != user_id) ...[
            CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage(userImg),
            ),
            const SizedBox(width: defaultPadding / 2),
          ],
          Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ' ${messagesData?[index]?['user_name']}',
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: (messagesData?[index]?['user_id'] == user_id)
                        ? Colors.white
                        : Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding * 0.75,
                    vertical: defaultPadding / 2,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(
                        (messagesData?[index]?['user_id'] == user_id)
                            ? 1
                            : 0.3),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    '${messagesData?[index]?['content']}',
                    style: TextStyle(
                      color: (messagesData?[index]?['user_id'] == user_id)
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ),
              ],
            )
          ]),
          if (messagesData?[index]?['user_id'] == user_id) MessageStatusDot(),
        ],
      ),
    );
  }

  Widget MessageStatusDot() {
    return Container(
      margin: const EdgeInsets.only(left: defaultPadding / 2),
      height: 12,
      width: 12,
      child: const Icon(
        Icons.done,
        size: 15,
        color: primaryColor,
      ),
    );
  }
}
