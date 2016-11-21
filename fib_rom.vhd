library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
entity rom is 
port (
	input_addr : in std_logic_vector(15 downto 0);
	output_ins : out std_logic_vector(15 downto 0);
);
end rom;

architecture Behavioral of rom is
begin
	process (input_addr)
	begin
		case input_addr is 
			when x"0000" => output_ins <= x"6901";
			when x"0001" => output_ins <= x"6a01";
			when x"0002" => output_ins <= x"6b85";
			when x"0003" => output_ins <= x"3360";
			when x"0004" => output_ins <= x"6c09";
			when x"0005" => output_ins <= x"db20";
			when x"0006" => output_ins <= x"db41";
			when x"0007" => output_ins <= x"e145";
			when x"0008" => output_ins <= x"e149";
			when x"0009" => output_ins <= x"4b02";
			when x"000a" => output_ins <= x"4cff";
			when x"000b" => output_ins <= x"2cf9";
			when others => output_ins <= x"0800";
		end case;
	end process;
end Behavioral;