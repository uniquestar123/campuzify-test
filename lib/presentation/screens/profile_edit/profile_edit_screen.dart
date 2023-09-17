import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/utils/utils.dart';
import 'package:masterstudy_app/data/models/account/account.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:masterstudy_app/presentation/screens/change_password/change_password_screen.dart';
import 'package:masterstudy_app/presentation/screens/splash/splash_screen.dart';
import 'package:masterstudy_app/presentation/widgets/dialog_author.dart';
import 'package:masterstudy_app/presentation/widgets/flutter_toast.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_dimensions.dart';
import 'package:masterstudy_app/theme/const_styles.dart';

class ProfileEditScreenArgs {
  ProfileEditScreenArgs(this.account);

  final Account? account;
}

class ProfileEditScreen extends StatelessWidget {
  ProfileEditScreen() : super();

  static const String routeName = '/profileEditScreen';

  @override
  Widget build(BuildContext context) {
    ProfileEditScreenArgs? args = ModalRoute.of(context)?.settings.arguments as ProfileEditScreenArgs;
    return BlocProvider(
      create: (context) => EditProfileBloc()..account = args.account!,
      child: _ProfileEditWidget(
        account: args.account,
      ),
    );
  }
}

class _ProfileEditWidget extends StatefulWidget {
  const _ProfileEditWidget({Key? key, this.account}) : super(key: key);

  final Account? account;

  @override
  State<StatefulWidget> createState() => _ProfileEditWidgetState();
}

class _ProfileEditWidgetState extends State<_ProfileEditWidget> {
  final _formKey = GlobalKey<FormState>();
  FocusNode myFocusNode = FocusNode();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _occupationController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _facebookController = TextEditingController();
  TextEditingController _twitterController = TextEditingController();
  TextEditingController _instagramController = TextEditingController();

  var enableInputs = true;
  var passwordVisible = false;
  File? _imageFile;

  @override
  void initState() {
    passwordVisible = true;
    _firstNameController.text = BlocProvider.of<EditProfileBloc>(context).account.meta!.firstName;
    _lastNameController.text = BlocProvider.of<EditProfileBloc>(context).account.meta!.lastName;
    _emailController.text = BlocProvider.of<EditProfileBloc>(context).account.email!;
    _bioController.text = BlocProvider.of<EditProfileBloc>(context).account.meta!.description;
    _occupationController.text = BlocProvider.of<EditProfileBloc>(context).account.meta!.position;
    _facebookController.text = BlocProvider.of<EditProfileBloc>(context).account.meta!.facebook;
    _twitterController.text = BlocProvider.of<EditProfileBloc>(context).account.meta!.twitter;
    _instagramController.text = BlocProvider.of<EditProfileBloc>(context).account.meta!.instagram;
    myFocusNode.dispose();

    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _occupationController.dispose();
    _passwordController.dispose();
    _facebookController.dispose();
    _twitterController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorApp.mainColor,
        centerTitle: true,
        title: Text(
          localizations.getLocalization('edit_profile_title'),
          style: kAppBarTextStyle,
        ),
      ),
      body: BlocListener<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (state is UpdatedEditProfileState) {
            BlocProvider.of<ProfileBloc>(context).add(FetchProfileEvent());

            showFlutterToast(
              title: localizations.getLocalization('profile_updated_message'),
            );
          }

          if (state is CloseEditProfileState) {
            BlocProvider.of<ProfileBloc>(context).add(FetchProfileEvent());

            showFlutterToast(
              title: localizations.getLocalization('profile_change_canceled'),
            );
          }

          if (state is SuccessDeleteAccountState) {
            preferences.remove(PreferencesName.demoMode);
            BlocProvider.of<ProfileBloc>(context).add(LogoutProfileEvent());
            Navigator.of(context).pushNamedAndRemoveUntil(
              SplashScreen.routeName,
              (Route<dynamic> route) => false,
            );
          }

