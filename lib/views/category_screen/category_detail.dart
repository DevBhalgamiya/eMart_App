import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/consts/consts.dart';
import 'package:emart/controllers/product_controller.dart';
import 'package:emart/services/firestore_services.dart';
import 'package:emart/views/category_screen/item_details.dart';
import 'package:emart/widgets_common/bg_widget.dart';
import 'package:emart/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class CategoryDetails extends StatefulWidget {
  final String? title;
  const CategoryDetails({super.key, required this.title});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  @override
  void initState() {
    super.initState();
    switchCategory(widget.title);
  }

  switchCategory(title) {
    if (controller.subcat.contains(title)) {
      productMethod = FirestoreServices.getSubCategoryProduct(title);
    } else {
      productMethod = FirestoreServices.getProducts(title);
    }
  }

  var controller = Get.put(ProductController());
  dynamic productMethod;

  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: whiteColor),
        title: widget.title!.text.fontFamily(bold).white.make(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                controller.subcat.length,
                (index) => "${controller.subcat[index]}"
                    .text
                    .size(12)
                    .fontFamily(semibold)
                    .color(darkFontGrey)
                    .makeCentered()
                    .box
                    .white
                    .rounded
                    .size(120, 60)
                    .margin(const EdgeInsets.symmetric(horizontal: 4))
                    .make()
                    .onTap(() {
                  switchCategory("${controller.subcat[index]}");
                  setState(() {});
                }),
              ),
            ),
          ),
          20.heightBox,
          StreamBuilder(
            stream: productMethod,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Expanded(
                  child: Center(
                    child: loadingIndicator(),
                  ),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return Expanded(
                  child: "No products found!"
                      .text
                      .color(darkFontGrey)
                      .makeCentered(),
                );
              } else {
                var data = snapshot.data!.docs;
                return Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 250,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8),
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            data[index]['p_imgs'][0],
                            height: 150,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                          "${data[index]['p_name']}"
                              .text
                              .fontFamily(semibold)
                              .color(darkFontGrey)
                              .make(),
                          10.heightBox,
                          "${data[index]['p_price']}"
                              .numCurrency
                              .text
                              .color(redColor)
                              .fontFamily(bold)
                              .size(16)
                              .make()
                        ],
                      )
                          .box
                          .white
                          .margin(const EdgeInsets.symmetric(horizontal: 4))
                          .roundedSM
                          .outerShadowSm
                          .padding(const EdgeInsets.all(12))
                          .make()
                          .onTap(() {
                        controller.checkIfFav(data[index]);
                        Get.to(
                          () => ItemDetails(
                              title: "${data[index]['p_name']}",
                              data: data[index]),
                        );
                      });
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    ));
  }
}
