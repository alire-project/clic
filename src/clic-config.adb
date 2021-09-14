with Ada.Strings.Unbounded;

with Simple_Logging;

package body CLIC.Config is

   use Ada.Strings.Unbounded;
   use TOML;

   package Trace renames Simple_Logging;

   function Image (F : TOML.Any_Float) return String;

   ----------------------
   -- Import_Recursive --
   ----------------------

   procedure Import_Recursive (This   : in out Instance;
                               Table  :        TOML.TOML_Value;
                               Origin :        String;
                               Check  :        Check_Import := null;
                               Prefix :        String := "")
   is
   begin
      if Table = No_TOML_Value
        or else
          Table.Kind /= TOML_Table
      then
         return;
      end if;

      for Ent of Iterate_On_Table (Table) loop
         declare
            Key : constant String :=
              (if Prefix = "" then "" else Prefix & ".") &
              To_String (Ent.Key);

         begin
            if not Is_Valid_Config_Key (Key) then
               Trace.Error ("Invalid configuration key '" & Key & "' in " &
                              "'" & Origin & "'");
            elsif Ent.Value.Kind = TOML_Table then

               --  Recursive call on the table
               Import_Recursive (This, Ent.Value, Origin, Check, Key);
            else

               Trace.Debug ("Load config key: '" & Key & "' = '" &
                              Ent.Value.Kind'Img & "'");

               if Ent.Value.Kind  not in  TOML_String | TOML_Float |
                                          TOML_Integer | TOML_Boolean
               then
                  Trace.Error ("Invalid type '" & Ent.Value.Kind'Img &
                                 "' for key '" & Key &
                                 "' in configuration file '" &
                                 Origin & "'");
                  Trace.Error ("'" & Key & "' is ignored");
               elsif Check /= null and then not Check (Key, Ent.Value) then
                  Trace.Error ("'" & Key & "' is ignored");
               else
                  --  Insert the config value, potentially replacing a previous
                  --  definition.
                  This.Config_Map.Include
                    (To_Unbounded_String (Key),
                     (Value  => Ent.Value,
                      Origin => To_Unbounded_String (Origin)));
               end if;
            end if;
         end;
      end loop;
   end Import_Recursive;

   ------------
   -- Import --
   ------------

   procedure Import (This   : in out Instance;
                     Table  :        TOML.TOML_Value;
                     Origin :        String;
                     Check  :        Check_Import := null)
   is
   begin
      Import_Recursive (This, Table, Origin, Check);
   end Import;

   -------------
   -- Defined --
   -------------

   function Defined (This : Instance;
                     Key : Config_Key)
                     return Boolean
   is
   begin
      return This.Config_Map.Contains (+Key);
   end Defined;

   -------------------
   -- Get_As_String --
   -------------------

   function Get_As_String (This : Instance;
                           Key : Config_Key)
                           return String
   is
   begin
      if This.Defined (Key) then
         return Image (This.Get (Key).Value);
      else
         return "";
      end if;
   end Get_As_String;

   ---------
   -- Get --
   ---------

   function Get (This : Instance; Key : Config_Key) return Config_Value is
   begin
      if This.Defined (Key) then
         return This.Config_Map.Element (+Key);
      else
         return No_Config_Value;
      end if;
   end Get;

   ---------
   -- Get --
   ---------

   function Get (This    : Instance;
                 Key     : Config_Key;
                 Default : Boolean)
                 return Boolean
   is
      function Get_With_Default_Bool is new Get_With_Default_Gen
        (Boolean, TOML_Boolean, "Boolean", TOML.As_Boolean, Boolean'Image);

   begin
      return Get_With_Default_Bool (This, Key, Default);
   end Get;

   ---------
   -- Get --
   ---------

   function Get (This    : Instance;
                 Key     : Config_Key;
                 Default : String)
                 return String
   is
      function Id (Str : String) return String
      is (Str);

      function Get_With_Default_Str is new Get_With_Default_Gen
        (String, TOML_String, "String", TOML.As_String, Id);

   begin
      return Get_With_Default_Str (This, Key, Default);
   end Get;

   ---------
   -- Get --
   ---------

   function Get (This    : Instance;
                 Key     : Config_Key;
                 Default : TOML.Any_Integer)
      return TOML.Any_Integer
   is
      function Get_With_Default_Int is new Get_With_Default_Gen
        (TOML.Any_Integer, TOML_Integer, "Integer", TOML.As_Integer,
         Any_Integer'Image);

   begin
      return Get_With_Default_Int (This, Key, Default);
   end Get;

   ---------
   -- Get --
   ---------

   function Get (This    : Instance;
                 Key     : Config_Key;
                 Default : TOML.Any_Float)
                 return TOML.Any_Float
   is
      function Get_With_Default_Int is new Get_With_Default_Gen
        (TOML.Any_Float, TOML_Float, "Float", TOML.As_Float, Image);
   begin
      return Get_With_Default_Int (This, Key, Default);
   end Get;

   -----------
   -- Clear --
   -----------

   procedure Clear (This : in out Instance) is
   begin
      This.Config_Map.Clear;
   end Clear;

   --------------------------
   -- Get_With_Default_Gen --
   --------------------------

   function Get_With_Default_Gen (This    : Instance;
                                  Key     : Config_Key;
                                  Default : Return_Type)
                                  return Return_Type
   is
      Val : constant Config_Value := This.Get (Key);
   begin
      if Val.Value.Is_Null then
         Trace.Detail ("Using default value for configuration '" & Key &
                         "': '" & Image (Default) & "'");
         return Default;

      elsif Val.Value.Kind /= Expected_TOML_Kind then
         Trace.Error ("Invalid type ('" & Val.Value.Kind'Img &
                        "') for configuration '" & Key & "'");
         Trace.Error ("in '" & To_String (Val.Origin) & "'");
         Trace.Error (Type_Name & " expected");
         Trace.Error ("Using default: '" & Image (Default) & "'");
         return Default;

      else
         return TOML_As_Return_Type (Val.Value);
      end if;
   end Get_With_Default_Gen;

   -------------------
   -- To_TOML_Value --
   -------------------

   function To_TOML_Value (Str : String) return TOML.TOML_Value is
      Result : constant TOML.Read_Result := TOML.Load_String ("key=" & Str);
   begin
      if not Result.Success
        or else
         Result.Value.Kind /= TOML_Table
        or else
         not Result.Value.Has ("key")
      then

         --  Conversion failed

         --  Interpret as a string
         return Create_String (Str);
      else
         return Result.Value.Get ("key");
      end if;
   end To_TOML_Value;

   ---------------------
   -- No_Config_Value --
   ---------------------

   function No_Config_Value return Config_Value
   is (Value  => TOML.No_TOML_Value,
       Origin => Null_Unbounded_String);

   -----------
   -- Image --
   -----------

   function Image (F : TOML.Any_Float) return String is
   begin
      case F.Kind is
         when Regular =>
            return AAA.Strings.Trim (F.Value'Image);
         when NaN | Infinity =>
            return (if F.Positive then "" else "-") &
            (if F.Kind = NaN then "nan" else "inf");
      end case;
   end Image;

   -----------
   -- Image --
   -----------

   function Image (Val : TOML.TOML_Value) return String is
   begin
      case Val.Kind is
         when TOML_Boolean =>
            return (if Val.As_Boolean then "true" else "false");
         when TOML_Integer =>
            return AAA.Strings.Trim (Val.As_Integer'Img);
         when TOML_Float =>
            return Image (Val.As_Float);
         when TOML_String =>
            return Val.As_String;
         when others =>
            return "";
      end case;
   end Image;

end CLIC.Config;
