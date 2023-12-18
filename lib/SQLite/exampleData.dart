import 'dart:math';

import 'package:intl/intl.dart';
import 'package:planner/JsonModels/usuarios.dart';
import 'package:planner/SQLite/sqlite.dart';
import 'package:planner/userSession.dart';

class DataGenerator {
  final db = DatabaseHelper();
  int userId = UserSession.getID();
  DateTime today = DateTime.now();
  


  Future<void> generateExampleData() async {
    //await _createExampleUsers();
    Random rand = Random();
    int randomID = 1001 + rand.nextInt(99999 - 1001 + 1);
    await _createExampleTaskBoards(randomID);
    await _createExampleTasks(randomID);
    print('Dados de exemplo foram inseridos no banco de dados.');
  }

  String getRandomDate() {
    DateTime now = DateTime.now();
    Random random = Random();
    int randomDay = random.nextInt(15) - 3;
    DateTime randomDate = DateTime(now.year, now.month, now.day + randomDay);
    String formattedDate = DateFormat('yyyy-MM-dd').format(randomDate);

    return formattedDate;
  }

  Future<void> _createExampleTaskBoards(int idd) async {
    await db.insertTaskBoardID(idd,'Exercícios', 8, 0, userId); //0
    await db.insertTaskBoardID(idd+1,'Mercado', 2, 6, userId); //1
    await db.insertTaskBoardID(idd+2,'Aniversários', 7, 8, userId); //2
    await db.insertTaskBoardID(idd+3,'Viagem', 3, 10, userId); //3
    await db.insertTaskBoardID(idd+4,'Estudos', 5, 2, userId); //4
    await db.insertTaskBoardID(idd+5,'Finanças', 1, 13, userId); //5
    await db.insertTaskBoardID(idd+6,'Médicos', 0, 3, userId); //6
  }

