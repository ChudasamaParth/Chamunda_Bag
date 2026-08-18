import 'package:chamunda_bag/data/product_data/office_bag.dart';
import 'package:chamunda_bag/data/product_data/school_bag.dart';

import '../../models/product_model.dart';

final Map<String, List<ProductModel>> categoryProducts = {
  "School": schoolBags,
  "Office": officeBags,
};
