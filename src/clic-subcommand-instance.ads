--  Instantiate this package to create a sub-command parser/executor

with CLIC.Config;

generic

   Main_Command_Name : String; --  Name of the main command or program
   Version           : String; --  Version of the program

   with procedure Set_Global_Switches
     (Config : in out CLIC.Subcommand.Switches_Configuration);
   --  This procedure should define the global switches using the
   --  Register_Switch procedures of the CLIC.Subcommand package.

   with procedure Put (Str : String); -- Used to print help and usage
   with procedure Put_Line (Str : String); -- Used to print help and usage
   with procedure Put_Error (Str : String); -- Used to print errors

   with procedure Error_Exit (Code : Integer);
   --  Used to signal that the program should terminate with the give error
   --  code. Typicaly use GNAT.OS_Lib.OS_Exit.

   --  The procedures below are used to format the output such as usage and
   --  help. Use CLIC.Subcommand.No_TTY if you don't want or need formating.
   with function TTY_Chapter (Str : String) return String;
   with function TTY_Description (Str : String) return String;
   with function TTY_Version (Str : String) return String;
   with function TTY_Underline (Str : String) return String;
   with function TTY_Emph (Str : String) return String;

package CLIC.Subcommand.Instance is

   procedure Register (Cmd : not null Command_Access);
   --  Register a sub-command

   procedure Register (Group : String; Cmd : not null Command_Access);
   --  Register a sub-command in a group

   procedure Register (Topic : not null Help_Topic_Access);
   --  Register a help topic

   procedure Set_Alias (Alias : Identifier; Replacement : AAA.Strings.Vector);
   --  Define Alias such that "<Main_Command_Name> <Alias> <Extra_Args>" will
   --  be replaced by "<Main_Command_Name> <Replacement> <Extra_Args>".
   --  If Alias is already set, it will be silently replaced.

   procedure Load_Aliases (Conf     : CLIC.Config.Instance;
                           Root_Key : String := "alias");
   --  Load aliases from the given configuration.
   --
   --  All the config keys in the format "<Root_Key>.<sub-key>" are
   --  processed. If the value of a key is a (not null) String, <sub-key>
   --  is registered as an alias for the value (parsed into a list with
   --  GNAT.OS_Lib.Argument_String_To_List).
   --
   --  For instance when Root_Key := "alias" (default):
   --  alias.test1 = "cmd arg1 arg2" # Valid: test1 -> ["cmd", "arg1", "arg2"]
   --  alias.test2 = "cmd"           # Valid: test2 -> ["cmd"]
   --  alias.test3 = ""              # Ignored
   --  alias.test4.test = "cmd arg1" # Ignored
   --  alias.test5 = 20              # Ignored
   --  alias.test6 = ["cmd", "arg1"] # Ignored

   procedure Execute
     (Command_Line : AAA.Strings.Vector := AAA.Strings.Empty_Vector);
   --  Parse the command line and execute a sub-command or display help/usage
   --  depending on command line args.
   --
   --  If Command_Line is not empty it will be used instead of the actual
   --  command line arguments from Ada.Command_Line.

   procedure Parse_Global_Switches
     (Command_Line : AAA.Strings.Vector := AAA.Strings.Empty_Vector);
   --  Optional. Call this procedure before Execute to get only global switches
   --  parsed. This can be useful to check the values of global switches before
   --  running a sub-command or change the behavior of your program based on
   --  these (e.g. verbosity, output color, etc.).
   --
   --  If Command_Line is not empty it will be used instead of the actual
   --  command line arguments from Ada.Command_Line.

   function What_Command return String;

   procedure Display_Usage (Displayed_Error : Boolean := False);

   procedure Display_Help (Keyword : String);

   Error_No_Command : exception;
   Command_Already_Defined : exception;

   type Builtin_Help is new Command with private;
   --  Use Register (new Builtin_Help); to provide a build-in help command

   function Is_Global_Switch (Switch : String) return Boolean;
   --  Say if the switch has been defined as global

private

   -- Built-in Help Command --
   type Builtin_Help is new Command with null record;

   overriding
   function Name (This : Builtin_Help) return Identifier
   is ("help");

   overriding
   function Switch_Parsing (This : Builtin_Help) return Switch_Parsing_Kind
   is (Parse_All);

   overriding
   procedure Execute (This : in out Builtin_Help;
                      Args :        AAA.Strings.Vector);

   overriding
   function Long_Description (This : Builtin_Help)
                              return AAA.Strings.Vector
   is (AAA.Strings.Empty_Vector
       .Append ("Shows information about commands and topics.")
       .Append ("See available commands with '" &
           Main_Command_Name & " help commands'")
       .Append ("See available topics with '" &
           Main_Command_Name & " help topics'."));

   overriding
   procedure Setup_Switches
     (This    : in out Builtin_Help;
      Config  : in out CLIC.Subcommand.Switches_Configuration)
   is null;

   overriding
   function Short_Description (This : Builtin_Help) return String
   is ("Shows help on the given command/topic");

   overriding
   function Usage_Custom_Parameters (This : Builtin_Help) return String
   is ("[<command>|<topic>]");

end CLIC.Subcommand.Instance;
