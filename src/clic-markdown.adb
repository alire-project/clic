with AAA.Strings;

package body CLIC.Markdown is

   function Chapter (Str : String) return String is
     ("### " & Str);

   function Plain_Text (Str : String) return String is
      (Str);

   function Code (Str : String) return String is
     ('`' & Str & '`');

   function Bold (Str : String) return String is
     ('*' & Str & '*');

   function Italic (Str : String) return String is
     ('_' & Str & '_');

end CLIC.Markdown;
