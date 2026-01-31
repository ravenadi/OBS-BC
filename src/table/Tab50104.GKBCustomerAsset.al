table 50104 "GKB Customer Asset"
{
    Caption = 'Customer Asset';
    DrillDownPageId = "Customer Asset List";
    LookupPageId = "Customer Asset Card";
    DataClassification = CustomerContent;


    fields
    {
        field(1; No; Code[20])
        {
            Caption = 'No';
        }
        field(2; "Account Id"; Text[100])
        {
            Caption = 'Account Id';
            DataClassification = ToBeClassified;
        }
        field(3; Account; Code[50])
        {
            Caption = 'Account';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(4; "Equipment Card No."; Text[100])
        {
            Caption = 'Equipment Card No.';
            DataClassification = ToBeClassified;
        }
        field(5; "Name"; Text[100])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(6; "Asset number"; Text[100])
        {
            Caption = 'Asset Number';
            DataClassification = ToBeClassified;
        }
        field(7; "Asset Location"; Code[50])
        {
            Caption = 'Asset Location';
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(8; "Equipment Category"; enum "Empty Enum")
        {
            Caption = 'Equipment Category';
            DataClassification = ToBeClassified;
            // OptionCaption = '';
            // OptionMembers = "";
        }
        field(9; "Product Id"; Text[100])
        {
            Caption = 'product Id';
            DataClassification = ToBeClassified;
        }
        field(10; "SAP Item No."; Text[100])
        {
            Caption = 'SAP Item No.';
            DataClassification = ToBeClassified;
        }
        field(11; "Product"; Code[50])
        {
            Caption = 'Product';
            DataClassification = ToBeClassified;
            // TableRelation = ;
        }
        field(12; "Top-Level Asset"; Code[50])
        {
            Caption = 'Top-Level Asset';
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(13; "Parent Asset"; Code[50])
        {
            Caption = 'Parent Asset';
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(14; "CRM ID"; Text[100])
        {
            Caption = 'CRM ID';
            DataClassification = ToBeClassified;
        }
        field(15; "Agreement"; Code[50])
        {
            Caption = 'Agreement';
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(16; "Boiler Type"; enum "Boiler Type")
        {
            Caption = 'Boiler Type';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Condensing Boiler,Electric Boiler,High Temperature Hot Wa,Vertical Boiler,Waste Heat Boiler,Watertube Boiler,Coal Boiler,Biogas Boiler,Hot Oil,Hot Water,Superheated Steam';
            // OptionMembers = " ","Condensing Boiler","Electric Boiler","High Temperature Hot Wa","Vertical Boiler","Waste Heat Boiler","Watertube Boiler","Coal Boiler","Biogas Boiler","Hot Oil","Hot Water","Superheated Steam";
        }
        field(17; "Asset Tag"; Text[100])
        {
            Caption = 'Asset Tag';
            DataClassification = ToBeClassified;
        }
        field(18; "Building No. Name"; Text[100])
        {
            Caption = 'Building No. Name';
            DataClassification = ToBeClassified;
        }
        field(19; "Burner Brand"; enum "Manufacturer")
        {
            Caption = 'Burner Brand';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Saake,Eclipse,Elco,Reillo,American Meter,Weishapht,Nu-Way,REX 35,N/A,Cleaver Brooks,Industrial Combustion,Maxitherm,Eco-Flam,FBR,Dunphy,Baltur,Other';
            // OptionMembers = " ",Saake,Eclipse,Elco,Reillo,"American Meter",Weishapht,"Nu-Way","REX 35","N/A","Cleaver Brooks","Industrial Combustion",Maxitherm,"Eco-Flam",FBR,Dunphy,Baltur,Other;
        }
        field(20; "Burner Type"; enum "Burner Type")
        {
            Caption = 'Burner Type';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Water Tube,Jet,Duo-Bloc,Duct,Pre-Mixed,Integrated,Atmospheric Burner,Pro Mix Burner,Others,N/A,Natural Gas,Int,grated (Packaged),Pro-Mixed,Processed Burner';
            // OptionMembers = " ","Water Tube",Jet,"Duo-Bloc",Duct,"Pre-Mixed",Integrated,"Atmospheric Burner","Pro Mix Burner",Others,"N/A","Natural Gas",Int,"grated (Packaged)","Pro-Mixed","Processed Burner";
        }
        field(21; "Capacity(KW)"; Text[100])
        {
            Caption = 'Capacity(KW)';
            DataClassification = ToBeClassified;
        }
        field(22; "Category"; Code[50])
        {
            Caption = 'Category';
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(23; "Date Of Next 4 Monthly"; Date)
        {
            Caption = 'Date Of Next 4 Monthly';
            DataClassification = ToBeClassified;
        }
        field(24; "Date OfNext6MtlySteamTrapAudit"; Date)
        {
            Caption = 'Date Of Next 6 Monthly Steam Trap Audit';
            DataClassification = ToBeClassified;
        }
        field(25; "Date Of Next AS2593 Audit"; Date)
        {
            Caption = 'Date Of Next AS2593 Audit';
            DataClassification = ToBeClassified;
        }
        field(26; "Date Of Next Biennial Service"; Date)
        {
            Caption = 'Date Of Next Biennial Service';
            DataClassification = ToBeClassified;
        }
        field(27; "Date Of Next Steam Trap Audit"; Date)
        {
            Caption = 'Date Of Next Steam Trap Audit';
            DataClassification = ToBeClassified;
        }
        field(28; Days; Integer)
        {
            Caption = 'Days';
            DataClassification = ToBeClassified;
        }
        field(29; "Installation Date"; Date)
        {
            Caption = 'Installation Date';
            DataClassification = ToBeClassified;
        }
        field(30; "Last active alert time"; DateTime)
        {
            Caption = 'Last active alert time';
            DataClassification = ToBeClassified;
        }
        field(31; "Last Biennal Date"; Date)
        {
            Caption = 'Last Biennal Date';
            DataClassification = ToBeClassified;
        }
        field(32; "Equipment Man"; enum "Boiler Brand")
        {
            Caption = 'Equipment Man';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ALFAREL,ALLIANCE,CLAYTON,CLEAVERBROOKS,EAST COAST STEAM,FLEX,HUNT,MAXITHERM,N/A,OBY BASSO,OBY – 88,OBYALTO,OBYCON,OBYFLAME,OBYGREEN,OBYMAXIMO,OBYONE,OBYPHASE,OBYTRICE,OBYVERT,OTHER,RAYPACK,SUPERIOR,TOMLINSON,TPE,TREVOR,WHB';
            // OptionMembers = " ",ALFAREL,ALLIANCE,CLAYTON,CLEAVERBROOKS,"EAST COAST STEAM",FLEX,HUNT,MAXITHERM,"N/A","OBY BASSO","OBY – 88",OBYALTO,OBYCON,OBYFLAME,OBYGREEN,OBYMAXIMO,OBYONE,OBYPHASE,OBYTRICE,OBYVERT,OTHER,RAYPACK,SUPERIOR,TOMLINSON,TPE,TREVOR,WHB;
        }
        field(33; "ETC Serial No"; Text[100])
        {
            Caption = 'ETC Serial No';
            DataClassification = ToBeClassified;
        }
        field(34; Floor; Text[100])
        {
            Caption = 'Floor';
            DataClassification = ToBeClassified;
        }
        field(35; "Fuel Type"; enum "Fuel Type")
        {
            Caption = 'Fuel Type';
            DataClassification = ToBeClassified;
            // OptionCaption = 'Biogas,Biomass,Coal,Diesel,Electricity,Natural Gas,Hydrogen,LPG,Waste Oil,N/A';
            // OptionMembers = " ",Biogas,Biomass,Coal,Diesel,Electricity,"Natural Gas",Hydrogen,LPG,"Waste Oil","N/A";
        }
        field(36; "Functional Location"; Code[50])
        {
            Caption = 'Functional Location';
            DataClassification = ToBeClassified;
            TableRelation = "Ship-to Address";
        }
        field(37; Manufacture; Code[50])
        {
            Caption = 'Manufacture';
            DataClassification = ToBeClassified;
            TableRelation = Manufacturer;
        }
        field(38; "Manufacture Date"; Date)
        {
            Caption = 'Manufacture Date';
            DataClassification = ToBeClassified;
        }
        field(39; Manufacturer; Text[100])
        {
            Caption = 'Manufacturer';
            DataClassification = ToBeClassified;
        }
        field(40; "Manufacture Detail"; Text[100])
        {
            Caption = 'Manufacture Detail';
            DataClassification = ToBeClassified;
        }
        field(41; "Manufacture Serial No."; Text[100])
        {
            Caption = 'Manufacture Detail';
            DataClassification = ToBeClassified;
        }

        field(42; "Manufacturing Date"; Text[100])
        {
            Caption = 'Manufacturing Date';
            DataClassification = ToBeClassified;
        }
        field(43; "Next 3 Monthly Date"; Date)
        {
            Caption = 'Next 3 Monthly Date';
            DataClassification = ToBeClassified;
        }
        field(44; "Next 5 Weekly Date"; Date)
        {
            Caption = 'Next 5 Weekly Date';
            DataClassification = ToBeClassified;
        }
        field(45; "Next 6 Monthly Date"; Date)
        {
            Caption = 'Next 6 Monthly Date';
            DataClassification = ToBeClassified;
        }
        field(46; "Next Annual Date"; Date)
        {
            Caption = 'Next Annual Date';
            DataClassification = ToBeClassified;
        }
        field(47; "NoOfTechniesForAnnualService"; Integer)
        {
            Caption = 'No Of Technies For Annual Service';
            DataClassification = ToBeClassified;
        }
        field(48; "OBS Sim No"; Integer)
        {
            Caption = 'OBS Sim No';
            DataClassification = ToBeClassified;
        }
        field(49; "On-Site Installed location"; Text[100])
        {
            Caption = 'On-Site Installed location';
            DataClassification = ToBeClassified;
        }
        field(50; "Owning business Unit"; Code[50])
        {
            Caption = 'Owning Business Unit';
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
        }
        field(51; Pressure; Text[100])
        {
            Caption = 'Pressure';
            DataClassification = ToBeClassified;
        }
        field(52; "Registration Status"; enum "Registration Status")
        {
            Caption = 'Registration Status';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Unknown,Unregistered,In Progress,Registered,Error';
            // OptionMembers = " ",Unknown,Unregistered,"In Progress",Registered,Error;
        }
        field(53; "Room Location"; Text[100])
        {
            Caption = 'Room Location';
            DataClassification = ToBeClassified;
        }
        field(54; "Safety Valve"; Text[100])
        {
            Caption = 'Safety Valve';
            DataClassification = ToBeClassified;
        }
        field(55; Status; enum "Activity Status")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Active,InActive';
            // OptionMembers = " ",Active,InActive;
        }
        field(56; "Status reason"; Text[100])
        {
            Caption = 'Status Reason';
            DataClassification = ToBeClassified;
        }
        field(57; Unit; Text[100])
        {
            Caption = 'Unit';
            DataClassification = ToBeClassified;
        }
        field(58; warrenty; enum Choice1)
        {
            Caption = 'warrenty';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Yes,No';
            // OptionMembers = " ",YES,NO;
        }
        field(59; "Budgeted hours 3 Monthly"; Integer)
        {
            Caption = 'Budgeted hours 3 Monthly';
            DataClassification = ToBeClassified;
        }
        field(60; "Budgeted hours 4 Monthly"; Integer)
        {
            Caption = 'Budgeted hours 4 Monthly';
            DataClassification = ToBeClassified;
        }
        field(61; "Budgeted hours 5 Monthly"; Integer)
        {
            Caption = 'Budgeted Hours 5 Monthly';
            DataClassification = ToBeClassified;
        }
        field(62; "Budgeted hours 6 Monthly"; Integer)
        {
            Caption = 'Budgeted Hours 6 Monthly';
            DataClassification = ToBeClassified;
        }
        field(63; "Budgetedhrs6MntlyStmtrapaudit"; Integer)
        {
            Caption = 'Budgeted Hrs 6 Monthly Steam Trap Audit';
            DataClassification = ToBeClassified;
        }
        field(64; "Budgeted hours AS2593"; Integer)
        {
            Caption = 'Budgeted Hours AS2593';
            DataClassification = ToBeClassified;
        }
        field(65; "Budgeted hours for annual"; Integer)
        {
            Caption = 'Budgeted Hours For Annual';
            DataClassification = ToBeClassified;
        }
        field(66; "BudgetedhrsforbiennialSerice"; Integer)
        {
            Caption = 'Budgeted Hrs for Biennial Serice';
            DataClassification = ToBeClassified;
        }
        field(67; "Budgeted hrs 3steam trap audit"; Integer)
        {
            Caption = 'Budgeted Hrs 3 Steam Trap Audit';
            DataClassification = ToBeClassified;
        }
        field(68; Owner; Code[50])
        {
            Caption = 'Owner';
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(69; Notes; Text[100])
        {
            Caption = 'Notes';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
        key(Key2; Name)
        { }
        key(Key3; "Account Id")
        { }
    }
}