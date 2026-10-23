with Ada.Exceptions;
with Ada.Streams.Stream_IO;

with GNAT.OS_Lib;

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

   ---------------
   -- Read_File --
   ---------------

   function Read_File (Path : String) return TOML.Read_Result is
      --  Same as TOML.File_IO.Load_File, but parses the file contents from
      --  memory. TOML.File_IO detects the end of the file by handling an
      --  exception, and raising one is very slow on macOS for big binaries
      --  (it unwinds the stack to record a traceback).
      use Ada.Streams.Stream_IO;
      File : File_Type;
   begin
      begin
         Open (File, In_File, Path);
      exception
         when E : Name_Error | Use_Error =>
            return (Success  => False,
                    Message  => Ada.Strings.Unbounded.To_Unbounded_String
                                  (Ada.Exceptions.Exception_Message (E)),
                    Location => TOML.No_Location);
      end;

      declare
         Contents : String (1 .. Natural (Size (File)));
      begin
         --  Reading exactly the file size never hits the end of the file
         String'Read (Stream (File), Contents);
         Close (File);
         return TOML.Load_String (Contents);
      end;
   end Read_File;

   --------------------
   -- Load_TOML_File --
   --------------------

   function Load_TOML_File (Path : String) return TOML.TOML_Value is
   begin

      if GNAT.OS_Lib.Is_Read_Accessible_File (Path) then
         declare
            Config : constant TOML.Read_Result := Read_File (Path);
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
