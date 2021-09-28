with AAA.Strings;

with CLIC.Subcommand;
with CLIC.Config;

package CLIC_Ex.Commands.Config is

   type Instance
   is limited new CLIC.Subcommand.Command
   with private;

   overriding
   function Name (Cmd : Instance) return CLIC.Subcommand.Identifier
   is ("config");

   overriding
   function Switch_Parsing (This : Instance)
                            return CLIC.Subcommand.Switch_Parsing_Kind
   is (CLIC.Subcommand.Parse_All);

   overriding
   procedure Execute (Cmd  : in out Instance;
                      Args :        AAA.Strings.Vector);

   overriding
   procedure Setup_Switches
     (Cmd    : in out Instance;
      Config : in out CLIC.Subcommand.Switches_Configuration);

   overriding
   function Short_Description (Cmd : Instance) return String
   is ("List, Get, Set or Unset configuration options");

   overriding
   function Usage_Custom_Parameters (Cmd : Instance) return String is
     ("[--list] [--show-origin] [key_regex] |" &
        " --get <key> |" &
        " --set <key> <value> |" &
        " --unset <key>");

   overriding
   function Long_Description (Cmd : Instance)
                              return AAA.Strings.Vector
   is
     (AAA.Strings.Empty_Vector
      .Append ("Provides a command line interface to the Alire configuration" &
                 " option files.")
      .New_Line
      .Append ("Option names (keys) can use lowercase and uppercase" &
                 " alphanumeric characters")
      .Append ("from the Latin alphabet. Underscores and dashes can also be" &
                 " used except as")
      .Append ("first or last character. Dot '.' is used to specify" &
                 " sub-categories, e.g.")
      .Append ("'user.name' or 'user.email'.")
      .New_Line

      .Append ("Option values can be integers, float, Boolean (true or" &
                 " false) or strings. The")
      .Append ("type detection is automatic, e.g. 10 is integer, 10.1 is" &
                 " float, true is")
      .Append ("Boolean. You can force a value to be set a string by using" &
                 " double-quotes, e.g.")
      .Append ("""10.1"" or ""true"". Extra type checking is used for" &
                 " built-in options (see below).")
      .New_Line
      .Append ("Built-in configuration options:"));

private

   type Instance
   is limited new CLIC.Subcommand.Command with record
      Config       : CLIC.Config.Instance;
      Show_Origin  : aliased Boolean := False;
      List         : aliased Boolean := False;
      Get          : aliased Boolean := False;
      Set          : aliased Boolean := False;
      Unset        : aliased Boolean := False;
      Global       : aliased Boolean := False;
      Builtins_Doc : aliased Boolean := False;
   end record;

end CLIC_Ex.Commands.Config;
