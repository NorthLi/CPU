library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.const.all;

entity keyboard is
	port(
		datain, clkin : in std_logic ; -- PS2 clk and data
		fclk, rst : in std_logic ;  -- filter clock
		
		status: in std_logic_vector(4 downto 0);
		dout_key: out std_logic_vector(7 downto 0)
	);
end keyboard ;

architecture rtl of Keyboard is
	type state_type is (delay, start, d0, d1, d2, d3, d4, d5, d6, d7, parity, stop, finish) ;
	signal data, clk, clk1, clk2, odd, fok : std_logic ;
	signal code : std_logic_vector(7 downto 0) ; 
	signal state : state_type ;
	
	signal ready : std_logic;
begin
	clk1 <= clkin when rising_edge(fclk) ;
	clk2 <= clk1 when rising_edge(fclk) ;
	clk <= (not clk1) and clk2 ;
	
	data <= datain when rising_edge(fclk) ;
	
	odd <= code(0) xor code(1) xor code(2) xor code(3) 
		xor code(4) xor code(5) xor code(6) xor code(7) ;
	
	process(rst, fclk)
	begin
		if rst = '0' then
			state <= delay ;
			code <= (others => '0') ;
			fok <= '0' ;
		elsif rising_edge(fclk) then
			case state is 
				when delay =>
					state <= start ;
					fok <= '0' ;
				when start =>
					if clk = '1' then
						if data = '0' then
							state <= d0 ;
						else
							state <= delay ;
						end if ;
					end if ;
				when d0 =>
					if clk = '1' then
						code(0) <= data ;
						state <= d1 ;
					end if ;
				when d1 =>
					if clk = '1' then
						code(1) <= data ;
						state <= d2 ;
					end if ;
				when d2 =>
					if clk = '1' then
						code(2) <= data ;
						state <= d3 ;
					end if ;
				when d3 =>
					if clk = '1' then
						code(3) <= data ;
						state <= d4 ;
					end if ;
				when d4 =>
					if clk = '1' then
						code(4) <= data ;
						state <= d5 ;
					end if ;
				when d5 =>
					if clk = '1' then
						code(5) <= data ;
						state <= d6 ;
					end if ;
				when d6 =>
					if clk = '1' then
						code(6) <= data ;
						state <= d7 ;
					end if ;
				when d7 =>
					if clk = '1' then
						code(7) <= data ;
						state <= parity ;
					end if ;
				WHEN parity =>
					IF clk = '1' then
						if (data xor odd) = '1' then
							state <= stop ;
						else
							state <= delay ;
						end if;
					END IF;

				WHEN stop =>
					IF clk = '1' then
						if data = '1' then
							state <= finish;
						else
							state <= delay;
						end if;
					END IF;

				WHEN finish =>
					state <= delay ;
					fok <= '1' ;
				when others =>
					state <= delay ;
			end case ; 
		end if ;
	end process ;
	
	process(fclk)
	begin
		if(fclk'event and fclk = '0')then
			if(rst = '0')then
				dout_key <= x"00";
				ready <= '0';
			elsif(status = read_key)then
				if(fok = '1')then
					dout_key <= code;
				end if;
				ready <= '0';
			elsif(fok = '1')then
				dout_key <= code;
				ready <= '1';
			elsif(ready = '0')then
				dout_key <= x"00";
			end if;
		end if;
	end process;
end rtl ;
