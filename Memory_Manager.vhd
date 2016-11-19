library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Memory_Manager is
	port(
		clk, rst: in std_logic;
		pc_IF: in std_logic_vector(15 downto 0);
		ins_IF: out std_logic_vector(15 downto 0);
		stop: out std_logic;
		
		oe_MEM, we_MEM: in std_logic;
		addr_MEM: in std_logic_vector(15 downto 0);
		din_MEM: in std_logic_vector(15 downto 0);
		dout_MEM: out std_logic_vector(15 downto 0);
		
		ram1_oe, ram1_we, ram1_en : out std_logic;
		ram1_address: out std_logic_vector(17 downto 0);
		ram1_data: inout std_logic_vector(15 downto 0);
		
		rdn, wrn: out std_logic;
		data_ready, tbre, tsre: in std_logic
	);
end Memory_Manager;

architecture Behavioral of Memory_manager is
	
begin
	process(clk)
	begin
		if(clk'event and clk = '1')then
			if(rst = '0')then
				
			end if;
		end if;
	end process;
	
end Behavioral;
