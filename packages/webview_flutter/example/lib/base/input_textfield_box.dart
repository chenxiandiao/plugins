import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 输入框
/// @owner sariawang
/// @groupInfo [ComponentGroupInfo.input]
class TEInputTextFieldBox extends StatelessWidget {
  TEInputTextFieldBox(
      {this.placeHolderString = '输入内容',
      this.controller,
      this.onChanged,
      this.keyboardType = TextInputType.text,
      this.focusNode,
      this.textFontSize = 16.0,
      this.textFieldHeight = 52.0,
      this.horizonMargin = 16.0,
      this.autoFocus = false,
      this.obscureText = false,
      this.iconHeight = 18.0,
      this.iconWidth = 18.0,
      this.clearTextField,
      this.borderRadius = 10.0,
      this.padding,
      this.onSubmitted,
      this.name,
      this.showWordIndicator = false,
      this.showBorderColor = true,
      this.indicator, //显示计数，如1/3
      this.extraData,
      this.decoration,
      this.maxLength,
      this.maxLines,
      this.quickComment});

  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  /// 默认内容
  final String placeHolderString;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final FocusNode focusNode;
  final double textFontSize;
  final double textFieldHeight;
  final double horizonMargin;
  final EdgeInsets padding;
  final double iconWidth;
  final double iconHeight;
  final int maxLength;
  final int maxLines;

  /// 自动对焦
  final bool autoFocus;
  final bool obscureText;
  final VoidCallback clearTextField;
  final double borderRadius;

  /// 显示计数
  final Widget indicator;
  final bool showWordIndicator;
  final bool showBorderColor;
  final List<String> quickComment;

  final InputDecoration decoration;

  /// 控件名字
  final String name;

  /// 附加的上报信息
  final Map<String, dynamic> extraData;

  double flexible(BuildContext context, double val) {
    return val;
  }

  @override
  Widget build(BuildContext context) {
//    const double textFontSize = 16.0;
//    const double textFieldHeight = 52.0;
//    const magicNumber = 8.0;
//    var panding = (textFieldHeight - textFontSize - magicNumber) / 2;

    final textStyle = TextStyle(
      fontSize: flexible(context, textFontSize),
      color: Colors.black,
      textBaseline: TextBaseline.alphabetic,
    );
    final placeTextStyle = TextStyle(
      fontSize: flexible(context, textFontSize),
      color: Colors.grey,
      textBaseline: TextBaseline.alphabetic,
    );

    bool _showClearButton() {
//      print('${clearTextField != null}, ${controller.text.length}');
      bool _origin = clearTextField != null && controller != null && controller.text.isNotEmpty;
      if (focusNode != null) {
        _origin = focusNode.hasFocus && _origin;
      }
      return _origin;
    }

    return GestureDetector(
      onTap: () {
        if (focusNode != null && !focusNode.hasFocus) {
          FocusScope.of(context).requestFocus(focusNode);
        }
      },
      child: Container(
        height: flexible(context, textFieldHeight),
        decoration: BoxDecoration(
          border: Border.all(color: showBorderColor ? const Color(0xffE7E7F2) : Colors.transparent),
          borderRadius: BorderRadius.circular(flexible(context, borderRadius)),
          color: Colors.white,
        ),
        margin: EdgeInsets.only(right: flexible(context, horizonMargin), left: flexible(context, horizonMargin)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: padding ?? EdgeInsets.only(left: flexible(context, 16.0)),
                child: TextField(
                  maxLines: maxLines,
                  autocorrect: false,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  controller: controller,
                  focusNode: focusNode,
                  style: textStyle,
                  maxLength: maxLength,
                  autofocus: autoFocus,
                  obscureText: obscureText,
                  decoration: decoration ??
                      InputDecoration.collapsed(
                        hintStyle: placeTextStyle,
                        hintText: placeHolderString,
                      ),
                ),
              ),
            ),
            if (showWordIndicator && indicator != null)
              Container(
                width: flexible(context, 60.0),
                height: flexible(context, 44.0),
                padding: EdgeInsets.only(right: flexible(context, 16.0)),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: indicator,
                ),
              )
            else
              SizedBox(),
            if (quickComment != null && quickComment.isNotEmpty)
              Container(
                child: Wrap(
                  spacing: 8.0, // 主轴(水平)方向间距
                  runSpacing: 4.0, // 纵轴（垂直）方向间距
                  alignment: WrapAlignment.start,
                  children: quickComment.map((text) {
                    return Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(text),
                    );
                  }).toList(),
                ),
              )
            else
              SizedBox()
          ],
        ),
      ),
    );
  }
}
