page 50103 "Input User Email Dialog"
{
    Caption = 'Add Specific User from Microsoft 365';
    PageType = List;
    SourceTable = UserPlan;
    ApplicationArea = All;
    SourceTableTemporary = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    layout
    {

        area(Content)
        {
            /*             field(UserEmail; UserEmail)
                        {
                            ApplicationArea = All;
                            Caption = 'User Email';
                            ExtendedDatatype = EMail;

                        } */
            repeater(General)
            {

                field("User email"; Rec."User email")
                {
                    trigger OnValidate()
                    var
                        lineno: Integer;

                    begin
                        if xLineNo = 0 then begin
                            xLineNo := 1;
                            Rec."Line No" := 1
                        end else begin
                            xLineNo += 1;
                            Rec."Line No" := xLineNo;
                        end;

                    end;
                }
                field("Id"; Rec."Line No")
                {

                }
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action("Add User Email")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    RecPlan: Record UserPlan;
                begin

                    if Rec.FindSet() then begin
                        repeat
                            if Rec."User email" <> '' then begin
                                SynchronizesAUser(Rec."User email");
                            end;
                        until Rec.Next() = 0;
                        Message('Task completed');
                    end;
                end;
            }
        }
    }
    var
        UserEmail: Text;
        AADUserMgt: Codeunit "Azure AD User Management";
        xLineNo: Integer;

    procedure SynchronizesAUser(UserADEmail: text[50])

    begin
        AADUserMgt.SynchronizeLicensedUserFromDirectory(UserADEmail);

    end;

    procedure DeleteUser()
    var
        jUser: Record User;
    begin
        if UserEmail = '' then
            Error('Email is required.');
        jUser.Reset();
        jUser.SetFilter("Authentication Email", '*' + UserEmail + '*');
        IF jUser.FindSet() then begin
            repeat
                jUser.Delete();

            until jUser.Next() = 0;
            Message(UserEmail + ' is deleted!');
        end;
    end;
}
