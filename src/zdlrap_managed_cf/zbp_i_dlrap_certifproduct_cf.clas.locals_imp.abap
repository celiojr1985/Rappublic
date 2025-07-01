CLASS lhc_Certificate DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Certificate RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Certificate RESULT result.

    METHODS setInitialValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Certificate~setInitialValues.

    METHODS checkMaterial FOR VALIDATE ON SAVE
      IMPORTING keys FOR Certificate~checkMaterial.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Certificate RESULT result.

    METHODS ActiveVersion FOR MODIFY
      IMPORTING keys FOR ACTION Certificate~ActiveVersion RESULT result.

    METHODS InactiveVersion FOR MODIFY
      IMPORTING keys FOR ACTION Certificate~InactiveVersion RESULT result.

    METHODS NewVersion FOR MODIFY
      IMPORTING keys FOR ACTION Certificate~NewVersion RESULT result.
    METHODS setProductName FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Certificate~setProductName.
    METHODS UpdateProductName FOR MODIFY
      IMPORTING keys FOR ACTION Certificate~UpdateProductName RESULT result.

ENDCLASS.

CLASS lhc_Certificate IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD setInitialValues.


    READ ENTITIES OF zi_dlrap_certifproduct_cf IN LOCAL MODE
        ENTITY Certificate
        FIELDS ( CertStatus ) WITH CORRESPONDING #(  keys )
        RESULT DATA(lt_certificates).

    IF lt_certificates IS NOT INITIAL.

      MODIFY ENTITIES OF zi_dlrap_certifproduct_cf  IN LOCAL MODE
          ENTITY Certificate
          UPDATE FIELDS ( Version CertStatus )
          WITH VALUE #( FOR ls_certificate IN lt_certificates
                  (
                      %tky = ls_certificate-%tky
                      Version =    '1'
                      CertStatus = '1'
                  )
              ).
    ENDIF.

    DATA: lt_state       TYPE TABLE FOR CREATE zi_dlrap_certifproduct_cf\_Stats,
          ls_state       LIKE LINE OF lt_state,
          ls_state_value LIKE LINE OF ls_state-%target.


    LOOP AT lt_certificates INTO DATA(ls_certificates).

      CHECK ls_certificates-Matnr IS NOT INITIAL.

      ls_state-%key = LS_CERTIFICATEs-%key.

      ls_state_value-Version   = '1'.
      ls_state_value-StatusOld = space.
      ls_state_value-Status    = '1'.
      ls_state_value-%cid      = ls_state-CertUuid.

      ls_state_value-%control-Version       = if_abap_behv=>mk-on.
      ls_state_value-%control-StatusOld     = if_abap_behv=>mk-on.
      ls_state_value-%control-Status        = if_abap_behv=>mk-on.
      ls_state_value-%control-LastChangedAt = if_abap_behv=>mk-on.
      ls_state_value-%control-LastChangedBy = if_abap_behv=>mk-on.


      APPEND ls_state_value TO ls_state-%target.

      APPEND ls_state TO lt_state.


      MODIFY ENTITIES OF zi_dlrap_certifproduct_cf  IN LOCAL MODE
       ENTITY Certificate
       CREATE BY \_Stats
       FROM lt_state
       REPORTED DATA(ls_return_ass)
       MAPPED DATA(ls_mapped_ass)
       FAILED DATA(ls_failed_ass).

    ENDLOOP.

  ENDMETHOD.

  METHOD checkMaterial.

    READ ENTITIES OF zi_dlrap_certifproduct_cf IN LOCAL MODE
       ENTITY Certificate
       FIELDS ( CertStatus ) WITH CORRESPONDING #(  keys )
       RESULT DATA(lt_certificates).


    CHECK lt_certificates IS NOT INITIAL.

    SELECT * FROM  zdlrap_prod_cf  INTO TABLE @DATA(lt_prod).

    LOOP AT lt_certificates INTO DATA(ls_certificates).

      IF NOT LINE_EXISTs( lt_prod[ matnr = ls_certificates-matnr ] ).

        APPEND VALUE #( %tky = ls_certificates-%tky ) TO failed-certificate.
        APPEND VALUE #( %tky = ls_certificates-%tky
                        %state_areA = 'MATERIAL_UNKNOW'
                        %msg =  NEW zcx_dlrap_certificate_cf(
                            textid = zcx_dlrap_certificate_cf=>material_unknown
                            severity = if_abap_behv_message=>severity-error
                            attr1 = CONV string( ls_certificates-matnr ) ) ) TO reported-certificate.


      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD ActiveVersion.

   DATA: lt_state       TYPE TABLE FOR CREATE zi_dlrap_certifproduct_cf\_Stats,
          ls_state       LIKE LINE OF lt_state,
          ls_state_value LIKE LINE OF ls_state-%target.

    "Selecionar os dados que estao na grid da UI para o action

    READ ENTITIES OF zi_dlrap_certifproduct_cf IN LOCAL MODE
       ENTITY Certificate
       ALL FIELDS
       WITH CORRESPONDING #(  keys )
       RESULT DATA(lt_certificates).


    "Adicionar um novo log de status
    LOOP AT lt_certificates INTO DATA(ls_certificates).

      CHECK ls_certificates-Matnr IS NOT INITIAL.

      ls_state-%key = LS_CERTIFICATEs-%key.

      ls_state_value-Version   = ls_certificates-version + 1.
      ls_state_value-StatusOld = ls_certificates-CertStatus.
      ls_state_value-Status    = '2'.
      ls_state_value-%cid      = ls_state-CertUuid.

      ls_state_value-%control-Version       = if_abap_behv=>mk-on.
      ls_state_value-%control-StatusOld     = if_abap_behv=>mk-on.
      ls_state_value-%control-Status        = if_abap_behv=>mk-on.
      ls_state_value-%control-LastChangedAt = if_abap_behv=>mk-on.
      ls_state_value-%control-LastChangedBy = if_abap_behv=>mk-on.


      APPEND ls_state_value TO ls_state-%target.

      APPEND ls_state TO lt_state.


      MODIFY ENTITIES OF zi_dlrap_certifproduct_cf  IN LOCAL MODE
       ENTITY Certificate
       CREATE BY \_Stats
       FROM lt_state
       REPORTED DATA(ls_return_ass)
       MAPPED DATA(ls_mapped_ass)
       FAILED DATA(ls_failed_ass).

    ENDLOOP.



    "Modificar para uma nova versao o PAI
    MODIFY ENTITIES OF  zi_dlrap_certifproduct_cf  IN LOCAL MODE
       ENTITY Certificate
       UPDATE
       FIELDS (  Version CertStatus Matnr )
       WITH VALUE #(  FOR ls_modify IN lt_certificates
                        (
                            %tky = ls_modify-%tky
                            Version = ls_modify-Version + 1
                            Matnr   = ls_modify-Matnr
                            CertStatus = '03'
                        )
                   )
       REPORTED reported
       FAILED failed.




    "Mensagem de sucesso
    reported-certificate = VALUE #(
        FOR ls_report IN lt_certificates
            (
                %tky = ls_report-%tky
                %msg = new_message( id = 'ZDLRAP_MANAGED_CF'
                                    number = '002'
                                    severity = if_abap_behv_message=>severity-success ) ) ).



    "Retorno para um refresh para o frontend

    result = VALUE #( FOR certificate IN lt_certificates ( %tky = certificate-%tky %param = certificate ) ).


  ENDMETHOD.

  METHOD InactiveVersion.
  ENDMETHOD.

  METHOD NewVersion.

    DATA: lt_state       TYPE TABLE FOR CREATE zi_dlrap_certifproduct_cf\_Stats,
          ls_state       LIKE LINE OF lt_state,
          ls_state_value LIKE LINE OF ls_state-%target.

    "Selecionar os dados que estao na grid da UI para o action

    READ ENTITIES OF zi_dlrap_certifproduct_cf IN LOCAL MODE
       ENTITY Certificate
       ALL FIELDS
       WITH CORRESPONDING #(  keys )
       RESULT DATA(lt_certificates).


    "Adicionar um novo log de status
    LOOP AT lt_certificates INTO DATA(ls_certificates).

      CHECK ls_certificates-Matnr IS NOT INITIAL.

      ls_state-%key = LS_CERTIFICATEs-%key.

      ls_state_value-Version   = ls_certificates-version + 1.
      ls_state_value-StatusOld = ls_certificates-CertStatus.
      ls_state_value-Status    = '1'.
      ls_state_value-%cid      = ls_state-CertUuid.

      ls_state_value-%control-Version       = if_abap_behv=>mk-on.
      ls_state_value-%control-StatusOld     = if_abap_behv=>mk-on.
      ls_state_value-%control-Status        = if_abap_behv=>mk-on.
      ls_state_value-%control-LastChangedAt = if_abap_behv=>mk-on.
      ls_state_value-%control-LastChangedBy = if_abap_behv=>mk-on.


      APPEND ls_state_value TO ls_state-%target.

      APPEND ls_state TO lt_state.


      MODIFY ENTITIES OF zi_dlrap_certifproduct_cf  IN LOCAL MODE
       ENTITY Certificate
       CREATE BY \_Stats
       FROM lt_state
       REPORTED DATA(ls_return_ass)
       MAPPED DATA(ls_mapped_ass)
       FAILED DATA(ls_failed_ass).

    ENDLOOP.



    "Modificar para uma nova versao o PAI
    MODIFY ENTITIES OF  zi_dlrap_certifproduct_cf  IN LOCAL MODE
       ENTITY Certificate
       UPDATE
       FIELDS (  Version CertStatus Matnr )
       WITH VALUE #(  FOR ls_modify IN lt_certificates
                        (
                            %tky = ls_modify-%tky
                            Version = ls_modify-Version + 1
                            Matnr   = ls_modify-Matnr
                            CertStatus = ls_modify-CertStatus
                        )
                   )
       REPORTED reported
       FAILED failed.




    "Mensagem de sucesso
    reported-certificate = VALUE #(
        FOR ls_report IN lt_certificates
            (
                %tky = ls_report-%tky
                %msg = new_message( id = 'ZDLRAP_MANAGED_CF'
                                    number = '002'
                                    severity = if_abap_behv_message=>severity-success ) ) ).

    result = VALUE #( FOR certificate IN lt_certificates ( %tky = certificate-%tky %param = certificate ) ).



    "Retorno para um refresh para o frontend



  ENDMETHOD.

  METHOD setProductName.

