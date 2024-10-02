@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Subs Item Table'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZCDS_I_SERV_ITEM
  as select from crms4d_serv_i
{

  key object_id,
  key number_int,
      zz1_subscriptionrefid_sri,
      zz1_external_reference_sri,
      created_at_i,
      changed_at_i,
      product_id,
      stat_activation,
      stat_cont_ts,
      zz1_actiontype_sri,
      zz1_level_sri,
      ci_contract_item
}
where
  objtype_h = 'BUS2000266'
