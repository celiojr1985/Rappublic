@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic - Status Certificados'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DLRAP_CER_ST_CF
  as select from zdlrap_cer_st_cf
{
  key state_uuid            as StateUuid,
      cert_uuid             as CertUuid,
      matnr                 as Matnr,
      version               as Version,
      status                as Status,
      status_old            as StatusOld,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt
}
