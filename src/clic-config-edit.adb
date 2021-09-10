with Ada.Text_IO;
with Ada.Directories;

with AAA.Strings;
with AAA.Directories;

with CLIC.Config.Load;

with Simple_Logging;

with TOML;

package body CLIC.Config.Edit is

   package Trace renames Simple_Logging;

   use TOML;

   procedure Write_Config_File (Table : TOML_Value; Path : String)
     with Pre => Table.Kind = TOML_Table;

   function Remove_From_Table (Table : TOML_Value;
                               Key   : Config_Key)
                               return Boolean
     with Pre => Table.Kind = TOML_Table;

   function Add_In_Table (Table : TOML_Value;
                          Key   : Config_Key;
                          Val   : TOML_Value)
                          return Boolean
     with Pre => Table.Kind = TOML_Table;

   -----------------------
   -- Write_Config_File --
   -----------------------

   procedure Write_Config_File (Table : TOML_Value; Path : String) is
      use Ada.Text_IO;
      use Ada.Directories;
      File : File_Type;
   begin

      --  Create the directory for the config file, in case it doesn't exists
      Create_Path (Containing_Directory (Path));

      Create (File, Out_File, Path);
      Trace.Debug ("Write config: '" & TOML.Dump_As_String (Table) & "'");
      Put (File, TOML.Dump_As_String (Table));
      Close (File);
   end Write_Config_File;

   -----------------------
   -- Remove_From_Table --
   -----------------------

   function Remove_From_Table (Table : TOML_Value;
                               Key   : Config_Key)
                               return Boolean
   is
      use AAA.Strings;

      Id   : constant String := Split (Key, '.', Raises => False);
      Leaf : constant Boolean := Id = Key;
   begin
      if not Table.Has (Id) then
         --  The key doesn't exist
         Trace.Error ("Configuration key not defined");
         return False;
      end if;

      if Leaf then
         Table.Unset (Id);
         return True;
      else
         declare
            Sub : constant TOML_Value := Table.Get (Id);
         begin
            if Sub.Kind = TOML_Table then
               return Remove_From_Table (Sub, Split (Key, '.', Tail));
            else
               Trace.Error ("Configuration key not defined");
               return False;
            end if;
         end;
      end if;
   end Remove_From_Table;

   ------------------
   -- Add_In_Table --
   ------------------

   function Add_In_Table (Table : TOML_Value;
                          Key   : Config_Key;
                          Val   : TOML_Value)
                          return Boolean
   is
      use AAA.Strings;
      Id   : constant String := Split (Key, '.', Raises => False);
      Leaf : constant Boolean := Id = Key;
   begin
      if Leaf then
         Table.Set (Id, Val);
         return True;
      end if;

      if not Table.Has (Id) then
         --  The subkey doesn't exist, create a table for it
         Table.Set (Id, Create_Table);
      end if;

      declare
         Sub : constant TOML_Value := Table.Get (Id);
      begin
         if Sub.Kind = TOML_Table then
            return Add_In_Table (Sub, Split (Key, '.', Tail), Val);
         else
            Trace.Error ("Configuration key already defined");
            return False;
         end if;
      end;
   end Add_In_Table;

   -----------
   -- Unset --
   -----------

   function Unset (Path : String; Key : Config_Key) return Boolean is
      use AAA.Directories;

      Tmp : Replacer := New_Replacement (File              => Path,
                                         Backup            => False,
                                         Allow_No_Original => True);

      Table : constant TOML_Value := Load.Load_TOML_File (Tmp.Editable_Name);
   begin

      if Table.Is_Null then
         --  The configuration file doesn't exist or is not valid
         Trace.Error ("configuration file doesn't exist or is not valid");
         return False;
      end if;

      if not Remove_From_Table (Table, Key) then
         return False;
      end if;

      Write_Config_File (Table, Tmp.Editable_Name);

      Tmp.Replace;

      return True;
   end Unset;

   ---------
   -- Set --
   ---------

   function Set (Path  : String;
                 Key   : Config_Key;
                 Value : String;
                 Check : Check_Import := null)
                 return Boolean
   is
      use AAA.Directories;

      Tmp : Replacer := New_Replacement (File              => Path,
                                         Backup            => False,
                                         Allow_No_Original => True);

      Table : TOML_Value := Load.Load_TOML_File (Tmp.Editable_Name);

      To_Add : constant TOML_Value := To_TOML_Value (Value);
   begin
      if To_Add.Is_Null then
         Trace.Error ("Invalid configuration value: '" & Value & "'");
         return False;
      end if;

      if Check /= null and then not Check (Key, To_Add) then
         return False;
      end if;

      if Table.Is_Null then
         --  The configuration file doesn't exist or is not valid. Create an
         --  empty table.
         Table := TOML.Create_Table;
      end if;

      if not Add_In_Table (Table, Key, To_Add) then
         return False;
      end if;

      Write_Config_File (Table, Tmp.Editable_Name);

      Tmp.Replace;

      return True;
   end Set;

end CLIC.Config.Edit;
