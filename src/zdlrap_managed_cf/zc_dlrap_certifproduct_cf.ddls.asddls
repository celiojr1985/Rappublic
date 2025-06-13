@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumptions - Certificados'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_DLRAP_CERTIFPRODUCT_CF
  as projection on ZI_DLRAP_CERTIFPRODUCT_CF
{
  
  key CertUuid,
      Matnr,
      Description,
      Version,
      CertStatus,
      CertCe,
      CertGs,
      CertFcc,
      CertIso,
      CertTuev,
      LocalLastChangedAt,
      IconHeader,
      /* Associations */
      _Prod,
      _Stats : redirected to composition child ZC_DLRAP_CERTIF_ST_CF
}
