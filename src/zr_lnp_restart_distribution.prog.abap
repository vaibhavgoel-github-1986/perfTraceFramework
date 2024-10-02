*&---------------------------------------------------------------------*
*& Report ZR_LNP_RESTART_DISTRIBUTION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_lnp_restart_distribution.

TABLES: crms4d_serv_i.

SELECT-OPTIONS: s_subs FOR crms4d_serv_i-zz1_subscriptionrefid_sri NO INTERVALS.


START-OF-SELECTION.

  DATA:
    lv_vtkey_kk     TYPE vtkey_kk,
    ls_input_object TYPE fkk_do_object_input,
    lt_input_object TYPE fkk_do_object_input_tab,
    lt_bapiret2     TYPE bapiret2_tab ##NEEDED.

  SELECT *
    FROM crms4d_serv_i
   INTO TABLE @DATA(lt_subs)
    WHERE objtype_h = 'BUS2000266'
      AND zz1_subscriptionrefid_sri IN @s_subs[]
      AND stat_activation NE 'E'
   ORDER BY
    zz1_subscriptionrefid_sri,
    ci_contract_id.
  IF NOT sy-subrc IS INITIAL.
    MESSAGE 'No Data was found' TYPE 'S'
     DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  LOOP AT lt_subs INTO DATA(ls_subs_wa)
    GROUP BY
      ( zz1_subscriptionrefid_sri = ls_subs_wa-zz1_subscriptionrefid_sri
        size = GROUP SIZE
        index = GROUP INDEX )
    ASCENDING
    REFERENCE INTO DATA(lr_subs_group).

    IF sy-batch EQ abap_true.
      MESSAGE s000(fkk_cc) WITH |Subscription Ref ID: | lr_subs_group->zz1_subscriptionrefid_sri.
    ELSE.
      MESSAGE s000(fkk_cc) WITH |Subscription Ref ID: | lr_subs_group->zz1_subscriptionrefid_sri
       INTO DATA(lv_msg).

      WRITE:/ lv_msg.
    ENDIF.

    LOOP AT GROUP lr_subs_group INTO DATA(ls_subs).

      CLEAR:
       lv_vtkey_kk,
       ls_input_object,
       lt_bapiret2,
       lt_input_object.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_subs-ci_contract_id
        IMPORTING
          output = lv_vtkey_kk.

      ls_input_object-objtype = if_fkk_multicc_constants=>gc_objtype_pcmsg.
      ls_input_object-objid   = lv_vtkey_kk.
      APPEND ls_input_object TO lt_input_object.
      CLEAR ls_input_object.

      CALL METHOD cl_fkk_do_fwk=>trigger_distribution
        EXPORTING
          iv_mode     = cl_fkk_do_fwk=>gc_exe_immediately
        IMPORTING
          et_bapiret2 = lt_bapiret2
        CHANGING
          ct_objects  = lt_input_object.

      READ TABLE lt_input_object INTO ls_input_object INDEX 1.

      IF sy-batch EQ abap_true.
        IF ls_input_object-success = 'X'.
          MESSAGE s033(fkk_cc) WITH ls_subs-ci_contract_id.
        ELSE.
          MESSAGE i034(fkk_cc) WITH ls_subs-ci_contract_id.
        ENDIF.
      ELSE.
        IF ls_input_object-success = 'X'.
          MESSAGE s033(fkk_cc) WITH ls_subs-ci_contract_id INTO lv_msg.
        ELSE.
          MESSAGE s034(fkk_cc) WITH ls_subs-ci_contract_id INTO lv_msg.
        ENDIF.

        WRITE:/ lv_msg.
      ENDIF.

    ENDLOOP.
  ENDLOOP.
