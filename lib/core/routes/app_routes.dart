import 'package:flutter/material.dart';
import 'package:masterstudy_app/presentation/screens/auth/auth_screen.dart';
import 'package:masterstudy_app/presentation/screens/category_detail/category_detail_screen.dart';
import 'package:masterstudy_app/presentation/screens/change_password/change_password_screen.dart';
import 'package:masterstudy_app/presentation/screens/course_detail/course_detail_screen.dart';
import 'package:masterstudy_app/presentation/screens/detail_profile/detail_profile_screen.dart';
import 'package:masterstudy_app/presentation/screens/final/final_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/assignment/assignment_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/lesson_stream/lesson_stream_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/quiz_lesson/quiz_lesson_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/quiz_lesson/widgets/quiz_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/text_lesson/text_lesson_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/video_lesson/lesson_video_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/video_lesson/widgets/video_screen.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/zoom_lesson/zoom.dart';
import 'package:masterstudy_app/presentation/screens/main_screens.dart';
import 'package:masterstudy_app/presentation/screens/orders/orders_screen.dart';
import 'package:masterstudy_app/presentation/screens/plans/plans_screen.dart';
import 'package:masterstudy_app/presentation/screens/profile_edit/profile_edit_screen.dart';
import 'package:masterstudy_app/presentation/screens/questions_screens/question_ask/question_ask_screen.dart';
import 'package:masterstudy_app/presentation/screens/questions_screens/question_details/question_details_screen.dart';
import 'package:masterstudy_app/presentation/screens/questions_screens/questions_tab/questions_tab_screen.dart';
import 'package:masterstudy_app/presentation/screens/restore_password/restore_password_screen.dart';
import 'package:masterstudy_app/presentation/screens/review_write/review_write_screen.dart';
import 'package:masterstudy_app/presentation/screens/search_detail/search_detail_screen.dart';
import 'package:masterstudy_app/presentation/screens/splash/splash_screen.dart';
import 'package:masterstudy_app/presentation/screens/user_course/user_course.dart';
import 'package:masterstudy_app/presentation/screens/user_course_locked/user_course_locked_screen.dart';
import 'package:masterstudy_app/presentation/screens/web_checkout/web_checkout_screen.dart';
import 'package:page_transition/page_transition.dart';

class AppRoutes {
  PageRoute generateRoute(RouteSettings routeSettings, BuildContext context) {
    switch (routeSettings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(),
        );
      case AuthScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => AuthScreen(),
          settings: routeSettings,
        );
      case MainScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => MainScreen(),
          settings: routeSettings,
        );
      case CourseScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => CourseScreen(),
          settings: routeSettings,
        );
      case SearchDetailScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => SearchDetailScreen(),
          settings: routeSettings,
        );
      case DetailProfileScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => DetailProfileScreen(),
          settings: routeSettings,
        );
      case ProfileEditScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ProfileEditScreen(),
          settings: routeSettings,
        );
      case CategoryDetailScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => CategoryDetailScreen(),
          settings: routeSettings,
        );
      case AssignmentScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => AssignmentScreen(),
          settings: routeSettings,
        );
      case ReviewWriteScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ReviewWriteScreen(),
          settings: routeSettings,
        );
      case UserCourseScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => UserCourseScreen(),
          settings: routeSettings,
        );
      case TextLessonScreen.routeName:
        return PageTransition(
          child: TextLessonScreen(),
          type: PageTransitionType.leftToRight,
          settings: routeSettings,
        );
      case LessonVideoScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => LessonVideoScreen(),
          settings: routeSettings,
        );
      case LessonStreamScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => LessonStreamScreen(),
          settings: routeSettings,
        );
      case VideoScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => VideoScreen(),
          settings: routeSettings,
        );
      case QuizLessonScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => QuizLessonScreen(),
          settings: routeSettings,
        );
      case QuestionsScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => QuestionsScreen(),
          settings: routeSettings,
        );
      case QuestionAskScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => QuestionAskScreen(),
          settings: routeSettings,
        );
      case QuestionDetailsScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => QuestionDetailsScreen(),
          settings: routeSettings,
        );
      case FinalScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => FinalScreen(),
          settings: routeSettings,
        );
      case QuizScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => QuizScreen(),
          settings: routeSettings,
        );
      case PlansScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => PlansScreen(),
          settings: routeSettings,
        );
      case WebCheckoutScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => WebCheckoutScreen(),
          settings: routeSettings,
        );
      case OrdersScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => OrdersScreen(),
          settings: routeSettings,
        );
      case UserCourseLockedScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => UserCourseLockedScreen(),
          settings: routeSettings,
        );
      case RestorePasswordScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => RestorePasswordScreen(),
          settings: routeSettings,
        );
      case ChangePasswordScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ChangePasswordScreen(),
          settings: routeSettings,
        );
      case LessonZoomScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => LessonZoomScreen(),
          settings: routeSettings,
        );

      default:
        return MaterialPageRoute(builder: (context) => SplashScreen());
    }
  }

  MaterialPageRoute? onUnknownRoute(RouteSettings settings, BuildContext context) {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return const SplashScreen();
      },
    );
  }
}
