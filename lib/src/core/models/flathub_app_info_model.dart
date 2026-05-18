

class FlathubAppInfo {
  final String id;
  final String name;
  final String? summary;
  final String? description;
  final String? developerName;
  final String? projectLicense;
  final String? icon;
  final List<String>? categories;
  final List<String>? provides;
  final List<FlathubRelease>? releases;
  final FlathubBundle? bundle;
  final List<FlathubScreenshot>? screenshots;
  final List<FlathubIcon>? icons;
  final Map<String, dynamic>? urls;

  FlathubAppInfo({
    required this.id,
    required this.name,
    this.summary,
    this.description,
    this.developerName,
    this.projectLicense,
    this.icon,
    this.categories,
    this.provides,
    this.releases,
    this.bundle,
    this.screenshots,
    this.icons,
    this.urls,
  });

  factory FlathubAppInfo.fromJson(Map<String, dynamic> json) {
    return FlathubAppInfo(
      id: json['id'],
      name: json['name'],
      summary: json['summary'],
      description: json['description'],
      developerName: json['developer_name'],
      projectLicense: json['project_license'],
      icon: json['icon'],
      categories: (json['categories'] as List?)?.cast<String>(),
      provides: (json['provides'] as List?)?.cast<String>(),
      releases: (json['releases'] as List?)
          ?.map((e) => FlathubRelease.fromJson(e))
          .toList(),
      bundle: json['bundle'] != null ? FlathubBundle.fromJson(json['bundle']) : null,
      screenshots: (json['screenshots'] as List?)
          ?.map((e) => FlathubScreenshot.fromJson(e))
          .toList(),
      icons: (json['icons'] as List?)
          ?.map((e) => FlathubIcon.fromJson(e))
          .toList(),
      urls: json['urls'] as Map<String, dynamic>?,
    );
  }
}

class FlathubBundle {
  final String value;
  final String type;
  final String sdk;
  final String runtime;

  FlathubBundle({
    required this.value,
    required this.type,
    required this.sdk,
    required this.runtime,
  });

  factory FlathubBundle.fromJson(Map<String, dynamic> json) {
    return FlathubBundle(
      value: json['value'],
      type: json['type'],
      sdk: json['sdk'],
      runtime: json['runtime'],
    );
  }
}

class FlathubRelease {
  final String version;
  final String? type;
  final String? timestamp;

  FlathubRelease({
    required this.version,
    this.type,
    this.timestamp,
  });

  factory FlathubRelease.fromJson(Map<String, dynamic> json) {
    return FlathubRelease(
      version: json['version'],
      type: json['type'],
      timestamp: json['timestamp'],
    );
  }
}

class FlathubScreenshot {
  final List<FlathubScreenshotSize> sizes;
  final String? caption;
  final bool? isDefault;

  FlathubScreenshot({
    required this.sizes,
    this.caption,
    this.isDefault,
  });

  factory FlathubScreenshot.fromJson(Map<String, dynamic> json) {
    return FlathubScreenshot(
      sizes: (json['sizes'] as List)
          .map((e) => FlathubScreenshotSize.fromJson(e))
          .toList(),
      caption: json['caption'],
      isDefault: json['default'],
    );
  }
}

class FlathubScreenshotSize {
  final String scale;
  final String src;
  final String width;
  final String height;

  FlathubScreenshotSize({
    required this.scale,
    required this.src,
    required this.width,
    required this.height,
  });

  factory FlathubScreenshotSize.fromJson(Map<String, dynamic> json) {
    return FlathubScreenshotSize(
      scale: json['scale'],
      src: json['src'],
      width: json['width'],
      height: json['height'],
    );
  }
}

class FlathubIcon {
  final int? scale;
  final String url;
  final String type;
  final int width;
  final int height;

  FlathubIcon({
    this.scale,
    required this.url,
    required this.type,
    required this.width,
    required this.height,
  });

  factory FlathubIcon.fromJson(Map<String, dynamic> json) {
    return FlathubIcon(
      scale: json['scale'],
      url: json['url'],
      type: json['type'],
      width: json['width'],
      height: json['height'],
    );
  }
}