import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:wheather_app/blocs/home_bloc/home_bloc.dart';
import 'package:wheather_app/blocs/home_bloc/home_event.dart';
import 'package:wheather_app/blocs/home_bloc/home_state.dart';
import 'package:wheather_app/screens/sign_in_screen.dart';
import 'package:wheather_app/services/auth_service.dart';
import 'package:wheather_app/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc _bloc = HomeBloc();
  final AuthService _authService = AuthService();
  String? _userName;

  @override
  void initState() {
    _bloc.add(InitEvent(context: context));
    _loadUserName();
    super.initState();
  }

  Future<void> _loadUserName() async {
    final user = await _authService.currentUser;
    if (mounted) {
      setState(() {
        _userName = user?.name ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            _userName ?? 'Loading...',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.black),
              onPressed: () async {
                try {
                  await _authService.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Utils.showToast(
                      message: 'Error signing out: ${e.toString()}',
                    );
                  }
                }
              },
            ),
          ],
        ),
        body: BlocConsumer<HomeBloc, HomeState>(
          builder: (context, state) {
            return _buildBody();
          },
          listener: (context, state) {
            if (state is FailureState) {
              Utils.showToast(message: state.message);
            }
          },
        ),
      ),
    );
  }

  LinearGradient _gradient() {
    if (_bloc.wheatherModel?.weather?.first.description?.contains("rain") ??
        false) {
      return LinearGradient(
        colors: [Colors.grey, Colors.blueGrey],
        begin: AlignmentGeometry.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (_bloc.wheatherModel?.weather?.first.description?.contains(
          "clear",
        ) ??
        false) {
      return LinearGradient(
        colors: [Colors.orangeAccent, Colors.blueAccent],
        begin: AlignmentGeometry.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    return LinearGradient(
      colors: [Colors.blue, Colors.lightBlueAccent],
      begin: AlignmentGeometry.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  _unFocus() {
    FocusScope.of(context).unfocus();
  }

  Widget _buildBody() {
    return GestureDetector(
      onTap: () {
        _unFocus();
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: _gradient()),
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 30, horizontal: 29),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  "Search weather",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextFormField(
                    controller: _bloc.controller,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 15,
                      ),
                      hintText: "Enter city name",
                      border: InputBorder.none,
                      errorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      _unFocus();
                      _bloc.add(SearchWheatherEvent(context: context));
                    },
                    child: BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        if (state is ItemLoadingState) {
                          return CircularProgressIndicator();
                        }
                        return Text(
                          "Search",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 50),
                (_bloc.wheatherModel?.name?.isNotEmpty ?? false)
                    ? Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(113, 255, 255, 255),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: BlocBuilder<HomeBloc, HomeState>(
                          builder: (context, state) {
                            if (state is ItemLoadingState) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return Column(
                              children: [
                                Lottie.asset(
                                  (_bloc
                                              .wheatherModel
                                              ?.weather
                                              ?.first
                                              .description
                                              ?.contains("rain") ??
                                          false)
                                      ? "assets/jsons/rain.json"
                                      : (_bloc
                                                .wheatherModel
                                                ?.weather
                                                ?.first
                                                .description
                                                ?.contains("clear") ??
                                            false)
                                      ? "assets/jsons/sunny.json"
                                      : "assets/jsons/cloudy.json",
                                  height: 150,
                                  width: 150,
                                ),
                                SizedBox(height: 20),
                                Text(_bloc.wheatherModel?.name ?? ""),

                                Text(
                                  "${_bloc.wheatherModel?.main?.temp?.toStringAsFixed(1)}°C",
                                ),
                                Text(
                                  _bloc
                                          .wheatherModel
                                          ?.weather
                                          ?.first
                                          .description ??
                                      "",
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Humidity: ${_bloc.wheatherModel?.main?.humidity}%",
                                    ),
                                    Text(
                                      "Wind: ${_bloc.wheatherModel?.wind?.speed} m/s",
                                    ),
                                  ],
                                ),

                                SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.wb_sunny_outlined,
                                          color: Colors.orange,
                                        ),
                                        Text("Sunrise"),
                                        Text(
                                          formatDate(
                                            timeStamps:
                                                _bloc
                                                    .wheatherModel
                                                    ?.sys
                                                    ?.sunrise ??
                                                0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 20),

                                    Column(
                                      children: [
                                        Icon(
                                          Icons.nights_stay_outlined,
                                          color: Colors.purple,
                                        ),
                                        Text("Sunset"),
                                        Text(
                                          formatDate(
                                            timeStamps:
                                                _bloc
                                                    .wheatherModel
                                                    ?.sys
                                                    ?.sunset ??
                                                0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatDate({required int timeStamps}) {
    final date = DateTime.fromMicrosecondsSinceEpoch(timeStamps * 100);
    return DateFormat("hh:mm a").format(date);
  }
}
