CLASS zclc_products_cf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

        interfaces if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclc_products_cf IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

      types: tt_prd type table of zdlrap_prod_cf with DEFAULT KEY .


    data(lt_prd) = value tt_prd(
        ( MATNR = '000000001000000001'                       DESCRIPTION = 'Celular' language = 'P' )
        ( MATNR = '000000001000000002'                       DESCRIPTION = 'Capinha' language = 'P' )
        ( MATNR = '000000001000000003'                       DESCRIPTION = 'Televisao' language = 'P' )
        ( MATNR = '000000001000000004'                       DESCRIPTION = 'Garrafa'  language = 'P' )
        ( MATNR = '000000001000000001'                       DESCRIPTION = 'Celular' language = 'E' )
        ( MATNR = '000000001000000002'                       DESCRIPTION = 'Capinha' language = 'E' )
        ( MATNR = '000000001000000003'                       DESCRIPTION = 'Televisao' language = 'E' )
        ( MATNR = '000000001000000004'                      DESCRIPTION = 'Garrafa'  language = 'E' )

         ) .


    delete from zdlrap_prod_cf.
    MODIFY zdlrap_prod_cf from TABLE @lt_prd . commit work.

    out->write( 'Olá' ).

  ENDMETHOD.

ENDCLASS.
