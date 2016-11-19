library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity PC_Choose is
	port(
		clk, rst: in std_logic;
		stop, bubble:in std_logic;
		int: in std_logic;
		
		pc_branch: in std_logic_vector(15 downto 0);
		pc_ctrl: in std_logic;
		
		pc_IF: buffer std_logic_vector(15 downto 0)
	);
end entity;
	

architecture Behavioral of PC_Choose is
	signal pc_ready :std_logic_vector(15 downto 0);
begin
	pc_ready <= pc_branch when pc_ctrl = '1' else pc_IF  + 1;
	
	process(clk)
	begin
		if(clk'event and clk = '1')then
			if (rst = '0') then
				pc_IF <= (others => '0');
			elsif(stop = '0' and bubble = '0')then
				pc_IF <= pc_ready;
			end if;
		end if;
	end process;
	
end Behavioral;
