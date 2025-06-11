CLASS zclc_certificados_cf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

        interfaces if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclc_certificados_cf IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

      types: tt_CERTIF type table of zdlrap_certifcf with DEFAULT KEY .


    data(lt_CER) = value tt_CERTIF(
        ( MATNR = 1 cert_uuid =  599 )
        ( MATNR = 3 cert_uuid =  600 )
        ( MATNR = 2 cert_uuid =  601 )
        ( MATNR = 4 cert_uuid =  602 )
        ( MATNR = 1 cert_uuid =  603 )
        ( MATNR = 3 cert_uuid =  604 )
        ( MATNR = 2 cert_uuid =  605 )
        ( MATNR = 4 cert_uuid =  606 )

         ) .


    delete from zdlrap_prod_cf.
    MODIFY zdlrap_certifcf from TABLE @lt_CER . commit work.

    out->write( 'Olá' ).

  ENDMETHOD.

ENDCLASS.
