library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.const.ALL;

entity uart is
	port(
		clk_0, rst: in std_logic;
		status: in std_logic_vector(3 downto 0);
		
		din_uart: in std_logic_vector(15 downto 0);
		dout_uart: out std_logic_vector(15 downto 0);
		sta_uart: buffer std_logic_vector(1 downto 0);

		ram1_address: out std_logic_vector(17 downto 0);
		ram1_data: inout std_logic_vector(15 downto 0);
		rdn, wrn: out std_logic;
		data_ready, tbre, tsre: in std_logic
	);
end uart;

architecture Behavioral of uart is
	signal ust: std_logic_vector(2 downto 0);
begin
	sta_uart <= data_ready & "1" when ust = uart_ready else "00";
	ram1_address <= "0000000" & status & sta_uart & ust & tbre & tsre;
	process(clk_0)
	begin
		if(clk_0'event and clk_0 = '0')then
			if(rst = '0')then
				ust <= uart_ready;
				rdn <= '1';
				wrn <= '1';
			else
				case ust is
					when uart_ready =>
						if(status = read_uart)then
							rdn <= '0';
							ram1_data <= (others => 'Z');
							ust <= read_next;
						elsif(status = write_uart)then
							ram1_data <= din_uart;
							ust <= write_next;
						end if;
					when read_next =>
						dout_uart <= ram1_data;
						rdn <= '1';
						ust <= uart_ready;
					when write_next =>
						wrn <= '0';
						ust <= write_wait;
					when write_wait =>
						wrn <= '1';
						ust <= write_tbre;
					when write_tbre =>
						if(tbre = '1') then
							ust <= write_tsre;
						end if;
					when write_tsre =>
						if(tsre = '1') then
							 ust <= uart_ready;
						end if;
					when others =>
						ust <= uart_ready;
						rdn <= '1';
						wrn <= '1';
				end case;
			end if;
		end if;
	end process;
	
end Behavioral;
