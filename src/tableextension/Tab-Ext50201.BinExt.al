namespace GKBCustomization.GKBCustomization;

using Microsoft.Warehouse.Structure;

//GkbLabs_Tv_04/12/25
tableextension 50201 "Bin Ext" extends Bin
{
    fields
    {
        field(50100; "CRM ID"; Text[100])
        {
            Caption = 'CRM ID';
            DataClassification = ToBeClassified;
        }
    }
}
//GkbLabs_Tv_04/12/25