*    DATA: lt_update TYPE TABLE FOR UPDATE zi_dlrap_certifproduct_cf,
*          ls_update LIKE LINE OF lt_update.
*
*    READ ENTITIES OF zi_dlrap_certifproduct_cf IN LOCAL MODE
*           ENTITY Certificate
*           FIELDS ( Matnr ) WITH CORRESPONDING #(  keys )
*           RESULT DATA(lt_certificates).
*
*    IF lt_certificates IS NOT INITIAL.
*
*      SELECT matnr, description FROM zi_dlrap_prod_cf INTO TABLE @DATA(lt_prod).
*
*      LOOP AT lt_certificates INTO DATA(ls_certificate).
*
*        IF line_exists( lt_prod[ matnr = ls_certificate-Matnr ] ).
*          ls_update-%tky        = ls_certificate-%tky.
*          ls_update-Description = lt_prod[ matnr = ls_certificate-Matnr ]-Description.
*          APPEND ls_update TO lt_update.
*        ENDIF.
*      ENDLOOP.
*
*      MODIFY ENTITIES OF zi_dlrap_certifproduct_cf  IN LOCAL MODE
*      ENTITY Certificate
*      UPDATE FIELDS ( Description )
*      WITH lt_update.
*
*
*    ENDIF.

  ENDMETHOD.

  METHOD UpdateProductName.

    DATA: lt_update TYPE TABLE FOR UPDATE zi_dlrap_certifproduct_cf,
          ls_update LIKE LINE OF lt_update.

    READ ENTITIES OF zi_dlrap_certifproduct_cf IN LOCAL MODE
           ENTITY Certificate
           FIELDS ( Matnr ) WITH CORRESPONDING #(  keys )
           RESULT DATA(lt_certificates).

    IF lt_certificates IS NOT INITIAL.

      SELECT matnr, description FROM zi_dlrap_prod_cf INTO TABLE @DATA(lt_prod).

      LOOP AT lt_certificates INTO DATA(ls_certificate).

        IF line_exists( lt_prod[ matnr = ls_certificate-Matnr ] ).
          ls_update-%tky        = ls_certificate-%tky.
          ls_update-Description = lt_prod[ matnr = ls_certificate-Matnr ]-Description.
          APPEND ls_update TO lt_update.
        ENDIF.
      ENDLOOP.

      MODIFY ENTITIES OF zi_dlrap_certifproduct_cf  IN LOCAL MODE
      ENTITY Certificate
      UPDATE FIELDS ( Description )
      WITH lt_update.

    ENDIF.

     result = VALUE #( FOR certificate IN lt_certificates ( %tky = certificate-%tky %param = certificate ) ).


  ENDMETHOD.

ENDCLASS.
