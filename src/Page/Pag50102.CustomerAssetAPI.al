page 50102 "CustomerAssetAPI"
{
    PageType = API;
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'CustomerAsset';
    EntitySetName = 'CustomerAssets';
    SourceTable = "GKB Customer Asset";
    DelayedInsert = true;

    // Define the fields to be included in the API
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(AccountId; rec."Account Id")
                {
                    Caption = 'Account Id';
                }
                field("CRMID"; Rec."CRM ID")
                {
                    Caption = 'Crm Id';
                }
                field(Account; rec.Account)
                {
                    Caption = 'Account';
                }
                field(EquipmentCardNo; rec."Equipment Card No.")
                {
                    Caption = 'Equipment Card No.';
                }
                field(Name; rec.Name)
                {
                    Caption = 'Name';
                }
                field(AssetNumber; rec."Asset number")
                {
                    Caption = 'Asset Number';
                }
                field(AssetLocation; rec."Asset Location")
                {
                    Caption = 'Asset Location';
                }
                field(EquipmentCategory; rec."Equipment Category")
                {
                    Caption = 'Equipment Category';
                }
                field(ProductId; rec."Product Id")
                {
                    Caption = 'Product Id';
                }
                field(SAPItemNo; rec."SAP Item No.")
                {
                    Caption = 'SAP Item No.';
                }
                field(Product; rec.Product)
                {
                    Caption = 'Product';
                }
                field(TopLevelAsset; rec."Top-Level Asset")
                {
                    Caption = 'Top-Level Asset';
                }
                field(ParentAsset; rec."Parent Asset")
                {
                    Caption = 'Parent Asset';
                }
                field(Agreement; rec."Agreement")
                {
                    Caption = 'Agreement';
                }
                field(BoilerType; rec."Boiler Type")
                {
                    Caption = 'Boiler Type';
                }
                field(AssetTag; rec."Asset Tag")
                {
                    Caption = 'Asset Tag';
                }
                field(BuildingNoName; rec."Building No. Name")
                {
                    Caption = 'Building No. Name';
                }
                field(BurnerBrand; rec."Burner Brand")
                {
                    Caption = 'Burner Brand';
                }
                field(BurnerType; rec."Burner Type")
                {
                    Caption = 'Burner Type';
                }
                field(CapacityKW; rec."Capacity(KW)")
                {
                    Caption = 'Capacity(KW)';
                }
                field(Category; rec."Category")
                {
                    Caption = 'Category';
                }
                field(DateOfNext4Monthly; rec."Date Of Next 4 Monthly")
                {
                    Caption = 'Date Of Next 4 Monthly';
                }
                field(DateOfNext6MtlySteamTrapAudit; rec."Date OfNext6MtlySteamTrapAudit")
                {
                    Caption = 'Date Of Next 6 Monthly Steam Trap Audit';
                }
                field(DateOfNextAS2593Audit; rec."Date Of Next AS2593 Audit")
                {
                    Caption = 'Date Of Next AS2593 Audit';
                }
                field(DateOfNextBiennialService; rec."Date Of Next Biennial Service")
                {
                    Caption = 'Date Of Next Biennial Service';
                }
                field(DateOfNextSteamTrapAudit; rec."Date Of Next Steam Trap Audit")
                {
                    Caption = 'Date Of Next Steam Trap Audit';
                }
                field(Days; rec.Days)
                {
                    Caption = 'Days';
                }
                field(InstallationDate; rec."Installation Date")
                {
                    Caption = 'Installation Date';
                }
                field(LastActiveAlertTime; rec."Last active alert time")
                {
                    Caption = 'Last active alert time';
                }
                field(LastBiennalDate; rec."Last Biennal Date")
                {
                    Caption = 'Last Biennal Date';
                }
                field(EquipmentMan; rec."Equipment Man")
                {
                    Caption = 'Equipment Man';
                }
                field(ETCSerialNo; rec."ETC Serial No")
                {
                    Caption = 'ETC Serial No';
                }
                field(Floor; rec.Floor)
                {
                    Caption = 'Floor';
                }
                field(FuelType; rec."Fuel Type")
                {
                    Caption = 'Fuel Type';
                }
                field(FunctionalLocation; rec."Functional Location")
                {
                    Caption = 'Functional Location';
                }
                field(Manufacture; rec.Manufacture)
                {
                    Caption = 'Manufacture';
                }
                field(ManufactureDate; rec."Manufacture Date")
                {
                    Caption = 'Manufacture Date';
                }
                field(Manufacturer; rec.Manufacturer)
                {
                    Caption = 'Manufacturer';
                }

            }
        }
    }
}