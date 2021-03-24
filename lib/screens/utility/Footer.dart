import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

MaskFilter _blur;
final List<MaskFilter> _blurs = [
  null,
  MaskFilter.blur(BlurStyle.normal, 10.0),
  MaskFilter.blur(BlurStyle.inner, 10.0),
  MaskFilter.blur(BlurStyle.outer, 10.0),
  MaskFilter.blur(BlurStyle.solid, 16.0),
];
int _blurIndex = 0;
MaskFilter _nextBlur() {
  if (_blurIndex == _blurs.length - 1) {
    _blurIndex = 0;
  } else {
    _blurIndex = _blurIndex + 1;
  }
  _blur = _blurs[_blurIndex];
  return _blurs[_blurIndex];
}

class Footer extends StatelessWidget {
  const Footer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: RoundedDiagonalPathClipper(),
      child: Container(
        padding: EdgeInsets.only(left: 8, top: 37),
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(color: Colors.blue[600]),
        child: Container(
          child: Stack(children: [
            WaveWidget(
              config: CustomConfig(
                colors: [
                  Colors.blue[600],
                  Colors.orange[400],
                  Colors.orange[400],
                  Colors.orange[400],
                ],
                durations: [32000, 21000, 18000, 5000],
                heightPercentages: [-0.95, 1.6, 0.88, 0.84],
                blur: _blur,
              ),
              size: Size(double.infinity, 45),
              waveAmplitude: 15,
            ),
            Row(
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Image(
                    image: AssetImage('assets/image/ODFIFY copy.png'),
                    height: 280,
                    width: 280,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                    //padding: EdgeInsets.only(top: 45),
                    height: 105,
                    width: 95,
                    child: Image(image: AssetImage('assets/image/logo.png')))
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 29, top: 120),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Designed And Developed By Agrim Lab',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white54,
                        fontWeight: FontWeight.w300),
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
