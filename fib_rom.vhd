library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
entity rom is 
port (
	input_addr : in std_logic_vector(15 downto 0);
	output_ins : out std_logic_vector(15 downto 0)
);
end rom;

architecture Behavioral of rom is
begin
	process (input_addr)
	begin
		case input_addr is 
			when x"0001" => output_ins <= x"68bf";-- LI R0 BF
			when x"0002" => output_ins <= x"3000";-- SLL R0 R0 0 (BF00)
			when x"0003" => output_ins <= x"6a02";-- LI R2 2
			when x"0004" => output_ins <= x"3240";-- SLL R2 R2 0 (0200)
			when x"0005" => output_ins <= x"4a20";-- ADDIU R2 0X20 -> R2->0220
			when x"0006" => output_ins <= x"6b11";-- LI R3 11(SRAM_START_ADDR)
			when x"0007" => output_ins <= x"d882";-- SW R0 R4 2
			when x"0008" => output_ins <= x"0800";-- NOP
			when x"0009" => output_ins <= x"9822";-- LW R0 R1 2(circle)
			when x"000A" => output_ins <= x"0800";-- NOP
			when x"000B" => output_ins <= x"db20";-- SW R3 R1 0
			when x"000C" => output_ins <= x"4aff";-- (ADDIU R2 FF)R2count to 536 size of term : 0x"0220"(544)
			when x"000D" => output_ins <= x"4b01";-- ADDIU R3 1
			when x"000E" => output_ins <= x"4c01";-- ADDIU R4 1
			when x"000F" => output_ins <= x"2af7";-- BNEZ R2 F7(-9)
			when x"0010" => output_ins <= x"0800";-- NOP
			
--			when x"0000" => output_ins <= x"6885"; --LI R0 85
--			when x"0001" => output_ins <= x"3000"; --SLL R0 R0 00
--			when x"0002" => output_ins <= x"6400"; --MTSP R0
--			when x"0003" => output_ins <= x"6910"; --LI R1 10
--			when x"0004" => output_ins <= x"d100"; --SW_SP R1 0
			when others => output_ins <= x"0800";
		end case;
	end process;
end Behavioral;