          if (state is ErrorDeleteAccountState) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      localizations.getLocalization('error_dialog_title'),
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Colors.black, fontSize: 20.0),
                    ),
                    content: Text(
                      localizations.getLocalization('error_dialog_title'),
                      textScaleFactor: 1.0,
                    ),
                  );
                },
              ),
            );
          }
        },
        child: BlocBuilder<EditProfileBloc, EditProfileState>(
          builder: (context, state) {
            String userRole = '';
            enableInputs = !(state is LoadingEditProfileState);

            if (BlocProvider.of<EditProfileBloc>(context).account.roles!.isEmpty) {
              userRole = 'subscriber';
            } else {
              userRole = BlocProvider.of<EditProfileBloc>(context).account.roles![0];
            }
            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                          child: CircleAvatar(
                            radius: 50.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(60.0)),
                              child: CachedNetworkImage(
                                fit: BoxFit.contain,
                                imageUrl: widget.account!.avatarUrl!,
                                imageBuilder: (context, imageProvider) {
                                  if (_imageFile != null) {
                                    return Image.file(
                                      _imageFile!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    );
                                  }

                                  return Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                                placeholder: (context, url) => LoaderWidget(
                                  loaderColor: ColorApp.white,
                                ),
                                errorWidget: (context, url, error) {
                                  return SizedBox(
                                    width: 100.0,
                                    child: Image.asset(IconPath.emptyUser),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        if (_imageFile != null)
                          Positioned(
                            top: 10,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _imageFile = null;
                                });
                              },
                              child: Icon(
                                Icons.delete_forever_outlined,
                                color: ColorApp.lipstick,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Button "Change Photo"
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            side: BorderSide(color: ColorApp.secondaryColor),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(ColorApp.secondaryColor),
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(8)),
                      ),
                      onPressed: () async {
                        if (preferences.getBool(PreferencesName.demoMode) ?? false) {
                          showDialogError(context, localizations.getLocalization('demo_mode'));
                        } else {
                          XFile? image = await picker.pickImage(source: ImageSource.gallery);

                          if (image != null) {
                            setState(() {
                              _imageFile = File(image.path);
                            });
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              child: SvgPicture.asset(
                                IconPath.file,
                                color: Colors.white,
                              ),
                              width: 23,
                              height: 23,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              localizations.getLocalization('change_photo_button'),
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // FirstName
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                    child: TextFormField(
                      controller: _firstNameController,
                      enabled: enableInputs,
                      readOnly: preferences.getBool(PreferencesName.demoMode) ?? false,
                      cursorColor: ColorApp.mainColor,
                      decoration: InputDecoration(
                        labelText: localizations.getLocalization('first_name'),
                        filled: true,
                        labelStyle: TextStyle(
                          color: myFocusNode.hasFocus ? Colors.black : Colors.black,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorApp.mainColor, width: 2),
                        ),
                      ),
                    ),
                  ),
                  // LastName
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                    child: TextFormField(
                      controller: _lastNameController,
                      enabled: enableInputs,
                      readOnly: preferences.getBool(PreferencesName.demoMode) ?? false,
                      cursorColor: ColorApp.mainColor,
                      decoration: InputDecoration(
                        labelText: localizations.getLocalization('last_name'),
                        filled: true,
                        labelStyle: TextStyle(
                          color: myFocusNode.hasFocus ? Colors.black : Colors.black,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorApp.mainColor, width: 2),
                        ),
                      ),
                    ),
                  ),
                  // Occupation
                  userRole != 'subscriber'
                      ? Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                          child: TextFormField(
                            controller: _occupationController,
                            enabled: enableInputs,
                            readOnly: preferences.getBool(PreferencesName.demoMode) ?? false,
                            cursorColor: ColorApp.mainColor,
                            decoration: InputDecoration(
                              labelText: localizations.getLocalization('occupation'),
                              filled: true,
                              labelStyle: TextStyle(
                                color: myFocusNode.hasFocus ? Colors.black : Colors.black,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: ColorApp.mainColor, width: 2),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  // Email
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                    child: TextFormField(
                      controller: _emailController,
                      enabled: enableInputs,
                      validator: validateEmail,
                      readOnly: preferences.getBool(PreferencesName.demoMode) ?? false,
                      cursorColor: ColorApp.mainColor,
                      decoration: InputDecoration(
                        labelText: localizations.getLocalization('email_label_text'),
                        helperText: localizations.getLocalization('email_helper_text'),
                        filled: true,
                        labelStyle: TextStyle(
                          color: myFocusNode.hasFocus ? Colors.black : Colors.black,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorApp.mainColor, width: 2),
                        ),
                      ),
                    ),
                  ),
                  // Bio
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                    child: TextFormField(
                      controller: _bioController,
                      enabled: enableInputs,
                      maxLines: 5,
                      readOnly: preferences.getBool(PreferencesName.demoMode) ?? false,
                      textCapitalization: TextCapitalization.sentences,
                      cursorColor: ColorApp.mainColor,
                      decoration: InputDecoration(
                        labelText: localizations.getLocalization('bio'),
                        helperText: localizations.getLocalization('bio_helper'),
                        filled: true,
                        labelStyle: TextStyle(
                          color: myFocusNode.hasFocus ? Colors.black : Colors.black,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorApp.mainColor, width: 2),
                        ),
                      ),
                    ),
                  ),
                  // Facebook
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                    child: TextFormField(
                      controller: _facebookController,
                      enabled: enableInputs,
                      readOnly: preferences.getBool(PreferencesName.demoMode) ?? false,
                      cursorColor: ColorApp.mainColor,
                      decoration: InputDecoration(
                        labelText: 'Facebook',
                        hintText: localizations.getLocalization('enter_url'),
                        filled: true,
                        labelStyle: TextStyle(
                          color: myFocusNode.hasFocus ? Colors.black : Colors.black,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorApp.mainColor, width: 2),
                        ),
                      ),
                    ),
                  ),
                  // Twitter
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                    child: TextFormField(
                      controller: _twitterController,
                      enabled: enableInputs,
                      cursorColor: ColorApp.mainColor,
                      readOnly: preferences.getBool(PreferencesName.demoMode) ?? false,
                      decoration: InputDecoration(
                        labelText: 'Twitter',
                        hintText: localizations.getLocalization('enter_url'),
                        filled: true,
                        labelStyle: TextStyle(
                          color: myFocusNode.hasFocus ? Colors.black : Colors.black,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorApp.mainColor, width: 2),
                        ),
                      ),
                    ),
                  ),
                  // Instagram
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                    child: TextFormField(
                      controller: _instagramController,
                      enabled: enableInputs,
                      cursorColor: ColorApp.mainColor,
                      readOnly: preferences.getBool(PreferencesName.demoMode) ?? false,
                      decoration: InputDecoration(
                        labelText: 'Instagram',
                        hintText: localizations.getLocalization('enter_url'),
                        filled: true,
                        labelStyle: TextStyle(
                          color: myFocusNode.hasFocus ? Colors.black : Colors.black,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorApp.mainColor, width: 2),
                        ),
                      ),
                    ),
                  ),
                  // Button Save
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                    child: SizedBox(
                      height: kButtonHeight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorApp.mainColor,
                        ),
                        onPressed: state is LoadingEditProfileState
                            ? null
                            : () {
                                if (preferences.getBool(PreferencesName.demoMode) ?? false) {
                                  showDialogError(context, localizations.getLocalization('demo_mode'));
                                } else {
                                  if (_formKey.currentState!.validate()) {
                                    BlocProvider.of<EditProfileBloc>(context).add(
                                      SaveEvent(
                                        firstName: _firstNameController.text,
                                        lastName: _lastNameController.text,
                                        password: _passwordController.text,
                                        description: _bioController.text,
                                        position: _occupationController.text,
                                        facebook: _facebookController.text,
                                        twitter: _twitterController.text,
                                        instagram: _instagramController.text,
                                        photo: _imageFile,
                                      ),
                                    );
                                  }
                                }
                              },
                        child: state is LoadingEditProfileState
                            ? LoaderWidget()
                            : Text(
                                localizations.getLocalization('save_button'),
                                textScaleFactor: 1.0,
                              ),
                      ),
                    ),
                  ),
                  // Button Change Password
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      color: ColorApp.mainColor,
                      onPressed: () {
                        if (preferences.getBool(PreferencesName.demoMode) ?? false) {
                          showDialogError(context, localizations.getLocalization('demo_mode'));
                        } else {
                          Navigator.of(context).pushNamed(ChangePasswordScreen.routeName);
                        }
                      },
                      child: Text(
                        localizations.getLocalization('change_password'),
                      ),
                      textColor: Colors.white,
                    ),
                  ),
                  // Button Delete Account
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                    child: new MaterialButton(
                      minWidth: double.infinity,
                      color: Colors.red.shade600,
                      onPressed: () {
                        if (preferences.getBool(PreferencesName.demoMode) ?? false) {
                          showDialogError(context, localizations.getLocalization('demo_mode'));
                        } else {
                          _showDeleteAccountDialog(context, state);
                        }
                      },
                      child: Text(
                        localizations.getLocalization('delete_account'),
                      ),
                      textColor: Colors.white,
                    ),
                  ),
                  // Cancel button
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 18.0,
                      right: 18.0,
                    ),
                    child: TextButton(
                      child: Text(
                        localizations.getLocalization('cancel_button'),
                        textScaleFactor: 1.0,
                        style: TextStyle(color: ColorApp.mainColor),
                      ),
                      onPressed: () => BlocProvider.of<EditProfileBloc>(context).add(CloseScreenEvent()),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _showDeleteAccountDialog(BuildContext context, EditProfileState state) {
    AlertDialog alert = AlertDialog(
      title: Text(
        localizations.getLocalization('delete_account'),
        style: TextStyle(color: Colors.black, fontSize: 20.0),
      ),
      content: Text(
        localizations.getLocalization('delete_account_subscription'),
      ),
      actions: [
        TextButton(
          child: Text(
            localizations.getLocalization('cancel_button'),
            style: TextStyle(
              color: ColorApp.mainColor,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: state is LoadingDeleteAccountState
              ? LoaderWidget()
              : Text(
                  localizations.getLocalization('delete_account'),
                  textScaleFactor: 1.0,
                  style: TextStyle(color: ColorApp.mainColor),
                ),
          onPressed: state is LoadingDeleteAccountState
              ? null
              : () {
                  BlocProvider.of<EditProfileBloc>(context)
                      .add(DeleteAccountEvent(accountId: int.parse(widget.account!.id.toString())));
                },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
