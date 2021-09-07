with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with GNAT.Regexp;

package body CLIC.Config.Info is

   ----------
   -- List --
   ----------

   function List (This        : CLIC.Config.Instance;
                  Filter      : String := ".*";
                  Show_Origin : Boolean := False)
                  return AAA.Strings.Vector
   is
      use GNAT.Regexp;

      Re     : constant Regexp := Compile (Filter, Glob => True);

      Result : AAA.Strings.Vector;
   begin
      for C in This.Config_Map.Iterate loop
         declare
            Val : constant Config_Value := This.Config_Map (C);
            Key : constant String := To_String (Config_Maps.Key (C));
            Line : Unbounded_String;
         begin
            if Match (Key, Re) then
               if Show_Origin then
                  Line := Val.Origin & ": ";
               end if;

               Append (Line, Key & "=");
               Append (Line, Image (Val.Value));
               Result.Append (To_String (Line));
            end if;
         end;
      end loop;

      return Result;
   end List;

end CLIC.Config.Info;
