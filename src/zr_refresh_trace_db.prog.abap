*&---------------------------------------------------------------------*
*& Report ZVG_REFRESH_TRACE_DB
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_refresh_trace_db.

TABLES: crms4d_serv_i.

SELECT-OPTIONS:
 so_subs FOR crms4d_serv_i-zz1_subscriptionrefid_sri NO INTERVALS.

SELECT *
  FROM zdt_perf_trace
 INTO TABLE @DATA(lt_data)
  WHERE subs_ref_id IN @so_subs[].
IF sy-subrc IS INITIAL.
  DELETE zdt_perf_trace FROM TABLE lt_data.
  IF sy-subrc IS INITIAL.
    MESSAGE 'Trace DB was refreshed' TYPE 'S'.
  ENDIF.
ELSE.
  MESSAGE 'No Data was found' TYPE 'S'
   DISPLAY LIKE 'E'.
ENDIF.
