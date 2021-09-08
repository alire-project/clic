with AAA.Strings;

with TOML;

private with Ada.Containers.Hashed_Maps;
private with Ada.Strings.Unbounded.Hash;

package CLIC.Config with Preelaborate is

   function Is_Valid_Config_Key (Key : String) return Boolean
   is ((for all C of Key => C in '0' .. '9' | 'a' .. 'z' | 'A' .. 'Z' |
                                 '-' | '.' | '_')
      and then Key (Key'First) not in '-' | '.' | '_'
      and then Key (Key'Last) not in '-' | '.' | '_'
       and then not AAA.Strings.Contains (Key, ".."));
   --  Rule that define a valid configuration key. Dots are used to separate
   --  levels of configuration groups.
   --   eg:
   --     user.login
   --     user.email

   subtype Config_Key is String
     with Dynamic_Predicate => Is_Valid_Config_Key (Config_Key);

   type Instance is tagged limited private;
   pragma Preelaborable_Initialization (Instance);

   type Check_Import is
     access function (Key : Config_Key; Value : TOML.TOML_Value)
                      return Boolean;
   --  Return False when a Key/Value combination is not valid. Can be used to
   --  check formating of string value like email address for instance.

   procedure Import (This   : in out Instance;
                     Table  :        TOML.TOML_Value;
                     Origin :        String;
                     Check  :        Check_Import := null);
   --  Import configuration from the TOML table.
   --
   --  The Origin parameter is used in error messages and when listing config
   --  values to help the user identify the origin of the value. It can be just
   --  a word (e.g. local vs global), or the full path to the config file.
   --
   --  When a Check function is provided, it will be called for each imported
   --  config key/value. If Check return False, the value is ignored and not
   --  imported in the configuration. Import will print an Error message saying
   --  that the key/value is ignored. In addition the Check function can also
   --  print an error message explaining why the key/value is invalid.

   function Defined (This : Instance; Key : Config_Key) return Boolean;
   --  Return True if a value is defined for the given key

   function Get_As_String (This : Instance; Key : Config_Key) return String;
   --  Return a string representation of the value for the given configuration
   --  Key. If the key is not defined, an empty string is returned.

   function Get (This    : Instance;
                 Key     : Config_Key;
                 Default : Boolean)
                 return Boolean;
   --  Return the Boolean value for the given configuration Key. If the key is
   --  not defined, the Default value is returned. If the key is defined but
   --  not as a Boolean, an error message is displayed and the Default value
   --  is returned.

   function Get (This   : Instance;
                 Key     : Config_Key;
                 Default : String)
                 return String;
   --  Return the String value for the given configuration Key. If the key is
   --  not defined, the Default value is returned. If the key is defined but
   --  not as a String, an error message is displayed and the Default value
   --  is returned.

   function Get (This    : Instance;
                 Key     : Config_Key;
                 Default : TOML.Any_Integer)
                 return TOML.Any_Integer;
   --  Return the Integer value for the given configuration Key. If the key is
   --  not defined, the Default value is returned. If the key is defined but
   --  not as an Integer, an error message is displayed and the Default value
   --  is returned.

   function Get (This    : Instance;
                 Key     : Config_Key;
                 Default : TOML.Any_Float)
                 return TOML.Any_Float;
   --  Return the Float value for the given configuration Key. If the key is
   --  not defined, the Default value is returned. If the key is defined but
   --  not as an Float, an error message is displayed and the Default value
   --  is returned.

   procedure Clear (This : in out Instance);
   --  Remove all configuration keys

   function Image (Val : TOML.TOML_Value) return String;

private

   generic
      type Return_Type (<>) is private;
      Expected_TOML_Kind : TOML.Any_Value_Kind;
      Type_Name : String;

      with function TOML_As_Return_Type (Value : TOML.TOML_Value)
                                         return Return_Type;

      with function Image (V : Return_Type) return String;

   function Get_With_Default_Gen (This    : Instance;
                                  Key     : Config_Key;
                                  Default : Return_Type)
                                  return Return_Type;

   function To_TOML_Value (Str : String) return TOML.TOML_Value;
   --  Use the TOML parser to convert the string Str. If Str is not a valid
   --  TOML value, No_TOML_Value is returned.

   type Config_Value is record
      Value  : TOML.TOML_Value;
      Origin : Ada.Strings.Unbounded.Unbounded_String;
   end record;

   function No_Config_Value return Config_Value;

   package Config_Maps is new Ada.Containers.Hashed_Maps
     (Key_Type        => Ada.Strings.Unbounded.Unbounded_String,
      Element_Type    => Config_Value,
      Hash            => Ada.Strings.Unbounded.Hash,
      Equivalent_Keys => Ada.Strings.Unbounded."=");

   function "+" (Source : String) return Ada.Strings.Unbounded.Unbounded_String
                 renames Ada.Strings.Unbounded.To_Unbounded_String;

   type Instance is tagged limited record
      Config_Map : Config_Maps.Map;
   end record;

   function Get (This : Instance; Key : Config_Key) return Config_Value;

end CLIC.Config;
