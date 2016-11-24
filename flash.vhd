library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.const.ALL;

entity flash is 
	port(
		clk_0, rst: in std_logic;
		status : in std_logic_vector(3 downto 0);
		flash_byte : out std_logic;
		flash_vpen : out std_logic;
		flash_ce   : out std_logic;
		flash_oe   : out std_logic;
		flash_we   : out std_logic;
		flash_rp   : out std_logic;
		flash_addr : buffer std_logic_vector(22 downto 1);
		flash_data : inout std_logic_vector(15 downto 0);
		dout_flash : out std_logic_vector(15 downto 0)
	);
end flash;

architecture Behavioral of flash is
type status_type is (read1, read2, read3, read4);
signal flash_status : status_type;
begin
	flash_byte <= '1';
	flash_vpen <= '1';
	flash_ce <= '0';
	flash_rp <= '1';
	process (clk_0, rst, status, flash_status)
	begin
		if (clk_0'event and clk_0 = '0')then
			if (rst = '0')then
				flash_status <= read1;
				flash_we <= '0';
				flash_oe <= '1';
				flash_data <= (others => 'Z');
				flash_addr <= (others => '0');
				dout_flash <= (others => '0');
			else 
				case flash_status is
					when read1 =>
						if (status = read_flash)then
							flash_data <= x"00FF";
							flash_status <= read2;
						end if;
					when read2 =>
						flash_we <= '1';
						flash_status <= read3;
						dout_flash <= (others => '0');
					when read3 =>
						if (status = read_flash)then
							flash_oe <= '0';
							flash_data <= (others => 'Z');
							flash_status <= read4;
						end if;
					when read4 =>
						flash_addr <= flash_addr + 1;
						dout_flash <= flash_data;
						flash_status <= read3;
					when others => flash_status <= read1;
				end case;
			end if;
		end if;
	end process;
end Behavioral;