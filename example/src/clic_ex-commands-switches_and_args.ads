with AAA.Strings;

with CLIC.Subcommand;

package CLIC_Ex.Commands.Switches_And_Args is

   type Instance
   is new CLIC.Subcommand.Command
   with private;

   overriding
   function Name (Cmd : Instance) return CLIC.Subcommand.Identifier
   is ("switches_and_args");

   overriding
   function Switch_Parsing (This : Instance)
                            return CLIC.Subcommand.Switch_Parsing_Kind
   is (CLIC.Subcommand.All_As_Args);

   overriding
   procedure Execute (Cmd  : in out Instance;
                      Args :        AAA.Strings.Vector);

   overriding
   function Long_Description (Cmd : Instance) return AAA.Strings.Vector
   is (AAA.Strings.Empty_Vector);

   overriding
   procedure Setup_Switches
     (Cmd    : in out Instance;
      Config : in out CLIC.Subcommand.Switches_Configuration)
   is null;

   overriding
   function Short_Description (Cmd : Instance) return String
   is ("Print all the sub-command switches and args");

   overriding
   function Usage_Custom_Parameters (Cmd : Instance) return String
   is ("[switches] [args]");

private

   type Instance
   is new CLIC.Subcommand.Command
   with null record;

end CLIC_Ex.Commands.Switches_And_Args;
