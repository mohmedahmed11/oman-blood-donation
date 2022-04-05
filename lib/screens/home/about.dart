import 'package:blood_donation/constant.dart';
import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 10.0, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  Text(
                    "عن التطبيق",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
            // SizedBox(height: 20),
            Image.asset("images/obb-1.png"),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "هو تطبيق إلكتروني مجاني في سلطنة عمان ويعد الأول من نوعه في عُمان ، من خلاله تستطيع الوصول إلى المتبرعين بالدم والفصيلة التي تحتاجها بسهولة ويسر كما أنك تستطيع أن تساهم كمتبرع ، فعبر قاعدة البيانات المتاحة في التطبيق سوف يكون بإمكانك تحديد المحافظة والمستشفى ثم البحث عن أقرب متبرع يمكنه الوصول إليك",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
