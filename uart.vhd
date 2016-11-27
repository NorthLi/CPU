library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.const.ALL;

entity uart is
	port(
		clk_0, rst: in std_logic;
		status: in std_logic_vector(4 downto 0);
		
		din_uart: in std_logic_vector(15 downto 0);
		dout_uart: out std_logic_vector(15 downto 0);
		sta_uart: buffer std_logic_vector(1 downto 0);

		ram1_data: inout std_logic_vector(15 downto 0);
		rdn, wrn: out std_logic;
		data_ready, tbre, tsre: in std_logic
	);
end uart;

architecture Behavioral of uart is
	signal ust: std_logic_vector(2 downto 0);
begin
	sta_uart <= data_ready & "1" when ust = uart_ready else "00";
	ram1_data <= din_uart when status = write_uart else (others => 'Z');
	dout_uart <= ram1_data;

	process(clk_0)
	begin
		if(clk_0'event and clk_0 = '0')then
			if(rst = '0')then
				rdn <= '1';
				wrn <= '1';
				ust <= uart_ready;
			else
				case ust is
					when uart_ready =>
						case status is
							when read_uart =>
								rdn <= '0';
								ust <= read_next;
							when write_uart =>
								wrn <= '0';
								ust <= write_next;
							when others =>
						end case;
					when read_next =>
						rdn <= '1';
						ust <= uart_ready;
					when write_next =>
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
						rdn <= '1';
						wrn <= '1';
						ust <= uart_ready;
				end case;
			end if;
		end if;
	end process;
	
end Behavioral;
