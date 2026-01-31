namespace GKBCustomization.GKBCustomization;

using Microsoft.Foundation.NoSeries;

codeunit 50251 "FA Prefix Setup"
{
    procedure PopulateNoSeriesMappings()
    var
        NoSeries: Record "No. Series";
    begin
        // FASC
        if NoSeries.Get('FASC') then begin
            NoSeries.Validate("FA Class Code", 'INTANGIBL');
            NoSeries.Validate("FA Subclass Code", 'COMP SOFT');
            if NoSeries."Default FA Posting Group" = '' then
                NoSeries.Validate("Default FA Posting Group", 'CS');
            NoSeries.Modify();
        end else begin
            NoSeries.Init();
            NoSeries.Code := 'FASC';
            NoSeries.Description := 'Computer Software';
            NoSeries."FA Class Code" := 'INTANGIBL';
            NoSeries."FA Subclass Code" := 'COMP SOFT';
            NoSeries."Default FA Posting Group" := 'CS';
            NoSeries.Insert();
        end;

        // FAFF
        if NoSeries.Get('FAFF') then begin
            NoSeries.Validate("FA Class Code", 'TANGIBLE');
            NoSeries.Validate("FA Subclass Code", 'FURNT&FITT');
            if NoSeries."Default FA Posting Group" = '' then
                NoSeries.Validate("Default FA Posting Group", 'FF');
            NoSeries.Modify();
        end else begin
            NoSeries.Init();
            NoSeries.Code := 'FAFF';
            NoSeries.Description := 'Furniture & Fittings';
            NoSeries."FA Class Code" := 'TANGIBLE';
            NoSeries."FA Subclass Code" := 'FURNT&FITT';
            NoSeries."Default FA Posting Group" := 'FF';
            NoSeries.Insert();
        end;

        // FAIE
        if NoSeries.Get('FAIE') then begin
            NoSeries.Validate("FA Class Code", 'TANGIBLE');
            NoSeries.Validate("FA Subclass Code", 'IT&EQUIPME');
            if NoSeries."Default FA Posting Group" = '' then
                NoSeries.Validate("Default FA Posting Group", 'ITE');
            NoSeries.Modify();
        end else begin
            NoSeries.Init();
            NoSeries.Code := 'FAIE';
            NoSeries.Description := 'IT & Equipment';
            NoSeries."FA Class Code" := 'TANGIBLE';
            NoSeries."FA Subclass Code" := 'IT&EQUIPME';
            NoSeries."Default FA Posting Group" := 'ITE';
            NoSeries.Insert();
        end;

        // FALI
        if NoSeries.Get('FALI') then begin
            NoSeries.Validate("FA Class Code", 'TANGIBLE');
            NoSeries.Validate("FA Subclass Code", 'LEASEHOLD');
            if NoSeries."Default FA Posting Group" = '' then
                NoSeries.Validate("Default FA Posting Group", 'LI');
            NoSeries.Modify();
        end else begin
            NoSeries.Init();
            NoSeries.Code := 'FALI';
            NoSeries.Description := 'Leasehold Imp';
            NoSeries."FA Class Code" := 'TANGIBLE';
            NoSeries."FA Subclass Code" := 'LEASEHOLD';
            NoSeries."Default FA Posting Group" := 'LI';
            NoSeries.Insert();
        end;

        // FALC
        if NoSeries.Get('FALC') then begin
            NoSeries.Validate("FA Class Code", 'TANGIBLE');
            NoSeries.Validate("FA Subclass Code", 'LOWCOSTPOL');
            if NoSeries."Default FA Posting Group" = '' then
                NoSeries.Validate("Default FA Posting Group", 'LCP');
            NoSeries.Modify();
        end else begin
            NoSeries.Init();
            NoSeries.Code := 'FALC';
            NoSeries.Description := 'Low cost Pool';
            NoSeries."FA Class Code" := 'TANGIBLE';
            NoSeries."FA Subclass Code" := 'LOWCOSTPOL';
            NoSeries."Default FA Posting Group" := 'LCP';
            NoSeries.Insert();
        end;

        // FAOE
        if NoSeries.Get('FAOE') then begin
            NoSeries.Validate("FA Class Code", 'TANGIBLE');
            NoSeries.Validate("FA Subclass Code", 'OFFICE EQU');
            if NoSeries."Default FA Posting Group" = '' then
                NoSeries.Validate("Default FA Posting Group", 'OE');
            NoSeries.Modify();
        end else begin
            NoSeries.Init();
            NoSeries.Code := 'FAOE';
            NoSeries.Description := 'Office equipment';
            NoSeries."FA Class Code" := 'TANGIBLE';
            NoSeries."FA Subclass Code" := 'OFFICE EQU';
            NoSeries."Default FA Posting Group" := 'OE';
            NoSeries.Insert();
        end;

        // FAPM
        if NoSeries.Get('FAPM') then begin
            NoSeries.Validate("FA Class Code", 'TANGIBLE');
            NoSeries.Validate("FA Subclass Code", 'PM');
            if NoSeries."Default FA Posting Group" = '' then
                NoSeries.Validate("Default FA Posting Group", 'PM');
            NoSeries.Modify();
        end else begin
            NoSeries.Init();
            NoSeries.Code := 'FAPM';
            NoSeries.Description := 'Plant and Machinery';
            NoSeries."FA Class Code" := 'TANGIBLE';
            NoSeries."FA Subclass Code" := 'PM';
            NoSeries."Default FA Posting Group" := 'PM';
            NoSeries.Insert();
        end;

        // FARB
        if NoSeries.Get('FARB') then begin
            NoSeries.Validate("FA Class Code", 'TANGIBLE');
            NoSeries.Validate("FA Subclass Code", 'RNTALBOILP');
            if NoSeries."Default FA Posting Group" = '' then
                NoSeries.Validate("Default FA Posting Group", 'RB');
            NoSeries.Modify();
        end else begin
            NoSeries.Init();
            NoSeries.Code := 'FARB';
            NoSeries.Description := 'Rental Boilers - P&E';
            NoSeries."FA Class Code" := 'TANGIBLE';
            NoSeries."FA Subclass Code" := 'RNTALBOILP';
            NoSeries."Default FA Posting Group" := 'RB';
            NoSeries.Insert();
        end;

        // FAMV
        if NoSeries.Get('FAMV') then begin
            NoSeries.Validate("FA Class Code", 'TANGIBLE');
            NoSeries.Validate("FA Subclass Code", 'VEHICLES');
            if NoSeries."Default FA Posting Group" = '' then
                NoSeries.Validate("Default FA Posting Group", 'MV');
            NoSeries.Modify();
        end else begin
            NoSeries.Init();
            NoSeries.Code := 'FAMV';
            NoSeries.Description := 'Vehicles';
            NoSeries."FA Class Code" := 'TANGIBLE';
            NoSeries."FA Subclass Code" := 'VEHICLES';
            NoSeries."Default FA Posting Group" := 'MV';
            NoSeries.Insert();
        end;

        Message('No. Series mappings populated successfully.');
    end;
}