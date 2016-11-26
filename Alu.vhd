library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;
--use ieee.numeric_std.All;
use work.const.ALL;

entity ALU is
	port(
		op_EX:in std_logic_vector(3 downto 0);
		datax_EX:in std_logic_vector(15 downto 0);
		datay_EX:in std_logic_vector(15 downto 0);
		dataz_ALU:out std_logic_vector(15 downto 0)
	);
end ALU;

architecture Behavioral of ALU is
begin
			  
	process(op_EX, datax_EX, datay_EX)
	begin
		case op_EX is
			when ALU_ADD => dataz_ALU <= datax_EX + datay_EX;
			when ALU_AND => dataz_ALU <= datax_EX and datay_EX;
			when ALU_MOVE => dataz_ALU <= datax_EX;
			when ALU_NOT => dataz_ALU <= not datax_EX;
			when ALU_OR => dataz_ALU <= datax_EX or datay_EX;
			when ALU_SLL => dataz_ALU <= to_stdlogicvector(to_bitvector(datax_EX) sll conv_integer(unsigned(datay_EX)));
			when ALU_SRA => dataz_ALU <= to_stdlogicvector(to_bitvector(datax_EX) sra conv_integer(unsigned(datay_EX)));
			when ALU_SRL => dataz_ALU <= to_stdlogicvector(to_bitvector(datax_EX) srl conv_integer(unsigned(datay_EX)));
			when ALU_SUB => dataz_ALU <= datax_EX - datay_EX;
			when ALU_XOR => dataz_ALU <= datax_EX xor datay_EX;
			
			when ALU_CMP =>
				if(datax_EX = datay_EX)then
					dataz_ALU <= x"0000";
				else
					dataz_ALU <= x"0001";
				end if;
			when ALU_SLT =>
				if(datax_EX(15) > datay_EX(15) or (datax_EX(15) = datay_EX(15) and datax_EX < datay_EX))then
					dataz_ALU <= x"0001";
				else
					dataz_ALU <= x"0000";
				end if;
			when ALU_SLTU =>
				if(datax_EX < datay_EX)then
					dataz_ALU <= x"0001";
				else
					dataz_ALU <= x"0000";
				end if;
				
			when others => dataz_ALU <= x"1111";
		end case;
	end process;
	
end Behavioral;
