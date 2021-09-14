with GNAT.OS_Lib;
with TOML.File_IO;

with Simple_Logging;

package body CLIC.Config.Load is

   package Trace renames Simple_Logging;

   use TOML;

   ---------------
   -- From_TOML --
   ---------------

   procedure From_TOML (C      : in out CLIC.Config.Instance;
                        Origin :        String;
                        Path   :        String;
                        Check  :        Check_Import := null)
   is
      Table : constant TOML_Value := Load_TOML_File (Path);
   begin
      C.Import (Table, Origin, Check => Check);
   end From_TOML;

   --------------------
   -- Load_TOML_File --
   --------------------

   function Load_TOML_File (Path : String) return TOML.TOML_Value is
   begin

      if GNAT.OS_Lib.Is_Read_Accessible_File (Path) then
         declare
            Config : constant TOML.Read_Result :=
              TOML.File_IO.Load_File (Path);
         begin
            if Config.Success then
               if Config.Value.Kind /= TOML.TOML_Table then
                  Trace.Error ("Bad config file '" & Path &
                                 "': TOML table expected.");
               else
                  return Config.Value;
               end if;
            else
               Trace.Detail ("error while loading '" & Path & "':");
               Trace.Detail
                 (Ada.Strings.Unbounded.To_String (Config.Message));
            end if;
         end;
      else
         Trace.Detail ("Config file is not readable or doesn't exist: '" &
                         Path & "'");
      end if;

      return No_TOML_Value;
   end Load_TOML_File;

end CLIC.Config.Load;
