-- created by Rachel Waldon
-- Programming Languages CSCI 315
-- May 2019
with Ada.Text_IO;		                use Ada.Text_IO;
with Ada.Characters.Handling;                   use Ada.Characters.Handling;
with Ada.Integer_Text_IO;                       use Ada.Integer_Text_IO;



procedure Main is
   
   Input : File_Type;
   Output : File_Type;
   Num_Trials : Integer;        -- number of trials
   Num_Outcomes : Integer;      -- choose integers from 0...n-1.
   R : Integer;                -- r == 1 samples with replacement,
                               -- r == 0 samples w/o replacement.
   Buffer_Index : Integer := 0;

   -- choices array will hold range of consecutive
   -- integers 0 ... n-1 for sampling.
   type CharArr is array (0..9) of Character;
   Choices : CharArr;
   Buffer: CharArr;  -- Buffer holds results of sampling.
   
      -- calc procedure calculates the sample space recursively and stores result in Buffer.
      procedure calc(Choices: CharArr; Size: Integer; Trials_Left: Integer;
                     Buffer: out CharArr; Buffer_Index: Integer; R: Integer; N: Integer) is
      J : Integer := 0;
      Count : Integer := 0;
      Next : CharArr;
      begin
         -- base case
         if Trials_Left = 0 then
            for I in 0 .. N-1 loop
               -- print out unique sampling outcome from Buffer
               Put(Character'Image(Buffer(I)));
            end loop;
            New_Line;
            return;
         end if;

         for I in 0 .. Size-1 loop
            if R = 1 then
               while Is_Letter(Choices(J)) loop
                  J := J + 1;
               end loop;
               Buffer(Buffer_Index) := Choices(J);
               Next := Choices;
               Next(J) := 'a';
               calc(Next,Size-1,Trials_Left-1,Buffer,Buffer_Index+1,R,N);
               J := J + 1;
            end if;
            if R = 0 then
               Buffer(Buffer_Index) := Choices(J);
               calc(Choices,Size,Trials_Left-1,Buffer,Buffer_Index+1,R,N);
               J := J + 1;
            end if;
         end loop;
   end calc;
begin
   Open(File => Input,  Mode => In_File,  Name => "input.txt");
   Create (File => Output, Mode => Out_File, Name => "output.txt");
   Set_Output(Output);
   Num_Trials := Integer'Value(Get_Line(Input));
   Num_Outcomes := Integer'Value(Get_Line(Input));
   R := Integer'Value(Get_Line(Input));

   for I in 0 .. Num_Outcomes-1 loop
      Choices(I) := Character'Val(I+48);
   end loop;
   calc(Choices,Num_Outcomes,Num_Trials,Buffer,Buffer_Index,R,Num_Trials);
   Set_Output(Output);
   Close (Input);
   Close (Output);
exception
   when End_Error =>
      if Is_Open(Input) then 
         Close (Input);
      end if;
      if Is_Open(Output) then 
         Close (Output);
      end if;
end Main;

