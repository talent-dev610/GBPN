import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbpn_messages/bloc/app_bloc.dart';
import 'package:gbpn_messages/bloc/bloc.dart';
import 'package:gbpn_messages/consts/colors.dart';
import 'package:gbpn_messages/model/company_model.dart';
import 'package:gbpn_messages/model/user_model.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthLoggedInState) {
          return Container();
        }
        UserModel user = authState.user;
        List<CompanyModel>? companies = user.companies;
        return Drawer(
          backgroundColor: kPrimary,
          child: SafeArea(
            child: Row(
              children: [
                Container(
                    width: 80,
                    height: double.infinity,
                    child: Column(
                      children: [
                        Expanded(child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            primary: false,
                            padding: EdgeInsets.zero,
                            itemBuilder: (ctx, i) {
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    if (user.selectedCompany == companies![i].uuid) {
                                      return;
                                    }
                                    AppBloc.authBloc.add(AuthSelectCompanyEvent(uuid: companies[i].uuid!));
                                  },
                                  splashColor: kPrimary.withOpacity(0.3),
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: companies![i].uuid! == user.selectedCompany ? Colors.white.withOpacity(0.1) : Colors.transparent,
                                      borderRadius: companies[i].uuid! == user.selectedCompany ? BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)) : null,
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.apartment,
                                            size: 36,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            companies[i].name!,
                                            style: TextStyle(fontSize: 12, color: Colors.white),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (_, index) {
                              int selectedCompanyIndex = user.getSelectedCompanyIndex();
                              if (index == selectedCompanyIndex - 1 || index == selectedCompanyIndex) return Container();
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Colors.grey.withOpacity(0.3),
                                  height: 1,
                                  thickness: 1,
                                ),
                              );
                            },
                            itemCount: companies!.length)),
                        IconButton(
                          onPressed: () {
                            AppBloc.authBloc.add(AuthLogoutEvent());
                          },
                          icon: const Icon(Icons.logout, color: Colors.white,),
                        ),
                        const SizedBox(height: 10,)
                      ],
                    )
                ),
                Expanded(
                  child: Container(
                    color: Colors.white.withOpacity(0.1),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        DrawerHeader(
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            //decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
                            child: Stack(children: <Widget>[
                              /*Positioned(
                                  right: 0,
                                  top: 0,
                                  child: IconButton(onPressed: () {}, icon: Icon(Icons.nights_stay_sharp))),*/
                              Positioned(bottom: 12.0, left: 16.0, child: Text(user.getSelectedCompany()!.name!, style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500))),
                            ])),
                        SizedBox(height: 10,),
                        createDrawerBodyItem(icon: Icons.phone, text: user.getSelectedCompany()!.phoneNumbers != null && user.getSelectedCompany()!.phoneNumbers!.isNotEmpty ? user.getSelectedCompany()!.phoneNumbers![0] : "No phone",),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget createDrawerBodyItem({required IconData icon, required String text, GestureTapCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      title: Row(
        children: <Widget>[
          Icon(icon, color: Colors.white,),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
