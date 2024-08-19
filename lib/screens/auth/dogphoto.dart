import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:puppid/screens/home/bottomnav.dart';

class DogPhoto extends StatefulWidget {
  @override
  _DogPhotoState createState() => _DogPhotoState();
}

class _DogPhotoState extends State<DogPhoto>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<File> _photos = [];
  List<File> _videos = [];

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

  Future<void> _pickMedia(bool isPhoto) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        if (isPhoto) {
          _photos.add(File(pickedFile.path));
        } else {
          _videos.add(File(pickedFile.path));
        }
      });
    }
  }

  void _navigateToNextPage() {
    // Replace 'NextPage' with the name of the page you want to navigate to.
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => BottomNav(),
    ));
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
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.green),
            onPressed: _navigateToNextPage,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => _pickMedia(_tabController.index == 0),
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
                _buildGridView(_photos, true), // For Photos
                _buildGridView(_videos, false), // For Videos
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<File> mediaList, bool isPhoto) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: mediaList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemBuilder: (context, index) {
          return Container(
            color: Colors.grey[300],
            child: isPhoto
                ? Image.file(
                    mediaList[index],
                    fit: BoxFit.cover,
                  )
                : Icon(
                    Icons.videocam,
                    color: Colors.white,
                    size: 50,
                  ),
          );
        },
      ),
    );
  }
}
