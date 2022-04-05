import 'package:blood_donation/constant.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HowCanDonate extends StatelessWidget {
  const HowCanDonate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                        "من يمكنه أن يتبرع بالدم؟",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "يمكن لجميع الأشخاص التبرع بالدم في حال تمتعهم بصحة جيدة. وهناك بعض المتطلبات الأساسية التي لا بد من الوفاء بها للتبرع بالدم. ويرد أدناه بعض المبادئ التوجيهية الأساسية لأهلية التبرع بالدم:",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "السن",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "يتراوح عمر المتبرع بين 18 و65 سنة.",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "*- يسمح التشريع الوطني في بعض البلدان للأشخاص المتراوحة أعمارهم بين 16 و17 سنة بالتبرع بالدم شريطة أن يستوفوا المعايير البدنية والدموية اللازمة وأن يتسنى الحصول على الموافقة المناسبة.",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "*- يمكن قبول المتبرعين المنتظمين بالدم البالغة أعمارهم أكثر من 65 سنة في بعض البلدان حسب تقدير الطبيب المسؤول. والسن القصوى للتبرع بالدم في بعض البلدان هي 60 سنة.",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "الوزن",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "يبلغ وزن المتبرع 50 كيلوغراماً على الأقل.",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "الصحة",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "يجب على المتبرع التمتع بصحة جيدة عندما يتبرع بالدم.",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "لا يمكن للفرد التبرع بالدم إذا كان مصاباً بالزكام أو الأنفلونزا أو التهاب الحلق أو هربس الحمى أو وجع البطن أو أي عدوى أخرى.",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "ولا يجب على الفرد التبرع بالدم إن لم يبلغ مستوى الهيموغلوبين الأدنى المطلوب للتبرع بالدم",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "السفر",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "إن السفر إلى مناطق تتوطنها حالات العدوى المنقولة عن طريق البعوض مثل العدوى بالملاريا وحمى الضنك وفيروس زيكا يمكن أن يؤدي إلى وقف التبرع بالدم بصورة مؤقتة.",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "السلوك",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "لا يجب التبرع بالدم في الحالات التالية:",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "إذا مارس الفرد علاقات جنسية \"تُعرّض للخطر\" خلال فترة الاثني عشر شهراً الماضية",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "يوقف التبرع بالدم بصورة دائمة لدى الأفراد الذين يكون سلوكهم على النحو التالي:",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "الأفراد الذين حصلوا على نتائج إيجابية في فحص تحري فيروس العوز المناعي البشري (فيروس الإيدز)",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "الأفراد الذين تعاطوا مخدرات ترفيهية بالحقن.",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "الحمل والرضاعة الطبيعية",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "ينبغي أن تدوم فترة وقف التبرع بالدم بعد الحمل طوال عدد من الأشهر يساوي عدد أشهر فترة الحمل.",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "ويوصى بعدم التبرع بالدم أثناء الإرضاع. وتستغرق فترة وقف التبرع بالدم بعد الولادة 9 أشهر على الأقل (مثل فترة الحمل) وحتى 3 أشهر بعد أن يُفطم المولود بشكل ملحوظ (أي عندما يعتمد في تغذيته على الأغذية الصلبة أو التغذية بالزجاجات أساساً).",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "جميع هذه المعلومات تم نقلها من موقع منظمة الصحة العالمية",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          child: Text("اضغط هنا للتأكد!",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue)),
                          onTap: () async {
                            const url =
                                'https://www.who.int/ar/campaigns/world-blood-donor-day/2019/who-can-give-blood';
                            if (await canLaunch(url)) launch(url);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 20),
                //   child:
                // ),
              ]),
        ),
      ),
    );
  }
}
