CLASS LCL_ZPERF_TRACE_DO_CA DEFINITION DEFERRED.
CLASS CL_FKK_CA_HANDLER DEFINITION LOCAL FRIENDS LCL_ZPERF_TRACE_DO_CA.
CLASS LCL_ZPERF_TRACE_DO_CA DEFINITION.
PUBLIC SECTION.
CLASS-DATA OBJ TYPE REF TO LCL_ZPERF_TRACE_DO_CA. "#EC NEEDED
DATA CORE_OBJECT TYPE REF TO CL_FKK_CA_HANDLER . "#EC NEEDED
 INTERFACES: IPR_ZPERF_TRACE_DO_CA, IPO_ZPERF_TRACE_DO_CA.
  METHODS:
   CONSTRUCTOR IMPORTING CORE_OBJECT
     TYPE REF TO CL_FKK_CA_HANDLER OPTIONAL.
ENDCLASS.
CLASS LCL_ZPERF_TRACE_DO_CA IMPLEMENTATION.
METHOD CONSTRUCTOR.
  ME->CORE_OBJECT = CORE_OBJECT.
ENDMETHOD.

METHOD IPR_ZPERF_TRACE_DO_CA~EXECUTE.
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
      iv_step_name = zcl_perf_trace=>gc_steps-do_contract_account
      iv_mainprog      =  sy-repid ).

ENDMETHOD.
METHOD IPO_ZPERF_TRACE_DO_CA~EXECUTE.
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

    zcl_perf_trace=>get_instance( )->step_end( zcl_perf_trace=>gc_steps-do_contract_account ).

ENDMETHOD.
ENDCLASS.