  Future<void> _createExampleTasks(int idd) async {
    //Exercicios
    await db.insertTask('30 min de exercícios', 'Correr, andar de bicicleta ou pular corda.', 1, '08:00', '08:30', getRandomDate(), idd, userId);
    await db.insertTask('Treino de musculação', 'Treino focado nos principais grupos musculares.', 0, '12:00', '13:00', getRandomDate(), idd, userId);
    await db.insertTask('Alongamento', 'Realizar exercícios de alongamento para melhorar a flexibilidade.', 0, '16:00', '16:30', getRandomDate(), idd, userId);
    await db.insertTask('Aula de ioga', 'Participar de uma aula de ioga para melhorar flexibilidade e relaxamento.', 0, '16:00', '17:00', getRandomDate(), idd, userId);
    await db.insertTask('Exercícios aeróbicos em casa', 'Realizar uma rotina de exercícios aeróbicos em casa.', 0, '09:00', '09:30', getRandomDate(), idd, userId);
    await db.insertTask('Natação', 'Ir à piscina local para uma sessão de natação.', 0, '18:00', '19:00', getRandomDate(), idd, userId);
    await db.insertTask('Caminhada no parque', 'Fazer uma caminhada revigorante no parque.', 1, '15:00', '16:00', getRandomDate(), idd, userId);
    await db.insertTask('Aula de dança', 'Participar de uma aula de dança para se exercitar de forma divertida.', 1, '19:00', '20:00', getRandomDate(), idd, userId);
    //mercado
    await db.insertTask('Compras mensais', 'Reabastecer itens essenciais para o mês.', 1, '09:00', '11:00', getRandomDate(), idd+1, userId);
    await db.insertTask('Comprar vegetais frescos', 'Certifique-se de obter uma variedade de vegetais para refeições saudáveis.', idd+1, '15:00', '16:00', getRandomDate(), idd+1, userId);
    await db.insertTask('Buscar carne no açougue', 'Comprar carne para as refeições da semana.', 1, '12:30', '13:30', getRandomDate(), idd+1, userId);
    await db.insertTask('Compras para festa', 'Preparar uma lista de compras para a festa deste fim de semana.', 0, '17:00', '18:00', getRandomDate(), idd+1, userId);
    //aniversario
    await db.insertTask('Planejar festa surpresa', 'Organizar detalhes para uma festa surpresa para o aniversariante.', 0, '15:00', '17:00', getRandomDate(), idd+2, userId);
    await db.insertTask('Comprar presente', 'Escolher um presente especial para o aniversariante.', 1, '12:00', '13:00', getRandomDate(), idd+2, userId);
    //viagem
    await db.insertTask('Ir para o aeroporto', 'Planejar a ida para o aeroporto e chegar a tempo para o voo.', 0, '06:00', '07:00', getRandomDate(), idd+3, userId);
    //Estudos
    await db.insertTask('Ler livro', 'Dedique um tempo para leitura de um livro interessante.', 1, '10:00', '11:30', getRandomDate(), idd+4, userId);
    await db.insertTask('Estudar para prova', 'Revisar os tópicos importantes para a próxima prova.', 0, '14:00', '16:00', getRandomDate(), idd+4, userId);
    await db.insertTask('Praticar programação', 'Resolver problemas de programação para aprimorar habilidades.', 1, '18:00', '19:30', getRandomDate(), idd+4, userId);
    await db.insertTask('Assistir aulas online', 'Participar de aulas virtuais para aprendizado contínuo.', 0, '13:30', '15:00', getRandomDate(), idd+4, userId);
    await db.insertTask('Fazer resumos', 'Criar resumos para melhorar a compreensão dos tópicos estudados.', 1, '20:00', '21:30', getRandomDate(), idd+4, userId);
    //Financas
    await db.insertTask('Pagar conta de luz', 'Certifique-se de pagar a conta de luz até a data de vencimento.', 0, '12:00', '12:30', getRandomDate(), idd+5, userId);
    await db.insertTask('Pagar aluguel', 'Efetuar o pagamento do aluguel até a data estabelecida.', 0, '09:00', '09:30', getRandomDate(), idd+5, userId);
    await db.insertTask('Renovar assinatura', 'Renovar assinatura de serviços como streaming, internet, etc.', 0, '15:00', '15:30', getRandomDate(), idd+5, userId);
    await db.insertTask('Poupar dinheiro', 'Transferir uma quantia para a conta de poupança ou investimentos.', 1, '20:00', '20:30', getRandomDate(), idd+5, userId);
    await db.insertTask('Registrar despesas', 'Atualizar o registro de despesas mensais no aplicativo financeiro.', 1, '16:00', '16:30', getRandomDate(), idd+5, userId);
    await db.insertTask('Pagar plano de saúde', 'Garantir o pagamento do plano de saúde mensal.', 0, '11:00', '11:30', getRandomDate(), idd+5, userId);
    await db.insertTask('Contribuir a aposentadoria', 'Realizar contribuição para a previdência ou plano de aposentadoria.', 0, '19:00', '19:30', getRandomDate(), idd+5, userId);
    await db.insertTask('Avaliar investimentos', 'Revisar e ajustar a carteira de investimentos conforme necessário.', 1, '17:00', '17:30', getRandomDate(), idd+5, userId);
    // medico
    await db.insertTask('Consulta cardiologista', 'Realizar consulta de rotina com o cardiologista.', 0, '10:00', '10:30', getRandomDate(), idd+6, userId);
    await db.insertTask('Agendar exame de sangue', 'Marcar data para realização de exame de sangue.', 1, '14:00', '14:30', getRandomDate(), idd+6, userId);
    await db.insertTask('Consulta oftalmologista', 'Realizar exame de vista e verificar a saúde ocular.', 1, '16:00', '16:30', getRandomDate(), idd+6, userId);
    await db.insertTask('Comprar medicamento', 'Adquirir medicamentos para tratar os sintomas da gripe.', 0, '12:00', '12:30', getRandomDate(), idd+6, userId);
    await db.insertTask('Tomar antibiótico', 'Seguir prescrição médica e tomar antibiótico conforme orientação.', 0, '18:00', '18:30', getRandomDate(), idd+6, userId);
    await db.insertTask('Remédio para pressão', 'Adquirir medicamento para controle da pressão arterial.', 0, '09:00', '09:30', getRandomDate(), idd+6, userId);
    await db.insertTask('Agendar consulta', 'Marcar consulta com médico especializado conforme recomendação médica.', 0, '15:00', '15:30', getRandomDate(), idd+6, userId);
    await db.insertTask('Renovar receita médica', 'Agendar consulta para renovar receita médica de uso contínuo.', 1, '20:00', '20:30', getRandomDate(), idd+6, userId);
    await db.insertTask('Realizar exame', 'Agendar e realizar exames de check-up para avaliação geral da saúde.', 0, '14:00', '14:30', getRandomDate(), idd+6, userId);

  }
}