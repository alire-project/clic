with AAA.Strings;

with CLIC.Subcommand;

package CLIC_Ex.Commands.TTY is

   type Instance
   is new CLIC.Subcommand.Command
   with private;

   overriding
   function Name (Cmd : Instance) return CLIC.Subcommand.Identifier
   is ("tty");

   overriding
   procedure Execute (Cmd  : in out Instance;
                      Args :        AAA.Strings.Vector);

   overriding
   function Long_Description (Cmd : Instance) return AAA.Strings.Vector
   is (AAA.Strings.Empty_Vector
       .Append ("Long description of the TTY command.")
       .Append ("Multiple lines:")
       .Append (" - 1")
       .Append (" - 2")
       .Append (" - 3")
      );

   overriding
   procedure Setup_Switches
     (Cmd    : in out Instance;
      Config : in out CLIC.Subcommand.Switches_Configuration)
   is null;

   overriding
   function Short_Description (Cmd : Instance) return String
   is ("Show tty colors");

   overriding
   function Usage_Custom_Parameters (Cmd : Instance) return String
   is ("");


private

   type Instance
   is new CLIC.Subcommand.Command
   with null record;

end CLIC_Ex.Commands.TTY;
