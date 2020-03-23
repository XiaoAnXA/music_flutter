import 'package:music_flutter/generated/json/base/json_convert_content.dart';

class TranslateJsonEntity with JsonConvert<TranslateJsonEntity> {
	String tSpeakUrl;
	List<String> returnPhrase;
	List<TranslateJsonWeb> web;
	String query;
	List<String> translation;
	String errorCode;
	TranslateJsonDict dict;
	TranslateJsonWebdict webdict;
	TranslateJsonBasic basic;
	String l;
	String speakUrl;
}

class TranslateJsonWeb with JsonConvert<TranslateJsonWeb> {
	List<String> value;
	String key;
}

class TranslateJsonDict with JsonConvert<TranslateJsonDict> {
	String url;
}

class TranslateJsonWebdict with JsonConvert<TranslateJsonWebdict> {
	String url;
}

class TranslateJsonBasic with JsonConvert<TranslateJsonBasic> {
	List<String> explains;
}
