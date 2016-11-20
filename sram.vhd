library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use const.ALL;

entity sram is
	port(
		clk_0, rst: in std_logic;
		status: in std_logic_vector(2 downto 0);
		pc_ram: in std_logic_vector(15 downto 0);
		addr_ram: in std_logic_vector(15 downto 0);
		din_ram: in std_logic_vector(15 downto 0);
		dout_ram: out std_logic_vector(15 downto 0);
		
		ram2_oe, ram2_we: out std_logic;
		ram2_address: out std_logic_vector(17 downto 0);
		ram2_data: inout std_logic_vector(15 downto 0)
	);
end sram;

architecture Behavioral of sram is
	signal fist_period : std_logic;
	signal ram_data : std_logic_vector(15 downto 0);
	
--	signal test_rom: std_logic;
--	signal rom_data : std_logic_vector(15 downto 0);
	
begin
	ram2_address(17 downto 16) <= "00";
	
	process(clk_0)
	begin
		if(clk_0'event and clk_0 = '0')then
			if(rst = '0') then
				fist_period <= '0';
				ram_data <= (others => '1');
			elsif(fist_period = '0')then
				fist_period <= '1';
				case status is
					when read_pc =>
						ram2_we <= '1';
						ram2_oe <= '0';
						ram2_address(15 downto 0) <= pc_ram;
						ram2_data <= (others => 'Z');
					when read_ram =>
						ram2_we <= '1';
						ram2_oe <= '0';
						ram2_address(15 downto 0) <= addr_ram;
						ram2_data <= (others => 'Z');
					when write_ram =>
						ram2_oe <= '1';
						ram2_we <= '0';
						ram2_address(15 downto 0) <= addr_ram;
						ram2_data <= din_ram;
					when others =>
						ram2_oe <= '1';
						ram2_we <= '1';
				end case;
			else
				fist_period <= '0';
				ram2_oe <= '1';
				ram2_we <= '1';
				ram_data <= ram2_data;
			end if;
		end if;
	end process;
	
	dout_ram <= ram_data;
	
end Behavioral;
