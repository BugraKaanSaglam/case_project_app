import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Text dbError(BuildContext context) => Text('error'.tr(), style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis);
