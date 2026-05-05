class GaleriaItemModel {
  const GaleriaItemModel({
    required this.remoteUrl,
    required this.localPath,
    required this.fileName,
  });

  final String remoteUrl;
  final String localPath;
  final String fileName;

  bool get hasRemote => remoteUrl.trim().isNotEmpty;
  bool get hasLocal => localPath.trim().isNotEmpty;
  bool get hasImage => hasRemote || hasLocal;

  factory GaleriaItemModel.empty() {
    return const GaleriaItemModel(
      remoteUrl: '',
      localPath: '',
      fileName: '',
    );
  }

  GaleriaItemModel copyWith({
    String? remoteUrl,
    String? localPath,
    String? fileName,
  }) {
    return GaleriaItemModel(
      remoteUrl: remoteUrl ?? this.remoteUrl,
      localPath: localPath ?? this.localPath,
      fileName: fileName ?? this.fileName,
    );
  }
}
