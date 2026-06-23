with AAA.Strings;

package CLIC.Utils with Preelaborate is

   function Suggestion (Input           : String;
                        Possible_Values : AAA.Strings.Vector)
     return String;
   --  Return "Did you mean '<suggestion>'?" if a good enought suggestion
   --  can be found in Possible_Value, otherwise return an empty string.

   type String_Transform is (None, Lower_Case, Upper_Case, Tomify);

   generic
      type Enum is (<>);
      Transform : String_Transform;
   function Enum_Suggestion (Input : String) return String;
   --  Convert all possible Enum values in a string vector and call Suggestion.
   --  The enum string values are converted acording to the Transform value.

   function Tomify (Image : String) return String;

private
   --  function Tomify (Image : String) return String;

   function Tomify (Image : String) return String is
     (AAA.Strings.Replace
        (AAA.Strings.To_Lower_Case (Image),
         Match => "_",
         Subst => "-"));
   --  Take some enumeration image and turn it into a TOML-style key, replacing
   --  every "_" with a "-" and in lower case.

end CLIC.Utils;
