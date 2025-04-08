import 'dart:convert';

class OrderResponse {
  bool status;
  List<OrderData> data;
  Pagination pagination;

  OrderResponse({
    required this.status,
    required this.data,
    required this.pagination,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      status: json['status'],
      data: List<OrderData>.from(json['data'].map((order) => OrderData.fromJson(order))),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

}

class OrderData {
  int id;
  String status;
  String? username;
  String? number; // Nullable String
  String userId;
  String bkashNumber;
  String trxid;
  String userdata;
  String? itemId; // Nullable String for item_id as it's either an int or null
  String itemtitle;
  String total; // Keeping this as a string, converting int to string dynamically
  String datetime;
  Map? api_response;
  String? created_at;
  String? updated_at;

  OrderData({
    required this.id,
    required this.status,
    this.username,
    this.number, // number is nullable, so it's marked as String?
    required this.userId,
    required this.bkashNumber,
    required this.trxid,
    required this.userdata,
    this.itemId, // Nullable field
    required this.itemtitle,
    required this.total, // Always treat total as string
    required this.datetime,
    this.api_response,
    this.created_at,
    this.updated_at,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'],
      status: json['status'],
      username: json['username'] ?? "",
      // Handling null and converting it to a String, if it's an int or null
      number: json['number'] != null ? json['number'].toString() : null,
      userId: json['user_id'],
      bkashNumber: json['bkash_number'],
      trxid: json['trxid'],
      userdata: json['userdata'],
      // itemId can be an int or null, convert to string or null
      itemId: json['item_id'] != null ? json['item_id'].toString() : null,
      itemtitle: json['itemtitle'],
      // Convert total to string, whether it's an int or string in JSON
      total: json['total'].toString(),
      datetime: json['datetime'].toString(),
      api_response: json['api_response'] != null ? jsonDecode(json['api_response']) : null,
      created_at: json['created_at'] ?? "",
      updated_at: json['updated_at'] ?? "",
    );
  }

}

class Pagination {
  int currentPage;
  int lastPage;
  int perPage;
  int total;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }
}
