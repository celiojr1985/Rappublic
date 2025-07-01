CLASS zcx_dlrap_certificate_cf DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_abap_behv_message.
    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

    data ATTR1 type string READ-ONLY.
    data attr2 type string READ-ONLY.
    data attr3 type string READ-ONLY.
    data attr4 type string READ-ONLY.

    CONSTANTS: BEGIN OF material_unknown,
                 msgid TYPE symsgid VALUE 'Z_CERTIFICATE_MSG',
                 msgNO TYPE symsgno VALUE '001',
                 attr1 TYPE scx_attrname VALUE 'MATNR',
                 attr2 TYPE scx_attrname VALUE '',
                 attr3 TYPE scx_attrname VALUE '',
                 attr4 TYPE scx_attrname VALUE '',
               END OF material_unknown.


    METHODS constructor
      IMPORTING
        SEVERITY type if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        textid   LIKE if_t100_message=>t100key OPTIONAL
        previous LIKE previous OPTIONAL
        attr1    type string OPTIONAL.


PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_dlrap_certificate_cf IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor(
    previous = previous
    ).
    CLEAR me->textid.

    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    me->if_abap_behv_message~m_severity = severity.
    me->attr1 = |{ attr1 ALPHA = OUT }|.
    me->attr2 = |{ attr2 ALPHA = OUT }|.
    me->attr3 = |{ attr3 ALPHA = OUT }|.
    me->attr4 = |{ attr4 ALPHA = OUT }|.


  ENDMETHOD.
ENDCLASS.
