import 'package:flutter/material.dart';
import 'dart:async';
import 'navbar.dart';


class PillTextWidget extends StatelessWidget {
  final String category;

  const PillTextWidget({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text;
    Color backgroundColor;
    Color textColor;

    switch (category.toLowerCase()) {
      case 'kecelakaan':
        text = 'Kecelakaan';
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[900]!;
        break;
      case 'bencana alam':
        text = 'Bencana Alam';
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[900]!;
        break;
      case 'kemacetan':
        text = 'Kemacetan';
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[900]!;
        break;
      default:
        text = category;
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[900]!;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'PlusJakarta',
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  final int _totalPages = 6;
  String _activeButton = 'Pusat';
  int _selectedIndex = 0;
  bool _isDropdownExpanded = false;

  final List<String> _imageAssets = [
    'assets/carousel1.png',
    'assets/carousel2.png',
    'assets/carousel3.png',
    'assets/carousel4.png',
    'assets/carousel5.png',
    'assets/carousel6.png',
  ];

  

 final Map<String, List<Map<String, String>>> _listItems = {
    'Pusat': [
      {
        'title': 'Kemacetan di Jalan Thamrin',
        'subtitle':
            'Terjadi kemacetan padat merayap akibat demo di depan gedung DPR. Disarankan mencari jalur alternatif.',
        'category': 'Kemacetan'
      },
      {
        'title': 'Kecelakaan di Bundaran HI',
        'subtitle':
            'Kecelakaan melibatkan dua kendaraan di Bundaran HI. Petugas sedang menangani di lokasi.',
        'category': 'Kecelakaan'
      },
      {
        'title': 'Banjir di Tanah Abang',
        'subtitle':
            'Banjir setinggi 50 cm di beberapa titik Tanah Abang. Kendaraan disarankan untuk menghindari area tersebut.',
        'category': 'Bencana Alam'
      },
    ],
    'Utara': [
      {
        'title': 'Kepadatan di Pelabuhan Tanjung Priok',
        'subtitle':
            'Terjadi antrean panjang kendaraan menuju Pelabuhan Tanjung Priok. Diimbau untuk berangkat lebih awal.',
        'category': 'Kemacetan'
      },
      {
        'title': 'Kecelakaan di Jalan Yos Sudarso',
        'subtitle':
            'Kecelakaan tunggal terjadi di Jalan Yos Sudarso. Lalu lintas tersendat, harap berhati-hati.',
        'category': 'Kecelakaan'
      },
      {
        'title': 'Banjir Rob di Muara Baru',
        'subtitle':
            'Banjir rob setinggi 30 cm melanda kawasan Muara Baru. Warga diminta waspada.',
        'category': 'Bencana Alam'
      },
    ],
    'Barat': [
      {
        'title': 'Banjir di Cengkareng',
        'subtitle':
            'Banjir setinggi 30 cm di beberapa ruas jalan Cengkareng. Pengendara diminta untuk waspada.',
        'category': 'Bencana Alam'
      },
      {
        'title': 'Kecelakaan di Tol Kebon Jeruk',
        'subtitle':
            'Terjadi kecelakaan beruntun di Tol Kebon Jeruk. Lalu lintas tersendat hingga 2 km.',
        'category': 'Kecelakaan'
      },
      {
        'title': 'Kemacetan di Glodok',
        'subtitle':
            'Pasar tumpah di area Glodok menyebabkan kemacetan. Disarankan mencari rute alternatif.',
        'category': 'Kemacetan'
      },
    ],
    'Timur': [
      {
        'title': 'Perbaikan Jembatan Kalimalang',
        'subtitle':
            'Sedang dilakukan perbaikan Jembatan Kalimalang. Lalu lintas dialihkan ke jalan paralel.',
        'category': 'Kemacetan'
      },
      {
        'title': 'Kecelakaan di Jalan Raya Bekasi',
        'subtitle':
            'Kecelakaan melibatkan truk dan motor di Jalan Raya Bekasi. Lalu lintas padat, harap berhati-hati.',
        'category': 'Kecelakaan'
      },
      {
        'title': 'Banjir di Cipinang',
        'subtitle':
            'Banjir setinggi 40 cm di beberapa titik Cipinang. Kendaraan disarankan untuk mencari jalur alternatif.',
        'category': 'Bencana Alam'
      },
    ],
    'Selatan': [
      {
        'title': 'Kemacetan di Blok M',
        'subtitle':
            'Terjadi kemacetan padat di area Blok M akibat penutupan sebagian jalan untuk renovasi trotoar.',
        'category': 'Kemacetan'
      },
      {
        'title': 'Pohon Tumbang di Jagakarsa',
        'subtitle':
            'Sebuah pohon besar tumbang di Jalan Jagakarsa. Tim dari Dinas Pertamanan sedang dalam proses evakuasi.',
        'category': 'Bencana Alam'
      },
      {
        'title': 'Kecelakaan di Tol TB Simatupang',
        'subtitle':
            'Terjadi kecelakaan di Tol TB Simatupang arah Cilandak. Disarankan untuk berangkat lebih awal.',
        'category': 'Kecelakaan'
      },
    ],
  };

String _selectedCategory = 'Tempat';
  final List<String> _categories = ['Tempat', 'Makanan', 'Liburan', 'Lainnya'];

  final Map<String, List<Map<String, String>>> _categoryItems = {
    'Tempat': [
      {
        'title': 'Museum Sejarah Jakarta',
        'subtitle': 'Koleksi baru tentang era kolonial Belanda',
        'location': 'Kota Tua'
      },
      {
        'title': 'Taman Impian Jaya Ancol',
        'subtitle': 'Wahana air baru "Tsunami Ride"',
        'location': 'Jakarta Utara'
      },
      {
        'title': 'RPTRA Kalijodo',
        'subtitle': 'Area skatepark yang baru direnovasi',
        'location': 'Jakarta Barat'
      },
    ],
    'Makanan': [
      {
        'title': 'Nasi Goreng Kambing Kebon Sirih',
        'subtitle': 'Varian baru dengan bumbu rempah khas Timur Tengah',
        'location': 'Kebon Sirih'
      },
      {
        'title': 'Sate Taichan Senayan',
        'subtitle': 'Menu baru sate taichan dengan saus matah',
        'location': 'Senayan'
      },
      {
        'title': 'Bakmi GM',
        'subtitle': 'Bakmi ayam jamur dengan topping baru',
        'location': 'Berbagai cabang di Jakarta'
      },
    ],
    'Liburan': [
      {
        'title': 'Thousand Islands Getaway',
        'subtitle': 'Paket wisata 3 hari 2 malam ke Pulau Macan',
        'location': 'Kepulauan Seribu'
      },
      {
        'title': 'Jakarta Night Tour',
        'subtitle': 'Tur malam hari mengunjungi landmark Jakarta',
        'location': 'Jakarta Pusat'
      },
      {
        'title': 'Ragunan Zoo Safari',
        'subtitle': 'Pengalaman safari malam di Kebun Binatang Ragunan',
        'location': 'Jakarta Selatan'
      },
    ],
    'Lainnya': [
      {
        'title': 'Jakarta Fashion Week',
        'subtitle': 'Pameran busana terbesar se-Asia Tenggara',
        'location': 'Senayan City'
      },
      {
        'title': 'Jakarta International Java Jazz Festival',
        'subtitle': 'Festival musik jazz tahunan',
        'location': 'JIExpo Kemayoran'
      },
      {
        'title': 'Jakarta Marathon',
        'subtitle': 'Lomba lari maraton internasional',
        'location': 'Berbagai rute di Jakarta'
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _totalPages * 1000);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Image.asset(
            'assets/logoDKJ2.png',
            height: 40, // Sesuaikan ukuran sesuai kebutuhan
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
       body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Hai, Jakartans',
                 style: TextStyle(
                      fontFamily: 'PlusJakarta',
                      color: Color(0xFFF3520D),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page % _totalPages;
                  });
                },
                itemBuilder: (context, index) {
                  final imageIndex = index % _totalPages;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage(_imageAssets[imageIndex]),
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                  _totalPages,
                  (index) => Container(
                    width:
                        (MediaQuery.of(context).size.width - 20) / _totalPages,
                    height: 3,
                    color: _currentPage == index ?Color(0xFFF3520D): Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Lalu Lintas',
                style: TextStyle(
                  fontFamily: 'PlusJakarta',
                  color: Color(0xFFF3520D),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButton('Pusat', Colors.red),
                  _buildButton('Utara', Colors.blue),
                  _buildButton('Barat', Color(0xFFF3520D)),
                  _buildButton('Timur', Colors.pink),
                  _buildButton('Selatan', Colors.green),
                ],
              ),
            ),
            // const SizedBox(height: 20),
            ..._buildListItems(),
            // const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Yang Baru di Jakarta!',
                style: TextStyle(
                  fontFamily: 'PlusJakarta',
                  color: Color(0xFFF3520D),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildCustomDropdown(),
            ),
            const SizedBox(height: 10),
            ..._buildCategoryItems(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(height: 100),
          ],
              
            ),
          ),
          FloatingBottomNavBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        ],
      ),
     
    );
  }

  Widget _buildButton(String text, Color color) {
    bool isActive = _activeButton == text;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _activeButton = text;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          isActive ? color.withOpacity(0.7) : color, // Darker when active
        ),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 15,vertical: 4),
        ),
        minimumSize: MaterialStateProperty.all(Size(0, 32)),
      ),
       child: Text(
        text,
        style: TextStyle(fontSize: 14,
          fontFamily: 'PlusJakarta',
        ), // Reduced font size
      ),
    );
  }

 List<Widget> _buildListItems() {
    return [
      Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: _listItems[_activeButton]?.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                   Row(
                        children: [
                          SizedBox(width: 32), // Align with title
                          PillTextWidget(
                              category: item['category'] ?? 'Lainnya'),
                        ],
                      ),
                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'PlusJakarta',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF3520D),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title']!,
                              style: TextStyle(
                                fontFamily: 'PlusJakarta',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              item['subtitle']!,
                              style: TextStyle(
                                fontFamily: 'PlusJakarta',
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Icon(Icons.location_on, color: Colors.red, size: 20),
                          SizedBox(height: 4),
                          Text(
                            _activeButton,
                            style: TextStyle(
                              fontFamily: 'PlusJakarta',
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList() ?? [],
        ),
      ),
    ];
  }


  List<Widget> _buildCategoryItems() {
    return _categoryItems[_selectedCategory]
            ?.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    elevation: 2,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: TextStyle(
                              fontFamily: 'PlusJakarta',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            item['subtitle']!,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PlusJakarta',
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  color: Colors.red, size: 16),
                              SizedBox(width: 4),
                              Text(
                                item['location']!,
                                style: TextStyle(
                                  fontFamily: 'PlusJakarta',
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
            .toList() ??
        [];
  }

 Widget _buildCustomDropdown() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isDropdownExpanded = !_isDropdownExpanded;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
                boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),

                ),
              ],
            ),
            
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_selectedCategory),
                Icon(
                  _isDropdownExpanded
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
        if (_isDropdownExpanded)
          Container(
             decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: _categories.map((String category) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                      _isDropdownExpanded = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: _selectedCategory == category
                          ? Colors.grey[200]
                          : Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: category != _categories.last
                              ? Colors.grey[200]!
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(category),
                        if (_selectedCategory == category)
                          Icon(Icons.check, color: Colors.blue),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
