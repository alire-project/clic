package CLIC.Config.Edit is

   function Unset (Path : String;
                   Key  : Config_Key)
                   return Boolean;

   function Set (Path  : String;
                 Key   : Config_Key;
                 Value : String;
                 Check : Check_Import := null)
                 return Boolean;

end CLIC.Config.Edit;
