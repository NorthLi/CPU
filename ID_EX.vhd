library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ID_EX is
	port(
		clk, rst: in std_logic;
		stop, bubble: in std_logic;
		
		op_ID: in std_logic_vector(3 downto 0);
		datax_ID, datay_ID, dataz_ID: in std_logic_vector(15 downto 0);
		rz_ID: in std_logic_vector(3 downto 0);
		we_ID, oe_ID: in std_logic;
		
		op_EX: out std_logic_vector(3 downto 0);
		datax_EX, datay_EX, dataz_EX: out std_logic_vector(15 downto 0);
		rz_EX: out std_logic_vector(3 downto 0);	
		we_EX, oe_EX: out std_logic
	);
end entity;	

architecture Behavioral of ID_EX is
begin
	
	process(clk)
	begin
		if(clk'event and clk = '1')then
			if(rst = '0')then
				op_EX <= (others => '1');
				datax_EX <= (others => '1');
				datay_EX <= (others => '1');
				dataz_EX <= (others => '1');
				rz_EX <= (others => '1');
				we_EX <= '0';
				oe_EX <= '0';
			elsif (stop = '0') then
				if(bubble = '1') then
					op_EX <= (others => '1');
					datax_EX <= (others => '1');
					datay_EX <= (others => '1');
					dataz_EX <= (others => '1');
					rz_EX <= (others => '1');
					we_EX <= '0';
					oe_EX <= '0';
				else
					op_EX <= op_ID;
					datax_EX <= datax_ID;
					datay_EX <= datay_ID;
					dataz_EX <= dataz_ID;
					rz_EX <= rz_ID;
					we_EX <= we_ID;
					oe_EX <= oe_ID;
				end if;
			end if;
		end if;
	end process;

end Behavioral;
