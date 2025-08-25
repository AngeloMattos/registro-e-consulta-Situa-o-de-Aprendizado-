class Cliente {
  int? id;
  String nome;
  String email;

  Cliente({this.id, required this.nome, required this.email});

  @override
  String toString() => 'Cliente(id: $id, nome: $nome, email: $email)';
}


class Pedido {
  int? id;
  int clienteId;
  String descricao;
  double valor;

  Pedido({this.id, required this.clienteId, required this.descricao, required this.valor});

  @override
  String toString() =>
      'Pedido(id: $id, clienteId: $clienteId, descricao: $descricao, valor: $valor)';
}
