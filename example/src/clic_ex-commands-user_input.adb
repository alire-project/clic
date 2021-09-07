with Ada.Text_IO; use Ada.Text_IO;

with AAA.Strings;

with CLIC.User_Input; use CLIC.User_Input;
with GNAT.OS_Lib;

package body CLIC_Ex.Commands.User_Input is

   function Valid_Number (Str : String) return Boolean
   is (for all C of Str => C in '0' .. '9');

   -------------
   -- Execute --
   -------------

   overriding
   procedure Execute (Cmd : in out Instance;
                      Args : AAA.Strings.Vector)
   is
   begin
      if not Args.Is_Empty then
         Put_Line (Cmd.Name & " takes no arguments");
         GNAT.OS_Lib.OS_Exit (1);
      end if;

      declare
         Answer : Answer_Kind;
      begin
         Answer :=  Query (Question => "Do you like this tool?",
                           Valid    => (others => True),
                           Default  => Yes);
         if Answer = No then
            Put_Line ("Fine then.");
            GNAT.OS_Lib.OS_Exit (42);
         end if;
      end;

      declare
         Languages : constant AAA.Strings.Vector :=
           AAA.Strings.Empty_Vector
             .Append ("Ada")
             .Append ("C")
             .Append ("C++")
             .Append ("Rust")
             .Append ("OCAML")
             .Append ("Fortran")
             .Append ("Go");

         Answer : Positive;
      begin
         Answer := Query_Multi
           (Question  => "What is you favorite programming language?",
            Choices   => Languages);

         if Answer /= 1 then
            Put_Line ("Wrong answer.");
            GNAT.OS_Lib.OS_Exit (42);
         end if;
      end;

      Continue_Or_Abort;

      declare
         Answer : constant String :=
           Query_String (Question   => "Enter a number please",
                         Default    => "42",
                         Validation => Valid_Number'Access);
      begin
         Put_Line ("Thanks for your answer: '" & Answer & "'");
      end;

   end Execute;

end CLIC_Ex.Commands.User_Input;
