// lib/views/main_screen.dart
import 'package:case_project_app/viewmodels/main_viewmodels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../global/global_scaffold.dart';
import '../widget/bottombar_items.dart';
import '../widget/movie_card.dart';
import '../widget/resolve_image.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainViewModel>(
      create: (_) {
        final vm = MainViewModel();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          vm.initData(context);
        });
        return vm;
      },
      child: Consumer<MainViewModel>(
        builder: (context, vm, _) {
          return globalScaffold(title: '', body: _buildPageView(vm), bottomBarItems: bottomBarItems(context, widget, vm.favoriteMovies), isBackButtonVisible: false, isAppbarVisible: false);
        },
      ),
    );
  }

  Widget _buildPageView(MainViewModel vm) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: vm.displayedMovies.length + (vm.hasMore ? 1 : 0),
      onPageChanged: (index) {
        if (index >= vm.displayedMovies.length - 2 && !vm.isLoading && vm.hasMore) {
          vm.fetchMovies(context);
        }
      },
      itemBuilder: (context, index) {
        if (index == vm.displayedMovies.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final movie = vm.displayedMovies[index];
        return FutureBuilder<String>(
          future: resolveBestImageUrl(movie),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

            final imageUrl = (snapshot.hasData && snapshot.data!.isNotEmpty) ? snapshot.data! : (movie.images.isNotEmpty ? movie.images.first : '');

            return MovieCard(movie: movie, isFavorite: movie.isFavorite, imageUrl: imageUrl, onToggleFavorite: () => vm.toggleFavorite(context, movie.id));
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
