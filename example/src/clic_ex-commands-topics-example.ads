with AAA.Strings;
with CLIC.Subcommand;
with CLIC.TTY;

package CLIC_Ex.Commands.Topics.Example is

   type Instance is new CLIC.Subcommand.Help_Topic with null record;

   overriding
   function Name (This : Instance) return CLIC.Subcommand.Identifier
   is ("topic_example");

   overriding
   function Title (This : Instance) return String
   is ("Just an example of CLIC help topic");

   overriding
   function Content (This : Instance) return AAA.Strings.Vector
   is (AAA.Strings.Empty_Vector
       .Append ("Not " & CLIC.TTY.Dim ("much") & " to see here..."));

end CLIC_Ex.Commands.Topics.Example;
