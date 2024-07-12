import 'package:flutter/material.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({Key? key}) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  List<Map<String, dynamic>> stories = [
    {
      "title": "Jakarta Pusat",
      "images": [
        "assets/jakarta_pusat_1.jpg",
        "assets/jakarta_pusat_2.jpg",
        "assets/jakarta_pusat_3.jpg"
      ],
      "viewed": false
    },
    {
      "title": "Jakarta Utara",
      "images": [
        "assets/jakarta_utara_1.jpg",
        "assets/jakarta_utara_2.jpg",
        "assets/jakarta_utara_3.jpg"
      ],
      "viewed": false
    },
    {
      "title": "Jakarta Barat",
      "images": [
        "assets/jakarta_barat_1.jpg",
        "assets/jakarta_barat_2.jpg",
        "assets/jakarta_barat_3.jpg"
      ],
      "viewed": false
    },
    {
      "title": "Jakarta Selatan",
      "images": [
        "assets/jakarta_selatan_1.jpg",
        "assets/jakarta_selatan_2.jpg",
        "assets/jakarta_selatan_3.jpg"
      ],
      "viewed": false
    },
    {
      "title": "Jakarta Timur",
      "images": [
        "assets/jakarta_timur_1.jpg",
        "assets/jakarta_timur_2.jpg",
        "assets/jakarta_timur_3.jpg"
      ],
      "viewed": false
    },
    {
      "title": "Kepulauan Seribu",
      "images": [
        "assets/kepulauan_seribu_1.jpg",
        "assets/kepulauan_seribu_2.jpg",
        "assets/kepulauan_seribu_3.jpg"
      ],
      "viewed": false
    },
  ];

  void _updateStoryStatus(int index) {
    setState(() {
      stories[index]['viewed'] = true;
    });
  }

  void _openSettings() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Settings'),
          content: Text('Settings functionality will be added here.'),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DKJ'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStoryAvatars(),
          Expanded(child: Center(child: Text("Tap on a story to view"))),
        ],
      ),
    );
  }

  Widget _buildStoryAvatars() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => StoryView(
                    story: stories[index],
                    updateStoryStatus: () => _updateStoryStatus(index),
                  ),
                ),
              )
                  .then((_) {
                setState(
                    () {}); // Refresh the UI after returning from StoryView
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: stories[index]['viewed']
                              ? Colors.grey
                              : Color(0xFFF3520D),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 36,
                      backgroundImage: AssetImage(stories[index]["images"][0]),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    stories[index]["title"]!,
                    style: TextStyle(fontFamily: 'PlusJakarta', fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class StoryView extends StatefulWidget {
  final Map<String, dynamic> story;
  final VoidCallback updateStoryStatus;

  StoryView({required this.story, required this.updateStoryStatus});

  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextPage();
      }
    });

    _loadStory(widget.story['images'][_currentIndex]);
  }

  void _loadStory(String image) {
    _animationController.forward(from: 0);
  }

  void _nextPage() {
    if (_currentIndex != widget.story['images'].length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      widget.updateStoryStatus();
      Navigator.of(context).pop();
    }
  }

  void _previousPage() {
    if (_currentIndex != 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) => _onTapDown(details, context),
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _pageController,
              itemCount: widget.story['images'].length,
              itemBuilder: (context, index) {
                return Image.asset(
                  widget.story['images'][index],
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                );
              },
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _loadStory(widget.story['images'][index]);
              },
            ),
            Positioned(
              top: 40,
              left: 10,
              right: 10,
              child: Row(
                children: List<Widget>.from(
                  widget.story['images'].asMap().map((i, e) {
                    return MapEntry(
                      i,
                      AnimatedBar(
                        animationController: _animationController,
                        position: i,
                        currentIndex: _currentIndex,
                      ),
                    );
                  }).values,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tapPosition = details.globalPosition.dx;
    if (tapPosition < screenWidth / 3) {
      _previousPage();
    } else if (tapPosition > 2 * screenWidth / 3) {
      _nextPage();
    }
  }
}

class AnimatedBar extends StatelessWidget {
  final AnimationController animationController;
  final int position;
  final int currentIndex;

  const AnimatedBar({
    Key? key,
    required this.animationController,
    required this.position,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                _buildContainer(
                  double.infinity,
                  position < currentIndex
                      ? Color(0xFFF3520D)
                      : Colors.white.withOpacity(0.5),
                ),
                position == currentIndex
                    ? AnimatedBuilder(
                        animation: animationController,
                        builder: (context, child) {
                          return _buildContainer(
                            constraints.maxWidth * animationController.value,
                            Color(0xFFF3520D),
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _buildContainer(double width, Color color) {
    return Container(
      height: 5.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black26,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
  }
}
