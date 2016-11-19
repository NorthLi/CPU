library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;
use ieee.numeric_std.All;

entity ALU is
	port(
		op_EX:in std_logic_vector(3 downto 0);
		datax_EX:in std_logic_vector(15 downto 0);
		datay_EX:in std_logic_vector(15 downto 0);
		dataz_ALU:out std_logic_vector(15 downto 0)
	);
end ALU;

architecture Behavioral of ALU is
	type reg_array is array (15 downto 0) of std_logic_vector (15 downto 0);
	signal r: reg_array;
begin

	r(0) <= datax_EX + B;
	r(1) <= datax_EX and B;
	r(2) <= datax_EX;
	r(3) <= not datax_EX;
	r(4) <= datax_EX or B;
	r(5) <= to_stdlogicvector(to_bitvector(datax_EX) sll conv_integer(unsigned(datay_EX)));
	r(6) <= to_stdlogicvector(to_bitvector(datax_EX) sra conv_integer(unsigned(datay_EX)));
	r(7) <= to_stdlogicvector(to_bitvector(datax_EX) srl conv_integer(unsigned(datay_EX)));
	r(8) <= datax_EX - datay_EX;
	r(9) <= datax_EX xor datay_EX;
	r(10) <= '0' when datax_EX = datay_EX else '1';
	r(11) <= '1' when datax_EX(15) > datay_EX(15) else
				'1' when datax_EX(15) = datay_EX(15) and datax_EX < datay_EX else '0';
	r(12) <= '1' when datax_ExX < data_y_EX else '0';
	r(13) <= (others => '0');
	r(14) <= (others => '0');
	r(15) <= (others => '0');
	dataz_ALU <= r(conv_integer(op));
	
end Behavioral;
