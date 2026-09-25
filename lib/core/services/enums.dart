enum ProgressStatus { idle, inProgress, success, failure }

enum Role {
  buyer,
  supplier,
  admin,
}

extension RoleEx on Role {
  String get nameTr => switch (this) {
    Role.buyer => 'Исполнитель',
    Role.supplier => 'Поставщик',
    Role.admin => 'Администратор',
  };

  String get shortDescription => switch (this) {
    Role.buyer => 'Размещаю заказы и покупаю товары/услуги',
    Role.supplier => 'Предлагаю свои товары/услуги и откликаюсь на заказы',
    Role.admin => 'Управляю системой и пользователями',
  };
}