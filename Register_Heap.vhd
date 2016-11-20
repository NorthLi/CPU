library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity Register_Heap is
	port ( 
		clk : in  STD_LOGIC;
      rst : in  STD_LOGIC;
      rx_reg : in  STD_LOGIC_VECTOR(3 downto 0);
      ry_reg : in  STD_LOGIC_VECTOR(3 downto 0);
      datax_reg : out  STD_LOGIC_VECTOR(15 downto 0);
      datay_reg : out  STD_LOGIC_VECTOR(15 downto 0);
		
      rz_WB : in  STD_LOGIC_VECTOR(3 downto 0);
      dataz_WB : in  STD_LOGIC_VECTOR(15 downto 0)
	);
end Register_Heap;

architecture Behavioral of Register_Heap is
	type reg_arr is array(0 to 15) of std_logic_vector(15 downto 0);
	signal regs : reg_arr;
begin

	datax_reg <= regs(conv_integer(rx_reg));
	datay_reg <= regs(conv_integer(ry_reg));

	process(clk)
	begin
		if(clk'event and clk = '0') then
			if(rst = '0')then
				for i in 0 to 15 loop
					regs(i) <= (others => '0');
				end loop;
			else
				regs(conv_integer(rz_WB)) <= dataz_WB;
			end if;
		end if;
	end process;
	
end Behavioral;

