CLASS lcl_zperf_trace_do DEFINITION DEFERRED.
CLASS cl_fkk_do_fwk DEFINITION LOCAL FRIENDS lcl_zperf_trace_do.
CLASS lcl_zperf_trace_do DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA obj TYPE REF TO lcl_zperf_trace_do.          "#EC NEEDED
    DATA core_object TYPE REF TO cl_fkk_do_fwk .            "#EC NEEDED
 INTERFACES: IPR_ZPERF_TRACE_DO, IPO_ZPERF_TRACE_DO.
    METHODS:
      constructor IMPORTING core_object
                              TYPE REF TO cl_fkk_do_fwk OPTIONAL.
ENDCLASS.
CLASS lcl_zperf_trace_do IMPLEMENTATION.
  METHOD constructor.
    me->core_object = core_object.
  ENDMETHOD.

  METHOD ipr_zperf_trace_do~trigger_distribution.
*"------------------------------------------------------------------------*
*" Declaration of PRE-method, do not insert any comments here please!
*"
*"class-methods TRIGGER_DISTRIBUTION
*"  importing
*"    !IV_MODE type DO_MODE_KK
*"  changing
*"    !CT_OBJECTS type FKK_DO_OBJECT_INPUT_TAB .
*"------------------------------------------------------------------------*

    DATA: lo_instance TYPE REF TO cl_fkk_do_fwk.

    FIELD-SYMBOLS: <ls_data> TYPE isx_contract.

    IF iv_mode = cl_fkk_do_fwk=>gc_reg_on_commit.
      IF ct_objects IS NOT INITIAL.
        ASSIGN ct_objects[ 1 ]-data->* TO <ls_data>.
        IF <ls_data> IS ASSIGNED.
          zcl_perf_trace=>get_instance( )->step_start(
            iv_step_name = zcl_perf_trace=>gc_steps-create_item_plan
            iv_contract_id = <ls_data>-items[ 1 ]-item-contract_id
            iv_int_obj_no  = CONV #( <ls_data>-items[ 1 ]-item-cuobj )
            iv_mainprog    =  sy-repid ).
        ENDIF.
      ENDIF.
    ELSEIF iv_mode = cl_fkk_do_fwk=>gc_exe_immediately.
      IF ct_objects IS NOT INITIAL.
        CREATE OBJECT lo_instance
          EXPORTING
            is_input = ct_objects[ 1 ].

        IF lo_instance IS BOUND.
          zcl_perf_trace=>get_instance( )->step_start(
            iv_step_id     = 200
            iv_step_name   = zcl_perf_trace=>gc_steps-execute_distribution
            iv_xml_data    = lo_instance->ms_exec_plan-header-xml
            iv_header_step = abap_true
            iv_mainprog    =  sy-repid  ).
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.
  METHOD ipo_zperf_trace_do~trigger_distribution.
*"------------------------------------------------------------------------*
*" Declaration of POST-method, do not insert any comments here please!
*"
*"class-methods TRIGGER_DISTRIBUTION
*"  importing
*"    !IV_MODE type DO_MODE_KK
*"  changing
*"    !ET_BAPIRET2 type BAPIRET2_TAB
*"    !CT_OBJECTS type FKK_DO_OBJECT_INPUT_TAB .
*"------------------------------------------------------------------------*

    IF iv_mode = cl_fkk_do_fwk=>gc_reg_on_commit.
      zcl_perf_trace=>get_instance( )->step_end( zcl_perf_trace=>gc_steps-create_item_plan ).
    ELSEIF iv_mode = cl_fkk_do_fwk=>gc_exe_immediately.
      zcl_perf_trace=>get_instance( )->step_end( zcl_perf_trace=>gc_steps-execute_distribution ).
      zcl_perf_trace=>get_instance( )->save( ).
    ENDIF.

  ENDMETHOD.
  METHOD ipr_zperf_trace_do~execute_distribution.
*"------------------------------------------------------------------------*
*" Declaration of PRE-method, do not insert any comments here please!
*"
*"methods EXECUTE_DISTRIBUTION
*"  raising
*"    CX_FKK_DO_FWK_FAILURE .
*"------------------------------------------------------------------------*

    zcl_perf_trace=>get_instance( )->step_start(
      iv_step_name     = zcl_perf_trace=>gc_steps-process_item_do
      iv_mainprog      = sy-repid
      iv_xml_data      = core_object->ms_exec_plan-header-xml ).

  ENDMETHOD.
  METHOD ipo_zperf_trace_do~execute_distribution.
*"------------------------------------------------------------------------*
*" Declaration of POST-method, do not insert any comments here please!
*"
*"methods EXECUTE_DISTRIBUTION
*"  changing
*"    value(RV_SUCCESS) type BOOLE_D
*"  raising
*"    CX_FKK_DO_FWK_FAILURE . "#EC CI_VALPAR
*"------------------------------------------------------------------------*

    zcl_perf_trace=>get_instance( )->step_end( zcl_perf_trace=>gc_steps-process_item_do ).

  ENDMETHOD.
ENDCLASS.
