with CLIC_Ex.Commands.TTY;
with CLIC_Ex.Commands.User_Input;

package body CLIC_Ex.Commands.Subsub is

   -------------
   -- Execute --
   -------------

   overriding
   procedure Execute  (Cmd : in out Instance;
                       Args : AAA.Strings.Vector)
   is
      procedure Set_Global_Switches
        (Config : in out CLIC.Subcommand.Switches_Configuration)
      is null;

      package Sub is new CLIC.Subcommand.Instance
        (Main_Command_Name   => "subsub",
         Version             => "0.0.0",
         Set_Global_Switches => Set_Global_Switches,
         Put                 => Ada.Text_IO.Put,
         Put_Line            => Ada.Text_IO.Put_Line,
         Put_Error           => Ada.Text_IO.Put_Line,
         Error_Exit          => GNAT.OS_Lib.OS_Exit,
         TTY_Chapter         => CLIC.Formatter.Chapter,
         TTY_Description     => CLIC.Formatter.Description,
         TTY_Version         => CLIC.Formatter.Version,
         TTY_Underline       => CLIC.Formatter.Underline,
         TTY_Emph            => CLIC.Formatter.Emph);
   begin
      Sub.Register (new Sub.Builtin_Help);
      Sub.Register (new CLIC_Ex.Commands.TTY.Instance);
      Sub.Register (new CLIC_Ex.Commands.User_Input.Instance);
      Sub.Execute (Args);
   end Execute;

end CLIC_Ex.Commands.Subsub;
