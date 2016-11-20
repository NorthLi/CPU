library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MEM_WB is
	port(
		clk, rst:in std_logic;
		stop: in std_logic;
		
		rz_MEM: in std_logic_vector(3 downto 0);
		dataz_MEM: in std_logic_vector(15 downto 0);
		
		rz_WB: out std_logic_vector(3 downto 0);
		dataz_WB: out std_logic_vector(15 downto 0)	
	);
end entity;

architecture Behavioral of MEM_WB is
begin

	process(clk)
	begin
		if(clk'event and clk = '1')then
			if(rst = '0')then
				rz_WB <= (others => '1');
				dataz_WB <= (others => '1');
			elsif(stop = '0')then
				rz_WB <= rz_MEM;
				dataz_WB <= dataz_MEM;
			end if;
		end if;
	end process;

end Behavioral;

