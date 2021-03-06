// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:music_flutter/bean/translate_json_entity.dart';
import 'package:music_flutter/generated/json/translate_json_entity_helper.dart';

class JsonConvert<T> {
	T fromJson(Map<String, dynamic> json) {
		return _getFromJson<T>(runtimeType, this, json);
	}  Map<String, dynamic> toJson() {
		return _getToJson<T>(runtimeType, this);
  }  static _getFromJson<T>(Type type, data, json) {
    switch (type) {			case TranslateJsonEntity:
			return translateJsonEntityFromJson(data as TranslateJsonEntity, json) as T;			case TranslateJsonWeb:
			return translateJsonWebFromJson(data as TranslateJsonWeb, json) as T;			case TranslateJsonDict:
			return translateJsonDictFromJson(data as TranslateJsonDict, json) as T;			case TranslateJsonWebdict:
			return translateJsonWebdictFromJson(data as TranslateJsonWebdict, json) as T;			case TranslateJsonBasic:
			return translateJsonBasicFromJson(data as TranslateJsonBasic, json) as T;    }
    return data as T;
  }  static _getToJson<T>(Type type, data) {
		switch (type) {			case TranslateJsonEntity:
			return translateJsonEntityToJson(data as TranslateJsonEntity);			case TranslateJsonWeb:
			return translateJsonWebToJson(data as TranslateJsonWeb);			case TranslateJsonDict:
			return translateJsonDictToJson(data as TranslateJsonDict);			case TranslateJsonWebdict:
			return translateJsonWebdictToJson(data as TranslateJsonWebdict);			case TranslateJsonBasic:
			return translateJsonBasicToJson(data as TranslateJsonBasic);    }
    return data as T;
  }  static T fromJsonAsT<T>(json) {
    switch (T.toString()) {			case 'TranslateJsonEntity':
			return TranslateJsonEntity().fromJson(json) as T;			case 'TranslateJsonWeb':
			return TranslateJsonWeb().fromJson(json) as T;			case 'TranslateJsonDict':
			return TranslateJsonDict().fromJson(json) as T;			case 'TranslateJsonWebdict':
			return TranslateJsonWebdict().fromJson(json) as T;			case 'TranslateJsonBasic':
			return TranslateJsonBasic().fromJson(json) as T;    }
    return null;
  }}