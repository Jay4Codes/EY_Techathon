import 'package:carousel_slider/carousel_slider.dart';
import 'package:ey_hack/profile.dart';
import 'package:ey_hack/screens/movies.dart';
import 'package:ey_hack/screens/search.dart';
import 'package:ey_hack/screens/tvshows.dart';
import 'package:ey_hack/screens/wishlist.dart';
import 'package:ey_hack/universal/fetchdata.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _text = '';
  late String choices;
  late List<String> finalchoices;
  final List<String> imageList = [
    'https://occ-0-3933-116.1.nflxso.net/dnm/api/v6/9pS1daC2n6UGc3dUogvWIPMR_OU/AAAABVACVBhtk__TwjW_N_1p73DfGia8wGezAAeDKWrMG0zeXc1r9VEDB4ZJqtWNUHeiFnz7YfVhigBPpMAzYY2gIUPJlIP0WXQGfVt10TAZbYLjVGKJjknJwVpHtg.webp?r=6c7',
    'https://occ-0-3933-116.1.nflxso.net/dnm/api/v6/9pS1daC2n6UGc3dUogvWIPMR_OU/AAAABaGmtnaBUzeWcYgtgwwMamERran8Ida5zMbAOwljGigQOF-p9W64f8_ucg-E4hny677tnuMpbncy47d5cC15lYxllqxw0QSK83U8RGmUpN0n6bpqFFdcIS3_Ug.webp?r=b83',
    'https://occ-0-3933-116.1.nflxso.net/dnm/api/v6/E8vDc_W8CLv7-yMQu8KMEC7Rrr8/AAAABRiDdaQUAzgL0rze0R0T_zmdlB8y92QZVeYdNA6qMfM7ppWVTRUIQ-MvSATNMkm8Lg5XW2_kNmr0FRA3PEw28v64RIttHOAC6vHO.webp?r=f86',
    // Add more image URLs as needed
  ];
  Future<void> fetchStringFromSharedPreferences() async {
    final List<String> listofchoices = [
      "Sports",
      "Thriller",
    ];
    setState(() {
      finalchoices = listofchoices;
    });
  }

  @override
  void initState() {
    fetchStringFromSharedPreferences();
    super.initState();

    initBannerAd();
    initInterstitialAd();
    initmInterstitialAd();
  }

  late BannerAd bannerAd;
  bool isAdloaded = false;

  late InterstitialAd interstitialad;
  bool isinteradloaded = false;

  initInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/8691691433',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          interstitialad = ad;
          setState(() {
            isinteradloaded = true;
          });
        }, onAdFailedToLoad: ((error) {
          interstitialad.dispose();
        })));
  }

  late InterstitialAd minterstitialad;
  bool isminteradloaded = false;

  initmInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          minterstitialad = ad;
          setState(() {
            isminteradloaded = true;
          });
        }, onAdFailedToLoad: ((error) {
          interstitialad.dispose();
        })));
  }

  initBannerAd() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-3940256099942544/6300978111',
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              isAdloaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            print(error);
          },
        ),
        request: const AdRequest());
    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: isAdloaded
          ? SizedBox(
              height: bannerAd.size.height.toDouble(),
              width: bannerAd.size.width.toDouble(),
              child: AdWidget(ad: bannerAd),
            )
          : const SizedBox(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30), // Spacer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Profile(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      "assets/ey.png",
                      fit: BoxFit.fill,
                      height: 20,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TvShows(),
                      ),
                    );
                  },
                  child: Text(
                    "TV Shows",
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      {MaterialPageRoute(builder: (context) => Movies())},
                  child: Text(
                    "Movies",
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Wishlist(),
                      ),
                    );
                  },
                  child: Text(
                    "My List",
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 9 / 16,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
                items: imageList.map((url) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                url,
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (isinteradloaded) {
                                  interstitialad.show();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                backgroundColor: Colors.amber,
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList()),

            const SizedBox(
              height: 20,
            ),
            // Spacer
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: SizedBox(
                height: 50,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white),
                    boxShadow: [
                      // Add a boxShadow here
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.3), // Shadow color and opacity
                        blurRadius: 5, // Spread of the shadow
                        offset: const Offset(0, 3), // Offset of the shadow
                      ),
                    ],
                  ),
                  child: TextFormField(
                    onFieldSubmitted: (value) {
                      setState(() {
                        _text = value;
                        print(_text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Search(
                              searchtext: _text,
                            ),
                          ),
                        );
                        Search(
                          searchtext: _text,
                        );
                      });
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    style: GoogleFonts.dmSerifText(
                      color: Colors.yellow,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorStyle: GoogleFonts.dmSerifText(),
                      hintText: 'Search',
                      hintStyle: GoogleFonts.dmSerifText(color: Colors.grey),
                      icon: const Padding(
                        padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                        child: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // const SizedBox(height: 20), // Spacer
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     Column(
            //       children: [
            //         GestureDetector(
            //           onTap: () {
            //             if (isminteradloaded) {
            //               minterstitialad.show();
            //             }
            //           },
            //           child: Icon(
            //             Icons.add,
            //             color: Colors.black,
            //           ),
            //         ),
            //         Text(
            //           "My List",
            //           style: GoogleFonts.dmSerifDisplay(
            //             color: Colors.black,
            //           ),
            //         ),
            //       ],
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         if (isinteradloaded) {
            //           interstitialad.show();
            //         }
            //       },
            //       child: Container(
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 40,
            //           vertical: 5,
            //         ),
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(5),
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.black.withOpacity(0.5),
            //               blurRadius: 5,
            //               offset: const Offset(0, 3),
            //             ),
            //           ],
            //         ),
            //         child: Row(
            //           children: [
            //             Icon(
            //               Icons.play_arrow_rounded,
            //             ),
            //             SizedBox(width: 5),
            //             Text(
            //               "Play",
            //               style: GoogleFonts.dmSerifDisplay(
            //                   fontWeight: FontWeight.bold),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     Column(
            //       children: [
            //         Icon(
            //           Icons.info_outline,
            //           color: Colors.black,
            //         ),
            //         Text(
            //           "Info",
            //           style: GoogleFonts.dmSerifDisplay(color: Colors.black),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            ListView.builder(
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: finalchoices.length,
              itemBuilder: (context, index) {
                return DataWidget(text: finalchoices[index]);
              },
            )
          ],
        ),
      ),
    );
  }

  Future<List<String>> getStringFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    choices = prefs.getString("choices") ?? '';
    List<String> listofchoices = choices.split(";");
    return listofchoices;
  }
}
