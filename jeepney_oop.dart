mixin Loggable {
  String get logTag;

  void log(String message) {
    print('[$logTag] $message');
  }
}


abstract class FareCollector {
  String get route;
  String get paymentMethod;
  double collectFare(int passengers);
}


class Jeepney {
  String route;
  int capacity;

  double _fare;

  Jeepney(this.route, this.capacity, this._fare);

  double get fare => _fare;

  set fare(double newFare) {
    if (newFare > 0) {
      _fare = newFare;
    }
  }

  void showDetails() {
    print('  Route    : $route');
    print('  Capacity : $capacity seats');
    print('  Fare     : ₱${_fare.toStringAsFixed(2)}');
  }
}


class TraditionalJeepney extends Jeepney implements FareCollector {
  TraditionalJeepney(String route, int capacity, double fare)
      : super(route, capacity, fare);

  @override
  String get paymentMethod => 'Cash';

  @override
  double collectFare(int passengers) {
    return passengers * fare;
  }

  @override
  void showDetails() {
    super.showDetails();
    print('  Type     : Traditional');
    print('  Payment  : $paymentMethod');
  }
}


class ModernJeepney extends Jeepney implements FareCollector {
  final double airconFee;

  ModernJeepney(String route, int capacity, double fare,
      {this.airconFee = 3.0})
      : super(route, capacity, fare);

  @override
  String get paymentMethod => 'Beep Card or Cash';

  @override
  double collectFare(int passengers) {
    return passengers * (fare + airconFee);
  }

  @override
  void showDetails() {
    super.showDetails();
    print('  Type     : Modern (E-Jeepney)');
    print('  Aircon   : +₱${airconFee.toStringAsFixed(2)} per passenger');
    print('  Payment  : $paymentMethod');
  }
}


class Driver with Loggable {
  final String name;

  Driver(this.name);

  @override
  String get logTag => 'Driver $name';

  void drive(FareCollector vehicle, int passengers) {
    log('Driving ${vehicle.route} with $passengers passengers');
    
    final total = vehicle.collectFare(passengers);
    log('Collected ₱${total.toStringAsFixed(2)} via ${vehicle.paymentMethod}');
  }
}

class Dispatcher with Loggable {
  @override
  String get logTag => 'Dispatcher';

  void dispatchAll(List<Jeepney> fleet) {
    for (final jeepney in fleet) {
      log('Sending out the jeepney for ${jeepney.route}');
    }
  }
}


void main() {
  final cubao = TraditionalJeepney('Cubao - Divisoria', 20, 13.0);
  final up = ModernJeepney('UP - Katipunan', 14, 12.0);

  final List<Jeepney> fleet = [cubao, up];

  print('JEEPNEY FLEET REPORT\n');
  for (int i = 0; i < fleet.length; i++) {
    print('Vehicle #${i + 1}');
    fleet[i].showDetails(); 
    print('');
  }

  print('Updating Fare for ${cubao.route}...');
  cubao.fare = 15.0;
  print('New Fare: ₱${cubao.fare.toStringAsFixed(2)}\n');

  print('--- Dispatch ---');
  Dispatcher().dispatchAll(fleet);

  print('\n--- On the Road ---');
  final driverA = Driver('Mang Berto');
  final driverB = Driver('Aling Cora');
  driverA.drive(cubao, 18);
  driverB.drive(up, 12);
}