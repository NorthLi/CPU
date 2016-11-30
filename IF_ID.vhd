library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.const.ALL;

entity IF_ID is
	port(
		clk, rst: in std_logic;
		stop, bubble: in std_logic;
		
		int: in std_logic;
		pc_branch: in std_logic_vector(15 downto 0);
		pc_ctrl: in std_logic;
			
		pc_IF: in std_logic_vector(15 downto 0);
		ins_IF: in std_logic_vector(15 downto 0);
		
		pc_ID: out std_logic_vector(15 downto 0);
		ins_ID: out std_logic_vector(15 downto 0)
	);
end entity;

architecture Behavioral of IF_ID is
	signal int_ready, int_start: std_logic;
	signal ins_cnt: integer range 0 to 15;
	signal ins_int: std_logic_vector(15 downto 0);
begin
	ins_int <= ins_array(ins_cnt);
		
	process(clk)
	begin
		if(clk'event and clk = '1') then
			if(rst = '0')then
				pc_ID <= (others => '1');
				ins_ID <= (others => '1');
				int_ready <= '0';
				int_start <= '0';
				ins_cnt <= 0;
			elsif(stop = '0' and bubble = '0')then
				if(int_ready = '0')then
					pc_ID <= pc_IF;
					ins_ID <= ins_IF;
					int_ready <= int;
				else
					if(int_start = '0')then
						int_start <= '1';
						if(pc_ctrl = '0')then
							pc_ID <= pc_IF;
						end if;
					end if;
					
					ins_ID <= ins_int;
					if(ins_cnt = 10)then
						int_ready <= '0';
						int_start <= '0';
						ins_cnt <= 0;
					else
						ins_cnt <= ins_cnt + 1;
					end if;
				end if;
			else
				int_ready <= int_ready or int;
			end if;
		end if;
	end process;
	
end Behavioral;
