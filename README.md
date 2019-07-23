# SE16N_LOG
SE16N Log

SAMPLE:
data lt_det_ret type standard table of bapi_coru_return.
  data ls_det_ret type bapi_coru_return.

  data(log) = new zcl_se16n_log(
    object      = 'LOG_OBJ'
    subobject   = 'LOG_SUBOBJ'
    ext_id      = ext_id
  ).

  ls_det_ret-type = 'E'.
  ls_det_ret-id = 'CO'.
  ls_det_ret-number = '341'.
  append ls_det_ret to lt_det_ret.
  log->add_t_bapi_coru_return( lt_det_ret ).

  log->save( ).
