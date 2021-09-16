separate (CLIC.Subcommand.Instance)
procedure Print_Man_Page (Short_Description : String;
                          Long_Description  : AAA.Strings.Vector)
is
   use AAA.Strings;

   -------------------
   -- Put_Long_Desc --
   -------------------

   procedure Put_Long_Desc (Desc : AAA.Strings.Vector) is
   begin
      if not Desc.Is_Empty then
         Put_Line (".P");
         for Line of Desc loop
            if Line = "" then
               Put_Line (".P");
            else
               Put_Line (Line);
            end if;
         end loop;
      end if;
   end Put_Long_Desc;

   -------------------
   -- Format_Switch --
   -------------------

   function Format_Switch (Sw : Switch_Info) return String is
      Short : constant String := Trim (To_String (Sw.Switch), '-');
      Long  : constant String := Trim (To_String (Sw.Long_Switch), '-');
   begin
      if Short = "" then
         return "\-\-" & Long;
      elsif Long = "" then
         return "\-" & Short;
      else
         return "\-" & Short & ", \-\-" & Long;
      end if;
   end Format_Switch;

   ------------------
   -- Put_Switches --
   ------------------

   procedure Put_Switches (C : Switches_Configuration) is
   begin
      for Sw of C.Info loop
         Put_Line (".PP");
         Put_Line (Format_Switch (Sw));
         Put_Line (".RS");
         Put_Line (To_String (Sw.Help));
         Put_Line (".RE");
      end loop;
   end Put_Switches;

   ------------------
   -- Put_Commands --
   ------------------

   procedure Put_Commands is
      use Command_Maps;
      use Group_Maps;

      procedure Put_Command (Cmd : not null Command_Access) is
         Switches : Switches_Configuration;
      begin
         Cmd.Setup_Switches (Switches);

         Put_Line (".PP");
         Put_Line ("\fB" & Cmd.Name & "\fR " & Cmd.Usage_Custom_Parameters);
         Put_Line (".RS"); -- Start indent
         Put_Line (Cmd.Short_Description);
         Put_Long_Desc (Cmd.Long_Description);
         Put_Switches (Switches);
         Put_Line (".RE"); -- End indent

         Clear (Switches);
      end Put_Command;

   begin
      if Registered_Commands.Is_Empty then
         return;
      end if;

      Put_Line (".SH COMMANDS");

      for Name of Not_In_A_Group loop
         Put_Command (Registered_Commands (To_Unbounded_String (Name)));
      end loop;

      for Iter in Registered_Groups.Iterate loop
         declare
            Group : constant String := To_String (Key (Iter));
         begin
            Put_Line (".SH " & To_Upper_Case (Group) & " COMMANDS");
            for Name of Element (Iter) loop
               Put_Command
                 (Registered_Commands (To_Unbounded_String (Name)));
            end loop;
         end;
      end loop;
   end Put_Commands;

   ----------------
   -- Put_Topics --
   ----------------

   procedure Put_Topics is
      use Topic_Maps;
   begin
      Put_Line (".SH MISC");
      for Elt in Registered_Topics.Iterate loop
         Put_Line (".SS " & Element (Elt).Title);
         Put_Long_Desc (Element (Elt).Content);
      end loop;
   end Put_Topics;
begin
   Put_Line (".TH " & Main_Command_Name & " 1");
   Put_Line (".SH NAME");
   Put_Line (Main_Command_Name & " - " & Short_Description);
   Put_Line (".SH SYNOPSIS");
   Put_Line (".B " & Main_Command_Name & " [global options] " &
               "<command> [command options] [<arguments>]");
   Put_Line (".SH DESCRIPTION");
   Put_Long_Desc (Long_Description);

   Put_Line (".SH GLOBAL OPTIONS");

   Put_Switches (Global_Config);
   Put_Commands;
   Put_Topics;
end Print_Man_Page;
