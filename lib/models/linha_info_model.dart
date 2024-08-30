class LinhaOnibus {
  final int sequencial;
  final String numero;
  final String descricao;
  final String sentido;
  final double tarifa;

  LinhaOnibus({
    required this.sequencial,
    required this.numero,
    required this.descricao,
    required this.sentido,
    required this.tarifa,
  });

  factory LinhaOnibus.fromJson(Map<String, dynamic> json) {
    return LinhaOnibus(
      sequencial: json['sequencial'],
      numero: json['numero'],
      descricao: json['descricao'],
      sentido: json['sentido'],
      tarifa: json['faixaTarifaria']['tarifa'],
    );
  }
}
