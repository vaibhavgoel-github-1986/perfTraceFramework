*&---------------------------------------------------------------------*
*& Report ZVG_REFRESH_TRACE_DB
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_refresh_trace_db.


SELECT *
  FROM zdt_perf_trace
 INTO TABLE @DATA(lt_data).
IF sy-subrc IS INITIAL.
  DELETE zdt_perf_trace FROM TABLE lt_data.
  IF sy-subrc IS INITIAL.
    MESSAGE 'Trace DB was refreshed' TYPE 'S'.
  ENDIF.
ENDIF.
