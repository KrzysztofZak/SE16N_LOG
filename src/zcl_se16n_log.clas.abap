class ZCL_SE16N_LOG definition
  public
  final
  create public .

public section.

  methods ADD_SYST .
  methods ADD
    importing
      !ID_MSGTY type SYMSGTY
      !ID_MSGID type SYMSGID
      !ID_MSGNO type SYMSGNO
      !ID_MSGV1 type CLIKE
      !ID_MSGV2 type CLIKE
      !ID_MSGV3 type CLIKE
      !ID_MSGV4 type CLIKE .
  methods ADD_TEXT
    importing
      !MSGTY type SYMSGTY
      !TEXT type CLIKE .
  methods ADD_TEXT_E
    importing
      !TEXT type CLIKE .
  methods ADD_TEXT_W
    importing
      !TEXT type CLIKE .
  methods ADD_TEXT_S
    importing
      !TEXT type CLIKE .
  methods CONSTRUCTOR
    importing
      !OBJECT type BALOBJ_D optional
      !SUBOBJECT type BALSUBOBJ optional
      !EXT_ID type CLIKE optional
      !DATE_DELETE type ALDATE_DEL optional .
  methods ADD_BAPIRET2
    importing
      !MESSAGE type BAPIRET2 .
  methods ADD_T_BAPIRET2
    importing
      !MESSAGES type BAPIRET2_T .
  methods ADD_T_BAPI_CORU_RETURN
    importing
      !MESSAGES type TY_T_BAPI_CORU_RETURN .
  methods SAVE
    importing
      !IN_UPDATE_TASK type ABAP_BOOL default ABAP_FALSE
      !IN_SECONDARY_CONN type ABAP_BOOL default ABAP_TRUE
      !IN_SECONDARY_CONN_COMMIT type ABAP_BOOL default ABAP_TRUE .
protected section.
private section.

  data MV_LOG_HANDLE type BALLOGHNDL .

  methods AFTER_MSG_ADD
    importing
      !MESSAGE type RECAMSG .
  methods LOG_CALLSTACK .
ENDCLASS.



CLASS ZCL_SE16N_LOG IMPLEMENTATION.


  method ADD.

    data ls_message    TYPE recamsg.

    ls_message-msgty = id_msgty.
    ls_message-msgid = id_msgid.
    ls_message-msgno = id_msgno.
    ls_message-msgv1 = id_msgv1.
    ls_message-msgv2 = id_msgv2.
    ls_message-msgv3 = id_msgv3.
    ls_message-msgv4 = id_msgv4.

    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING
        i_log_handle     = mv_log_handle
        i_s_msg          = ls_message-msg
      EXCEPTIONS
        log_not_found    = 1
        msg_inconsistent = 2
        log_is_full      = 3
        OTHERS           = 4.

    after_msg_add( ls_message ).

  endmethod.


  method add_bapiret2.

    call method add
      exporting
        id_msgty = message-type
        id_msgid = message-id
        id_msgno = message-number
        id_msgv1 = message-message_v1
        id_msgv2 = message-message_v2
        id_msgv3 = message-message_v3
        id_msgv4 = message-message_v4.

  endmethod.


  method add_syst.

    add(
      exporting
        id_msgty = sy-msgty
        id_msgid = sy-msgid
        id_msgno = sy-msgno
        id_msgv1 = sy-msgv1
        id_msgv2 = sy-msgv2
        id_msgv3 = sy-msgv3
        id_msgv4 = sy-msgv4
    ).

  endmethod.


  method add_text.

    data message_text        type char200.

    message_text = text.

    call function 'BAL_LOG_MSG_ADD_FREE_TEXT'
      exporting
        i_log_handle = me->mv_log_handle
        i_msgty      = msgty
*       I_PROBCLASS  = '4'
        i_text       = message_text
