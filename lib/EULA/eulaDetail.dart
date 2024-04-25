import 'package:flutter/material.dart';

class EULADetail extends StatelessWidget {
  const EULADetail({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: const Text(
          '이용약관',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(screenSize.height * 0.02),
            child: const Column(
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '최종 사용자 사용권 계약 (EULA)\n',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      TextSpan(
                        text:
                            '\n본 계약은 귀하(이하 "사용자")와 통통 (이하 "회사") 간에 체결되는 법적 계약입니다. 본 서비스를 사용함으로써 사용자는 본 최종 사용자 사용권 계약(EULA)의 조건을 읽고 이에 동의한 것으로 간주됩니다. 사용자가 본 계약 조건에 동의하지 않는 경우, 서비스 사용을 즉시 중단할 수 있습니다.\n\n',
                        style: TextStyle(fontSize: 13),
                      ),
                      TextSpan(
                        text: '1. 사용 권한\n',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      TextSpan(
                        text:
                            '\n회사는 사용자에게 본 서비스를 개인적이고 비상업적인 용도로만 사용할 수 있는 비독점적이며 양도할 수 없는 권한을 부여합니다.\n\n',
                        style: TextStyle(fontSize: 13),
                      ),
                      TextSpan(
                        text: '2. 콘텐츠 사용 규정\n',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      TextSpan(
                        text:
                            '\n사용자는 서비스를 통해 공유되거나 생성되는 모든 콘텐츠에 대해 책임을 집니다. 회사는 다음과 같은 불쾌한 내용을 엄격히 금지합니다:\n- 폭력적 또는 위협적인 내용\n- 인종, 성별, 성적 취향, 종교 또는 국적에 대한 차별적인 발언\n- 불법적, 유해한 행위를 조장하는 내용\n- 저작권을 침해하는 내용\n- 개인의 프라이버시를 침해할 수 있는 내용\n위반 시 회사는 사용자의 서비스 이용을 즉시 중단시키고, 필요한 법적 조치를 취할 권리를 보유합니다.\n\n',
                        style: TextStyle(fontSize: 13),
                      ),
                      TextSpan(
                        text: '3. 계약의 해지\n',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      TextSpan(
                        text:
                            '\n회사는 사용자가 본 계약의 어떠한 조항을 위반했을 경우, 사전 통보 없이 사용자의 서비스 이용을 중단하고 계약을 해지할 권리를 보유합니다.\n\n',
                        style: TextStyle(fontSize: 13),
                      ),
                      TextSpan(
                        text: '4. 면책 조항\n',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      TextSpan(
                        text:
                            '\n회사는 서비스 이용 중 발생할 수 있는 어떠한 직접적, 간접적, 부수적, 특수적, 결과적 손해에 대해서도 책임을 지지 않습니다.\n\n',
                        style: TextStyle(fontSize: 13),
                      ),
                      TextSpan(
                        text: '5. 법적 근거\n',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      TextSpan(
                        text:
                            '\n본 계약은 대한민국의 법률에 의해 규제되고 해석됩니다. 본 계약에 관련된 모든 분쟁은 대한민국의 법원에 속합니다.',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
