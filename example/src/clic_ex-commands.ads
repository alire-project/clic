
private with Ada.Text_IO;
private with GNAT.OS_Lib;
private with CLIC.Subcommand.Instance;
private with CLIC.TTY;
private with CLIC.Config;

package CLIC_Ex.Commands is

   procedure Execute;

private

   Config_DB : CLIC.Config.Instance;

   procedure Set_Global_Switches
     (Config : in out CLIC.Subcommand.Switches_Configuration);

   package Sub_Cmd is new CLIC.Subcommand.Instance
     (Main_Command_Name   => "clic_example",
      Version             => "0.0.0",
      Set_Global_Switches => Set_Global_Switches,
      Put                 => Ada.Text_IO.Put,
      Put_Line            => Ada.Text_IO.Put_Line,
      Put_Error           => Ada.Text_IO.Put_Line,
      Error_Exit          => GNAT.OS_Lib.OS_Exit,
      TTY_Chapter         => CLIC.TTY.Info,
      TTY_Description     => CLIC.TTY.Description,
      TTY_Version         => CLIC.TTY.Version,
      TTY_Underline       => CLIC.TTY.Underline,
      TTY_Emph            => CLIC.TTY.Emph);
end CLIC_Ex.Commands;
