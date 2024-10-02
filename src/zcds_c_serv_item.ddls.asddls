@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for API'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_C_SERV_ITEM
  provider contract transactional_query
  as projection on ZCDS_I_SERV_ITEM
{
  key object_id                  as SAPObjectID,
  key number_int                 as SAPIntNumber,
      zz1_subscriptionrefid_sri  as SubsRefID,
      zz1_external_reference_sri as WebOrderNumber,
      created_at_i               as CreatedAt,
      changed_at_i               as ChangedAt,
      product_id                 as ProductID,
      stat_activation            as ActivationStatus,
      stat_cont_ts               as TimeSliceStatus,
      zz1_actiontype_sri         as ActionType,
      zz1_level_sri              as ItemLevel,
      ci_contract_item           as ContractID
}
