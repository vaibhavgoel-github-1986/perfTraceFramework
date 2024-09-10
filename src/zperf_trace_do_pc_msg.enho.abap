CLASS LCL_ZPERF_TRACE_DO_PC_MSG DEFINITION DEFERRED.
CLASS CL_FKK_PC_MESSAGE_HANDLER DEFINITION LOCAL FRIENDS LCL_ZPERF_TRACE_DO_PC_MSG.
CLASS LCL_ZPERF_TRACE_DO_PC_MSG DEFINITION.
PUBLIC SECTION.
CLASS-DATA OBJ TYPE REF TO LCL_ZPERF_TRACE_DO_PC_MSG. "#EC NEEDED
DATA CORE_OBJECT TYPE REF TO CL_FKK_PC_MESSAGE_HANDLER . "#EC NEEDED
 INTERFACES: IPR_ZPERF_TRACE_DO_PC_MSG, IPO_ZPERF_TRACE_DO_PC_MSG.
  METHODS:
   CONSTRUCTOR IMPORTING CORE_OBJECT
     TYPE REF TO CL_FKK_PC_MESSAGE_HANDLER OPTIONAL.
ENDCLASS.
CLASS LCL_ZPERF_TRACE_DO_PC_MSG IMPLEMENTATION.
METHOD CONSTRUCTOR.
  ME->CORE_OBJECT = CORE_OBJECT.
ENDMETHOD.

METHOD IPR_ZPERF_TRACE_DO_PC_MSG~EXECUTE.
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
      iv_step_name = zcl_perf_trace=>gc_steps-do_msg_upd
      iv_mainprog      =  sy-repid ).

ENDMETHOD.
METHOD IPO_ZPERF_TRACE_DO_PC_MSG~EXECUTE.
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

    zcl_perf_trace=>get_instance( )->step_end( zcl_perf_trace=>gc_steps-do_msg_upd ).

ENDMETHOD.
ENDCLASS.
