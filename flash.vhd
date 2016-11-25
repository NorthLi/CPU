library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.const.ALL;

entity flash is 
	port(
		clk_0, rst: in std_logic;
		input_addr : in std_logic_vector(15 downto 0);
		status : in std_logic_vector(3 downto 0);
		flash_byte : out std_logic;
		flash_vpen : out std_logic;
		flash_ce   : out std_logic;
		flash_oe   : out std_logic;
		flash_we   : out std_logic;
		flash_rp   : out std_logic;
		flash_addr : out std_logic_vector(22 downto 0);
		flash_data : inout std_logic_vector(15 downto 0);
		dout_flash : out std_logic_vector(15 downto 0)
	);
end flash;

architecture Behavioral of flash is
type status_type is (read1, read2, read3, read4, read_final, keep1, keep2);
signal flash_status : status_type;
signal to_input_addr : std_logic_vector(15 downto 0);
begin
	flash_byte <= '1';
	flash_vpen <= '1';
	flash_ce <= '0';
	flash_rp <= '1';
	dout_flash <= flash_data;
	flash_addr(22 downto 0) <= "000000" & to_input_addr & "0";
	process (clk_0, rst, status, flash_status, input_addr)
	begin
		if (clk_0'event and clk_0 = '1')then
			if (rst = '0')then
				flash_status <= read1;
				flash_we <= '1';
				flash_oe <= '1';
				flash_data <= (others => 'Z');
				to_input_addr <= (others => '0');
			else 
				case flash_status is
					when read1 =>
						if (status = write_flash)then
							flash_we <= '0';
							flash_data <= x"00FF";
							flash_status <= read2;
						elsif (status = read_flash)then
							flash_oe <= '0';
							flash_data <= (others => 'Z');
							flash_status <= read3;
						end if;
					when read2 => 
						flash_we <= '1';
						flash_data <= x"00FF";
						flash_status <= read1;
						to_input_addr <= input_addr;
					when read3 =>
						flash_status <= read1;
						flash_oe <= '1';
					when others => flash_status <= read1;
				end case;
			end if;
		end if;
	end process;
end Behavioral;