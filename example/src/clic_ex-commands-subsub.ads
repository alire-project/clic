with AAA.Strings;

with CLIC.Subcommand;

package CLIC_Ex.Commands.Subsub is

   type Instance
   is new CLIC.Subcommand.Command
   with private;

   overriding
   function Name (Cmd : Instance) return CLIC.Subcommand.Identifier
   is ("subsub");

   overriding
   function Switches_As_Args (This : Instance) return Boolean
   is (True);

   overriding
   procedure Execute (Cmd  : in out Instance;
                      Args :        AAA.Strings.Vector);

   overriding
   function Long_Description (Cmd : Instance) return AAA.Strings.Vector
   is (AAA.Strings.Empty_Vector
       .Append ("Long description Line1")
       .Append ("Long description Line2")
       .Append ("Long description Line3")
       .New_Line
       .Append ("Long description Line2"));

   overriding
   procedure Setup_Switches
     (Cmd    : in out Instance;
      Config : in out CLIC.Subcommand.Switches_Configuration)
   is null;

   overriding
   function Short_Description (Cmd : Instance) return String
   is ("Subcommands in a subcommand");

   overriding
   function Usage_Custom_Parameters (Cmd : Instance) return String
   is ("");

private

   type Instance
   is new CLIC.Subcommand.Command
   with null record;

end CLIC_Ex.Commands.Subsub;
