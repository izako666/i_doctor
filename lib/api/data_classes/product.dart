class Product {
  final int id;
  final String catId;
  final String subcatId;
  final String spId;
  final String spbId;
  final String name;
  final String description;
  final String photo;
  final int active;
  final String spPrice;
  final dynamic spDiscountPercent;
  final dynamic spDiscountAmount;
  final String spTotal;
  final String idocPrice;
  final String idocDiscountAmt;
  final String idocNet;
  final String idocType;
  final String startDate;
  final String endDate;
  final int availablePurchases;
  final String createdAt;
  final String updatedAt;

  Product({
    required this.id,
    required this.catId,
    required this.subcatId,
    required this.spId,
    required this.spbId,
    required this.name,
    required this.description,
    required this.photo,
    required this.active,
    required this.spPrice,
    required this.spDiscountPercent,
    required this.spDiscountAmount,
    required this.spTotal,
    required this.idocPrice,
    required this.idocDiscountAmt,
    required this.idocNet,
    required this.idocType,
    required this.startDate,
    required this.endDate,
    required this.availablePurchases,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> data) {
    return Product(
        id: data['id'],
        catId: data['cat_id'],
        subcatId: data['subcat_id'],
        spId: data['sp_id'],
        spbId: data['spb_id'],
        name: data['Name'],
        description: data['Description'],
        photo: data['Photo'],
        active: data['active'],
        spPrice: data['sp_price'],
        spDiscountPercent: data['sp_discount_percent'],
        spDiscountAmount: data['sp_discount_amount'],
        spTotal: data['sp_total'],
        idocPrice: data['idoc_price'],
        idocDiscountAmt: data['idoc_discount_amount'],
        idocNet: data['idoc_net'],
        idocType: data['idoc_type'],
        startDate: data['start_date'],
        endDate: data['end_date'],
        availablePurchases: data['available_purchase'],
        createdAt: data['created_at'],
        updatedAt: data['updated_at']);
  }
}
