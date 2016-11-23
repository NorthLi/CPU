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
		
			when x"0000" => output_ins <= x"6aff";
			when x"0001" => output_ins <= x"6bc0";
			when x"0002" => output_ins <= x"3360";
			when x"0003" => output_ins <= x"6dff";
			when x"0004" => output_ins <= x"35a0";
			when x"0005" => output_ins <= x"4d83";
			when x"0006" => output_ins <= x"6961";
			when x"0007" => output_ins <= x"db22";
			when x"0008" => output_ins <= x"9b82"; 
			when x"0009" => output_ins <= x"db81";
			when x"000a" => output_ins <= x"9b21";
			when x"000b" => output_ins <= x"2cfb";
			when x"000c" => output_ins <= x"4901";
			when x"000d" => output_ins <= x"2df8";
			when x"000e" => output_ins <= x"4d01";
			when x"000f" => output_ins <= x"ef00";
			when x"0010" => output_ins <= x"0800";
			
			when others => output_ins <= x"0800";
		end case;
	end process;
end Behavioral;
