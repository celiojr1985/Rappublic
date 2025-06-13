@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Composite - Status com Produto'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_DLRAP_CERTIF_ST_CF
  as select from ZI_DLRAP_CER_ST_CF
  association to parent  ZI_DLRAP_CERTIFPRODUCT_CF as _Certif on $projection.CertUuid = _Certif.CertUuid //associa com o pai (certificado)
  association [1..1] to ZI_DLRAP_PROD_CF as _Prd on $projection.Matnr = _Prd.Matnr and _Prd.Language = $session.system_language
  
  
  

{
  key StateUuid,
      CertUuid,
      Matnr,
      _Prd.Description as Description,
      Version,
      Status,
      StatusOld,
      @Semantics.user.lastChangedBy: true
      LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt, 
      'sap-icon://BusinessSuiteInAppSymbols/icon-function-hierarchy' as Icon,
      
      _Certif
}
