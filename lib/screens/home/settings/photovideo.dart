import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhotosAndVideosPage extends StatefulWidget {
  @override
  _PhotosAndVideosPageState createState() => _PhotosAndVideosPageState();
}

class _PhotosAndVideosPageState extends State<PhotosAndVideosPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos and Videos',
            style: GoogleFonts.robotoFlex(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Color(0xffE2EBE3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green, width: 1.5),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle,
                      size: 50,
                      color: Colors.green,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Add Photos / Videos',
                      style: GoogleFonts.robotoFlex(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.green,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: GoogleFonts.robotoFlex(fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                text: 'Photos',
                icon: Icon(Icons.photo),
              ),
              Tab(
                text: 'Videos',
                icon: Icon(Icons.videocam),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGridView(), // For Photos
                _buildGridView(), // For Videos
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount:
            12, // Number of items, you can change this based on your data
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemBuilder: (context, index) {
          return Container(
            color: Colors.grey[300],
            child: Center(
              child: Icon(
                Icons.image,
                color: Colors.white,
                size: 50,
              ),
            ),
          );
        },
      ),
    );
  }
}
