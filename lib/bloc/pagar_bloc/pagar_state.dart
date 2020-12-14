part of 'pagar_bloc.dart';

@immutable
class PagarState {
  final double montoPagar;
  final String moneda;
  final bool tarjetaActiva;
  final TarjetaCredito tarjeta;

  PagarState({
    this.montoPagar = 375.55,
    this.moneda = "PEN", 
    this.tarjetaActiva = false, 
    this.tarjeta
  });
  String get montoPagarString => '${ (this.montoPagar * 100).floor() }';
  
  PagarState copyWith({
    String montoPagar,
    String moneda,
    bool tarjetaActiva,
    TarjetaCredito tarjeta,
  }){
    return PagarState(
      montoPagar: montoPagar ?? this.montoPagar,
      moneda: moneda ?? this.moneda,
      tarjetaActiva: tarjetaActiva ?? this.tarjetaActiva,
      tarjeta: tarjeta ?? this.tarjeta,
    );
  }
}
