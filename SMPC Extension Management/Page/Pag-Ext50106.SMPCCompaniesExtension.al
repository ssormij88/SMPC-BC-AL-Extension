pageextension 50106 SMPCCompaniesExtension extends Companies
{
    actions
    {
        addfirst(processing)
        {
            action(CopyMultipleCompanies)
            {
                Caption = 'Copy to Multiple Companies';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Copy;

                trigger OnAction()
                var
                    CopyMultiCompaniesPage: Page "Copy to multiple companies";
                begin
                    CopyMultiCompaniesPage.SetSourceName(Rec.Name);
                    if CopyMultiCompaniesPage.RunModal() = Action::OK then
                        CopyMultiCompaniesPage.CopytoMultipleCompanies();
                end;
            }
        }
    }
}
