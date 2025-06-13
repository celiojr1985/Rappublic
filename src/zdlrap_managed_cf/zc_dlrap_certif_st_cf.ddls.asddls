@EndUserText.label: 'Consumptions - Status'
@Metadata.allowExtensions: true
define view entity ZC_DLRAP_CERTIF_ST_CF
  as projection on ZI_DLRAP_CERTIF_ST_CF
{
  key StateUuid,
      CertUuid,
      Matnr,
      Description,
      Version,
      Status,
      StatusOld,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,           
      Icon,
      /* Associations */
      _Certif : redirected to parent ZC_DLRAP_CERTIFPRODUCT_CF

}
