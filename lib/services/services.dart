import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
int command = 0;

// Metodo para iniciar sesion
Future<void> login(String user, String password, context) async {
  try {
    QuerySnapshot getUser = await db
        .collection('user')
        .where('password', isEqualTo: password)
        .where('user', isEqualTo: user)
        .get();

    print(getUser.docs[0]['role']);

    if (getUser.docs.isNotEmpty) {
      String user = getUser.docs[0]['user'];
      String role = getUser.docs[0]['role'];
      String name = getUser.docs[0]['name'];
      int idUser = getUser.docs[0]['id_user'];

      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('user', user);
      await preferences.setString('name', name);
      await preferences.setInt('id_user', idUser);

      if (role == 'host') {
        Navigator.pushReplacementNamed(context, '/host');
      } else if (role == 'corredor') {
        Navigator.pushReplacementNamed(context, '/clean');
      } else if (role == 'mesero') {
        Navigator.pushReplacementNamed(context, '/waiter');
      } else if (role == 'cocina') {
        Navigator.pushReplacementNamed(context, '/kitchen');
      } else if (role == 'caja') {
        Navigator.pushReplacementNamed(context, '/payment');
      } else if (role == 'administrador') {
        Navigator.pushReplacementNamed(context, '/admin');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Tus datos son incorrectos, por favor revíselos para poder iniciar sesión',
            style: TextStyle(fontSize: 16),
          ),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.pink));
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        'Contraseña y/o usuario incorrectos intentelo de nuevo',
        style: TextStyle(fontSize: 18),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.pink,
    ));
  }
}

Future<QuerySnapshot?> getTables() async {
  CollectionReference tablesCol = db.collection('table');

  try {
    QuerySnapshot result = await tablesCol.orderBy('id_table').get();
    return result;
  } catch (e) {
    return null;
  }
}

Future<void> updateTable(int idTable, String name, int status) async {
  QuerySnapshot tableDoc =
      await db.collection('table').where('id_table', isEqualTo: idTable).get();

  // Método para hacer la modificación en la tabla
  try {
    if (tableDoc.docs.isNotEmpty) {
      for (var doc in tableDoc.docs) {
        print(doc.id);
        String documentId = doc.id;
        DocumentReference docTable = db.collection('table').doc(documentId);
        if (name == '') {
          await docTable.update({'status': status});
        } else {
          await docTable.update({'customer_name': name, 'status': status});
        }
      }
    }
  } catch (error) {
    print(error);
  }
}

void countCommand() async {
  // Método que uso para obtener el numero de comanda
  QuerySnapshot countCommand = await db.collection('settings').get();

  // Método que uso para obtener el documento a modificar
  DocumentReference docUpdate =
      db.collection('settings').doc('wen3E5guNrUzJJa1GiIP');

  // Método que utilizo para aumentar aumentar en uno la comanda
  int count = countCommand.docs[0]['count_command'];
  count++;

  // Método para actualizar la comanda
  await docUpdate.update({'count_command': count});
}

// Métodos de asignación del host
Future<Color> assignColorHost(int status) async {
  switch (status) {
    case 1:
      return Colors.green.shade200;
    case 2:
      return Colors.pink.shade400;
    case 3:
      return Colors.red.shade400;
    case 4:
      return Colors.purple.shade200;
    case 5:
      return Colors.blue.shade300;
    default:
      return Colors.pink.shade100;
  }
}

Future<Icon> assignIconHost(int status) async {
  switch (status) {
    case 1:
      return const Icon(Icons.table_restaurant, size: 30, color: Colors.white);
    case 2:
      return const Icon(Icons.family_restroom, size: 30, color: Colors.white);
    case 3:
      return const Icon(Icons.fastfood, size: 30, color: Colors.white);
    case 4:
      return const Icon(Icons.attach_money, size: 30, color: Colors.white);
    case 5:
      return const Icon(Icons.clean_hands, size: 30, color: Colors.white);
    default:
      return const Icon(Icons.table_restaurant, size: 30, color: Colors.white);
  }
}

