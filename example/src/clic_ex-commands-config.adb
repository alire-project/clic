with GNAT.OS_Lib;

with Simple_Logging;

with CLIC.Config.Info;
with CLIC.Config.Edit;
with CLIC.Config.Load;

package body CLIC_Ex.Commands.Config is

   package Trace renames Simple_Logging;

   -------------
   -- Execute --
   -------------

   overriding
   procedure Execute (Cmd  : in out Instance;
                      Args :        AAA.Strings.Vector)
   is
      Enabled : Natural := 0;

      Config_Path : constant String :=
        (if Cmd.Global then "global_config.toml" else "local_config.toml");

   begin
      --  Check no multi-action
      Enabled := Enabled + (if Cmd.List then 1 else 0);
      Enabled := Enabled + (if Cmd.Get then 1 else 0);
      Enabled := Enabled + (if Cmd.Set then 1 else 0);
      Enabled := Enabled + (if Cmd.Unset then 1 else 0);
      Enabled := Enabled + (if Cmd.Builtins_Doc then 1 else 0);

      if Enabled > 1 then
         Trace.Error ("Specify at most one subcommand");
         GNAT.OS_Lib.OS_Exit (1);
      end if;

      if Enabled = 0 then
         --  The default command is --list
         Cmd.List := True;
      end if;

      if Cmd.Show_Origin and then not Cmd.List then
         Trace.Error ("--show-origin only valid with --list");
               GNAT.OS_Lib.OS_Exit (1);
      end if;

      if Cmd.List then
         case Args.Count is
            when 0 =>
               Trace.Always
                 (CLIC.Config.Info.List
                    (Cmd.Config,
                     Filter => "*",
                     Show_Origin => Cmd.Show_Origin).Flatten (ASCII.LF));
            when 1 =>
               Trace.Always
                 (CLIC.Config.Info.List
                    (Cmd.Config,
                     Filter => Args.First_Element,
                     Show_Origin => Cmd.Show_Origin).Flatten (ASCII.LF));
            when others =>
               Trace.Error ("List expects at most one argument");
               GNAT.OS_Lib.OS_Exit (1);
         end case;

      elsif Cmd.Get then
         if Args.Count /= 1 then
            Trace.Error ("Unset expects one argument");
            GNAT.OS_Lib.OS_Exit (1);
         end if;

         if not CLIC.Config.Is_Valid_Config_Key (Args.First_Element) then
            Trace.Error ("Invalid configration key '" &
                           Args.First_Element & "'");
            GNAT.OS_Lib.OS_Exit (1);
         end if;

         if Cmd.Config.Defined (Args.First_Element) then
            Trace.Always (Cmd.Config.Get_As_String (Args.First_Element));
         else
            Trace.Error ("Configuration key '" &
                           Args.First_Element &
                           "' is not defined");
            GNAT.OS_Lib.OS_Exit (1);

         end if;
      elsif Cmd.Set then
         if Args.Count /= 2 then
            Trace.Error ("Set expects two arguments");
            GNAT.OS_Lib.OS_Exit (1);
         end if;

         declare
            Key : constant String := Args.Element (1);
            Val : constant String := Args.Element (2);
         begin

            if not CLIC.Config.Is_Valid_Config_Key (Key) then
               Trace.Error ("Invalid configration key '" & Key & "'");
               GNAT.OS_Lib.OS_Exit (1);
            end if;

            if not CLIC.Config.Edit.Set (Config_Path, Key, Val) then
               GNAT.OS_Lib.OS_Exit (1);
            end if;
         end;

      elsif Cmd.Unset then
         if Args.Count /= 1 then
            Trace.Error ("Unset expects one argument");
            GNAT.OS_Lib.OS_Exit (1);
         end if;

         declare
            Key : constant String := Args.Element (1);
         begin
            if not CLIC.Config.Is_Valid_Config_Key (Key) then
               Trace.Error ("Invalid configration key '" &
                 Key & "'");
               GNAT.OS_Lib.OS_Exit (1);
            end if;

            if not CLIC.Config.Edit.Unset (Config_Path, Key) then
               GNAT.OS_Lib.OS_Exit (1);
            end if;
         end;
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
      use CLIC.Subcommand;
   begin
      Define_Switch
        (Config      => Config,
         Output      => Cmd.List'Access,
         Long_Switch => "--list",
         Help        => "List configuration options");

      Define_Switch
        (Config      => Config,
         Output      => Cmd.Show_Origin'Access,
         Long_Switch => "--show-origin",
         Help        => "Show origin of configuration values in --list");

      Define_Switch
        (Config      => Config,
         Output      => Cmd.Get'Access,
         Long_Switch => "--get",
         Help        => "Print value of a configuration option");

      Define_Switch
        (Config      => Config,
         Output      => Cmd.Set'Access,
         Long_Switch => "--set",
         Help        => "Set a configuration option");

      Define_Switch
        (Config      => Config,
         Output      => Cmd.Unset'Access,
         Long_Switch => "--unset",
         Help        => "Unset a configuration option");

      Define_Switch
        (Config      => Config,
         Output      => Cmd.Global'Access,
         Long_Switch => "--global",
         Help        => "Set and Unset global configuration instead" &
                         " of the local one");

      Define_Switch
        (Config      => Config,
         Output      => Cmd.Builtins_Doc'Access,
         Long_Switch => "--builtins-doc",
         Help        =>
           "Print Markdown list of built-in configuration options");

   end Setup_Switches;

end CLIC_Ex.Commands.Config;
