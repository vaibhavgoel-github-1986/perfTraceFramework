CLASS lcl_zperf_trace_do_trigger DEFINITION DEFERRED.
CLASS cl_crm_isx_order_msg_dist_mgr DEFINITION LOCAL FRIENDS lcl_zperf_trace_do_trigger.
CLASS lcl_zperf_trace_do_trigger DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA obj TYPE REF TO lcl_zperf_trace_do_trigger.  "#EC NEEDED
    DATA core_object TYPE REF TO cl_crm_isx_order_msg_dist_mgr . "#EC NEEDED
 INTERFACES: IPR_ZPERF_TRACE_DO_TRIGGER, IPO_ZPERF_TRACE_DO_TRIGGER.
    METHODS:
      constructor IMPORTING core_object
                              TYPE REF TO cl_crm_isx_order_msg_dist_mgr OPTIONAL.
ENDCLASS.
CLASS lcl_zperf_trace_do_trigger IMPLEMENTATION.
  METHOD constructor.
    me->core_object = core_object.
  ENDMETHOD.

  METHOD ipr_zperf_trace_do_trigger~process_header.
*"------------------------------------------------------------------------*
*" Declaration of PRE-method, do not insert any comments here please!
*"
*"methods PROCESS_HEADER
*"  importing
*"    !IV_HEADER_GUID type CRMT_OBJECT_GUID
*"    !IV_PROCESS_TYPE type CRMT_PROCESS_TYPE optional
*"    !IV_SYNCHRONOUS type ABAP_BOOL .
*"------------------------------------------------------------------------*

    zcl_perf_trace=>get_instance( )->step_start(
      iv_step_name = zcl_perf_trace=>gc_steps-before_save
      iv_mainprog  =  sy-repid ).

  ENDMETHOD.
  METHOD ipo_zperf_trace_do_trigger~process_header.
*"------------------------------------------------------------------------*
*" Declaration of POST-method, do not insert any comments here please!
*"
*"methods PROCESS_HEADER
*"  importing
*"    !IV_HEADER_GUID type CRMT_OBJECT_GUID
*"    !IV_PROCESS_TYPE type CRMT_PROCESS_TYPE optional
*"    !IV_SYNCHRONOUS type ABAP_BOOL .
*"------------------------------------------------------------------------*

    zcl_perf_trace=>get_instance( )->step_end( zcl_perf_trace=>gc_steps-before_save ).

  ENDMETHOD.
ENDCLASS.
