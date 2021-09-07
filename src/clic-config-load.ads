with TOML;

package CLIC.Config.Load is

   procedure From_TOML (C      : in out CLIC.Config.Instance;
                        Origin :        String;
                        Path   :        String);

   function Load_TOML_File (Path : String) return TOML.TOML_Value;

end CLIC.Config.Load;
