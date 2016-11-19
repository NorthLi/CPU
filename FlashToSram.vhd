library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
entity FlashToSram is
port(
	clk, rst	  : in std_logic;
	flash_byte : out std_logic;
	flash_vpen : out std_logic;
	flash_ce   : out std_logic;
	flash_oe   : out std_logic;
	flash_we   : out std_logic;
	flash_rp   : out std_logic;
	flash_addr : buffer std_logic_vector(22 downto 1);
	flash_data : inout std_logic_vector(15 downto 0);
	start_signal: in std_logic;
	finish_signal : out std_logic;
	low_address: out std_logic_vector(15 downto 0);
	ram2_address: buffer std_logic_vector(17 downto 0);
	ram2_data	: inout std_logic_vector(15 downto 0);
	ram2_oe, ram2_we, ram2_ce : out std_logic
);
end FlashToSram;

architecture Behavioral of FlashToSram is
type flash_state is (
waiting, read1, read2, read3, read4, done, input_ram2_data, keep_ram2_data
);
signal state : flash_state := waiting;
signal count : std_logic_vector(15 downto 0);
signal input_data : std_logic_vector(15 downto 0);
begin
	flash_byte <= '1';
	flash_vpen <= '1';
	flash_ce <= '0';
	flash_rp <= '1';
	process (state, rst, input_data)
	begin
		if (state = input_ram2_data)then
			ram2_ce <= '0';
			ram2_oe <= '1';
			ram2_we <= '0';
			ram2_data <= input_data;
		elsif (state = keep_ram2_data)then
			ram2_ce <= '0';
			ram2_oe <= '1';
			ram2_we <= '1';
			ram2_data <= input_data;
		else 
			ram2_ce <= '1';
			ram2_oe <= '1';
			ram2_we <= '1';
			ram2_data <= (others => 'Z');
		end if;
	end process;
	
	process (clk, rst)
	begin
		if (rst = '0')then
			flash_oe <= '1';
			flash_we <= '1';
			state <= waiting;
			flash_data <= (others => 'Z');
			flash_addr <= (others => '0');
			count <= (others => '0');
			finish_signal <= '0';
		elsif (clk'event and clk = '1')then
			case state is 
				when waiting =>
					if (start_signal = '1')then
						flash_we <= '0';
						state <= read1;
					end if;
				when read1 =>
					flash_data <= x"00FF";
					state <= read2;
				when read2 =>
					flash_we <= '1';
					state <= read3;
				when read3 =>
					flash_oe <= '0';
					flash_data <= (others => 'Z');
					state <= read4;
				when read4 =>
					state <= input_ram2_data;
					input_data <= flash_data;
					flash_addr <= flash_addr + 1;
					ram2_address <= flash_addr(18 downto 1);
					low_address <= flash_data;
				when input_ram2_data =>
					state <= keep_ram2_data;
				when keep_ram2_data =>
					if (count = x"3FFF")then
						state <= done;
						finish_signal <= '1';
					else 
						state <= waiting;
						count <= count + 1;
					end if;
				when others => 
					flash_oe <= '1';
					flash_we <= '1';
					flash_data <= (others => 'Z');
					state <= waiting;
			end case;
		end if;
	end process;
end Behavioral;