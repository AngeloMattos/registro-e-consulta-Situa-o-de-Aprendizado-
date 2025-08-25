import 'package:mysql_client/mysql_client.dart';
import 'cliente.dart';

Future<void> main() async {
  
  final conn = await MySQLConnection.createConnection(
    host: "localhost",
    port: 3306,
    userName: "angelo",
    password: "senha",
    databaseName: "devs2blu",
    secure: false,

  );
  await conn.connect();
  print("Conectado ao MySQL");

  var cliente = Cliente(nome: "Angelo", email: "angelo@email.com");
  await conn.execute(
    "INSERT INTO clientes (nome, email) VALUES (:nome, :email)",
    {"nome": cliente.nome, "email": cliente.email},
  );
  print("👤 Cliente inserido: ${cliente.nome}");


  var pedido = Pedido(clienteId: 2, descricao: "Celular", valor: 5000.00);
  await conn.execute(
    "INSERT INTO pedidos (cliente_id, descricao, valor) VALUES (:cid, :desc, :val)",
    {"cid": pedido.clienteId, "desc": pedido.descricao, "val": pedido.valor},
  );
  print(" Pedido inserido: ${pedido.descricao}");

  print("\n Pedidos com dados do cliente:");
  var result1 = await conn.execute("""
    SELECT p.id, c.nome, c.email, p.descricao, p.valor
    FROM pedidos p
    JOIN clientes c ON c.id = p.cliente_id;
  """);
  for (var row in result1.rows) {
    print("Pedido ${row.colAt(0)} | Cliente: ${row.colAt(1)} | ${row.colAt(3)} - R\$${row.colAt(4)}");
  }

  // SELECT 2 – GROUP BY
  print("\n Resumo de gastos por cliente:");
  var result2 = await conn.execute("""
    SELECT c.nome, SUM(p.valor) as total
    FROM clientes c
    JOIN pedidos p ON c.id = p.cliente_id
    GROUP BY c.id, c.nome;
  """);
  for (var row in result2.rows) {
    print("${row.colAt(0)} gastou um total de R\$${row.colAt(1)}");
  }

  await conn.close();
}
