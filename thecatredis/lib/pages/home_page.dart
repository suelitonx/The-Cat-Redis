import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thecatredis/services/data/vlb2.dart';
import 'package:thecatredis/states/cats_state.dart';
import 'package:thecatredis/stores/cats_store.dart';
import 'package:thecatredis/stores/favoritos_store.dart';
import '../models/cat_model.dart';
import '../services/auth_service.dart';
import '../services/theme/theme_model.dart';
import '../states/favoritos_state.dart';

class HomePage extends StatefulWidget {
  final AuthService authService;

  const HomePage({super.key, required this.authService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final themeService = ThemeModel.instance;
  final AppinioSwiperController controller = AppinioSwiperController();
  final PageController pageController = PageController();
  int currentPage = 0;
  int i = 0;

  final storeCats = CatsStore();
  final storeFavoritos = FavoritosStore();

  @override
  void initState() {
    carregarDados();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('The Cat Redis', style: GoogleFonts.workSans()),
        leading: currentPage == 0
            ? IconButton(
                icon: const Icon(Icons.brightness_4_rounded),
                onPressed: () {
                  themeService.toggleTheme();
                },
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                },
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              widget.authService.deslogar();
            },
          ),
        ],
      ),
      body: VLB2(
        first: storeCats,
        second: storeFavoritos,
        builder: (context, sCats, sFavoritos, _) {
          if (sCats is LoadingCatState || sFavoritos is LoadingFavoritosState) {
            return const Center(child: CircularProgressIndicator());
          } else if (sCats is ErrorCatState || sFavoritos is ErrorFavoritosState) {
            return const Center(child: Text('Erro ao carregar dados.'));
          } else if (sCats is LoadedCatState && sFavoritos is LoadedFavoritosState) {
            final gatinhos = sCats.cats;

            return SafeArea(
              child: PageView(
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: [
                  Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.75,
                          maxWidth: 500,
                        ),
                        child: AppinioSwiper(
                          initialIndex: i,
                          maxAngle: 20,
                          backgroundCardScale: 0.6,
                          controller: controller,
                          cardCount: gatinhos.length,
                          onSwipeEnd: (previousIndex, targetIndex, activity) {
                            return _swipeEnd(previousIndex, targetIndex, activity, gatinhos);
                          },
                          swipeOptions: const SwipeOptions.only(left: true, right: true, up: false, down: false),
                          cardBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  i = index;
                                  pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(gatinhos[index].url),
                                      fit: BoxFit.cover,
                                      onError: (exception, stackTrace) => const Icon(Icons.error_rounded),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                controller.swipeLeft();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                foregroundColor: Colors.red,
                                elevation: 10,
                              ),
                              child: const Center(child: Tooltip(message: "SAI GATO!!!", child: Icon(Icons.close_rounded, size: 40))),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                //controller.swipeDown();
                                pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                foregroundColor: Colors.blue,
                                elevation: 10,
                              ),
                              child: const Center(child: Tooltip(message: "Favoritos", child: Icon(Icons.menu_rounded, size: 40))),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                controller.swipeRight();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                foregroundColor: Colors.pink,
                                elevation: 10,
                              ),
                              child: const Center(child: Tooltip(message: "PSPSPSPSPS", child: Icon(Icons.favorite, size: 40))),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  //Favoritos
                  Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: (MediaQuery.of(context).size.width / 230).round(), // number of items in each row
                            mainAxisSpacing: 2.0, // spacing between rows
                            crossAxisSpacing: 2.0, // spacing between columns
                          ),
                          itemCount: sFavoritos.favoritos.length,
                          itemBuilder: (context, index) {
                            final gatinho = sFavoritos.favoritos[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(image: CachedNetworkImageProvider(gatinho.url), fit: BoxFit.cover, onError: (exception, stackTrace) => const Icon(Icons.error_rounded)),
                                ),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete_forever_rounded),
                                    onPressed: () {
                                      storeFavoritos.removerFavorito(gatinho);
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _swipeEnd(int previousIndex, int targetIndex, SwiperActivity activity, List<CatModel> gatins) async {
    switch (activity) {
      case Swipe():
        if (kDebugMode) {
          print('The card was swiped to the : ${activity.direction}');
          print('previous index: $previousIndex, target index: $targetIndex');
        }

        i = targetIndex;

        if (activity.direction == AxisDirection.right) {
          storeFavoritos.adicionarFavorito(gatins[previousIndex]);
        }

        break;
      case Unswipe():
        if (kDebugMode) {
          print('A ${activity.direction.name} swipe was undone.');
          print('previous index: $previousIndex, target index: $targetIndex');
        }
        break;
      case CancelSwipe():
        if (kDebugMode) {
          print('A swipe was cancelled');
        }
        break;
      case DrivenActivity():
        if (kDebugMode) {
          print('Driven Activity');
        }
        break;
    }
  }

  Future<void> carregarDados() async {
    await Future.wait([
      storeFavoritos.getFavoritos(),
      storeCats.getImages(realAPI: true),
    ]);
  }
}
