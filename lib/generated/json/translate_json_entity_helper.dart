import 'package:music_flutter/bean/translate_json_entity.dart';

translateJsonEntityFromJson(TranslateJsonEntity data, Map<String, dynamic> json) {
	if (json['tSpeakUrl'] != null) {
		data.tSpeakUrl = json['tSpeakUrl']?.toString();
	}
	if (json['returnPhrase'] != null) {
		data.returnPhrase = json['returnPhrase']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['web'] != null) {
		data.web = new List<TranslateJsonWeb>();
		(json['web'] as List).forEach((v) {
			data.web.add(new TranslateJsonWeb().fromJson(v));
		});
	}
	if (json['query'] != null) {
		data.query = json['query']?.toString();
	}
	if (json['translation'] != null) {
		data.translation = json['translation']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['errorCode'] != null) {
		data.errorCode = json['errorCode']?.toString();
	}
	if (json['dict'] != null) {
		data.dict = new TranslateJsonDict().fromJson(json['dict']);
	}
	if (json['webdict'] != null) {
		data.webdict = new TranslateJsonWebdict().fromJson(json['webdict']);
	}
	if (json['basic'] != null) {
		data.basic = new TranslateJsonBasic().fromJson(json['basic']);
	}
	if (json['l'] != null) {
		data.l = json['l']?.toString();
	}
	if (json['speakUrl'] != null) {
		data.speakUrl = json['speakUrl']?.toString();
	}
	return data;
}

Map<String, dynamic> translateJsonEntityToJson(TranslateJsonEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['tSpeakUrl'] = entity.tSpeakUrl;
	data['returnPhrase'] = entity.returnPhrase;
	if (entity.web != null) {
		data['web'] =  entity.web.map((v) => v.toJson()).toList();
	}
	data['query'] = entity.query;
	data['translation'] = entity.translation;
	data['errorCode'] = entity.errorCode;
	if (entity.dict != null) {
		data['dict'] = entity.dict.toJson();
	}
	if (entity.webdict != null) {
		data['webdict'] = entity.webdict.toJson();
	}
	if (entity.basic != null) {
		data['basic'] = entity.basic.toJson();
	}
	data['l'] = entity.l;
	data['speakUrl'] = entity.speakUrl;
	return data;
}

translateJsonWebFromJson(TranslateJsonWeb data, Map<String, dynamic> json) {
	if (json['value'] != null) {
		data.value = json['value']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['key'] != null) {
		data.key = json['key']?.toString();
	}
	return data;
}

Map<String, dynamic> translateJsonWebToJson(TranslateJsonWeb entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['value'] = entity.value;
	data['key'] = entity.key;
	return data;
}

translateJsonDictFromJson(TranslateJsonDict data, Map<String, dynamic> json) {
	if (json['url'] != null) {
		data.url = json['url']?.toString();
	}
	return data;
}

Map<String, dynamic> translateJsonDictToJson(TranslateJsonDict entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['url'] = entity.url;
	return data;
}

translateJsonWebdictFromJson(TranslateJsonWebdict data, Map<String, dynamic> json) {
	if (json['url'] != null) {
		data.url = json['url']?.toString();
	}
	return data;
}

Map<String, dynamic> translateJsonWebdictToJson(TranslateJsonWebdict entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['url'] = entity.url;
	return data;
}

translateJsonBasicFromJson(TranslateJsonBasic data, Map<String, dynamic> json) {
	if (json['explains'] != null) {
		data.explains = json['explains']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	return data;
}

Map<String, dynamic> translateJsonBasicToJson(TranslateJsonBasic entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['explains'] = entity.explains;
	return data;
}