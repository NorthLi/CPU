library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity IF_ID is
	port(
		clk, rst: in std_logic;
		stop, bubble: in std_logic;
		int: in std_logic;
		
		pc_IF: in std_logic_vector(15 downto 0);
		ins_IF: in std_logic_vector(15 downto 0);
		
		pc_ID: out std_logic_vector(15 downto 0);
		ins_ID: out std_logic_vector(15 downto 0)
	);
end entity;

architecture Behavioral of IF_ID is
begin
	
	process(clk)
	begin
		if(clk'event and clk = '1') then
			if(rst = '0')then
				pc_ID <= (others => '1');
				ins_ID <= (others => '1');
			elsif(stop = '0' and bubble = '0')then
				pc_ID <= pc_IF;
				ins_ID <= ins_IF;
			end if;
		end if;
	end process;

end Behavioral;
