import 'package:flutter/material.dart';

import '../../widgets/fetch_products.dart';

class Favourite extends StatefulWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: fetchData("users-favourite-items"),
      ),
    );
  }
}
