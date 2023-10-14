package CLIC.Formatter
with Preelaborate
is

   -- Provides markdown or TTY formatting for displaying help pages.

   procedure Force_Disable_TTY;

   procedure Enable_Markdown;
   --  Enables markdown output of formatting functions.

   procedure Enable_Color (Force : Boolean := False);
   --  Prepares colors for the terminal output. Unless Force, will do nothing
   --  if a console redirection is detected.

   function Chapter (Str : String) return String;
   function Description (Str : String) return String;
   function Version (Str : String) return String;
   function Underline (Str : String) return String;
   function Emph (Str : String) return String;
   function Terminal (Str : String) return String;

end CLIC.Formatter;