*       I_S_CONTEXT  =
*       I_S_PARAMS   =
*       I_DETLEVEL   = '1'
* IMPORTING
*       E_S_MSG_HANDLE            =
*       E_MSG_WAS_LOGGED          =
*       E_MSG_WAS_DISPLAYED       =
* EXCEPTIONS
*       LOG_NOT_FOUND             = 1
*       MSG_INCONSISTENT          = 2
*       LOG_IS_FULL  = 3
*       OTHERS       = 4
      .
    if sy-subrc <> 0.
* Implement suitable error handling here
    endif.

    if msgty = 'E'.
      log_callstack( ).
    endif.

  endmethod.


  method ADD_TEXT_E.

    add_text( msgty = 'E' text = text ).

  endmethod.


  method add_text_s.

    add_text( msgty = 'S' text = text ).

  endmethod.


  method ADD_TEXT_W.

    add_text( msgty = 'W' text = text ).

  endmethod.


  method ADD_T_BAPIRET2.

    field-symbols:
    <MESSAGES> like line of messages.

    loop at MESSAGES assigning <MESSAGES>.

      call method add
        exporting
          id_msgty    = <MESSAGES>-type
          id_msgid    = <MESSAGES>-id
          id_msgno    = <MESSAGES>-number
          id_msgv1    = <MESSAGES>-message_v1
          id_msgv2    = <MESSAGES>-message_v2
          id_msgv3    = <MESSAGES>-message_v3
          id_msgv4    = <MESSAGES>-message_v4.

    endloop.


  endmethod.


  method add_t_bapi_coru_return.

    field-symbols:
    <MESSAGES> like line of messages.

    loop at MESSAGES assigning <MESSAGES>.

      call method add
        exporting
          id_msgty    = <MESSAGES>-type
          id_msgid    = <MESSAGES>-id
          id_msgno    = <MESSAGES>-number
          id_msgv1    = <MESSAGES>-message_v1
          id_msgv2    = <MESSAGES>-message_v2
          id_msgv3    = <MESSAGES>-message_v3
          id_msgv4    = <MESSAGES>-message_v4.

    endloop.


  endmethod.


  method AFTER_MSG_ADD.

  IF message-msgty = 'E'.

    log_callstack( ).

  ENDIF.

  endmethod.


  method constructor.

    data lv_ext_id  type  balnrext.

    lv_ext_id = ext_id.

    data(ls_log) = value bal_s_log(
      extnumber  = lv_ext_id
      object     = object
      subobject  = subobject
      aldate_del = date_delete
    ).

    call function 'BAL_LOG_CREATE'
      exporting
        i_s_log                 = ls_log
      importing
        e_log_handle            = mv_log_handle
      exceptions
        log_header_inconsistent = 1
        others                  = 2.

  endmethod.


  method log_callstack.

    data callstack type  abap_callstack.
    data line_char type c length 10.
    data message_text type char200.

    call function 'SYSTEM_CALLSTACK'
*     EXPORTING
*       MAX_LEVEL          = 0
      importing
        callstack = callstack.
*        et_callstack =

    add_text_s('CALLSTACK').
    add_text_s('Main Program ! Include ! Line ! Block type ! Block name ! Flag system').

    loop at callstack assigning field-symbol(<ls_callstack>) where mainprogram(13) <> 'ZCL_SE16N_LOG'.
      line_char = <ls_callstack>-line.
      CONDENSE line_char.
      concatenate <ls_callstack>-mainprogram <ls_callstack>-include line_char <ls_callstack>-blocktype <ls_callstack>-blockname <ls_callstack>-flag_system
        into message_text separated by ' ! '.
      add_text_s( message_text  ).
    endloop.

  endmethod.


  method save.

    call function 'BAL_DB_SAVE'
      exporting
        i_in_update_task     = in_update_task
        i_t_log_handle       = value bal_t_logh( ( mv_log_handle ) )
        i_2th_connection     = in_secondary_conn
        i_2th_connect_commit = in_secondary_conn_commit
      exceptions
        log_not_found        = 1
        save_not_allowed     = 2
        numbering_error      = 3
        others               = 4.

    if sy-subrc <> 0.
      raise exception type zcx_se16n_log_error.
    endif.

  endmethod.
ENDCLASS.
