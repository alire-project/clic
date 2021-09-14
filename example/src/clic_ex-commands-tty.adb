with CLIC.TTY; use CLIC.TTY;
with Ada.Text_IO; use Ada.Text_IO;

package body CLIC_Ex.Commands.TTY is

   package TTY renames CLIC.TTY;

   --------------------
   -- Setup_Switches --
   --------------------

   overriding
   procedure Setup_Switches
     (Cmd    : in out Instance;
      Config : in out CLIC.Subcommand.Switches_Configuration)
   is
   begin
      CLIC.Subcommand.Define_Switch (Config,
                                     Cmd.Blink'Access,
                                     Long_Switch => "--blink");
   end Setup_Switches;

   -------------
   -- Execute --
   -------------

   overriding
   procedure Execute (Cmd : in out Instance; Args : AAA.Strings.Vector)
   is
   begin
      if not Args.Is_Empty then
         Put_Line (Cmd.Name & " takes no arguments");
         GNAT.OS_Lib.OS_Exit (1);
      end if;

      Put_Line (TTY.Bold ("CLIC.TTY.Bold ()"));
      Put_Line (TTY.Dim ("CLIC.TTY.Dim ()"));
      Put_Line (TTY.Italic ("CLIC.TTY.Italic ()"));
      Put_Line (TTY.Underline ("CLIC.TTY.Underline ()"));
      Put_Line (TTY.Emph ("CLIC.TTY.Emph ()"));
      Put_Line (TTY.Description ("CLIC.TTY.Description ()"));
      Put_Line (TTY.Error ("CLIC.TTY.Error ()"));
      Put_Line (TTY.Warn ("CLIC.TTY.Warn ()"));
      Put_Line (TTY.Info ("CLIC.TTY.Info ()"));
      Put_Line (TTY.Success ("CLIC.TTY.Success ()"));
      Put_Line (TTY.Terminal ("CLIC.TTY.Terminal ()"));

      Put_Line
        (TTY.Format (Text  => "CLIC.TTY.Format (""," &
                       " Fore  => ANSI.Light_Blue, Style => ANSI.Strike)",
                     Fore  => ANSI.Light_Blue,
                     Style => ANSI.Strike));

      if Cmd.Blink then
         Put_Line (TTY.Format (Text  => "Blinky blink!",
                               Fore  => ANSI.Red,
                               Style => ANSI.Blink));

      end if;

   end Execute;

end CLIC_Ex.Commands.TTY;
