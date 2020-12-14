import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:stripe_app/bloc/pagar_bloc/pagar_bloc.dart';

import 'package:stripe_app/data/tarjetas.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/pages/tarjeta_page.dart';
import 'package:stripe_app/widgets/total_pay_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_app/services/stripe_service.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final estado = context.bloc<PagarBloc>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagar'),
        actions: [
          IconButton(
            icon: Icon( Icons.add ), 
            onPressed: () async {
                
              StripeService service = new StripeService();
              final response = await service.pagarConNuevaTarjeta(
                amount: estado.montoPagarString, 
                currency: estado.moneda
              );
              if(response.exito){
                mostrarAlerta(context, "Pago realizado", "" );
              }else{
                mostrarAlerta(context, "Ocurrió un error", "" );
              }

            }
          )
        ],
      ),
      body: Stack(
        children: [


          Positioned(
            width: size.width,
            height: size.height,
            top: 200,
            child: PageView.builder(
              controller: PageController(
                viewportFraction: 0.9
              ),
              physics: BouncingScrollPhysics(),
              itemCount: tarjetas.length,
              itemBuilder: ( _, i ) {
                
                final tarjeta = tarjetas[i];
                
                
                return GestureDetector(
                  onTap: () {
                    context.bloc<PagarBloc>().add(OnSeleccionarTarjeta(tarjeta));
                    Navigator.push(context, navegarFadeIn(context, TarjetaPage() ));
                  },
                  child: Hero(
                    tag: tarjeta.cardNumber,
                    child: CreditCardWidget(
                      cardNumber: tarjeta.cardNumberHidden,
                      expiryDate: tarjeta.expiracyDate,
                      cardHolderName: tarjeta.cardHolderName,
                      cvvCode: tarjeta.cvv,
                      showBackView: false,
                    ),
                  ),
                );

              }
            ),
          ),


          Positioned(
            bottom: 0,
            child: TotalPayButton()
          )


          
        ],
      )
   );
  }
}