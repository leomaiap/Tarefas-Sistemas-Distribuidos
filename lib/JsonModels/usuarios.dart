//Aqui primeiro criamos o modelo JSON dos usuários

class Usuarios {
  final int? usrId;
  final String usrName;
  final String usrPassword;

  Usuarios({
    this.usrId,
    required this.usrName,
    required this.usrPassword,
  });

  factory Usuarios.fromMap(Map<String, dynamic> json) => Usuarios(
        usrId: json["usrId"],
        usrName: json["usrName"],
        usrPassword: json["usrPassword"],
      );

  Map<String, dynamic> toMap() => {
        "usrId": usrId,
        "usrName": usrName,
        "usrPassword": usrPassword,
      };
}
