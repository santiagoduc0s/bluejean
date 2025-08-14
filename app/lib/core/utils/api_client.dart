// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lune/core/exceptions/exceptions.dart';
import 'package:lune/core/utils/utils.dart';

class ApiClient {
  ApiClient({
    required this.baseUrl,
    this.enableLogging = false,
    http.Client? client,
    AppLogger? logger,
  }) : _client = client ?? http.Client(),
       _logger = logger ?? AppLogger.instance;

  final http.Client _client;

  final String baseUrl;
  late final void Function() onUnauthorized;
  late final Future<bool> Function() isAuthenticated;
  late final String? Function() getAccessToken;

  final bool enableLogging;

  final AppLogger _logger;

  Future<bool> get isNotAuthenticated async => !(await isAuthenticated());

  Future<Map<String, String>> getHeaders() async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (await isAuthenticated())
        'Authorization': 'Bearer ${getAccessToken()}',
    };
  }

  http.Response _handleResponse(http.Response response) {
    if (response.statusCode == 401) {
      onUnauthorized.call();
      throw InvalidCredentialException();
    }

    return response;
  }

  void _logRequest(
    String method,
    Uri uri,
    Map<String, String> headers, [
    dynamic body,
  ]) {
    if (!enableLogging) return;
    String formattedHeaders;
    try {
      formattedHeaders = const JsonEncoder.withIndent('  ').convert(headers);
    } catch (e) {
      formattedHeaders = headers.entries
          .map((entry) => '  ${entry.key}: ${entry.value}')
          .join('\n');
    }

    var formattedBody = 'null';
    if (body != null) {
      try {
        final jsonObject = json.decode(body.toString());
        formattedBody = const JsonEncoder.withIndent('  ').convert(jsonObject);
      } catch (e) {
        formattedBody = body.toString();
      }
    }

    _logger.debug(
      [
        'REQUEST >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>',
        'Method: $method',
        'URI: $uri',
        'Headers:',
        formattedHeaders,
        'Body:',
        formattedBody,
      ].join('\n'),
    );
  }

  void _logResponse(http.Response response) {
    if (!enableLogging) return;

    var formattedBody = response.body;
    try {
      final jsonObject = json.decode(response.body);
      formattedBody = const JsonEncoder.withIndent('  ').convert(jsonObject);
      // ignore: empty_catches
    } catch (e) {}

    _logger.debug(
      [
        'RESPONSE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<',
        'Status Code: ${response.statusCode}',
        'Body:',
        formattedBody,
      ].join('\n'),
    );
  }

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? queryParameters,
    Map<String, String>? additionalHeaders,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);
    final requestHeaders = {...(await getHeaders()), ...?additionalHeaders};

    _logRequest('GET', uri, requestHeaders);
    final response = await _client.get(uri, headers: requestHeaders);
    _logResponse(response);

    return _handleResponse(response);
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? additionalHeaders,
  }) async {
    final uri = _buildUri(endpoint);
    final requestHeaders = {...(await getHeaders()), ...?additionalHeaders};
    final jsonBody = body != null ? json.encode(body) : null;

    _logRequest('POST', uri, requestHeaders, jsonBody);
    final response = await _client.post(
      uri,
      headers: requestHeaders,
      body: jsonBody,
    );
    _logResponse(response);

    return _handleResponse(response);
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? additionalHeaders,
  }) async {
    final uri = _buildUri(endpoint);
    final requestHeaders = {...(await getHeaders()), ...?additionalHeaders};
    final jsonBody = body != null ? json.encode(body) : null;

    _logRequest('PUT', uri, requestHeaders, jsonBody);
    final response = await _client.put(
      uri,
      headers: requestHeaders,
      body: jsonBody,
    );
    _logResponse(response);

    return _handleResponse(response);
  }

  Future<http.Response> delete(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? additionalHeaders,
  }) async {
    final uri = _buildUri(endpoint);
    final requestHeaders = {...(await getHeaders()), ...?additionalHeaders};
    final jsonBody = body != null ? json.encode(body) : null;

    _logRequest('DELETE', uri, requestHeaders, jsonBody);
    final response = await _client.delete(
      uri,
      headers: requestHeaders,
      body: jsonBody,
    );
    _logResponse(response);

    return _handleResponse(response);
  }

  Uri _buildUri(String endpoint, [Map<String, String>? queryParameters]) {
    final url = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    final cleanEndpoint =
        endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;

    return Uri.parse(
      '$url$cleanEndpoint',
    ).replace(queryParameters: queryParameters);
  }

  void dispose() {
    _client.close();
  }
}

extension ResponseExtension on http.Response {
  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  bool get isError => statusCode >= 400;

  bool get isUnauthorized => statusCode == 401;

  Map<String, dynamic> get jsonBody {
    if (body.isEmpty) return {};
    return json.decode(body) as Map<String, dynamic>;
  }
}
