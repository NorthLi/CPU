
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EX_MEM is
	port(
		clk, rst: in std_logic;
		stop, bubble: in std_logic;
		
		rz_EX: in std_logic_vector(3 downto 0);
		we_EX, oe_EX: in std_logic;
		addr_EX: in std_logic_vector(15 downto 0);
		din_EX: in std_logic_vector(15 downto 0);
		
		rz_MEM: out std_logic_vector(3 downto 0);
		we_MEM, oe_MEM: out std_logic;
		addr_MEM: out std_logic_vector(15 downto 0);
		din_MEM: out std_logic_vector(15 downto 0)		
	);
end entity;

architecture Behavioral of EX_MEM is

begin
	
	process(clk)
	begin
		if(clk'event and clk = '1')then
			if(rst = '0') then
				rz_MEM <= (others => '1');
				we_MEM <= '0';
				oe_MEM <= '0';
				addr_MEM <= (others => '1');
				din_MEM <= (others => '1');
			elsif (stop = '0') then
				if(bubble = '1') then
					rz_MEM <= (others => '1');
					we_MEM <= '0';
					oe_MEM <= '0';
					addr_MEM <= (others => '1');
					din_MEM <= (others => '1');
				else
					rz_MEM <= rz_EX;
					we_MEM <= we_EX;
					oe_MEM <= oe_EX;
					addr_MEM <= addr_EX;
					din_MEM <= din_EX;
				end if;
			end if;
		end if;
	end process;

end Behavioral;
