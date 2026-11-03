with GNAT.IO;

package body CLIC_Ex.Commands.Switches_And_Args is

   -------------
   -- Execute --
   -------------

   overriding procedure Execute
     (Cmd : in out Instance; Args : AAA.Strings.Vector)
   is
   begin
      GNAT.IO.Put_Line (Args.Flatten);
   end Execute;

end CLIC_Ex.Commands.Switches_And_Args;
