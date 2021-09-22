with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body CLIC.Subcommand is

   -------------------
   -- Define_Switch --
   -------------------

   procedure Define_Switch
     (Config      : in out Switches_Configuration;
      Switch      : String := "";
      Long_Switch : String := "";
      Help        : String := "";
      Section     : String := "";
      Argument    : String := "ARG")
   is
   begin
      CLIC.Command_Line.Define_Switch (Config.GNAT_Cfg,
                                       Switch      => Switch,
                                       Long_Switch => Long_Switch,
                                       Help        => Help,
                                       Section     => Section,
                                       Argument    => Argument);
      Add (Config.Info, Switch, Long_Switch, Help, Argument);
   end Define_Switch;

   -------------------
   -- Define_Switch --
   -------------------

   procedure Define_Switch
     (Config      : in out Switches_Configuration;
      Output      : access Boolean;
      Switch      : String := "";
      Long_Switch : String := "";
      Help        : String := "";
      Section     : String := "";
      Value       : Boolean := True)
   is
   begin
      CLIC.Command_Line.Define_Switch (Config.GNAT_Cfg,
                                       Output      => Output,
                                       Switch      => Switch,
                                       Long_Switch => Long_Switch,
                                       Help        => Help,
                                       Section     => Section,
                                       Value       => Value);
      Add (Config.Info, Switch, Long_Switch, Help, "");
   end Define_Switch;

   -------------------
   -- Define_Switch --
   -------------------

   procedure Define_Switch
     (Config      : in out Switches_Configuration;
      Output      : access Integer;
      Switch      : String := "";
      Long_Switch : String := "";
      Help        : String := "";
      Section     : String := "";
      Initial     : Integer := 0;
      Default     : Integer := 1;
      Argument    : String := "ARG")
   is
   begin
      CLIC.Command_Line.Define_Switch (Config.GNAT_Cfg,
                                       Switch      => Switch,
                                       Output      => Output,
                                       Long_Switch => Long_Switch,
                                       Help        => Help,
                                       Section     => Section,
                                       Initial     => Initial,
                                       Default     => Default,
                                       Argument    => Argument);
      Add (Config.Info, Switch, Long_Switch, Help, Argument);
   end Define_Switch;

   -------------------
   -- Define_Switch --
   -------------------

   procedure Define_Switch
     (Config      : in out Switches_Configuration;
      Output      : access GNAT.Strings.String_Access;
      Switch      : String := "";
      Long_Switch : String := "";
      Help        : String := "";
      Section     : String := "";
      Argument    : String := "ARG")
   is
   begin
      CLIC.Command_Line.Define_Switch (Config.GNAT_Cfg,
                                       Output      => Output,
                                       Switch      => Switch,
                                       Long_Switch => Long_Switch,
                                       Help        => Help,
                                       Section     => Section,
                                       Argument    => Argument);
      Add (Config.Info, Switch, Long_Switch, Help, Argument);
   end Define_Switch;

   -------------------
   -- Define_Switch --
   -------------------

   procedure Define_Switch
     (Config      : in out Switches_Configuration;
      Callback    : not null CLIC.Command_Line.Value_Callback;
      Switch      : String := "";
      Long_Switch : String := "";
      Help        : String := "";
      Section     : String := "";
      Argument    : String := "ARG")
   is
   begin
      CLIC.Command_Line.Define_Switch (Config.GNAT_Cfg,
                                       Callback    => Callback,
                                       Switch      => Switch,
                                       Long_Switch => Long_Switch,
                                       Help        => Help,
                                       Section     => Section,
                                       Argument    => Argument);
      Add (Config.Info, Switch, Long_Switch, Help, Argument);
   end Define_Switch;

   ---------
   -- Add --
   ---------

   procedure Add (Vect : in out Switch_Info_Vectors.Vector;
                  Switch, Long_Switch, Help, Argument : String)
   is
   begin
      Vect.Append (Switch_Info'(To_Unbounded_String (Switch),
                                To_Unbounded_String (Long_Switch),
                                To_Unbounded_String (Help),
                                To_Unbounded_String (Argument)));
   end Add;

   -----------
   -- Clear --
   -----------

   procedure Clear (This : in out Switches_Configuration) is
   begin
      CLIC.Command_Line.Free (This.GNAT_Cfg);
      This.Info.Clear;
   end Clear;

end CLIC.Subcommand;
