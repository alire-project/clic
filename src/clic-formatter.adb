with CLIC.TTY;
with CLIC.Markdown;

package body CLIC.Formatter is

   Markdown_Enabled : Boolean := False;

   procedure Enable_Markdown is
   begin
      Markdown_Enabled := True;
   end Enable_Markdown;

   procedure Force_Disable_TTY renames TTY.Force_Disable_TTY;
   procedure Enable_Color (Force : Boolean := False)
     renames TTY.Enable_Color;

   function Chapter (Str : String) return String is
     (if Markdown_Enabled
      then Markdown.Chapter (Str)
      else TTY.Bold (Str));

   function Description (Str : String) return String is
     (if Markdown_Enabled
      then Markdown.Code (Str)
      else TTY.Description (Str));

   function Version (Str : String) return String is
     (if Markdown_Enabled
      then Markdown.Italic (Str)
      else TTY.Version (Str));

   function Underline (Str : String) return String is
     (if Markdown_Enabled
      then Str
      else TTY.Underline (Str));

   -- Emph is used to highlight switches, so we use Code for the markdown
   -- version.
   function Emph (Str : String) return String is
     (if Markdown_Enabled
      then Markdown.Code (Str)
      else TTY.Emph (Str));

   function Terminal (Str : String) return String is
     (if Markdown_Enabled
      then Markdown.Code (Str)
      else TTY.Terminal (Str));

end CLIC.Formatter;
