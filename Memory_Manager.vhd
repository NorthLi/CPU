library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.const.ALL;

entity Memory_Manager is
	port(
		clk_0, clk, rst: in std_logic;
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
		
		ram2_oe, ram2_we, ram2_en : out std_logic;
		ram2_address: out std_logic_vector(17 downto 0);
		ram2_data: inout std_logic_vector(15 downto 0);
		
		rdn, wrn: out std_logic;
		data_ready, tbre, tsre: in std_logic
	);
end Memory_Manager;

architecture Behavioral of Memory_manager is
	
begin
	process(oe_MEM, we_MEM)
	begin
		ram1_oe <= '1';
		ram1_we <= '1';
		ram1_en <= '1';
		
		ram1_address <= (others => '0');
		rdn <= '1';
		wrn <= '1';
	
		if(we_MEM = '1') then 
			ram1_en <= '0';
			ram1_we <= '0';
		elsif(oe_MEM = '1') then 
			ram1_oe <= '0';
			ram1_en <= '0';
			dout_MEM <= x"0011";
		end if;
	end process;
	
	process(pc_IF)
	begin
		case pc_IF is
			when x"0000" =>
				ins_IF <= "0110100100000100";--lw 001 <- 1
				stop <= '0';
			when x"0001" =>
				ins_IF <= "0110101000000010";
				stop <= '0';
			when x"0002" =>
				ins_IF <= "0000100000000000";
				stop <= '0';
			when x"0003" =>
				ins_IF <= "0011011100101011";
				stop <= '0';
			when others =>
				ins_IF <= "1110000101001101";
				stop <= '0';
		end case;
	end process;
end Behavioral;
