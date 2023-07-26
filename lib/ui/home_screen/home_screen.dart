import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/auth_provider.dart';
import 'package:todo/ui/home_screen/addtask_bottomsheet.dart';
import 'package:todo/ui/home_screen/list_screen/list_screen.dart';
import 'package:todo/ui/home_screen/setting_screen/setting_screen.dart';
import 'package:todo/ui/login_screen/loginscreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'homescreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> tabs = [const ListScreen(), SettingScreen()];

  int currentIndexx = 0;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AuthProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,  //5D9CEC
          title:  Text(AppLocalizations.of(context)!.appbartitle),
          actions: [
            IconButton(
                onPressed: () {
                  provider.signout();
                  Navigator.pushReplacementNamed(
                      context, LoginScreen.routeName);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: StadiumBorder(
              side: BorderSide(color:Theme.of(context).dividerColor,width: 4)
          ),
          onPressed: (){
            addTaskBottomSheet();
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          notchMargin: 8,
          shape: const CircularNotchedRectangle(),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            currentIndex: currentIndexx,
            onTap: (index) {
              setState(() {
                currentIndexx = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.list_outlined,
                    size: 26,
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings_outlined,
                    size: 26,
                  ),
                  label: '')
            ],
          ),
        ),
      body: tabs[currentIndexx],
    );
  }
  void addTaskBottomSheet(){
    showModalBottomSheet(context: context,
        builder: (context) => AddTaskBottomSheet(),
      showDragHandle: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true
    );
  }
}
