private with  Ada.Strings.UTF_Encoding.Wide_Wide_Strings;

package CLIC
with Preelaborate
is

private

   function U (S          : Wide_Wide_String;
               Output_BOM : Boolean := False)
               return Ada.Strings.UTF_Encoding.UTF_8_String
               renames Ada.Strings.UTF_Encoding.Wide_Wide_Strings.Encode;

   function WW (S          : Ada.Strings.UTF_Encoding.UTF_8_String)
                return Wide_Wide_String
                renames Ada.Strings.UTF_Encoding.Wide_Wide_Strings.Decode;

end CLIC;
