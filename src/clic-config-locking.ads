with AAA.Filesystem.Locks;

private package CLIC.Config.Locking is

   --  Keeps processes from reading a configuration file while another one
   --  changes it, which may otherwise find it half written, and from changing
   --  it at the same time, which may otherwise lose one of the changes.

   package Locks renames AAA.Filesystem.Locks;

   function Lock (Path : String; Kind : Locks.Kinds) return Locks.Lock;
   --  Lock the configuration file at Path, Shared to read it and Exclusive to
   --  change it, until the result goes out of scope. The lock is on a file
   --  next to it, "<Path>.lock". There is nothing to lock for reading a
   --  missing file, and if the lock file can't be created (e.g. in a
   --  read-only folder) the configuration file is used unlocked.

end CLIC.Config.Locking;
