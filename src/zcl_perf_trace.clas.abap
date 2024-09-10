CLASS zcl_perf_trace DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.

    TYPES:
      gtt_perf_trace TYPE STANDARD TABLE OF zdt_perf_trace.

    TYPES:
      gtt_smum_xmltb TYPE STANDARD TABLE OF smum_xmltb.

    CLASS-DATA:
      go_instance TYPE REF TO zcl_perf_trace.

    DATA:
      gv_subs_ref_id   TYPE zz1_subscriptionrefid,
      gv_web_order_num TYPE zz1_external_reference.

    DATA:
      gv_contract_id TYPE ist_ext_ref,
      gv_int_obj_no  TYPE crmt_int_obj_no.

    DATA:
      gv_step_id      TYPE int2,
      gv_trace_active TYPE char1.

    DATA:
      gt_perf_trace TYPE gtt_perf_trace.

    CONSTANTS:
      BEGIN OF gc_steps,
        process_payload       TYPE char50 VALUE 'PROCESS_PAYLOAD',
        validation_logic      TYPE char50 VALUE 'VALIDATION_LOGIC',
        processing_logic      TYPE char50 VALUE 'PROCESSING_LOGIC',
        call_order_create_api TYPE char50 VALUE 'CALL_ORDER_CREATE_API',
        before_save           TYPE char50 VALUE 'BEFORE_SAVE',
        execute_distribution  TYPE char50 VALUE 'EXECUTE_DISTRIBUTION',
        create_item_plan      TYPE char50 VALUE 'CREATE_ITEM_PLAN',
        process_item_do       TYPE char50 VALUE 'PROCESS_ITEM_DO',
        do_business_partner   TYPE char50 VALUE 'DO_BUSINESS_PARTNER',
        do_contract_account   TYPE char50 VALUE 'DO_CONTRACT_ACCOUNT',
        do_provider_contract  TYPE char50 VALUE 'DO_PROVIDER_CONTRACT',
        do_pc_status_update   TYPE char50 VALUE 'DO_PC_STATUS_UPDATE',
        do_msg_upd            TYPE char50 VALUE 'DO_MSG_UPD',
      END OF gc_steps.


    CLASS-METHODS:
      get_instance
        IMPORTING
          VALUE(iv_subs_ref_id)   TYPE zz1_subscriptionrefid   OPTIONAL " Subscription Reference ID
          VALUE(iv_web_order_num) TYPE zz1_external_reference  OPTIONAL " Web Order Number
        RETURNING
          VALUE(ro_instance)      TYPE REF TO zcl_perf_trace.

    METHODS:
      constructor
        IMPORTING
          VALUE(iv_subs_ref_id)   TYPE zz1_subscriptionrefid   OPTIONAL  " Subscription Reference ID
          VALUE(iv_web_order_num) TYPE zz1_external_reference  OPTIONAL. " Web Order Number


    METHODS:
      set_item_data
        IMPORTING
          VALUE(iv_contract_id) TYPE ist_ext_ref OPTIONAL
          VALUE(iv_int_obj_no)  TYPE crmt_int_obj_no OPTIONAL.

    METHODS:
      step_start
        IMPORTING
          VALUE(iv_step_name)     TYPE char50                                  " Step Name
          VALUE(iv_step_id)       TYPE int2                          OPTIONAL  " Step Hier ID
          VALUE(iv_header_step)   TYPE char1                         OPTIONAL  " To populate only Key attributes
          VALUE(iv_subs_ref_id)   TYPE zz1_subscriptionrefid         OPTIONAL  " Subscription Reference ID
          VALUE(iv_web_order_num) TYPE zz1_external_reference        OPTIONAL  " Web Order Number
          VALUE(iv_contract_id)   TYPE ist_ext_ref                   OPTIONAL  " Contract ID
          VALUE(iv_int_obj_no)    TYPE crmt_int_obj_no               OPTIONAL  " Internal Object Number
          VALUE(iv_mainprog)      TYPE syrepid                       OPTIONAL  "  Main Calling Program
          VALUE(iv_xml_data)      TYPE xml_strng                     OPTIONAL. " XML Data for Distribution Plan

    METHODS:
      transform_data
        IMPORTING
          VALUE(iv_xml) TYPE xml_strng
        EXPORTING
          es_data       TYPE isx_contract.

    METHODS:
      step_end
        IMPORTING
          VALUE(iv_step_name) TYPE char50.

    METHODS:
      save.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_perf_trace IMPLEMENTATION.


  METHOD constructor.

    CLEAR:
     gv_trace_active,
     gv_subs_ref_id,
     gv_web_order_num,
     gv_contract_id,
     gv_int_obj_no,
     gt_perf_trace,
     gv_step_id.

    IF iv_subs_ref_id IS SUPPLIED.
      gv_subs_ref_id = iv_subs_ref_id.
    ENDIF.

    IF iv_web_order_num IS SUPPLIED.
      gv_web_order_num = iv_web_order_num.
    ENDIF.

