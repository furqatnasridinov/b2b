enum ProgressStatus { idle, inProgress, success, failure }

enum Role {
  buyer,
  supplier,
  admin,
}

extension RoleEx on Role {
  String get nameTr => switch (this) {
    Role.buyer => 'Заказчик',
    Role.supplier => 'Исполнитель',
    Role.admin => 'Администратор',
  };

  String get shortDescription => switch (this) {
    Role.buyer => 'Размещаю заказы и покупаю товары/услуги',
    Role.supplier => 'Предлагаю свои товары/услуги и откликаюсь на заказы',
    Role.admin => 'Управляю системой и пользователями',
  };
}

enum CatalogType {
  product,
  service,
}

extension CatalogTypeEx on CatalogType {

  String get nameTr => switch (this) {
    CatalogType.product => 'Товар',
    CatalogType.service => 'Услуга',
  };

  String get pluralName => switch (this) {
    CatalogType.product => 'Товары',
    CatalogType.service => 'Услуги',
  };
}

enum CatalogSort {
  defaultOrder,
  newest,
  priceLowToHigh,
  priceHighToLow,
  popular,
}

extension CatalogSortEx on CatalogSort {
  String get nameTr => switch (this) {
    CatalogSort.defaultOrder => 'По умолчанию',
    CatalogSort.newest => 'Сначала новые',
    CatalogSort.priceLowToHigh => 'Сначала дешевле',
    CatalogSort.priceHighToLow => 'Сначала дороже',
    CatalogSort.popular => 'По популярности',
  };

  String get description => switch (this) {
    CatalogSort.defaultOrder => 'В порядке выдачи',
    CatalogSort.newest => 'Недавно добавленные предложения',
    CatalogSort.priceLowToHigh => 'По возрастанию цены',
    CatalogSort.priceHighToLow => 'По убыванию цены',
    CatalogSort.popular => 'Больше просмотров и заявок',
  };
}

enum SupplierKind {
  individual,
  company,
}

extension SupplierKindEx on SupplierKind {
  String get nameTr => switch (this) {
    SupplierKind.individual => 'Физлицо',
    SupplierKind.company => 'Компания',
  };
}