// Métodos de asignación del personal de limpieza
Future<bool> getTablesCleaning(int idClean, int idTable) async {
  CollectionReference tablesCol = db.collection('table');

  try {
    QuerySnapshot result = await tablesCol
        .where('id_clean', isEqualTo: idClean)
        .where('id_table', isEqualTo: idTable)
        .get();

    if (result.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<Color> assignColor(int status, int idTable, int idClean) async {
  bool isClean = await getTablesCleaning(idClean, idTable);

  if (isClean) {
    switch (status) {
      case 1:
        return Colors.green.shade200;
      case 2:
        return Colors.pink.shade400;
      case 3:
        return Colors.red.shade400;
      case 4:
        return Colors.purple.shade200;
      case 5:
        return Colors.blue.shade300;
      default:
        return Colors.pink.shade100;
    }
  } else {
    return Colors.pink.shade100;
  }
}

Future<Icon> assignIcon(int status, int idTable, idClean) async {
  bool isClean = await getTablesCleaning(idClean, idTable);

  if (isClean) {
    switch (status) {
      case 1:
        return const Icon(Icons.table_restaurant,
            size: 30, color: Colors.white);
      case 2:
        return const Icon(Icons.family_restroom, size: 30, color: Colors.white);
      case 3:
        return const Icon(Icons.fastfood, size: 30, color: Colors.white);
      case 4:
        return const Icon(Icons.attach_money, size: 30, color: Colors.white);
      case 5:
        return const Icon(Icons.clean_hands, size: 30, color: Colors.white);
      default:
        return const Icon(Icons.table_restaurant,
            size: 30, color: Colors.white);
    }
  } else {
    return const Icon(
      Icons.cancel_outlined,
      size: 30,
      color: Colors.white70,
    );
  }
}

// Métodos de asignación de los meseros
Future<bool> getTablesWaiter(int idClean, int idTable) async {
  CollectionReference tablesCol = db.collection('table');

  try {
    QuerySnapshot result = await tablesCol
        .where('id_waiter', isEqualTo: idClean)
        .where('id_table', isEqualTo: idTable)
        .get();

    if (result.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<Color> assignColorWaiter(int status, int idTable, int idWaiter) async {
  bool isWaiter = await getTablesWaiter(idWaiter, idTable);
  print(status);
  print(isWaiter);

  if (isWaiter) {
    switch (status) {
      case 1:
        return Colors.green.shade200;
      case 2:
        return Colors.pink.shade400;
      case 3:
        return Colors.red.shade400;
      case 4:
        return Colors.purple.shade200;
      case 5:
        return Colors.blue.shade300;
      default:
        return Colors.pink.shade100;
    }
  } else {
    return Colors.pink.shade100;
  }
}

Future<Icon> assignIconWaiter(int status, int idTable, idWaiter) async {
  bool isWaiter = await getTablesWaiter(idWaiter, idTable);

  if (isWaiter) {
    switch (status) {
      case 1:
        return const Icon(Icons.table_restaurant,
            size: 30, color: Colors.white);
      case 2:
        return const Icon(Icons.family_restroom, size: 30, color: Colors.white);
      case 3:
        return const Icon(Icons.fastfood, size: 30, color: Colors.white);
      case 4:
        return const Icon(Icons.attach_money, size: 30, color: Colors.white);
      case 5:
        return const Icon(Icons.clean_hands, size: 30, color: Colors.white);
      default:
        return const Icon(Icons.table_restaurant,
            size: 30, color: Colors.white);
    }
  } else {
    return const Icon(
      Icons.cancel_outlined,
      size: 30,
      color: Colors.white70,
    );
  }
}

// Esta función la hago para mostrar alertas informativas sin tener que utilizar demasiado código en las clases de mis pantallas
void showInfoDialog(
    BuildContext context, Text title, Text description, Color color) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: color,
        ),
        child: AlertDialog(
          title: title,
          content: description,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: Colors.white),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    },
  );
}

// Funciones para el modulo de meseros
Future<QuerySnapshot?> getMenu() async {
  CollectionReference tablesCol = db.collection('products');

  try {
    QuerySnapshot result = await tablesCol.get();
    return result;
  } catch (e) {
    return null;
  }
}

void showAddOrder(
    BuildContext context,
    Map<String, dynamic> item,
    TextEditingController _controllerQuantity,
    TextEditingController _controllerOption,
    int idTable) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Nombre del cliente'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controllerQuantity,
              decoration: const InputDecoration(
                hintText: 'Ingresa la cantidad del producto: ',
              ),
            ),
            TextField(
              controller: _controllerOption,
              decoration: const InputDecoration(
                hintText: 'Ingresa la opción del producto: ',
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              String quantityText = _controllerQuantity.text;
              int quantity = int.parse(quantityText);
              String option = _controllerOption.text;

              addOrder(item, option, quantity, idTable);
              updateTable(idTable, '', 3);
              Navigator.of(context).pop();
            },
            child: const Text('Enviar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}

Future<void> addOrder(
    Map<String, dynamic> item, String option, int quantity, int idTable) async {
  Timestamp time = Timestamp.now();

  await db.collection('order').add({
    'food': item['nombre'],
    'opcion': option,
    'cantidad': quantity,
    'status': 1,
    'id_table': idTable,
    'total': item['precio'] * quantity,
    'fecha': time
  });
}

// Funciones para el modulo de cocina
Future<QuerySnapshot?> getOrders(int idTable) async {
  CollectionReference tablesCol = db.collection('order');

  try {
    QuerySnapshot result = await tablesCol
        .where('status', isEqualTo: 1)
        .where('id_table', isEqualTo: idTable)
        .get();
    return result;
  } catch (e) {
    return null;
  }
}

void showOrderKitchen(
    BuildContext context, int idTable, Map<String, dynamic> item) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Entregar pedido a la mesa'),
        content: const Text(
            'Los clientes de la mesa han pedido estos alimentos por favor cocinarlos y entregarlos'),
        actions: [
          ElevatedButton(
            onPressed: () {
              deliverFood(idTable, item);
              Navigator.of(context).pop();
            },
            child: const Text('Enviar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}

// Actualiza la orden para entregar la comida
void deliverFood(int idTable, Map<String, dynamic> item) async {
  QuerySnapshot tableDoc = await db
      .collection('order')
      .where('id_table', isEqualTo: idTable)
      .where('food', isEqualTo: item['food'])
      .where('opcion', isEqualTo: item['opcion'])
      .where('cantidad', isEqualTo: item['cantidad'])
      .where('status', isEqualTo: 1)
      .get();

  // Método para hacer la modificación en la tabla
  if (tableDoc.docs.isNotEmpty) {
    for (var doc in tableDoc.docs) {
      String documentId = doc.id;
      DocumentReference docTable = db.collection('order').doc(documentId);

      await docTable.update({'status': 2});
    }
  }
}

Future<double> paymentOrder(int idTable) async {
  QuerySnapshot result = await db
      .collection('order')
      .where('id_table', isEqualTo: idTable)
      .where('status', isEqualTo: 2)
      .get();

  if (result.docs.isNotEmpty) {
    List<Map<String, dynamic>> paymentList = result.docs.map((doc) {
      return doc.data() as Map<String, dynamic>;
    }).toList();

    double payment = 0;
    for (int i = 0; i < paymentList.length; i++) {
      payment += paymentList[i]['total'];
    }

    return payment;
  } else {
    return 0;
  }
}

void closeDay() async {
  DocumentReference docUpdate =
      db.collection('settings').doc('wen3E5guNrUzJJa1GiIP');

  await docUpdate.update({'count_command': 0});
}
