library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;
use ieee.numeric_std.All;
use const.ALL;

entity ALU is
	port(
		op_EX:in std_logic_vector(3 downto 0);
		datax_EX:in std_logic_vector(15 downto 0);
		datay_EX:in std_logic_vector(15 downto 0);
		dataz_ALU:out std_logic_vector(15 downto 0)
	);
end ALU;

architecture Behavioral of ALU is
	signal cmp, slt, slti : std_logic;
begin

	cmp <= '0' when datax_EX = datay_EX else '1';
	slt <= '1' when datax_EX(15) > datay_EX(15) else 
			 '1' when datax_EX(15) = datay_EX(15) and datax_EX < datay_EX else '0';
	slti <= '1' when datax_EX < datay_EX else '0';
				
	dataz_ALU <= datax_EX + datay_EX   when op_EX = ALU_ADD else
					 datax_EX and datay_EX when op_EX = ALU_AND else
					 datax_EX              when op_EX = ALU_MOVE else
					 not datax_EX          when op_EX = ALU_NOT else
					 datax_EX or datay_EX  when op_EX = ALU_OR else
					 to_stdlogicvector(to_bitvector(datax_EX) sll conv_integer(unsigned(datay_EX))) when op_EX = ALU_SLL else
					 to_stdlogicvector(to_bitvector(datax_EX) sra conv_integer(unsigned(datay_EX))) when op_EX = ALU_SRA else
					 to_stdlogicvector(to_bitvector(datax_EX) srl conv_integer(unsigned(datay_EX))) when op_EX = ALU_SRL else
					 datax_EX - datay_EX   when op_EX = ALU_SUB else
					 datax_EX xor datay_EX when op_EX = ALU_XOR else
					 ZERO15 & cmp          when op_EX = ALU_CMP else
					 ZERO15 & slt          when op_EX = ALU_SLT else
					 ZERO15 & slti         when op_EX = ALU_SLTI else (others => '1');
					 
end Behavioral;