*- Check for Trace Active Flag
    SELECT SINGLE *
     FROM tvarvc
    INTO @DATA(ls_tvarvc)
    WHERE name = 'Z_PERF_TRACE_ACTIVATE'.
    IF sy-subrc IS INITIAL.
      gv_trace_active = ls_tvarvc-low.
    ENDIF.

  ENDMETHOD.


  METHOD get_instance.

    IF go_instance IS NOT BOUND.
      CREATE OBJECT go_instance
        EXPORTING
          iv_subs_ref_id   = iv_subs_ref_id
          iv_web_order_num = iv_web_order_num.
    ENDIF.

    ro_instance = go_instance.

  ENDMETHOD.


  METHOD transform_data.

    CLEAR:
     es_data.

    CALL TRANSFORMATION ('ID')
    SOURCE XML iv_xml
    RESULT para = es_data.

  ENDMETHOD.


  METHOD step_start.

    CHECK gv_trace_active EQ abap_true.

    IF iv_step_id IS SUPPLIED.
      gv_step_id = iv_step_id.
    ELSE.
      ADD 1 TO gv_step_id.
    ENDIF.

    IF  iv_subs_ref_id IS SUPPLIED
    AND iv_web_order_num IS SUPPLIED.
      gv_subs_ref_id = iv_subs_ref_id.
      gv_web_order_num = iv_web_order_num.
    ENDIF.

    IF iv_contract_id IS SUPPLIED.
      gv_contract_id = iv_contract_id.
    ENDIF.

    IF iv_int_obj_no IS SUPPLIED.
      gv_int_obj_no = iv_int_obj_no.
    ENDIF.

    IF iv_xml_data IS SUPPLIED.
*-   Convert XML Data
      transform_data(
        EXPORTING
          iv_xml  = iv_xml_data
        IMPORTING
          es_data = DATA(ls_data) ).

      IF ls_data-header IS NOT INITIAL.
        TRY.
            IF ls_data-items IS NOT INITIAL.
              gv_contract_id = ls_data-items[ 1 ]-item-contract_id.
              gv_int_obj_no = ls_data-items[ 1 ]-item-cuobj.


              IF ls_data-items[ 1 ]-parameters IS NOT INITIAL.
                IF gv_subs_ref_id IS INITIAL.
                  READ TABLE ls_data-items[ 1 ]-parameters INTO DATA(ls_param)
                   WITH KEY parameter-name = 'CIS_CC_SUBREF_ID'.
                  IF sy-subrc IS INITIAL.
                    gv_subs_ref_id = ls_param-parameter-value.
                  ENDIF.
                ENDIF.

                IF gv_web_order_num IS INITIAL.
                  READ TABLE ls_data-items[ 1 ]-parameters INTO ls_param
                   WITH KEY parameter-name = 'CIS_CC_ORDER_ID'.
                  IF sy-subrc IS INITIAL.
                    gv_web_order_num = ls_param-parameter-value.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.

          CATCH cx_sy_itab_line_not_found.
        ENDTRY.
      ENDIF.

    ENDIF.

*- Adding Trace Record
    APPEND INITIAL LINE TO gt_perf_trace
     ASSIGNING FIELD-SYMBOL(<ls_perf_trace>).

    <ls_perf_trace>-subs_ref_id   = gv_subs_ref_id.
    <ls_perf_trace>-web_order_num = gv_web_order_num.

    <ls_perf_trace>-step_id = gv_step_id.
    <ls_perf_trace>-step_name = iv_step_name.

    IF iv_header_step EQ abap_false.
      <ls_perf_trace>-contract_id = gv_contract_id.
      <ls_perf_trace>-int_obj_no = gv_int_obj_no.
    ENDIF.

    GET TIME STAMP FIELD <ls_perf_trace>-step_trigid.
    GET TIME STAMP FIELD <ls_perf_trace>-step_start.

    <ls_perf_trace>-mainprogram = iv_mainprog.

  ENDMETHOD.


  METHOD step_end.

    CHECK gv_trace_active EQ abap_true.

