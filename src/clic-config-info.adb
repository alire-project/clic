with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with GNAT.Regpat;

package body CLIC.Config.Info is

   ----------
   -- List --
   ----------

   function List (This        : CLIC.Config.Instance;
                  Filter      : String := ".*";
                  Show_Origin : Boolean := False)
                  return AAA.Strings.Vector
   is
      Result : AAA.Strings.Vector;
   begin

      for Key of List_Keys (This, Filter) loop
         declare
            Val : constant Config_Value := This.Config_Map (+Key);
            Line : Unbounded_String;
         begin
            if Show_Origin then
               Line := Val.Origin & ": ";
            end if;

            Append (Line, Key & "=");
            Append (Line, Image (Val.Value));
            Result.Append (To_String (Line));
         end;
      end loop;

      return Result;
   end List;

   ---------------
   -- List_Keys --
   ---------------

   function List_Keys (This        : CLIC.Config.Instance;
                       Filter      : String := ".*")
                       return AAA.Strings.Vector
   is
      use GNAT.Regpat;

      Re     : constant Pattern_Matcher := Compile (Filter);

      Result : AAA.Strings.Vector;
   begin
      for C in This.Config_Map.Iterate loop
         declare
            Key : constant String := To_String (Config_Maps.Key (C));
         begin
            if Match (Re, Key) then
               Result.Append (Key);
            end if;
         end;
      end loop;
      return Result;
   end List_Keys;

end CLIC.Config.Info;
