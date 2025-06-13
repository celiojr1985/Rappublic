@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Composite - Certificado com Produto'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_DLRAP_CERTIFPRODUCT_CF
  as select from ZI_DLRAP_CERTIF_CF 
  composition [1..*] of ZI_DLRAP_CERTIF_ST_CF as _Stats //Associa o PAI (certificado com o filho)
  association [1..1] to ZI_DLRAP_PROD_CF as _Prod on $projection.Matnr = _Prod.Matnr and _Prod.Language = $session.system_language

{
  key CertUuid,
      Matnr,
      _Prod.Description,
      Version,
      CertStatus,
      CertCe,
      CertGs,
      CertFcc,
      CertIso,
      CertTuev,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      'sap-icon://BusinessSuiteInAppSymbols/icon-alert-groups' as IconHeader,
        
      _Prod,
      _Stats
      
      }
