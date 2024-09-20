import 'package:emart/consts/consts.dart';

Widget orderStatus({icon, color, title, showDone}) {
  Color iconColor = color ?? Colors.black;
  return ListTile(
    leading: Icon(
      icon,
      color: iconColor,
    )
        .box
        .border(color: iconColor)
        .roundedSM
        .padding(const EdgeInsets.all(4))
        .make(),
    trailing: SizedBox(
      height: 100,
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          "$title".text.color(darkFontGrey).make(),
          showDone ? const Icon(Icons.done, color: redColor) : Container(),
        ],
      ),
    ),
  );
}
