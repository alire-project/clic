package CLIC.Config.Edit is

   function Unset (Path : String;
                   Key  : Config_Key)
                   return Boolean;
   --  Unset/Remove a key from a configuration file. Return True in case of
   --  success or False when the configuration file or the key don't exist.

   function Set (Path  : String;
                 Key   : Config_Key;
                 Value : String;
                 Check : Check_Import := null)
                 return Boolean;
   --  Set a key in a configuration file. Return True in case of success or
   --  False when the value is invalid or rejected by the Check function.
   --
   --  When a Check function is provided, it will be called on the
   --  config key/value. If Check return False, Set returns False and the
   --  configuration file is not modified. In addition the Check function
   --  can print an error message explaining why the key/value is invalid.

end CLIC.Config.Edit;
