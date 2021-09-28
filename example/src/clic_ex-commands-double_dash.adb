package body CLIC_Ex.Commands.Double_Dash is

   Upper_Case : aliased Boolean := False;

   -------------
   -- Execute --
   -------------

   overriding
   procedure Execute (Cmd : in out Instance; Args : AAA.Strings.Vector)
   is
   begin
      if Upper_Case then
         Ada.Text_IO.Put_Line (AAA.Strings.To_Upper_Case (Args.Flatten));
      else
         Ada.Text_IO.Put_Line (Args.Flatten);
      end if;

   end Execute;

   --------------------
   -- Setup_Switches --
   --------------------

   overriding
   procedure Setup_Switches
     (Cmd    : in out Instance;
      Config : in out CLIC.Subcommand.Switches_Configuration)
   is
   begin
      CLIC.Subcommand.Define_Switch (Config,
                                     Output => Upper_Case'Access,
                                     Long_Switch => "--upper");
   end Setup_Switches;

end CLIC_Ex.Commands.Double_Dash;
