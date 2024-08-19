import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class DogPage extends StatefulWidget {
  const DogPage({super.key});

  @override
  State<DogPage> createState() => _DogPageState();
}

class _DogPageState extends State<DogPage> {
  List<String> images = [
    "https://t3.ftcdn.net/jpg/06/10/71/64/360_F_610716498_li6BIgt75TXw8B4W89pbf3VtKgHNQkXo.jpg",
    "https://wallpaperaccess.com/full/2637581.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTIZccfNPnqalhrWev-Xo7uBhkor57_rKbkw&usqp=CAU",
    "https://wallpaperaccess.com/full/2637581.jpg"
  ];
  bool isExpanded = false;
  bool isLike = false;
  bool isNotRequested = true;
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      isNotRequested = true;
      isLike = false;
    });
    _pageController.addListener(() {
      int nextPage = _pageController.page!.round();
      if (_currentPage != nextPage) {
        setState(() {
          _currentPage = nextPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          forceMaterialTransparency: true,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios)),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.share)),
          ],
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 50,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  itemBuilder: (context, pagePosition) {
                    return Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: new NetworkImage(
                                images[pagePosition],
                              ),
                              fit: BoxFit.fill)),
                      child: pagePosition == 0
                          ? Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 95.h,
                                    width: MediaQuery.of(context).size.width,
                                    color: Color(0xBF6D6C6C),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 2.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Tom',
                                                      style: GoogleFonts
                                                          .robotoFlex(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 28,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    Icon(
                                                      Icons.verified,
                                                      size: 30,
                                                      color: Color(0xff3AB648),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  'Male • 6 Months',
                                                  style: GoogleFonts.robotoFlex(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 3.0),
                                                  child: Text(
                                                    'Breed Type • Colour',
                                                    style:
                                                        GoogleFonts.robotoFlex(
                                                            color: Colors.white,
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                  alignment: Alignment.topLeft,
                                                  onPressed: () {
                                                    setState(() {
                                                      isLike = !isLike;
                                                    });
                                                  },
                                                  icon: isLike
                                                      ? Icon(
                                                          Icons.favorite,
                                                          color: Colors.white,
                                                          size: 30,
                                                        )
                                                      : Icon(
                                                          Icons
                                                              .favorite_outline,
                                                          color: Colors.white,
                                                          size: 30,
                                                        )),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      color: Colors.white,
                                                      size: 25,
                                                    ),
                                                    Text(
                                                      '1.5 Km',
                                                      style: GoogleFonts
                                                          .robotoFlex(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DetailsCateg(cont: 'Vaccinated'),
                    DetailsCateg(cont: 'KCI Certified'),
                    DetailsCateg(cont: 'No Allergies'),
                  ],
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(185, 243, 192, 0.425),
                      border: Border.all(color: Color(0xff3AB648), width: 2.0),
                      borderRadius: BorderRadius.circular(10)),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SoloCateg(icon: Icons.vaccines, title: 'Vaccinated'),
                      SoloCateg(icon: Icons.favorite, title: 'Good'),
                      SoloCateg(icon: Icons.pets, title: 'Friendly')
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  top: 9.0,
                ),
                child: Row(
                  children: [
                    Text('About',
                        style: GoogleFonts.robotoFlex(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black)),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 2.0),
                    child: Align(
                      child: Text(
                        '''Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.''',
                        maxLines: isExpanded ? null : 3,
                        style: GoogleFonts.robotoFlex(
                            fontWeight: FontWeight.w400, fontSize: 15),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  isExpanded == true
                      ? Container()
                      : Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                  });
                                },
                                child: Text(
                                  isExpanded ? '' : 'Read More',
                                  style: GoogleFonts.robotoFlex(
                                      color: Color(0xff3AB648),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                )),
                          ],
                        )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                child: Row(
                  children: [
                    Text(
                      'Cared By',
                      style: GoogleFonts.robotoFlex(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(185, 243, 192, 0.425),
                      border: Border.all(color: Color(0xff3AB648), width: 2.0),
                      borderRadius: BorderRadius.circular(10)),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xff3AB648),
                        radius: 40,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Mr. XXXX',
                            style: GoogleFonts.robotoFlex(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            'Area, District',
                            style: GoogleFonts.robotoFlex(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.black45),
                          ),
                        ],
                      ),
                      CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0xff3AB648),
                          child: Image.asset('assets/whitepaw.png'))
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0),
                child: Row(
                  children: [
                    Text('You might also like',
                        style: GoogleFonts.robotoFlex(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ],
                ),
              ),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageTransition(
                          child: DogPage(),
                          type: PageTransitionType.rightToLeft));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg'),
                          fit: BoxFit.cover,
                        ),
                        border:
                            Border.all(color: Color(0xff3AB648), width: 3.0),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.all(5),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Color(0x99E2EBE3),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tom',
                                    style: GoogleFonts.robotoFlex(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.black,
                                        size: 22,
                                      ),
                                      Text(
                                        '1.5 Km',
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Male - 6 Months +',
                                style: GoogleFonts.robotoFlex(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                'Black & White',
                                style: GoogleFonts.robotoFlex(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          height: 75,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  isNotRequested = !isNotRequested;
                });
              },
              child: isNotRequested
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xff3AB648),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Request to Paw',
                            style: GoogleFonts.robotoFlex(
                                fontSize: 23.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Image.asset('assets/whitepaw.png')
                        ],
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          border:
                              Border.all(color: Color(0xff3AB648), width: 3.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Requested',
                            style: GoogleFonts.robotoFlex(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff3AB648)),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Icon(
                            Icons.verified,
                            size: 35,
                            color: Color(0xff3AB648),
                          )
                        ],
                      ),
                    ),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(3, 0), // changes position of shadow
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SoloCateg extends StatefulWidget {
  SoloCateg({super.key, required this.icon, required this.title});
  String title;
  IconData icon;
  @override
  State<SoloCateg> createState() => _SoloCategState();
}

class _SoloCategState extends State<SoloCateg> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            color: Colors.black.withOpacity(0.8),
            size: 30,
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            '${widget.title}',
            style: GoogleFonts.robotoFlex(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xff3AB648)),
          )
        ],
      ),
    );
  }
}

class DetailsCateg extends StatefulWidget {
  DetailsCateg({super.key, required this.cont});
  String cont;
  @override
  State<DetailsCateg> createState() => _DetailsCategState();
}

class _DetailsCategState extends State<DetailsCateg> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(185, 243, 192, 0.625),
          border: Border.all(color: Color(0xff3AB648), width: 3.0),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        child: Text(
          '${widget.cont}',
          style: GoogleFonts.robotoFlex(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: Color(0xff3AB648)),
        ),
      ),
    );
  }
}