*- Try with the Index First i.e. if we are closing the immediate step
    DATA(lv_count) = lines( gt_perf_trace ).

    ASSIGN gt_perf_trace[ lv_count ]
     TO FIELD-SYMBOL(<ls_perf_trace>).
    IF <ls_perf_trace>-step_name NE iv_step_name. "Step Name is not matching with the Open Step

*-   Check for Duplicate Step Names (same steps are being called repeatedly)
      DATA(lt_dedup_check) = gt_perf_trace.
      SORT lt_dedup_check BY step_name.
      DELETE ADJACENT DUPLICATES FROM lt_dedup_check COMPARING step_name.
      IF lines( lt_dedup_check ) NE lines( gt_perf_trace ).  "If duplicate was found i.e. this step was called in the above call stack
        DATA(lv_index) = lines( gt_perf_trace ).

        WHILE lv_index > 1.

          SUBTRACT 1 FROM lv_index.

          IF lv_index = 0.
            EXIT.
          ENDIF.

          IF gt_perf_trace[ lv_index ]-step_name = iv_step_name.
            ASSIGN gt_perf_trace[ lv_index ] TO <ls_perf_trace>.
            EXIT.
          ENDIF.

        ENDWHILE.

      ELSE.  "If not duplicate, go ahead with normal search

*-       Search by Full Data Set
        READ TABLE gt_perf_trace
         ASSIGNING <ls_perf_trace>
         WITH KEY subs_ref_id   = gv_subs_ref_id
                  web_order_num = gv_web_order_num
                  step_name = iv_step_name
                  contract_id = gv_contract_id
                  int_obj_no = gv_int_obj_no.
        IF sy-subrc IS NOT INITIAL.
*-       Search by Keys only
          READ TABLE gt_perf_trace
           ASSIGNING <ls_perf_trace>
           WITH KEY subs_ref_id   = gv_subs_ref_id
                    web_order_num = gv_web_order_num
                    step_name = iv_step_name.
        ENDIF.
      ENDIF.
    ENDIF.

    IF <ls_perf_trace> IS ASSIGNED.
      GET TIME STAMP FIELD <ls_perf_trace>-step_end.

      TRY.
          cl_abap_tstmp=>subtract(
            EXPORTING
              tstmp1 = <ls_perf_trace>-step_end
              tstmp2 = <ls_perf_trace>-step_start
            RECEIVING
              r_secs = <ls_perf_trace>-step_duration
          ).

        CATCH cx_parameter_invalid_range.
        CATCH cx_parameter_invalid_type.
      ENDTRY.

*-   Find the Parent ID
      lv_index = lines( gt_perf_trace ).

      WHILE lv_index > 1.

        SUBTRACT 1 FROM lv_index.

        IF lv_index = 0.
          <ls_perf_trace>-step_parent_id = 0.
          EXIT.
        ENDIF.

        IF gt_perf_trace[ lv_index ]-step_end IS INITIAL.
          <ls_perf_trace>-step_parent_id = gt_perf_trace[ lv_index ]-step_id.
          EXIT.
        ENDIF.

      ENDWHILE.

    ENDIF.

  ENDMETHOD.


  METHOD save.

    CHECK gv_trace_active EQ abap_true.

    IF gt_perf_trace IS NOT INITIAL.
      INSERT zdt_perf_trace FROM TABLE gt_perf_trace.
      IF sy-subrc IS INITIAL.
        MESSAGE 'Trace Log Inserted' TYPE 'S'.

        CLEAR:
         go_instance,
         gv_trace_active,
         gv_subs_ref_id,
         gv_web_order_num,
         gv_contract_id,
         gv_int_obj_no,
         gt_perf_trace,
         gv_step_id.

      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD set_item_data.

    gv_contract_id = iv_contract_id.
    gv_int_obj_no = iv_int_obj_no.

  ENDMETHOD.

ENDCLASS.
