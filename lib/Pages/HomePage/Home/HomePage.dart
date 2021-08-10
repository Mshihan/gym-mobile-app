// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymmer/ApiIntegration/NewsApi.dart';
import 'package:gymmer/ApiIntegration/ProductsAp.dart';
import 'package:gymmer/ApiIntegration/ProfileApi.dart';
import 'package:gymmer/ApiIntegration/SheduleApi.dart';
import 'package:gymmer/Pages/HomePage/Home/NewsBox/NewsBox.dart';
import 'package:gymmer/Pages/HomePage/Home/Personal%20Details%20Row/PersonalDetailsRow.dart';
import 'package:gymmer/Pages/HomePage/ProductCard/ProductCard.dart';

//Enums to render drawer navigations
enum UsernameTap { ShowLogout, HideLogout }
enum Pages { Home, Profile, Shedule, Products }

class HomePage extends StatefulWidget {
  static const homepage = '/homePage';
  const HomePage({required this.id});
  final String id;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Color palette
  Color backgroundColor = Color(0xff151515);
  Color selectedColor = Color(0xffE41C26);

  //Enum Initialization
  UsernameTap _usernameTap = UsernameTap.HideLogout;
  Pages _pages = Pages.Home;

  //Scaffold key to work with drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //Drawer open method
  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  //Drawer close method
  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _pages = Pages.Home;
    getNews();
    getPersonalDetails();
    getMembershipDetails();
    getProductDetails();
    getShedules();
  }

  BackEndServiceNews _backEndServiceNews = BackEndServiceNews();
  BackEndServiceProfile _backEndServiceProfile = BackEndServiceProfile();
  BackEndServiceProducts _backEndServiceProducts = BackEndServiceProducts();
  BackEndServiceShedule _backEndServiceShedule = BackEndServiceShedule();

  late List<NewsFeed> newsList;
  late List<ProductFeed> productList;
  late List<MembershipInfo> membershipList;
  late List<SheduleInfo> sheduleList;

  ProfileInfo profileInfo = ProfileInfo(
    id: 0,
    name: '',
    phone: '',
    createdAt: '',
    dob: '',
    isActive: '',
    nic: '',
    lastMembership: '',
  );

  void getNews() async {
    newsList = [];
    List<NewsFeed> list = await _backEndServiceNews.getNews();
    for (int i = 0; i < list.length; i++) {
      NewsFeed newNews = list[i];
      newsList.add(newNews);
    }
  }

  void getPersonalDetails() async {
    List<ProfileInfo> profileList =
        await _backEndServiceProfile.getPersonalDetails(int.parse(widget.id));
    profileInfo = ProfileInfo(
      id: profileList[0].id,
      name: profileList[0].name,
      phone: profileList[0].phone,
      createdAt: profileList[0].createdAt,
      dob: profileList[0].dob,
      isActive: profileList[0].isActive,
      nic: profileList[0].nic,
      lastMembership: profileList[0].lastMembership,
    );
  }

  void getProductDetails() async {
    productList = [];
    List<ProductFeed> list = await _backEndServiceProducts.getProducts();
    for (int i = 0; i < list.length; i++) {
      ProductFeed newProduct = list[i];
      productList.add(newProduct);
    }
  }

  void getMembershipDetails() async {
    membershipList = [];
    List<MembershipInfo> list =
        await _backEndServiceProfile.getMembershipInfo(int.parse(widget.id));
    for (int i = 0; i < list.length; i++) {
      MembershipInfo memberhsipNew = list[i];
      membershipList.add(memberhsipNew);
    }
    membershipUpdate();
    setState(() {});
  }

  List<DataRow> membershipRows = [];
  List<SheduleContainer> sheduleContainerList = [];
  List<SheduleIndividual> sheduleIndividualList = [];

  void membershipUpdate() {
    for (int i = 0; i < membershipList.length; i++) {
      var row = DataRow(
        cells: <DataCell>[
          DataCell(Text(
            membershipList[i].from,
            softWrap: true,
          )),
          DataCell(Text(
            membershipList[i].to,
            softWrap: true,
          )),
          DataCell(Text(
            membershipList[i].registeredBy,
            softWrap: true,
          )),
          DataCell(
            Text(
              membershipList[i].createdAt.substring(0, 10),
              softWrap: true,
            ),
          ),
        ],
      );
      membershipRows.add(row);
    }
  }

  void getShedules() async {
    sheduleList = [];
    List<SheduleInfo> list = await _backEndServiceShedule.getSheduleDetails(int.parse(widget.id));
    for (int i = 0; i < list.length; i++) {
      SheduleInfo memberhsipNew = list[i];
      sheduleList.add(memberhsipNew);
    }
    setupSheduleContainers();
  }

  void setupSheduleContainers() {
    DataRow rows;

    for (int i = 0; i < sheduleList.length; i++) {
      var row = DataRow(
        cells: <DataCell>[
          DataCell(Text(
            sheduleList[i].sheduleName,
            softWrap: true,
          )),
          DataCell(Text(
            sheduleList[i].rips,
            softWrap: true,
          )),
          DataCell(Text(
            sheduleList[i].sets,
            softWrap: true,
          )),
        ],
      );
      rows = row;

      var shedule = SheduleIndividual(
          day: sheduleList[i].day, date: sheduleList[i].date, rows: rows);
      sheduleIndividualList.add(shedule);
    }
    renderShedules();
  }

  void renderShedules() async {
    String previousDay = '1';
    List<DataRow> rows = [];

    for (int i = 0; i < sheduleIndividualList.length; i++) {
      if (sheduleIndividualList.length - 1 == i) {
        var sheduleContainer = SheduleContainer(
            width: width,
            day: sheduleIndividualList[i].day,
            sheduleDate: sheduleIndividualList[i].date,
            rows: rows);
        sheduleContainerList.add(sheduleContainer);
      }
      if (sheduleIndividualList[i].day == previousDay) {
        rows.add(sheduleIndividualList[i].rows);
      } else {
        var sheduleContainer = SheduleContainer(
            width: width,
            day: sheduleIndividualList[i - 1].day,
            sheduleDate: sheduleIndividualList[i - 1].date,
            rows: rows);
        sheduleContainerList.add(sheduleContainer);
        rows = [];
        rows.add(sheduleIndividualList[i].rows);
        previousDay = sheduleIndividualList[i].day;
      }
    }
  }

  late double width;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              image: DecorationImage(
                  image: AssetImage('assets/images/BackDrawer.jpg'),
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.black38, BlendMode.darken)),
            ),
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: backgroundColor.withOpacity(0.3),
                  ),
                  child: Text(
                    'NAVIGATION',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                ListTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Home',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: _pages == Pages.Home ? 18 : 16,
                            fontWeight: _pages == Pages.Home
                                ? FontWeight.w800
                                : FontWeight.normal),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      _pages == Pages.Home
                          ? Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.00)),
                            )
                          : SizedBox(),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _pages = Pages.Home;
                      _closeDrawer();
                    });
                  },
                ),
                ListTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: _pages == Pages.Profile ? 18 : 16,
                            fontWeight: _pages == Pages.Profile
                                ? FontWeight.w800
                                : FontWeight.normal),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      _pages == Pages.Profile
                          ? Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.00)),
                            )
                          : SizedBox(),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _pages = Pages.Profile;
                      _closeDrawer();
                    });
                  },
                ),
                ListTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Schedule',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: _pages == Pages.Shedule ? 18 : 16,
                            fontWeight: _pages == Pages.Shedule
                                ? FontWeight.w800
                                : FontWeight.normal),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      _pages == Pages.Shedule
                          ? Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.00)),
                            )
                          : SizedBox(),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _pages = Pages.Shedule;
                      _closeDrawer();
                    });
                  },
                ),
                ListTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Products',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: _pages == Pages.Products ? 18 : 16,
                            fontWeight: _pages == Pages.Products
                                ? FontWeight.w800
                                : FontWeight.normal),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      _pages == Pages.Products
                          ? Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.00)),
                            )
                          : SizedBox(),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _pages = Pages.Products;
                      _closeDrawer();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/images/BackHome.jpg',
                      ),
                      fit: BoxFit.cover),
                ),
              ),
              _pages == Pages.Home
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.1,
                          ),
                          Container(
                            width: width,
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.08),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.00),
                            ),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_usernameTap ==
                                          UsernameTap.HideLogout) {
                                        _usernameTap = UsernameTap.ShowLogout;
                                      } else {
                                        _usernameTap = UsernameTap.HideLogout;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20.00)),
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        profileInfo.name.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                                _usernameTap == UsernameTap.ShowLogout
                                    ? Container(
                                        width: width,
                                        height: 3,
                                        color: Colors.black,
                                      )
                                    : SizedBox(),
                                _usernameTap == UsernameTap.ShowLogout
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(20.00),
                                                  bottomRight:
                                                      Radius.circular(20.00)),
                                              color:
                                                  Colors.red.withOpacity(0.7)),
                                          child: Center(
                                            child: Text(
                                              "LOGOUT",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            width: width,
                            height: height * 0.795,
                            child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: newsList.length,
                              itemBuilder: (context, i) {
                                return NewsBox(
                                    width: width,
                                    height: height,
                                    title: newsList[i].heading,
                                    by: newsList[i].by,
                                    date: newsList[i].date,
                                    paragraph: newsList[i].description,
                                    url: newsList[i].imageUrl);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              _pages == Pages.Profile
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.1,
                          ),
                          Container(
                            width: width,
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.08),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.00),
                            ),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_usernameTap ==
                                          UsernameTap.HideLogout) {
                                        _usernameTap = UsernameTap.ShowLogout;
                                      } else {
                                        _usernameTap = UsernameTap.HideLogout;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20.00)),
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        profileInfo.name.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                                _usernameTap == UsernameTap.ShowLogout
                                    ? Container(
                                        width: width,
                                        height: 3,
                                        color: Colors.black,
                                      )
                                    : SizedBox(),
                                _usernameTap == UsernameTap.ShowLogout
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(20.00),
                                                  bottomRight:
                                                      Radius.circular(20.00)),
                                              color:
                                                  Colors.red.withOpacity(0.7)),
                                          child: Center(
                                            child: Text(
                                              "LOGOUT",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: height * 0.03,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.00)),
                                width: width,
                                margin: EdgeInsets.symmetric(
                                    horizontal: width * 0.08),
                                padding: EdgeInsets.symmetric(
                                    vertical: height * 0.03,
                                    horizontal: width * 0.05),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.00),
                                        border: Border.all(
                                            color: Colors.black, width: 5),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.person,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      child: Text(
                                        profileInfo.name.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        profileInfo.lastMembership,
                                        style: TextStyle(
                                            color: Colors.deepOrange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    profileInfo.isActive == '1'
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.lightGreen,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Text(
                                              'Active',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : SizedBox(),
                                    profileInfo.isActive == '0'
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Text(
                                              'Deactive',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.00)),
                                margin: EdgeInsets.symmetric(
                                    horizontal: width * 0.08),
                                child: ExpansionTile(
                                  collapsedIconColor: Colors.black,
                                  title: Text(
                                    "Personal Details",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  children: <Widget>[
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      margin: EdgeInsets.only(
                                          left: width * 0.03,
                                          right: width * 0.03,
                                          bottom: height * 0.01),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          PersonalDetailsRow(
                                            width: width,
                                            title: 'Phone',
                                            icon: Icons.phone,
                                          ),
                                          Container(
                                            child: Text(
                                              profileInfo.phone,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      margin: EdgeInsets.only(
                                          left: width * 0.03,
                                          right: width * 0.03,
                                          bottom: height * 0.01),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          PersonalDetailsRow(
                                            width: width,
                                            title: 'NIC',
                                            icon: Icons.credit_card,
                                          ),
                                          Container(
                                            child: Text(
                                              profileInfo.nic,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      margin: EdgeInsets.only(
                                          left: width * 0.03,
                                          right: width * 0.03,
                                          bottom: height * 0.01),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          PersonalDetailsRow(
                                            width: width,
                                            title: 'Joined Date',
                                            icon: Icons.date_range_rounded,
                                          ),
                                          Container(
                                            child: Text(
                                              profileInfo.createdAt
                                                  .substring(0, 10),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      margin: EdgeInsets.only(
                                          left: width * 0.03,
                                          right: width * 0.03,
                                          bottom: height * 0.01),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          PersonalDetailsRow(
                                            width: width,
                                            title: 'Birth Date',
                                            icon: Icons.update,
                                          ),
                                          Container(
                                            child: Text(
                                              profileInfo.dob.substring(0, 10),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.00)),
                                margin: EdgeInsets.symmetric(
                                    horizontal: width * 0.08),
                                child: ExpansionTile(
                                  collapsedIconColor: Colors.black,
                                  title: Text(
                                    "Membership Details",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  children: <Widget>[
                                    Container(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: DataTable(
                                          columns: const <DataColumn>[
                                            DataColumn(
                                              label: Text(
                                                'From',
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'To',
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Received',
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Date',
                                              ),
                                            ),
                                          ],
                                          rows: membershipRows,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  : SizedBox(),
              _pages == Pages.Shedule
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.1,
                          ),
                          Container(
                            width: width,
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.08),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.00),
                            ),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_usernameTap ==
                                          UsernameTap.HideLogout) {
                                        _usernameTap = UsernameTap.ShowLogout;
                                      } else {
                                        _usernameTap = UsernameTap.HideLogout;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20.00)),
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        profileInfo.name.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                                _usernameTap == UsernameTap.ShowLogout
                                    ? Container(
                                        width: width,
                                        height: 3,
                                        color: Colors.black,
                                      )
                                    : SizedBox(),
                                _usernameTap == UsernameTap.ShowLogout
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(20.00),
                                                  bottomRight:
                                                      Radius.circular(20.00)),
                                              color:
                                                  Colors.red.withOpacity(0.7)),
                                          child: Center(
                                            child: Text(
                                              "LOGOUT",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          //ToDo shedule containers display
                          // SheduleContainer(width: width),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Column(
                            children: sheduleContainerList,
                          ),
                          // Container(
                          //   decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       borderRadius: BorderRadius.circular(20.00)),
                          //   margin:
                          //       EdgeInsets.symmetric(horizontal: width * 0.08),
                          //   child: ExpansionTile(
                          //     collapsedIconColor: Colors.black,
                          //     subtitle: Text(
                          //       'Day 2',
                          //       style: TextStyle(
                          //           fontSize: 15, fontWeight: FontWeight.w600),
                          //     ),
                          //     title: Text(
                          //       "Shedule 2021-06-05",
                          //       style: TextStyle(
                          //           fontSize: 18, fontWeight: FontWeight.bold),
                          //     ),
                          //     children: <Widget>[
                          //       Container(
                          //         child: SingleChildScrollView(
                          //           scrollDirection: Axis.horizontal,
                          //           child: DataTable(
                          //             columns: const <DataColumn>[
                          //               DataColumn(
                          //                 label: Text(
                          //                   'From',
                          //                 ),
                          //               ),
                          //               DataColumn(
                          //                 label: Text(
                          //                   'To',
                          //                 ),
                          //               ),
                          //               DataColumn(
                          //                 label: Text(
                          //                   'Received',
                          //                 ),
                          //               ),
                          //               DataColumn(
                          //                 label: Text(
                          //                   'Date',
                          //                 ),
                          //               ),
                          //             ],
                          //             rows: const <DataRow>[
                          //               DataRow(
                          //                 cells: <DataCell>[
                          //                   DataCell(Text(
                          //                     '2021-05-06',
                          //                     softWrap: true,
                          //                   )),
                          //                   DataCell(Text(
                          //                     '2021-05-06',
                          //                     softWrap: true,
                          //                   )),
                          //                   DataCell(Text(
                          //                     'ADMIN',
                          //                     softWrap: true,
                          //                   )),
                          //                   DataCell(Text(
                          //                     '2021-05-06',
                          //                     softWrap: true,
                          //                   )),
                          //                 ],
                          //               ),
                          //               DataRow(
                          //                 cells: <DataCell>[
                          //                   DataCell(Text(
                          //                     '2021-05-06',
                          //                     softWrap: true,
                          //                   )),
                          //                   DataCell(Text(
                          //                     '2021-05-06',
                          //                     softWrap: true,
                          //                   )),
                          //                   DataCell(Text(
                          //                     'ADMIN',
                          //                     softWrap: true,
                          //                   )),
                          //                   DataCell(Text(
                          //                     '2021-05-06',
                          //                     softWrap: true,
                          //                   )),
                          //                 ],
                          //               ),
                          //               DataRow(
                          //                 cells: <DataCell>[
                          //                   DataCell(Text(
                          //                     '2021-05-06',
                          //                     softWrap: true,
                          //                   )),
                          //                   DataCell(Text(
                          //                     '2021-05-06',
                          //                     softWrap: true,
                          //                   )),
                          //                   DataCell(Text(
                          //                     'ADMIN',
                          //                     softWrap: true,
                          //                   )),
                          //                   DataCell(Text(
                          //                     '2021-05-06',
                          //                     softWrap: true,
                          //                   )),
                          //                 ],
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: height * 0.03,
                          // ),
                          // Container(
                          //   decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       borderRadius: BorderRadius.circular(20.00)),
                          //   margin:
                          //       EdgeInsets.symmetric(horizontal: width * 0.08),
                          //   child: ExpansionTile(
                          //     collapsedIconColor: Colors.black,
                          //     subtitle: Text(
                          //       'Day 1',
                          //       style: TextStyle(
                          //           fontSize: 15, fontWeight: FontWeight.w600),
                          //     ),
                          //     title: Text(
                          //       "Shedule 2021-06-08",
                          //       style: TextStyle(
                          //           fontSize: 18, fontWeight: FontWeight.bold),
                          //     ),
                          //     children: <Widget>[
                          //       Container(
                          //         child: SingleChildScrollView(
                          //           scrollDirection: Axis.horizontal,
                          //           child: DataTable(
                          //             columns: const <DataColumn>[
                          //               DataColumn(
                          //                 label: Text(
                          //                   'From',
                          //                 ),
                          //               ),
                          //               DataColumn(
                          //                 label: Text(
                          //                   'To',
                          //                 ),
                          //               ),
                          //               DataColumn(
                          //                 label: Text(
                          //                   'Received',
                          //                 ),
                          //               ),
                          //               DataColumn(
                          //                 label: Text(
                          //                   'Date',
                          //                 ),
                          //               ),
                          //             ],
                          //             rows: const <DataRow>[
                          //               DataRow(
                          //                 cells: <DataCell>[
                          //                   DataCell(Text(
                          //                     '2021-05-06',
                          //                     softWrap: true,
                          //                   )),
                          //                   DataCell(Text(
                          //                     '2021-05-06',
                          //                     softWrap: true,
                          //                   )),
                          //                   DataCell(Text(
                          //                     'ADMIN',
                          //                     softWrap: true,
                          //                   )),
                          //                   DataCell(Text(
                          //                     '2021-05-06',
                          //                     softWrap: true,
                          //                   )),
                          //                 ],
                          //               ),
                          //               DataRow(
                          //                 cells: <DataCell>[
                          //                   DataCell(Text(
                          //                     '2021-05-06',
                          //                     softWrap: true,
                          //                   )),
                          //                   DataCell(Text(
                          //                     '2021-05-06',
                          //                     softWrap: true,
                          //                   )),
                          //                   DataCell(Text(
                          //                     'ADMIN',
                          //                     softWrap: true,
                          //                   )),
                          //                   DataCell(Text(
                          //                     '2021-05-06',
                          //                     softWrap: true,
                          //                   )),
                          //                 ],
                          //               ),
                          //               DataRow(
                          //                 cells: <DataCell>[
                          //                   DataCell(Text(
                          //                     '2021-05-06',
                          //                     softWrap: true,
                          //                   )),
                          //                   DataCell(Text(
                          //                     '2021-05-06',
                          //                     softWrap: true,
                          //                   )),
                          //                   DataCell(Text(
                          //                     'ADMIN',
                          //                     softWrap: true,
                          //                   )),
                          //                   DataCell(Text(
                          //                     '2021-05-06',
                          //                     softWrap: true,
                          //                   )),
                          //                 ],
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    )
                  : SizedBox(),
              _pages == Pages.Products
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.1,
                          ),
                          Container(
                            width: width,
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.08),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.00),
                            ),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_usernameTap ==
                                          UsernameTap.HideLogout) {
                                        _usernameTap = UsernameTap.ShowLogout;
                                      } else {
                                        _usernameTap = UsernameTap.HideLogout;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20.00)),
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        profileInfo.name.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                                _usernameTap == UsernameTap.ShowLogout
                                    ? Container(
                                        width: width,
                                        height: 3,
                                        color: Colors.black,
                                      )
                                    : SizedBox(),
                                _usernameTap == UsernameTap.ShowLogout
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(20.00),
                                                  bottomRight:
                                                      Radius.circular(20.00)),
                                              color:
                                                  Colors.red.withOpacity(0.7)),
                                          child: Center(
                                            child: Text(
                                              "LOGOUT",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: width,
                            height: height * 0.795,
                            child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: productList.length,
                              itemBuilder: (context, i) {
                                return ProductCard(
                                  width: width,
                                  height: height,
                                  category: productList[i].category,
                                  url: productList[i].url,
                                  title: productList[i].name,
                                  price: productList[i].price,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              Container(
                height: height * 0.08,
                color: backgroundColor.withOpacity(0.8),
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 5,
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Image.asset('assets/images/logo.png'),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20.00))),
                    ),
                    SizedBox(),
                    Row(
                      children: [
                        Container(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (_usernameTap == UsernameTap.HideLogout) {
                                  _usernameTap = UsernameTap.ShowLogout;
                                } else {
                                  _usernameTap = UsernameTap.HideLogout;
                                }
                              });
                            },
                            icon: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 25,
                            ),
                            onPressed: () {
                              _openDrawer();
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SheduleContainer extends StatelessWidget {
  const SheduleContainer({
    required this.width,
    required this.day,
    required this.sheduleDate,
    required this.rows,
  });

  final String sheduleDate;
  final String day;
  final double width;
  final List<DataRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.00)),
      margin:
          EdgeInsets.only(right: width * 0.08, left: width * 0.08, bottom: 20),
      child: ExpansionTile(
        collapsedIconColor: Colors.black,
        subtitle: Text(
          'Day ' + day,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        title: Text(
          "Shedule " + sheduleDate,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Name',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Rips',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Sets',
                    ),
                  ),
                ],
                rows: rows,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// FocusScope.of(context).unfocus();

class SheduleIndividual {
  String date;
  String day;
  DataRow rows;
  SheduleIndividual({
    required this.day,
    required this.date,
    required this.rows,
  });
}
