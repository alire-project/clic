with Ada.Directories;
with Ada.Exceptions;
with Ada.IO_Exceptions;

with GNAT.OS_Lib;

with Simple_Logging;

package body CLIC.Config.Locking is

   package Trace renames Simple_Logging;

   use type Locks.Kinds;

   ----------
   -- Lock --
   ----------

   function Lock (Path : String; Kind : Locks.Kinds) return Locks.Lock is
   begin
      return Result : Locks.Lock do
         --  No file for reading, nothing to do
         if Kind = Locks.Shared
           and then not GNAT.OS_Lib.Is_Regular_File (Path)
         then
            return;
         end if;

         --  For a first change, the folder may not exist yet
         if Kind = Locks.Exclusive then
            Ada.Directories.Create_Path
              (Ada.Directories.Containing_Directory (Path));
         end if;

         Result.Acquire (Path & ".lock", Kind);
      exception
         when E : Ada.IO_Exceptions.Use_Error =>
            Trace.Debug ("Configuration file used unlocked: "
                         & Ada.Exceptions.Exception_Message (E));
      end return;
   end Lock;

end CLIC.Config.Locking;
