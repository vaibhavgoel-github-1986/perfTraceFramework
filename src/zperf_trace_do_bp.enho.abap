CLASS lcl_zperf_trace_do_bp DEFINITION DEFERRED.
CLASS cl_fkk_bp_handler DEFINITION LOCAL FRIENDS lcl_zperf_trace_do_bp.
CLASS lcl_zperf_trace_do_bp DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA obj TYPE REF TO lcl_zperf_trace_do_bp.       "#EC NEEDED
    DATA core_object TYPE REF TO cl_fkk_bp_handler .        "#EC NEEDED
 INTERFACES: IPR_ZPERF_TRACE_DO_BP, IPO_ZPERF_TRACE_DO_BP.
    METHODS:
      constructor IMPORTING core_object
                              TYPE REF TO cl_fkk_bp_handler OPTIONAL.
ENDCLASS.
CLASS lcl_zperf_trace_do_bp IMPLEMENTATION.
  METHOD constructor.
    me->core_object = core_object.
  ENDMETHOD.

  METHOD ipr_zperf_trace_do_bp~execute.
*"------------------------------------------------------------------------*
*" Declaration of PRE-method, do not insert any comments here please!
*"
*"methods EXECUTE
*"  importing
*"    !IS_HDR_KEY type FKK_OBJ_TYP_KEY
*"    !IT_OBJECTS type FKK_OBJ_TYP_KEY_TAB
*"    !IV_OBJ_GUID type OBJKY_KK optional
*"    !IO_TECH_LOG type ref to CL_FKK_TECH_MSG_LOG optional
*"    !IV_NO_COMMIT type BOOLE_D optional .
*"------------------------------------------------------------------------*

    zcl_perf_trace=>get_instance( )->step_start(
      iv_step_name = zcl_perf_trace=>gc_steps-do_business_partner
      iv_mainprog      =  sy-repid ).

  ENDMETHOD.
  METHOD ipo_zperf_trace_do_bp~execute.
*"------------------------------------------------------------------------*
*" Declaration of POST-method, do not insert any comments here please!
*"
*"methods EXECUTE
*"  importing
*"    !IS_HDR_KEY type FKK_OBJ_TYP_KEY
*"    !IT_OBJECTS type FKK_OBJ_TYP_KEY_TAB
*"    !IV_OBJ_GUID type OBJKY_KK optional
*"    !IO_TECH_LOG type ref to CL_FKK_TECH_MSG_LOG optional
*"    !IV_NO_COMMIT type BOOLE_D optional
*"  changing
*"    !EV_SUCCESS type BOOLE_D
*"    !EV_FATAL type BOOLE_D
*"    !EV_TRIG_TYPE type TRITYP_KK .
*"------------------------------------------------------------------------*

    zcl_perf_trace=>get_instance( )->step_end( zcl_perf_trace=>gc_steps-do_business_partner ).

  ENDMETHOD.
ENDCLASS.
