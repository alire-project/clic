package CLIC.Config.Info is

   function List (This        : CLIC.Config.Instance;
                  Filter      : String := ".*";
                  Show_Origin : Boolean := False)
                  return AAA.Strings.Vector;
   --  Return a Vector of String that contains a list of configuration
   --  key/value as seen in the configuration. When Show_Origin is true,
   --  the configuration file where each key was loaded is also listed.
   --
   --  The keys not matching the Filter regular expression (see GNAT.Regpat)
   --  are ignored.

   function List_Keys (This        : CLIC.Config.Instance;
                       Filter      : String := ".*")
                       return AAA.Strings.Vector;
   --  Same as above but only return the config keys

end CLIC.Config.Info;
