import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:puppid/screens/home/mainhome/chat.dart';
import 'package:puppid/screens/home/mainhome/dogpage.dart';

class HomeNotificationPage extends StatefulWidget {
  const HomeNotificationPage({Key? key}) : super(key: key);

  @override
  State<HomeNotificationPage> createState() => _HomeNotificationPageState();
}

class _HomeNotificationPageState extends State<HomeNotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Separate lists for requested and friends
  List<bool> invites = [true, true, true];
  List<bool> friends = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void removeInvite(int index) {
    setState(() {
      invites[index] = false;
    });
  }

  void acceptInvite(int index) {
    setState(() {
      friends.add(true); // Add to friends list
      invites[index] = false; // Remove from invites list
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    bool noInvites = invites.every((invite) => !invite);
    bool noFriends = friends.isEmpty;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 25,
                color: Colors.black,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Requests Page",
              style: GoogleFonts.robotoFlex(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "Requested"),
              Tab(text: "Friends"),
            ],
            labelColor: Colors.black,
            labelStyle: GoogleFonts.robotoFlex(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            indicatorColor: Color(0xff3AB648),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Requested Tab
            noInvites
                ? Center(
                    child: Text(
                      "No requests found",
                      style: GoogleFonts.robotoFlex(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: List.generate(invites.length, (index) {
                        return invites[index]
                            ? InviteCard(
                                onAccept: () => acceptInvite(index),
                                onRemove: () => removeInvite(index),
                              )
                            : SizedBox(); // Empty space if no invite
                      }),
                    ),
                  ),
            // Friends Tab
            noFriends
                ? Center(
                    child: Text(
                      "No friends yet",
                      style: GoogleFonts.robotoFlex(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: List.generate(friends.length, (index) {
                        return friends[index]
                            ? FriendCard() // Create a simple card for friends
                            : SizedBox();
                      }),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class InviteCard extends StatefulWidget {
  final VoidCallback onRemove;
  final VoidCallback onAccept;
  const InviteCard({Key? key, required this.onRemove, required this.onAccept})
      : super(key: key);

  @override
  State<InviteCard> createState() => _InviteCardState();
}

class _InviteCardState extends State<InviteCard> {
  bool isMsg = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.h),
      child: Container(
        height: 95,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xff3AB648),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageTransition(
                          child: DogPage(),
                          type: PageTransitionType.leftToRight));
                    },
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        'assets/paw.png',
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                'Name',
                style: GoogleFonts.robotoFlex(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: 45.w,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: isMsg
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(PageTransition(
                            child: MessageChat(),
                            type: PageTransitionType.leftToRight,
                            duration: Duration(milliseconds: 300),
                          ));
                        },
                        child: Text(
                          'Message',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff3AB648),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          IconButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.green)),
                            icon: Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                isMsg = true;
                              });
                              widget.onAccept(); // Accept invite
                            },
                            color: Color(0xff3AB648),
                            iconSize: 30,
                          ),
                          SizedBox(
                            width: 25.w,
                          ),
                          IconButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.red)),
                            icon: Icon(
                              Icons.dangerous_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              widget.onRemove();
                            },
                            color: Colors.red,
                            iconSize: 30,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FriendCard extends StatelessWidget {
  const FriendCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.h),
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xff3AB648),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'assets/paw.png',
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Name',
                  style: GoogleFonts.robotoFlex(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.message),
                color: Color(0xff3AB648),
                onPressed: () {
                  Navigator.of(context).push(PageTransition(
                    child: MessageChat(),
                    type: PageTransitionType.leftToRight,
                    duration: Duration(milliseconds: 300),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
