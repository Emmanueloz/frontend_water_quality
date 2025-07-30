import 'package:frontend_water_quality/core/interface/response/base_response.dart';

class ListResponse<T> extends BaseResponse {
  final List<T> data;
  final int? total;
  final int? page;
  final int? limit;

  ListResponse({
    required this.data,
    this.total,
    this.page,
    this.limit,
    super.message,
    super.detail,
  });

  factory ListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ListResponse<T>(
      data: (json['data'] as List?)
              ?.map((item) => fromJsonT(item))
              .toList() ??
          [],
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      message: json['message'],
      detail: json['detail'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'total': total,
      'page': page,
      'limit': limit,
      'message': message,
      'detail': detail,
    };
  }
} 