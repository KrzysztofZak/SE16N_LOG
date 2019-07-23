# SE16N_LOG<br />

<br />
SAMPLE:<br />
data lt_det_ret type standard table of bapi_coru_return.<br />
data ls_det_ret type bapi_coru_return.<br />
<br />
data(log) = new zcl_se16n_log(<br />
  object      = 'LOG_OBJ'<br />
  subobject   = 'LOG_SUBOBJ'<br />
  ext_id      = ext_id<br />
  ).<br />
  <br />
  ls_det_ret-type = 'E'.<br />
  ls_det_ret-id = 'CO'.<br />
  ls_det_ret-number = '341'.<br />
  append ls_det_ret to lt_det_ret.<br />
  
  log->add_t_bapi_coru_return( lt_det_ret ).<br />
  log->save( ).<br />
  <br />

