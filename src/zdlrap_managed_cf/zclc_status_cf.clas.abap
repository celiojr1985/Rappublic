CLASS zclc_status_cf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

        interfaces if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclc_status_cf IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

      types: tt_CARGA type table of  zdlrap_cer_st_cf with DEFAULT KEY .


    data(lt_CARGA) = value tt_CARGA(
        ( state_uuid = 1 cert_uuid  = 599 matnr      = 1 status = '03' status_old = '01' version = 1 )
        ( state_uuid = 2 cert_uuid  = 600 matnr      = 3 status = '03' status_old = '01' version = 1 )
        ( state_uuid = 3 cert_uuid  = 601 matnr      = 2 status = '03' status_old = '01' version = 1 )
         ).


    delete from  zdlrap_cer_st_cf.
    MODIFY  zdlrap_cer_st_cf from TABLE @lt_CARGA . commit work.

    out->write( 'Olá' ).

  ENDMETHOD.

ENDCLASS.
