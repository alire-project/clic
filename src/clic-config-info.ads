package CLIC.Config.Info is

   function List (This        : CLIC.Config.Instance;
                  Filter      : String := ".*";
                  Show_Origin : Boolean := False)
                  return AAA.Strings.Vector;
   --  Return a Vector of String that contains a list of configuration
   --  key/value as seen in the configuration. When Show_Origin is true,
   --  the configuration file where each key was loaded is also listed.

end CLIC.Config.Info;
