with AAA.Strings;

with CLIC.TTY;
with CLIC.User_Input;
with CLIC.Config.Load;

with CLIC_Ex.Commands.TTY;
with CLIC_Ex.Commands.User_Input;
with CLIC_Ex.Commands.Switches_And_Args;
with CLIC_Ex.Commands.Double_Dash;
with CLIC_Ex.Commands.Topics.Example;
with CLIC_Ex.Commands.Config;
with CLIC_Ex.Commands.Subsub;

package body CLIC_Ex.Commands is

   Help_Switch : aliased Boolean := False;

   No_Color : aliased Boolean := False;
   --  Force-disable color output

   No_TTY : aliased Boolean := False;
   --  Used to disable control characters in output

   -------------------------
   -- Set_Global_Switches --
   -------------------------

   procedure Set_Global_Switches
     (Config : in out CLIC.Subcommand.Switches_Configuration)
   is
      use CLIC.Subcommand;
   begin
      Define_Switch (Config,
                     Help_Switch'Access,
                     "-h", "--help",
                     "Display general or command-specific help");

      Define_Switch (Config,
                     CLIC.User_Input.Not_Interactive'Access,
                     "-n", "--non-interactive",
                     "Assume default answers for all user prompts");

      Define_Switch (Config,
                     No_Color'Access,
                     Long_Switch => "--no-color",
                     Help        => "Disables colors in output");

      Define_Switch (Config,
                     No_TTY'Access,
                     Long_Switch => "--no-tty",
                     Help        => "Disables control characters in output");
   end Set_Global_Switches;

   -------------
   -- Execute --
   -------------

   procedure Execute is
   begin
      Sub_Cmd.Parse_Global_Switches;

      if No_TTY then
         CLIC.TTY.Force_Disable_TTY;
      end if;

      if not No_Color and then not No_TTY then
         CLIC.TTY.Enable_Color (Force => False);
         --  This may still not enable color if TTY is detected to be incapable
      end if;

      CLIC.Config.Load.From_TOML (Config_DB, "global", "global_config.toml");
      CLIC.Config.Load.From_TOML (Config_DB, "local", "local_config.toml");

      Sub_Cmd.Load_Aliases (Config_DB);

      Sub_Cmd.Execute;
   end Execute;

begin

   Sub_Cmd.Register (new Sub_Cmd.Builtin_Help);
   Sub_Cmd.Register (new CLIC_Ex.Commands.Config.Instance);
   Sub_Cmd.Register (new CLIC_Ex.Commands.TTY.Instance);
   Sub_Cmd.Register (new CLIC_Ex.Commands.User_Input.Instance);
   Sub_Cmd.Register (new CLIC_Ex.Commands.Switches_And_Args.Instance);
   Sub_Cmd.Register (new CLIC_Ex.Commands.Double_Dash.Instance);
   Sub_Cmd.Register (new CLIC_Ex.Commands.Subsub.Instance);
   Sub_Cmd.Register (new CLIC_Ex.Commands.Topics.Example.Instance);

   Sub_Cmd.Set_Alias ("blink", AAA.Strings.Empty_Vector
                               .Append ("tty")
                               .Append ("--blink"));

   Sub_Cmd.Set_Alias ("error_alias", AAA.Strings.Empty_Vector
                                     .Append ("tty")
                                     .Append ("--test"));

   Sub_Cmd.Set_Alias ("alias_to_switch", AAA.Strings.Empty_Vector
                                         .Append ("--plop"));
end CLIC_Ex.Commands;
