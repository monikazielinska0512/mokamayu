import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

Widget Gallery(BuildContext context, Map<String, Widget>? tab) {
  List<Tab>? tabs = tab?.keys
      .map((label) => Tab(
          child: Text(label,
              style: TextStyles.paragraphRegularSemiBold14(),
              textAlign: TextAlign.center)))
      .toList();
  return tabs == null
      ? Container()
      : MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Expanded(
            child: DefaultTabController(
              length: tabs.length,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TabBar(
                    padding: const EdgeInsets.only(top: 0, bottom: 5),
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorsConstants.peachy.withOpacity(0.3)),
                    indicatorColor: ColorsConstants.darkBrick,
                    labelStyle: TextStyles.paragraphRegular16(),
                    labelColor: ColorsConstants.darkBrick,
                    unselectedLabelColor: ColorsConstants.grey,
                    tabs: tabs,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: tab!.values
                          .map((widget) => Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: widget))
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
}
