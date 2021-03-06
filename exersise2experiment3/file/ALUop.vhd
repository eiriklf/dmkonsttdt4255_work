-- This is the ALUOp component, which sets the operation for the ALU,
-- based on the two ALUOp signals from the control unit, and on the
-- 6 least significant bits (known as funct field) from R-Type instructions.


--we chose to control memtoreg signal here and not in the control module because we found out that with our new instruction set, this signal(s) would be dependent on the function field
-- of the instruction as well as the operation field.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--remove branch operation
entity ALUoperation is
    Port ( ALUOp0 : in  STD_LOGIC;
           ALUOp1 : in  STD_LOGIC;
           funct : in  STD_LOGIC_VECTOR (5 downto 0);
           operation : out  STD_LOGIC_VECTOR (4 downto 0);
           memtoreg2: out std_logic;
           memtoreg: out std_logic
          );
end ALUoperation;

architecture Behavioral of ALUoperation is

begin
    aluoperations: process(aluop0,aluop1,funct) 
    begin

        -- checking the other instructions before the R-type can give only the funct field as "sensitive" input to the R type checks.
        -- LW, SW or R-Type: Add
        if((aluop1 = '0' and aluop0 = '0') ) then
            operation <= "00010";
 				  memtoreg2<='0';   
 				 memtoreg<='1';
        -- LUI
        elsif(aluop1 = '1' and aluop0 = '1') --we need to do it this way. It make sense since we cant use a funct field for this operation
        then
            operation <= "01000";
 				 memtoreg2<='0'; 
				memtoreg<='0';
        -- BEQ or R-Type: Subract
		  --BEQ is not currently executed by the alu. However, we have decided to keep the design as it is because it should not limit the clockspeed of the current design.
		  -- the combination (aluop0 = '1' and aluop1 = '0') is then by means reserved for future expansions.
        -- Notice that aluop0 and aluop1 have switched places
        elsif((aluop0 = '1' and aluop1 = '0') or (aluop1 = '1' and funct = "100010")) then
            operation <= "00110";
				 memtoreg2<='0';
				memtoreg<='0';
        
        --we dont need to check if aluop0='0' or if aluop1='1' down from here (only funct field). ALUOP= "00", "01" and "11" are checked in previous sentences
        --however, removing the checks might not trigger the "else" operation if the ALUOP signal are expanded and this can make it harder to debug eventual mistakes in the ALU or controlunit.
		  -- R-Type: AND
        elsif(aluop1 = '1' and aluop0 = '0' and funct = "100100") then
            operation <= "00000";
				 memtoreg2<='0';
				memtoreg<='0';
        -- R-Type: OR
        elsif(aluop1 = '1' and aluop0 = '0' and funct = "100101") then
            operation <= "00001";
				 memtoreg2<='0';
				 memtoreg<='0';
				 --add
		  elsif(aluop1 = '1' and aluop0 = '0' and funct = "100000") then
            operation <= "00010";
				 memtoreg2<='0';
				 memtoreg<='0';
				 
        -- R-Type: SLT
        elsif(aluop1 = '1' and aluop0 = '0' and funct = "101010") then
            operation<="00111";
             memtoreg2<='0';
            memtoreg<='0';
			 --MFHI
			elsif(aluop1 = '1' and aluop0 = '0' and funct = "010000") then
            memtoreg2<='1';
           memtoreg<='1';
            operation<="00000";
			--MFLO				
			elsif(aluop1 = '1' and aluop0 = '0' and funct = "010010") then
           memtoreg2<='1';
          memtoreg<='0';
            operation<="00000";				

        else
        memtoreg<='0';
         memtoreg2<='0';
            operation<="00000";
        end if;
    end process;

end Behavioral;

